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

	<div class="container">
		<form  role="form" method="post" autocomplete="off">
			<input type="hidden" id="page" name="page" value="${scri.page}" readonly="readonly" />
			<input type="hidden" id="perPageNum" name="perPageNum" value="${scri.perPageNum}" readonly="readonly" />
			<input type="hidden" id="searchType" name="searchType" value="${scri.searchType}" readonly="readonly" />
			<input type="hidden" id="keyword" name="keyword" value="${scri.keyword}" readonly="readonly" />
			
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>게시글 상세</h4></th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td><h5>글 번호</h5></td>
						<td>
							<input type="text" id="bno" name="bno" class="form-control" value="${read.bno}" readonly="readonly" />
						</td>
					</tr>
					
					<tr>
						<td style="width: 150px;"><h5>글 제목</h5></td>
						<td>
							<input type="text" id="title" name="title" class="form-control" value="${read.title}" readonly="readonly" />
						</td>
					</tr>
					
					<tr>
						<td style="width: 150px;"><h5>글 내용</h5></td>
						<td>
							<textarea id="content" name="content" class="form-control" readonly="readonly" style="width: 100%; height: 200px;">${read.content}</textarea>
						</td>
					</tr>
					
					<tr>
						<td style="width: 150px;"><h5>작성자</h5></td>
						<td>
							<input class="form-control" type="text" id="writer" name="writer" maxlength="30" value="${read.writer}" readonly="readonly">
						</td>
					</tr>
					
					<tr>
						<td><h5>작성 일자</h5></td>
						<td align="left"><fmt:formatDate value="${read.regDate}" pattern="yyyy-MM-dd" /></td>
					</tr>
					
					<tr>
						<td align="right" colspan="3">
							<button type="button" id="list_btn" class="btn btn-primary">목록</button>
							<button type="button" id="modity_btn" class="btn btn-warning">수정</button>
							<button type="button" id="delete_btn" class="btn btn-danger">삭제</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>

	<script>
	//폼을 변수에 저장
	var formObj = $("form[role='form']");
	
	//목록 버튼 클릭
	$("#list_btn").click(function() {	
		self.location = "listSearch?"
			+ "page=${scri.page}&perPageNum=${scri.perPageNum}"
			+ "&searchType=${scri.searchType}&keyword=${scri.keyword}";					
	});
	
	//수정 버튼 클릭
	$("#modity_btn").click(function() {
		formObj.attr("action", "modify");
		formObj.attr("method", "get");		
		formObj.submit();					
	});
	
	//삭제 버튼 클릭
	$("#delete_btn").click(function() {
		formObj.attr("action", "delete");
		formObj.attr("method", "get");
		formObj.submit();
	});
	</script>	
				
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="2"><h4>댓글 목록</h4></th>
				</tr>
			</thead>
				
			<tbody>
				<tr>
					<td><i style="font-weight: bold;">※ 댓글은 작성자에게 큰 힘이 됩니다.</i></td>
				</tr>
				<c:forEach items="${repList}" var="repList">	
					<tr>
						<td align="left">
							<p>
								<span class="glyphicon glyphicon-user"></span>
									${repList.writer}
									(<fmt:formatDate value="${repList.regDate}" pattern="yyyy-MM-dd" />)
							</p>
							<p class="bg-info">${repList.content}</p>
							<button type="button" class="replyUpdate btn btn-warning btn-xs" data-rno="${repList.rno}">수정</button>
							<button type="button" class="replyDelete btn btn-danger btn-xs" data-rno="${repList.rno}">삭제</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
		<script> 
			$(".replyUpdate").click(function() {
				self.location = "replyUpdate?bno=${read.bno}" + "&page=${scri.page}"
					+ "&perPageNum=${scri.perPageNum}" + "&searchType=${scri.searchType}"
					+ "&keyword=${scri.keyword}" + "&rno=" + $(this).attr("data-rno");								
			});
			
			$(".replyDelete").click(function() {
				self.location = "replyDelete?bno=${read.bno}" + "&page=${scri.page}"
					+ "&perPageNum=${scri.perPageNum}" + "&searchType=${scri.searchType}"
					+ "&keyword=${scri.keyword}" + "&rno=" + $(this).attr("data-rno");	
			});							
		</script>
	</div>
			
	<section class="replyForm">
		<div class="container">
			<c:if test="${member != null}">
				<form role="form" method="post" autocomplete="off" class="form-horizontal">
					<input type="hidden" id="bno" name="bno" value="${read.bno}" readonly="readonly" />
					<input type="hidden" id="page" name="page" value="${scri.page}" readonly="readonly" />
					<input type="hidden" id="perPageNum" name="perPageNum" value="${scri.perPageNum}" readonly="readonly" />
					<input type="hidden" id="searchType" name="searchType" value="${scri.searchType}" readonly="readonly" />
					<input type="hidden" id="keyword" name="keyword" value="${scri.keyword}" readonly="readonly" />
				
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2"><h4>댓글 작성</h4></th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<td style="width: 150px;"><h5>작성자</h5></td>
							<td><input class="form-control" type="text" id="writer" name="writer" maxlength="30" value="${member.userName}" readonly="readonly"></td>
						</tr>
	
						<tr>
							<td style="width: 150px;"><h5>댓글 내용</h5></td>
							<td><textarea id="content" name="content" style="width: 100%; height: 100px;"></textarea></td>
						</tr>
						
						<tr>
							<td align="right" colspan="2">
								<button type="button" class="repSubmit btn btn-success">작성</button>
							</td>
						</tr>
					</tbody>					
				</table>
				</form>
			</c:if>
		</div>	
		
		<script>
			var formObj = $(".replyForm form[role='form']");
									
			$(".repSubmit").click(function() {
				formObj.attr("action", "replyWrite");
				formObj.submit();
			});				
		</script>	
	</section>
</body>
</html>