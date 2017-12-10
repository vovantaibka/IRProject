package webapp;

import formatter.BoldFormatter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.highlight.*;
import org.apache.lucene.store.FSDirectory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

public class Search {
    private static final String index_path = Configs.getInstance().getString("indexPath");
    private static final String searchField = Configs.getInstance().getString("searchField");
    public static final int hitsPerPage = Configs.getInstance().getInt("hitsPerPage");
    public static final int maxNHits = Configs.getInstance().getInt("maxNHits");


    private static final Logger logger = LogManager.getLogger(Search.class);

    private IndexReader reader = null;
    private IndexSearcher searcher = null;
    private Analyzer analyzer = new StandardAnalyzer();
    private QueryParser parser = new QueryParser(searchField, analyzer);

    public Search() throws IOException {
        logger.info("Loading index from " + index_path);

        String filePath = new File("").getAbsolutePath();
        logger.info(filePath.concat(" path to the property file"));

        reader = DirectoryReader.open(FSDirectory.open(Paths.get(index_path)));
        searcher = new IndexSearcher(reader);
    }

    public JSONObject search(String query_text, int page) throws ParseException, IOException {
        Query query = parser.parse(query_text);
        TopDocs results = searcher.search(query, maxNHits);

        BoldFormatter formatter = new BoldFormatter();
        Highlighter highlighter = new Highlighter(formatter, new QueryScorer(query));
        highlighter.setTextFragmenter(new SimpleFragmenter(50));

        long totalHits = results.totalHits;
        ScoreDoc[] hits = results.scoreDocs;
        JSONObject out = new JSONObject();
        JSONArray arr = new JSONArray();

        int totalPages = (int)(totalHits / hitsPerPage) + 1;
        int start = (page - 1) * hitsPerPage;
        int end = start + hitsPerPage;

        for (int i = start; i < Math.min(end, hits.length); ++i) {
            ScoreDoc scoreDoc = hits[i];
            Document doc = searcher.doc(scoreDoc.doc);
            JSONObject obj = new JSONObject();
            obj.put("url", doc.get("url"));
            obj.put("title", doc.get("title"));
            obj.put("relevance", doc.get("relevance"));

            int docId = scoreDoc.doc;

            //Get stored text from found document
            String text = doc.get(searchField);

            int maxNumFragmentsRequired = 5;

            //Create token stream
            TokenStream stream = TokenSources.getAnyTokenStream(reader, docId, searchField, analyzer);

            String highlightedText = "";
            try {
                String[] frags = highlighter.getBestFragments(stream, text, maxNumFragmentsRequired);
                for (String frag : frags)
                {
                    highlightedText = highlightedText.concat(frag);
                }
                obj.put("highlightedText", highlightedText);
            } catch (InvalidTokenOffsetsException e) {
                e.printStackTrace();
            }
            arr.add(obj);
        }

        out.put("hits", arr);
        out.put("totalHits", totalHits);
        out.put("totalPages", totalPages);
        return out;
    }
}
