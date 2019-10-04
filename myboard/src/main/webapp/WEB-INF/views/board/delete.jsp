<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
				<li class="navbar-bold"><a href="write">글 작성</a></li>
				<li class="active" style="font-weight: bold;"><a href="listSearch">글 목록</a></li>
			</ul>
		</div>
	</nav>

	<div class="container" style="width: 50%">
		<form role="form" method="post" autocomplete="off">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>게시글 삭제</h4></th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td style="width: 150px;"><h5>글 번호</h5></td>
						<td><input class="form-control" type="text" id="bno" name="bno" value="${delete}" readonly="readonly" /></td>
					</tr>
					
					<tr>
						<td colspan="2">
							<input class="btn btn-primary pull-right" type="button" id="cancel_btn" value="취소">
							<input style="margin-right: 20px;" class="btn btn-primary pull-right" type="submit" value="삭제">
						</td>
					</tr>
				</tbody>				
			</table>
		
			<script>
				//폼을 변수에 저장
				var formObj = $("form[role='form']");  
				
				//취소 버튼 클릭
				$("#cancel_btn").click(function(){
					self.location = "read?bno=${delete}"
						+ "&page=${scri.page}"
						+ "&perPageNum=${scri.perPageNum}"
						+ "&searchType=${scri.searchType}"
						+ "&keyword=${scri.keyword}";						
				});
			</script>
		</form>	
	</div>	
</body>
</html>








