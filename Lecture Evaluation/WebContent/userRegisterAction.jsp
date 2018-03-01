<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="user.UserDTO" %>
    <%@ page import="user.UserDAO" %>
    <%@ page import="util.SHA256" %>
    <%@ page import="java.io.PrintWriter" %>
    <%
    
    request.setCharacterEncoding("utf-8");
    String userID = null;
    if(session.getAttribute("userID")!= null){
    	userID = (String) session.getAttribute("userID");
    }
    if(userID != null){
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("alert('이미 로그인이 된 상태입니다. ');");
    	script.println("location.href='index.jsp'");
    	script.println("</script>");
    	script.close();
    	return;
    }
    String userPassword = request.getParameter("userPassword");
    String userEmail = request.getParameter("userEmail");
    userID = request.getParameter("userID");
    if(userID == null || userPassword == null || userEmail == null){
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("alert('입력 안된 사항이 있습니다. ');");
    	script.println("history.back();");
    	script.println("</script>");
    	script.close();
    	return;
    }
    
    UserDAO userDAO = new UserDAO();
    UserDTO user = new UserDTO();
    user.setUserID(userID);
    user.setUserPassword(userPassword);
    user.setUserEmail(userEmail);
    user.setUserEmailHash(SHA256.getSHA256(userEmail));
    user.setUserEmailChecked(false);
    int result = userDAO.join(user);
    
    if(result == -1){
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("alert('중복된 아이디가 존재합니다. ');");
    	script.println("history.back();");
    	script.println("</script>");
    	script.close();
    }else{
    	session.setAttribute("userID", userID);
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("location.href='emailSendAction.jsp';");
    	script.println("</script>");
    	script.close();
    }
    
    %>
