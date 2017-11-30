package webapp;

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
    public ProcessQuery() throws IOException {
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Search searcher = new Search();

        //Fix error font
        response.setContentType("application/json;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");

        PrintWriter out = response.getWriter();

        try {
            String query = request.getParameter("search");
            JSONObject result = searcher.search(query, 10);

            JSONArray pages = (JSONArray) result.get("hits");
            Iterator page = pages.iterator();

            List list = new ArrayList();
            while (page.hasNext()) {
                JSONObject jsonObject = (JSONObject) page.next();

                Map m1 = new HashMap();
                m1.put("url", jsonObject.get("url"));
                m1.put("title", jsonObject.get("title"));
                list.add(m1);
//                list.add(jsonObject.get("url"));
//                list.add(jsonObject.get("title"));
            }

            request.setAttribute("query", query);
            request.setAttribute("results", list);
            request.getRequestDispatcher("./index.jsp").forward(request, response);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        // request.setAttribute("results", "Kết quả trả về!!!");

        // request.getRequestDispatcher("./index.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
