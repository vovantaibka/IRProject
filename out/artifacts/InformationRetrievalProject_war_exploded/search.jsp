<%--<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--<%@ page import="java.util.Iterator" %>--%>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: francy
  Date: 12/1/17
  Time: 10:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <%--Bootstrap CSS--%>
    <%--<link href=”bootstrap/css/bootstrap.css” rel=”stylesheet” type=”text/css” />--%>
    <%--<script type=”text/javascript” src=”bootstrap/js/bootstrap.js”></script>--%>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js" integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1" crossorigin="anonymous"></script>

    <title>Information Retrieval Project</title>
    <style type="text/css">
        .search-form .form-group {
            float: right !important;
            transition: all 0.35s, border-radius 0s;
            width: 100%;
            height: 32px;
            background-color: #fff;
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
            border-radius: 25px;
            border: 1px solid #ccc;
        }
        .search-form .form-group input.form-control {
            padding-right: 20px;
            border: 0 none;
            background: transparent;
            box-shadow: none;
            display:block;
        }
        /*.search-form .form-group input.form-control::-webkit-input-placeholder {*/
        /*display: none;*/
        /*}*/
        /*.search-form .form-group input.form-control:-moz-placeholder {*/
        /*!* Firefox 18- *!*/
        /*display: none;*/
        /*}*/
        /*.search-form .form-group input.form-control::-moz-placeholder {*/
        /*!* Firefox 19+ *!*/
        /*display: none;*/
        /*}*/
        /*.search-form .form-group input.form-control:-ms-input-placeholder {*/
        /*display: none;*/
        /*}*/
        /*.search-form .form-group:hover {*/
        /*width: 100%;*/
        /*border-radius: 4px 25px 25px 4px;*/
        /*}*/
        /*.search-form .form-group span.form-control-feedback {*/
        /*position: absolute;*/
        /*top: -1px;*/
        /*right: -2px;*/
        /*z-index: 2;*/
        /*display: block;*/
        /*width: 34px;*/
        /*height: 34px;*/
        /*line-height: 34px;*/
        /*text-align: center;*/
        /*color: #3596e0;*/
        /*left: initial;*/
        /*font-size: 14px;*/
        /*}*/
        .search-form .item-list .item a {
            cursor: pointer;
        }
        
    </style>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6" style="text-align: center">
                <h1>Information Retrieval Tool</h1>
            </div>
        </div>
        <form action="/processquery" class="search-form" method="get">
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <div class="form-group has-feedback">
                        <% String query = (String) request.getAttribute("query");%>
                        <% if (query==null || query.isEmpty()) { %>
                        <label for="search" class="sr-only">Search</label>
                        <input type="text" class="form-control" name="search" id="search" placeholder="Search" value="">
                        <% } else { %>
                        <label for="search" class="sr-only">Search</label>
                        <input type="text" class="form-control" name="search" id="search" placeholder="Search" value="<%=query%>">
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-10">
                    <div class="item-list">
                        <table>
                            <c:forEach items="${results}" var="result">
                                <div class="item">
                                    <tr>
                                        <td class="title">
                                            <a href="<c:out value="${result['url']}"/>"><c:out value="${result['title']}"/></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="url"><c:out value="${result['url']}"/></td>
                                    </tr>
                                    <tr>
                                        <td class="summary"></td>
                                    </tr>
                                </div>
                            </c:forEach>
                        </table>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="pagination">
                    <nav aria-label="Page navigation">
                        <% int totalPages = (int) request.getAttribute("totalPages"); %>
                        <ul class="pagination">
                            <% int currentPage = (int) request.getAttribute("page"); %>
                            <% if(currentPage > 1) { %>
                            <li>
                                <a href="/processquery?search=<%=request.getParameter("search")%>&page=<%=(currentPage - 1)%>" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <% } %>
                            <%  for (int i = 1; i <= totalPages; i++) { %>
                                <li>
                                    <a href="/processquery?search=<%=request.getParameter("search")%>&page=<%=i%>"><%=i%></a>
                                </li>
                            <% } %>
                            <% if(currentPage != totalPages) { %>
                            <li>
                                <a href="/processquery?search=<%=request.getParameter("search")%>&page=<%=(currentPage + 1)%>" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                            <% } %>
                        </ul>
                    </nav>
                </div>
            </div>
        </form>
    </div>
    <div class="alert alert-info" role="alert">
        There are<strong> ${totalHits} </strong>results
    </div>
</body>
</html>