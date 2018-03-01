<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="user.UserDTO" %>
    <%@ page import="user.UserDAO" %>
    <%@ page import="util.SHA256" %>
    <%@ page import="java.io.PrintWriter" %>
    <%
    
    request.setCharacterEncoding("utf-8");
    String userID = null;
    String code = null;
    if(request.getParameter("code")!= null){
    	code = (String) request.getParameter("code");
    }
    if(session.getAttribute("userID")!= null){
    	userID = (String) session.getAttribute("userID");
    }
    UserDAO userDAO = new UserDAO();
    if(userID ==null){
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("alert('로그인을 해주세요.');");
    	script.println("location.href='userLogin.jsp'");
    	script.println("</script>");
    	script.close();
    	return;
    }
    String userEmail = userDAO.getUserEmail(userID);
    boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true:false;
    if(isRight){
    	userDAO.setUserEmailChecked(userID);
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("location.href='index.jsp'");
    	script.println("</script>");
    	script.close();
    }else{
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("alert('유효하지 않은 코드입니다.');");
    	script.println("location.href='index.jsp'");
    	script.println("</script>");
    	script.close();
    }
    
    
    
    %>
