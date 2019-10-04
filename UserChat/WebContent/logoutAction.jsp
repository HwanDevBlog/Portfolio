<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>(주)한국기업 커뮤니티 사이트</title>
</head>
<body>
	<%
		session.invalidate();
	%>
	<script>
		//로그아웃 시 index 페이지로 이동할 수 있도록 함
		location.href = 'index.jsp';
	</script>
</body>
</html>