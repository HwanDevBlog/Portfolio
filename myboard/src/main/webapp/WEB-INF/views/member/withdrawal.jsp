<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<script src='https://code.jquery.com/jquery-3.3.1.min.js'></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<link href="<c:url value="/resources/css/custom.css" />" rel="stylesheet">
	
	<title>스프링 게시판</title>
</head>
<body>
	<!-- 메뉴 네비게이션 생성 -->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" 
			data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<i><a class="navbar-brand" href="/controller">스프링 게시판</a></i>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active" style="font-weight: bold;"><a href="/controller">메인</a></li>
				<li class="navbar-bold"><a href="${pageContext.request.contextPath}/board/write">글 작성</a></li>
				<li class="navbar-bold"><a href="${pageContext.request.contextPath}/board/listSearch">글 목록</a></li>
			</ul>
		</div>
	</nav>
	
	<div class="container" style="width: 50%">
		<form role="form" method="post" autocomplete="off">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>회원탈퇴</h4></th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td style="width: 150px;"><h5>아이디</h5></td>
						<td>
							<input class="form-control" type="text" id="userId" name="userId" maxlength="20" value="${member.userId}" placeholder="아이디를 입력하세요" >
						</td>
					</tr>
					
					<tr>
						<td style="width: 150px;"><h5>비밀번호</h5></td>
						<td>
							<input class="form-control" type="password" id="userPass" name="userPass" maxlength="20" placeholder="비밀번호를 입력하세요" >
						</td>
					</tr>
					
					<tr>
						<td style="text-align: Left;" colspan="2">
							<input class="btn btn-primary pull-right" type="submit" value="탈퇴완료">
							<c:if test="${msg == false }">
								<i style="font-weight: bold; color: red;">※ 입력한 비밀번호가 잘못되었습니다.</i>
							</c:if>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</body>
</html>