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

    <%--Font Awesome--%>
    <script src="https://use.fontawesome.com/8eb9fd090f.js"></script>

    <title>Information Retrieval Project</title>
    <style type="text/css">
        body {
            position: absolute;
            width: 100%;
            height: 100%;
        }
        #title {
            padding-top: 20px;
        }
        #item-list {
            padding-top: 25px;
        }
        .no-relevance {
            color: red!important;
        }
        .search-form {
            margin-bottom: 48px;
        }
        .search-form #item-list .title {
            font-size: large;
        }
        .search-form #item-list .url {
            color: #006621;
        }
        .search-form #item-list .highlightedText {
            color: #545454;
            font-size: small;
            padding-bottom: 20px;
        }
        .search-form .form-group {
            float: right !important;
            transition: all 0.35s, border-radius 0s;
            width: 100%;
            /*height: 32px;*/
            background-color: #fff;
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
            border-radius: 25px;
            border: 1px solid #ccc;
        }
        .search-form .form-group input.form-control {
            border-radius: 25px;
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
        .col-center-block {
            float: none;
            display: block;
            margin: 0 auto;
            /* margin-left: auto; margin-right: auto; */
        }
        .col-center-block .pagination .current-page a {
            font-size: medium;
            color: white!important;
        }
        .col-center-block .pagination .page{
            border: #545454 0.5px;
        }
        .col-center-block .pagination .current-page{
            background-color: #007bff;
        }
        .col-center-block .pagination>li>a {
            /*border-radius: 50% !important;*/
            margin: 0 5px;
        }
        .total-hits {
            position: fixed;
            bottom: 0;
            width: 100%;
            margin-bottom: 0px!important;
        }
    </style>
</head>
<body>
    <div class="container">
        <div id="title" class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6" style="text-align: center">
                <h1>Information Retrieval Tool</h1>
            </div>
        </div>
        <form action="/processquery" class="search-form" method="get">
            <div id="input-search" class="row">
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
            <div id="item-list" class="row">
                <div class="col-md-1"></div>
                <div class="col-md-10">
                    <div class="item-list">
                        <table>
                            <c:forEach items="${results}" var="result">
                                <div class="item">
                                    <tr>
                                        <td class="title">
                                            <a href="<c:out value="${result['url']}"/>"><c:out value="${result['title']}"/>
                                                <c:choose>
                                                    <c:when test="${result['relevance'] == 1}">
                                                        <span class="fa fa-check" aria-hidden="true"></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="fa fa-times no-relevance" aria-hidden="true"></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="url">
                                            <c:choose>
                                                <c:when test="${fn:length(result['url']) <= 110}">
                                                    <c:out value="${result['url']}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${fn:substring(result['url'], 0, 110)}..."/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="highlightedText">${result['highlightedText']}</td>
                                    </tr>
                                </div>
                            </c:forEach>
                        </table>
                    </div>
                </div>
            </div>
            <div id="pagination" class="row">
                <div class="col-center-block">
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
                                    <% if(i == currentPage) { %>
                                        <li class="page current-page">
                                            <a href="/processquery?search=<%=request.getParameter("search")%>&page=<%=i%>"><%=i%></a>
                                        </li>
                                    <% } else { %>
                                        <li class="page">
                                            <a href="/processquery?search=<%=request.getParameter("search")%>&page=<%=i%>"><%=i%></a>
                                        </li>
                                    <% } %>
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
            </div>
        </form>
    </div>
    <div class="alert alert-info total-hits" role="alert">
        <div>
            There are<strong> ${totalHits} </strong>results
        </div>
        <div style="position: fixed; bottom: 12px; right: 15px;">
            Page<strong> ${page} </strong>
        </div>
    </div>
</body>
</html>
