<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="user.UserDAO" %>
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="evaluation.EvaluationDTO" %>
    <%@ page import="evaluation.EvaluationDAO" %>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="java.net.URLEncoder" %>
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

	request.setCharacterEncoding("utf-8");

	String search = "";
	String searchType="최신순";
	String lectureDivide = "전체";
	int pageNumber = 0;
	if(request.getParameter("search") != null){
		search = (String) request.getParameter("search");
	}
	if(request.getParameter("searchType") != null){
		searchType = (String) request.getParameter("searchType");
	}
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = (String) request.getParameter("lectureDivide");
	}
	if(request.getParameter("pageNumber") != null){
		try{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	System.out.println(searchType);
	
	ArrayList<EvaluationDTO> evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);

	String userID = null;
	if(session.getAttribute("userID")!=null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
	}
	
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked == false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='emailSendConfirm.jsp'");
		script.println("</script>");
	}
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">JSP 강의평가</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
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
<section class="container">
	<form style="width: 1200px;" method="get" action="./index.jsp" class="form-inline mt-2">
		<div class="input-group mt-2">
		  <div class="input-group-prepend">
		    <label class="input-group-text" for="inputGroupSelect01">option</label>
		  </div>
		  <select name="lectureDivide" class="custom-select" id="inputGroupSelect01">
		    <option value="전체">전체</option>
		    <option value="전공" <% if(lectureDivide.equals("전공")) {out.println("selected");} %>>전공</option>
		    <option value="교양" <% if(lectureDivide.equals("교양")) {out.println("selected");} %>>교양</option>
		    <option value="기타" <% if(lectureDivide.equals("기타")) {out.println("selected");} %>>기타</option>
		  </select>
		  <div class="mx-1"></div>
		  <select name="searchType" class="custom-select">
		    <option value="최신순">최신순</option>
		    <option value="추천순" <% if(searchType.equals("추천순")) {out.println("selected");} %>>추천순</option>
		    </select>
		</div>
		<input type="text" name="search" placeholder="내용을 입력하세요..." class="form-control mx-1 mt-2">
		<button type="submit" class="btn btn-secondary mx-1 mt-2">검색</button>
		<a class="btn btn-secondary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
		<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고하기</a>
	</form>											<!-- data-toggle : 클릭시 모달을 띄우겠다. -->
	
	<%
		if(evaluationList != null){
			for(int i = 0 ; i < evaluationList.size(); i ++){
				
				if(i == 5) break;
				EvaluationDTO evaluation = evaluationList.get(i);
	%>
				<div class="card mt-3">
				  <h5 class="card-header"><%=evaluation.getLectureName() %>&nbsp;<small><%=evaluation.getProfessorName() %></small></h5>
				  <div class="card-body">
				    <h5 class="card-title"><%=evaluation.getEvaluationTitle() %></h5>
				    <p class="card-text"><%= evaluation.getEvaluationContent() %></p>
				    <br>
				    <div class="row">
				    	<div class="col-sm-8 text-left">
				    		성적<span style="color: red;"><%= evaluation.getCreditScore() %></span>
				    		널널<span style="color: red;"><%= evaluation.getComfortableScore() %></span>
				    		강의<span style="color: red;"><%= evaluation.getLectureScore() %></span>
				    		추천 <span style="color: blue"><%= evaluation.getLikeCount() %></span>
				    	</div>
				    	<div class="col-sm-4 text-right">
				    		<a class="btn btn-primary" onclick="return confirm('추천하시겠습니까?');" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID()%>">추천</a>
				    		<a class="btn btn-secondary" onclick="return confirm('삭제하시겠습니까?');" href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID()%>">삭제</a>
				    	</div>
				    </div>
				  </div>
				</div>				
	<%		
			}
		}
	%>
	
			
</section>
<nav aria-label="Page navigation example" class="mt-4">
  <ul class="pagination">
  <%
	if(pageNumber <= 0 ){
	%>
		<li class="page-item"><a class="page-link disabled">Previous</a></li>
	<%	
	}else{
	%>
	<li class="page-item"><a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "utf-8")%>
	&searchType=<%=URLEncoder.encode(searchType, "utf-8")%>&search=<%=URLEncoder.encode(search, "utf-8")%>&pageNumber=<%=pageNumber-1%>">Previous</a></li>
	<%
	}
%>
<%
	if(evaluationList.size() < 6){
%>
	    <li class="page-item"><a class="page-link disabled">Next</a></li>	
<%
	}else{
%>	
	<li class="page-item"><a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "utf-8")%>
	&searchType=<%=URLEncoder.encode(searchType, "utf-8")%>&search=<%=URLEncoder.encode(search, "utf-8")%>&pageNumber=<%=pageNumber+1%>">Previous</a></li>
	
<% 
	}
%>
  	
  </ul>
</nav>

<div class="modal" tabindex="-1" role="dialog" id="registerModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">평가 등록</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form method="post" action="./evaluationRegisterAction.jsp">
      <div class="modal-body">
        	<div class="form-row">	<!--하나의 행을 여러개의 열로 나눌때 사용-->
        		<div class="form-group col-sm-6">	<!-- 6개의 열만큼 차지 -->
        			<label>강의명</label>
        			<input type="text" name="lectureName" class="form-control" maxlength="20">
        		</div>
        		<div class="form-group col-sm-6">	<!-- 6개의 열만큼 차지 -->
        			<label>교수명</label>
        			<input type="text" name="professorName" class="form-control" maxlength="20">
        		</div>
        	</div>
        	<div class="form-row">
        		<div class="form-group col-sm-4">
        			<label>수강연도</label>
        			<select name="lectureYear" class="form-control">
        				<option value="2011">2011</option>
        				<option value="2012">2012</option>
        				<option value="2013">2013</option>
        				<option value="2014">2014</option>
        				<option value="2015">2015</option>
        				<option value="2016">2016</option>
        				<option value="2017">2017</option>
        				<option value="2018" selected>2018</option>
        				<option value="2019">2019</option>
        				<option value="2020">2020</option>
        				<option value="2021">2021</option>
        			</select>
        		</div>
        		<div class="form-group col-sm-4">
        			<label>수강학기</label>
        			<select name="semesterDivide" class="form-control">
        				<option value="1학기" selected>1학기</option>
        				<option value="여름학기">여름학기</option>
        				<option value="2학기">2학기</option>
        				<option value="겨울학기">겨울학기</option>
        			</select>
        		</div>
        		<div class="form-group col-sm-4">
        			<label>강의구분</label>
        			<select name="lectureDivide" class="form-control">
        				<option value="전공" selected>전공</option>
        				<option value="교양">교양</option>
        				<option value="기타">기타</option>
        			</select>
        		</div>
        	</div>
        	<div class="form-group">
        		<label>제목</label>
        		<input placeholder="제목을 입력해주세요..." type="text" name="evaluationTitle" class="form-control" maxlength="20">
        		<label>내용</label>
        		<textarea class="form-control" style="min-height: 300px;" placeholder="내용을 입력해주세요..." maxlength="2048" name="evaluationContent"></textarea>
        	</div>
        	<div class="form-row">
        		<div class="form-group col-sm-3">
        			<label>종합</label>
        			<select name="totalScore" class="form-control">
        				<option value="A" selected>A</option>
        				<option value="B">B</option>
        				<option value="C">C</option>
        				<option value="D">D</option>
        				<option value="F">F</option>
        			</select>
        		</div>
        		<div class="form-group col-sm-3">
        			<label>성적</label>
        			<select name="creditScore" class="form-control">
        				<option value="A" selected>A</option>
        				<option value="B">B</option>
        				<option value="C">C</option>
        				<option value="D">D</option>
        				<option value="F">F</option>
        			</select>
        		</div>
        		<div class="form-group col-sm-3">
        			<label>널널</label>
        			<select name="comfortableScore" class="form-control">
        				<option value="A" selected>A</option>
        				<option value="B">B</option>
        				<option value="C">C</option>
        				<option value="D">D</option>
        				<option value="F">F</option>
        			</select>
        		</div>
        		<div class="form-group col-sm-3">
        			<label>강의</label>
        			<select name="lectureScore" class="form-control">
        				<option value="A" selected>A</option>
        				<option value="B">B</option>
        				<option value="C">C</option>
        				<option value="D">D</option>
        				<option value="F">F</option>
        			</select>
        		</div>
        	</div>
        
      </div>
      <div class="modal-footer">
      	<button type="submit" class="btn btn-primary">등록하기</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
      </form>
    </div>
  </div>
</div>

<div class="modal" tabindex="-1" role="dialog" id="reportModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">신고 하기</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form method="post" action="./reportAction.jsp">
      <div class="modal-body">
        
        	<div class="form-group">
        		<label>제목</label>
        		<input placeholder="제목을 입력해주세요..." type="text" name="reportTitle" class="form-control" maxlength="20">
        		<label>내용</label>
        		<textarea name="reportContent" placeholder="내용을 입력해주세요..." class="form-control" maxlength="2048"></textarea>
        	</div>
        
      </div>
      <div class="modal-footer">
      	<button type="submit" class="btn btn-danger">신고하기</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
      </form>
    </div>
  </div>
</div>

<footer class="bg-dark mt-4 p-5 text-center" style="color:#ffffff;">
	Copyright &copy; 신동규 all rights reserved
</footer>
	
	<!-- 뭐 하다가 오류 생기거나 잘 안돼면 헤드 부분으로 올리세요 -->
	<script type="text/javascript" src="./js/jquery.min.js"></script>
	<script type="text/javascript" src="./js/popper.js"></script>
	<script type="text/javascript" src="./js/bootstrap.min.js"></script>
</body>
</html>