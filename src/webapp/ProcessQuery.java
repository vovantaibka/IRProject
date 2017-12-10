package webapp;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.lucene.queryparser.classic.ParseException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet(name = "ProcessQuery")
public class ProcessQuery extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(ProcessQuery.class);

    public ProcessQuery() throws IOException {
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Search searcher = new Search();

        //Fix error font
        response.setContentType("application/json;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");

        PrintWriter out = response.getWriter();

        try {
            String query = request.getParameter("search");
            String page_str = request.getParameter("page");

            logger.info("Query: " + query + " - Page: " + page_str);

            int page = 1;
            if (page_str!= null && !page_str.isEmpty())
            {
                page = Integer.parseInt(page_str);
            }

            JSONObject results = searcher.search(query, page);

            JSONArray pages = (JSONArray) results.get("hits");
            long totalHits = (long) results.get("totalHits");
            int totalPages = (int) results.get("totalPages");
            Iterator it = pages.iterator();

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            while (it.hasNext()) {
                JSONObject jsonObject = (JSONObject) it.next();

                Map<String, Object> m1 = new HashMap<>();
                m1.put("url", jsonObject.get("url"));
                m1.put("title", jsonObject.get("title"));
                m1.put("relevance", jsonObject.get("relevance"));
                m1.put("highlightedText", jsonObject.get("highlightedText"));
                list.add(m1);
            }

            request.setAttribute("query", query);
            request.setAttribute("page", page);
            request.setAttribute("results", list);
            request.setAttribute("totalHits", totalHits);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("./search.jsp").forward(request, response);
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
}
