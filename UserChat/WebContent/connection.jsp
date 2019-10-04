<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, javax.naming.*"%><!-- javax.naming.*은 JNDI를 활용하기 위함 -->
</head>
<body>
	<!-- 커넥션 풀(DBCP)에 접근할 수 있도록 만들어주기 위한 작업 -->
	<%
	Context initContext = new InitialContext();
	Context envContext = (Context) initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource) envContext.lookup("jdbc/UserChat");
	Connection conn = ds.getConnection();
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("SELECT SYSDATE FROM DUAL");
	
	while(rs.next()) {
		String time = rs.getString(1);
		out.println("Oracle sysdate : " + time);
	}
	
	rs.close();
	stmt.close();
	conn.close();
	initContext.close();
	%>
</body>
</html>