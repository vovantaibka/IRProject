package processdata;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import webapp.Configs;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Date;

public class IndexFile {
    private static final Logger logger = LogManager.getLogger(IndexFile.class);
    public IndexFile() {}

    public static void main(String[] args) {
        // Indexing JSON data
        String indexPath = Configs.getInstance().getString("index.dir");

        boolean create = Configs.getInstance().getBoolean("createNewIndex");
        Date start = new Date();

        try {
            Directory dir = FSDirectory.open(Paths.get(indexPath));
            Analyzer analyzer = new StandardAnalyzer();
            IndexWriterConfig iwc = new IndexWriterConfig(analyzer);

            if (create) {
                // Create a new index in the directory, removing any
                // previously indexed documents:
                iwc.setOpenMode(IndexWriterConfig.OpenMode.CREATE);
            } else {
                // Add new documents to an existing index:
                iwc.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
            }

            // Optional: for better indexing performance, if you
            // are indexing many documents, increase the RAM
            // buffer.  But if you do this, increase the max heap
            // size to the JVM (eg add -Xmx512m or -Xmx1g):
            //
            // iwc.setRAMBufferSizeMB(256.0);

            IndexWriter writer = new IndexWriter(dir, iwc);
            indexDocs(writer);

            // NOTE: if you want to maximize search performance,
            // you can optionally call forceMerge here.  This can be
            // a terribly costly operation, so generally it's only
            // worth it when your index is relatively static (ie
            // you're done adding documents to it):
            //
            // writer.forceMerge(1);

            writer.close();

            Date end = new Date();
            logger.info(end.getTime() - start.getTime() + " total milliseconds");
        } catch (IOException e) {
            logger.info("Caught a " + e.getClass() +
                    "\n with message: " + e.getMessage());
        }
        // End Indexing
    }

    private static void indexDocs(final IndexWriter writer)
    {
        //JSON parser object to parse read file
        JSONParser jsonParser = new JSONParser();
        try (FileReader reader = new FileReader("group1.json"))
        {
            JSONObject root = (JSONObject) jsonParser.parse(reader);
            JSONArray collection = (JSONArray) root.get("collection");
            collection.forEach(q -> parseQueryDetailObject(writer, (JSONObject) q));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    private static void parseQueryDetailObject(IndexWriter writer, JSONObject queryDetail)
    {
        JSONArray sites = (JSONArray)queryDetail.get("sites");
        for (Object obj: sites) {
            //
            JSONObject siteDetail = (JSONObject)obj;
            try {
                Document doc = new Document();

                String url = (String) siteDetail.get("url");
                Field urlField = new StringField("url", url, Field.Store.YES);
                doc.add(urlField);

                String title = (String) siteDetail.get("title");
                Field titleField = new StringField("title", title, Field.Store.YES);
                doc.add(titleField);

                String content = (String) siteDetail.get("content");
                Field contentField = new TextField("content", content, Field.Store.YES);
                doc.add(contentField);

                String relevance = (String) siteDetail.get("relevance");
                Field relevanceField = new StringField("relevance", relevance, Field.Store.YES);
                doc.add(relevanceField);

                writer.addDocument(doc);
            } catch (IOException ex) {
                logger.info("Error adding documents to the index. " +  ex.getMessage());
            }
        }
    }
}
