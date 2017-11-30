<%--
  Created by IntelliJ IDEA.
  User: francy
  Date: 11/28/17
  Time: 3:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Information Retrieval Project</title>
  </head>
  <body>
  <form action="/processquery" method="post">
    <input type="text" name="query">
    <input type="submit" value="search">
  </form>
  <p>${results}</p>
  </body>
</html>
