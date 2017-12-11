<%--<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--<%@ page import="java.util.Iterator" %>--%>
<%@ page import="java.util.List" %><%--
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

      <%--Bootstrap CSS--%>
      <%--<link href=”bootstrap/css/bootstrap.css” rel=”stylesheet” type=”text/css” />--%>

      <%--Jquery--%>
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

      <%--<script type=”text/javascript” src=”bootstrap/js/bootstrap.js”></script>--%>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
      <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js" integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1" crossorigin="anonymous"></script>

      <title>Information Retrieval Project</title>
      <style type="text/css">
          body {
              position: absolute;
              width: 100%;
              height: 100%;
          }
          .container {
              position: relative;
              top: 35%;
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
                      <label for="search" class="sr-only">Search</label>
                      <input type="text" class="form-control" name="search" id="search" placeholder="Search" required>
                      <input type="hidden" name="page" id="page" value="1">
                  </div>
              </div>
          </div>
      </form>
  </div>
  <script type="text/javascript">
      $(document).ready(function() {
          $('#search').focus();
      });
  </script>
  </body>
</html>
