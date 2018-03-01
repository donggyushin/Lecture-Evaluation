<%@page import="evaluation.EvaluationDAO" %>
<%@page import="likey.LikeyDTO" %>
<%@page import="likey.LikeyDAO" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!


//해당 유저의 아이피를 가지고 오는 함수
public static String getClientIP(HttpServletRequest request) {
    String ip = request.getHeader("X-FORWARDED-FOR"); 
    if (ip == null || ip.length() == 0) {
        ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0) {
        ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0) {
        ip = request.getRemoteAddr() ;
    }
    return ip;
}

%>

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
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	LikeyDAO likeyDAO = new LikeyDAO();
	int result = likeyDAO.like(userID, evaluationID, getClientIP(request));
	if(result == 1){
		result = evaluationDAO.like(evaluationID);
		if(result == 1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('성공적으로 추천이 되었습니다.');");
			script.println("location.href='index.jsp'");
			script.println("</script>");
			script.close();
		}else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류.');");
			script.println("history.back()");
			script.println("</script>");
			script.close();
			
		}
	}else{

		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 추천한 게시물입니다. ');");
		script.println("history.back()");
		script.println("</script>");
		script.close();
	}
	
%>
