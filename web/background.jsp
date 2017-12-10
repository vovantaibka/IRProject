<%--
  Created by IntelliJ IDEA.
  User: francy
  Date: 12/10/17
  Time: 8:54 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Haters gonna hate</title>

    <style type="text/css">
        @import url(https://fonts.googleapis.com/css?family=Crafty+Girls);

        .title-walker {
            font-family: 'Crafty Girls';
            text-align: center;
        }

        img {
            position: absolute;
            width: 200px;
            margin-top: 230px;
            cursor: pointer;
        }

        img.flip {
            -webkit-transform: scaleX(-1);
            transform: scaleX(-1);
        }
    </style>
</head>
<body>
    <%--<h1 class="title-walker">Haters gonna hate</h1>--%>
    <img id="walker" src="http://media.giphy.com/media/XGnWMiVXL87Xa/giphy.gif">
    <script type="text/javascript">
        // Get the walker image:
        var walker = document.getElementById('walker');
        var walkingLeft = true;
        var dist = 1;
        var leftBorder = 1100;
        var rightBorder = 20;
        var position = rightBorder;

        function check(){
            position += walkingLeft ? dist : -dist;
            walker.style.right = position +'px';
            if (position > leftBorder || position < rightBorder){
                walkingLeft = !walkingLeft;
                walker.classList.toggle('flip')
            }
        }

        setInterval(check, 20)
    </script>
</body>
</html>
