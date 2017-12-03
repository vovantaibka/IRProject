package webapp;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.lucene.analysis.Analyzer;
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
import org.apache.lucene.store.FSDirectory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.io.IOException;
import java.nio.file.Paths;

public class Search {
    private static final String index_path = Configs.getInstance().getString("indexPath");
    private static final String searchField = Configs.getInstance().getString("searchField");
    public static final int hitsPerPage = Configs.getInstance().getInt("hitsPerPage");


    private static final Logger logger = LogManager.getLogger(Search.class);

    private IndexSearcher searcher = null;
    private Analyzer analyzer = new StandardAnalyzer();
    private QueryParser parser = new QueryParser(searchField, analyzer);

    public Search() throws IOException {
        logger.info("12/11/1996");
        IndexReader reader = DirectoryReader.open(FSDirectory.open(Paths.get(index_path)));
        searcher = new IndexSearcher(reader);
    }

    public JSONObject search(String query_text, int page) throws ParseException, IOException {
        Query query = parser.parse(query_text);
        TopDocs results = searcher.search(query, 1000);
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
//            obj.put("content", doc.get("content"));
            arr.add(obj);
        }

        out.put("hits", arr);
        out.put("totalHits", totalHits);
        out.put("totalPages", totalPages);
        return out;
    }
}
