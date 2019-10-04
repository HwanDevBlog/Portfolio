<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%	
		//userID를 통한 세션 관리
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		if (userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>(주)한국기업 커뮤니티 사이트</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
	<script type="text/javascript">
		//접속한 사용자가 읽지 않은 메시지의 개수를 출력하기 위한 함수 생성
		function getUnread() {
			$.ajax({
				type: "POST",
				url: "./chatUnread",
				data: {
					userID: encodeURIComponent('<%= userID %>'),
				},
				success: function(result) {
					if(result >= 1) {
						showUnread(result);
					} else {
						showUnread('');
					}
				}
			});
		}
		
		//몇초 간격으로 읽지 않은 메시지의 개수를 계속해서 가져오도록 하는 함수
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		
		//읽지 않은 메시지의 개수가 화면에 출력되도록 하기 위한 함수 생성
		function showUnread(result) {
			$('#unread').html(result);
		}
		
		//메시지함 구현을 위한 함수 생성
		function chatBoxFunction() {
			var userID = '<%= userID %>'
			$.ajax({
				type: "POST",
				url: "./chatBox",
				data: {
					userID: encodeURIComponent(userID),
				},
				success: function(data) {
					if(data == "") return;
					$('#boxTable').html('');
					var parsed = JSON.parse(data);
					var result = parsed.result;
					
					for(var i=0; i<result.length; i++) {
						if(result[i][0].value == userID) {
							result[i][0].value = result[i][1].value;
						} else {
							result[i][1].value = result[i][0].value;
						}
						addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, result[i][5].value);
					}
				}
			});
		}
		
		//화면에 메시지 목록을 출력해주기 위한 함수 생성
		function addBox(lastID, toID, chatContent, chatTime, unread, profile) {
			$('#boxTable').append('<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' + 
					'<td style="width: 150px;">' + 
					'<img class="media-object img-circle" style="margin: 0 auto; max-width: 40px; max-height: 40px;" src="' + profile + '">' +
					'<h4>' + lastID + '</h4></td>' +
					'<td>' +
					'<h4>' + chatContent +
					'<span class="label label-info">' + unread + '</span></h4>' +
					'<div class="pull-right">' + chatTime + '</div>' +
					'</td>' + 
					'</tr>');
		}
		
		function getInfiniteBox() {
			setInterval(function() {
				chatBoxFunction();
			}, 3000);
		}
	</script>
</head>
<body>
	<!-- 메뉴 네비게이션 생성 -->
	<nav class="navbar navbar-default">
		<div class-"navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			
			<i><a class="navbar-brand" href="index.jsp">(주)한국기업 커뮤니티 사이트</a></i>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li><!-- 첫번째 리스트 항목 -->
				<li><a href="find.jsp">회원찾기</a></li>
				<li class="active"><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
			</ul>
			<%
				if(userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class=dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="ture"
						aria-expanded="false">접속하기<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				<li>
			</ul>
			<%
				} else { //로그인을 한 상태라면 아래 html 코드가 실행되도록 함
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class=dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="ture"
						aria-expanded="false">회원관리<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">회원정보수정</a></li>
						<li><a href="profileUpdate.jsp">프로필사진수정</a></li>	
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				<li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	
	<!-- 메시지함 디자인 제작 -->
	<div class="container">
		<table class="table" style="margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>메시지 목록</h4></th>
				</tr>
			</thead>
			<div style="overflow-y: auto; width: 100%; max-height: 450px;">
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; margin: 0 auto;">
					<tbody id="boxTable">
					</tbody>
				</table>
			</div>
		</table>
	</div><!-- 메시지함 디자인 제작 종료 -->
	
	<%
		//메세지 내용을 담을 messageContent 변수 생성
		String messageContent = null;
	
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		
		//메세지 타입을 담을 messageType 변수 생성
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		
		//최종적으로 messageContent에 세션값이 존재한다면 아래 문장 실행
		if (messageContent != null) {
	%>
	<!-- modal 디자인 제작 -->
	<div class="modal fade" id="messageModal" tableindex="-1" role="dialog" aria-hidden="ture">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content
				<% if(messageType.equals("오류 메시지")) out.println("panel-warning");
				else out.println("panel-success"); %>">
					<div class="modal-header panel-heading"><!-- modal header -->
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="ture">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div><!-- //modal header -->
					<div class="modal-body"><!-- modal body -->
						<%= messageContent %>
					</div><!-- //modal body -->
					<div class="modal-footer"><!-- modal footer -->
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div><!-- //modal footer -->
				</div>
			</div>
		</div>
	</div><!-- modal 디자인 제작 종료 -->
	<%	
		//modal창을 띄워준 다음 세션 파기
		//즉, 단 한번만 modal창을 사용자에게 보여줄 수 있도록 함
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		if(userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread();
				getInfiniteUnread();
				chatBoxFunction();
				getInfiniteBox();
			});
		</script>
	<%
		}
	%>
</body>
</html>