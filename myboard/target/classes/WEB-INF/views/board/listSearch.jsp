<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

	<div class="container">
		<c:if test="${msg == null}">
			<table class="table table-hover">
				<thead>
					<tr>
						<th colspan="4" style="font-size: 18px;">게시글 목록</th>
					</tr>
				
					<tr>
						<th>글 번호</th>
						<th>글 제목</th>
						<th>작성자</th>
						<th>작성 일자</th>
					</tr>
				</thead>
			
				<!-- 목록 시작 -->
				<c:forEach items="${list}" var="list">
					<tr>
						<td style="text-align: center;">${list.bno}</td>
						<td style="text-align: center;">				
							<a href="read?bno=${list.bno}&
										page=${scri.page}&
										perPageNum=${scri.perPageNum}&
										searchType=${scri.searchType}&
										keyword=${scri.keyword}">${list.title}</a>
						</td>
						<td style="text-align: center;">${list.writer}</td>
						<td style="text-align: center;"><fmt:formatDate value="${list.regDate}" pattern="yyyy-MM-dd" /></td>
					</tr>
				</c:forEach><!-- 목록 끝 -->
			</table>
		
			<div class="search row">
				<div class="col-xs-2 col-sm-2">
					<select name="searchType" class="form-control"> 
						<option value="n"<c:out value="${scri.searchType == null ? 'selected' : ''}"/>>-----</option>
						<option value="t"<c:out value="${scri.searchType eq 't' ? 'selected' : ''}"/>>제목</option>
						<option value="c"<c:out value="${scri.searchType eq 'c' ? 'selected' : ''}"/>>내용</option>
						<option value="w"<c:out value="${scri.searchType eq 'w' ? 'selected' : ''}"/>>작성자</option>
						<option value="tc"<c:out value="${scri.searchType eq 'tc' ? 'selected' : ''}"/>>제목+내용</option>
					</select>
				</div>	
			
				<div class="col-xs-10 col-sm-10">
					<div class="input-group">
						<input type="text" name="keyword" id="keywordInput" value="${scri.keyword}" class="form-control"/>
						<span class="input-group-btn">
							<button id="searchBtn" class="btn btn-default">검색</button>
						</span>
					</div>
				</div>
		
				<script>
					$(function(){
						$('#searchBtn').click(function() {
							self.location = "listSearch" + '${pageMaker.makeQuery(1)}'
								+ "&searchType=" + $("select option:selected").val()
								+ "&keyword=" + encodeURIComponent($('#keywordInput').val());
						});
					});			
				</script>
			</div>	
				 
			<div class="col-md-offset-3"> 
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li><a href="listSearch${pageMaker.makeSearch(pageMaker.startPage - 1)}">이전</a></li>
					</c:if>	
		
					<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
						<li <c:out value="${pageMaker.cri.page == idx ? 'class=active' : ''}"/>>
						<a href="listSearch${pageMaker.makeSearch(idx)}">${idx}</a></li>
					</c:forEach>
							
					<c:if test="${pageMaker.next && pageMaker.endPage > 0}">
						<li><a href="listSearch${pageMaker.makeSearch(pageMaker.endPage + 1)}">다음</a></li>
					</c:if>	
				</ul> 
			</div>
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