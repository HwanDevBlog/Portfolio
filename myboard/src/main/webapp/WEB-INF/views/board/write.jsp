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
				<li class="navbar-bold"><a href="/controller">메인</a></li>
				<li class="active" style="font-weight: bold;"><a href="write">글 작성</a></li>
				<li class="navbar-bold"><a href="listSearch">글 목록</a></li>
			</ul>
		</div>
	</nav>

	<div class="container">
		<c:if test="${msg == null}">
			<form role="form" method="post" autocomplete="off">
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2"><h4>게시글 작성</h4></th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<td style="width: 150px;"><h5>글 제목</h5></td>
							<td>
								<input class="form-control" type="text" id="title" name="title" maxlength="30" >
							</td>
						</tr>
						
						<tr>
							<td style="width: 150px;"><h5>글 내용</h5></td>
							<td>
								<textarea id="content" name="content" style="width: 100%; height: 300px;"></textarea>
							</td>
						</tr>
						
						<tr>
							<td style="width: 150px;"><h5>작성자</h5></td>
							<td>
								<input class="form-control" type="text" id="writer" name="writer" maxlength="30" value="${member.userName}" readonly="readonly">
							</td>
						</tr>
				
						<tr>
							<td style="text-align: Left;" colspan="2">
								<input class="btn btn-primary pull-right" type="submit" value="작성완료">
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</c:if>
	</div>

	<div class="container" style="width: 50%">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<c:if test="${msg == false}">
						<th><h4>권한이 없습니다. 로그인이 필요합니다.</h4></th>
					</c:if>
				</tr>
			</thead>
			
			<tbody>
				<tr>
					<c:if test="${msg == false}">
						<td><i><a style="font-weight: bold; fint-size: 25px;" href="/controller">※ 로그인 화면으로 이동</a></i></td>
					</c:if>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>