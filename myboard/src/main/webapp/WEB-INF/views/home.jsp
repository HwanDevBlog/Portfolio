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
				<li class="navbar-bold"><a href="board/write">글 작성</a></li>
				<li class="navbar-bold"><a href="board/listSearch">글 목록</a></li>
			</ul>
		</div>
	</nav>

	<c:if test="${member == null}">
	<div class="container" style="width: 50%">
		<form role="form" method="post" autocomplete="off" action="member/login">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>스프링 게시판에 오신 것을 환영합니다.</h4></th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><input class="form-control" type="text" name="userId" maxlength="20" placeholder="아이디를 입력하세요"></td>
					</tr>
					
					<tr>
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td><input class="form-control" type="password" name="userPass" maxlength="20" placeholder="비밀번호를 입력하세요"></td>
					</tr>
					
					<tr>
						<td style="text-align: left" colspan="2">
							<input class="btn btn-primary pull-right" type="submit" value="로그인">
							<input style="margin-right: 20px;" class="btn btn-primary pull-right" type="button" onclick="location.href='member/register'" value="회원가입">
							<c:if test="${msg == false}">
								<i style="font-weight: bold; color: red;">※ 로그인 정보가 올바르지 않습니다. 아이디 또는 비밀번호를 확인해주세요</i>
							</c:if>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	</c:if>

	<c:if test="${member != null}">
	<div class="container" style="width: 50%">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th><h4>${member.userName}님 환영합니다.</h4></th>
				</tr>
			</thead>
			
			<tbody>
				<tr>
					<td><a style="font-weight: bold; font-size: 15px;" href="member/logout">로그아웃</a></td>
				</tr>
				
				<tr>
					<td><a style="font-weight: bold; font-size: 15px;" href="member/modify">회원정보수정</a></td>
				</tr>
				
				<tr>
					<td><a style="font-weight: bold; font-size: 15px;" href="member/withdrawal">회원탈퇴</a></td>
				</tr>
			</tbody>
		</table>
	</div>
	</c:if>
</body>
</html>