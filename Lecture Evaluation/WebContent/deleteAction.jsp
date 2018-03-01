<%@page import="evaluation.EvaluationDAO" %>
<%@page import="likey.LikeyDTO" %>
<%@page import="likey.LikeyDAO" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}

	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		
	}
	
	String evaluationID = null;
	if(request.getParameter("evaluationID")!= null){
		evaluationID = (String)request.getParameter("evaluationID"); 
	}
	System.out.println("evaluationID:"+evaluationID);
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	if(!userID.equals(evaluationDAO.getUserID(evaluationID))){
		System.out.println(userID);
		System.out.println(evaluationDAO.getUserID(evaluationID));
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('본인이 작성한 글만 지울 수 있습니다.');");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;
	}else{
		int result = evaluationDAO.delete(evaluationID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('삭제가 완료되었습니다.');");
			script.println("location.href='index.jsp'");
			script.println("</script>");
			script.close();	
		}else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류.');");
			script.println("history.back()");
			script.println("</script>");
			script.close();
		}
	}
	
%>
