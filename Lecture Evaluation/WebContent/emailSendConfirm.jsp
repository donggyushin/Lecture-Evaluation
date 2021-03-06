<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="./css/custom.css">
<title>JSP Evaluation web page</title>
</head>
<body>
<%
	String userID = null;
	if(session.getAttribute("userID")!=null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요. ');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		return;
	}
	
	
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">JSP 강의평가</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item">
        <a class="nav-link" href="index.jsp">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          회원관리
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
        	 <%
        	if(userID == null){
        	%>
        		<a class="dropdown-item" href="userLogin.jsp">로그인</a>
          <a class="dropdown-item" href="userJoin.jsp">회원가입</a>
        	<% 
        	}else{
        		%>
        			<div class="dropdown-divider"></div>
          <a class="dropdown-item" href="userLogout.jsp">로그아웃</a>	
        		<%
        	}
        %> 
        </div>
      </li>
    </ul>
    <form class="form-inline my-2 my-lg-0" method="get" action="./index.jsp">
      <input class="form-control mr-sm-2" type="text" name="search" placeholder="Search" aria-label="Search">
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
    </form>
  </div>
</nav>
<section class="container mt-3">
	 <div class="alert alert-warning mt-4" role="alert">
      이메일 주소 인증을 하셔야 이용 가능합니다. 인증 메일을 받지 못하셨나요?
   </div>
   <a href="emailSendAction.jsp" class="btn btn-primary">인증 메일 받기</a>
</section>

<footer class="bg-dark mt-4 p-5 text-center" style="color:#ffffff;">
	Copyright &copy; 신동규 all rights reserved
</footer>
	
	<!-- 뭐 하다가 오류 생기거나 잘 안돼면 헤드 부분으로 올리세요 -->
	<script type="text/javascript" src="./js/jquery.min.js"></script>
	<script type="text/javascript" src="./js/popper.js"></script>
	<script type="text/javascript" src="./js/bootstrap.min.js"></script>
</body>
</html>