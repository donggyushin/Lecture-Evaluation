<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="user.UserDTO" %>
    <%@ page import="user.UserDAO" %>
    <%@ page import="util.SHA256" %>
    <%@ page import="java.io.PrintWriter" %>
    <%
    
    request.setCharacterEncoding("utf-8");
    String userID = request.getParameter("userID");
    String userPassword = request.getParameter("userPassword");
    if(userID == null || userPassword == null){
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
  
    user.setUserEmailChecked(false);
    int result = userDAO.login(userID, userPassword);
    
    if(result == 1){
    	session.setAttribute("userID", userID);
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("location.href='index.jsp'");
    	script.println("</script>");
    	script.close();
    }else if(result == 0){
    	PrintWriter script = response.getWriter();
    	script.println("<script>");
    	script.println("alert('비밀번호가 틀렸습니다.');");
    	script.println("history.back();");
    	script.println("</script>");
    	script.close();
    	
    }
	else if(result == -1){
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('존재하지 않는 아이디입니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
    
	
    %>
