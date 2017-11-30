package webapp;

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
    public static final String index_path = "/home/francy/IdeaProjects/InformationRetrievalProject/indexingJSONData";
    public static final String field = "content";
    public static final int hitsPerPage = 10;

    private IndexReader reader = null;
    private IndexSearcher searcher = null;
    private Analyzer analyzer = new StandardAnalyzer();
    private QueryParser parser = new QueryParser(field, analyzer);

    public Search() throws IOException {
        reader = DirectoryReader.open(FSDirectory.open(Paths.get(index_path)));
        searcher = new IndexSearcher(reader);
    }

    public JSONObject search(String query_text, int page) throws ParseException, IOException {
        Query query = parser.parse(query_text);
        TopDocs results = searcher.search(query, 1000);
        ScoreDoc[] hits = results.scoreDocs;
        JSONObject out = new JSONObject();
        JSONArray arr = new JSONArray();

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
        return out;
    }
}
