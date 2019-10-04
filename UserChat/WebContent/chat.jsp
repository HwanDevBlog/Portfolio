<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
	<%
		//userID를 통한 세션 관리
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		//데이터를 전송할 때, 보내는 사람과 받는 사람을 모두 정해서 입력해야 하기 때문에 매개변수로 toID 생성
		String toID = null;
		if (request.getParameter("toID") != null) {
			toID = (String) request.getParameter("toID");
		}
		
		if (userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		if (toID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "대화 상대가 지정되지 않았습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		if(userID.equals(URLDecoder.decode(toID, "UTF-8"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "자기 자신에게는 메시지를 전송할 수 없습니다.");
			response.sendRedirect("find.jsp");
			return;
		}
		
		//자신의 프로필 사진을 가져올 수 있도록 하는 객체 생성
		String fromProfile = new UserDAO().getProfile(userID);
		
		//대화 상대방의 프로필 사진을 가져올 수 있도록 하는 객체 생성
		String toProfile = new UserDAO().getProfile(toID);
	%>
	
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>(주)한국기업 커뮤니티 사이트</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
	<!-- 실제로 메시지를 보낼 수 있도록 하는 javascript 생성 -->
	<script type="text/javascript">
		//메시지 출력 후 자동 숨김 함수 생성(이후 메시지 전송 함수 내에서 활용됨)
		function autoClosingAlert(selector, delay) {
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function() { alert.hide() }, delay);
		}
		
		//메시지 전송 함수 생성
		function submitFunction() {
			var fromID = '<%= userID %>'; //메시지를 보내게 되면 자기자신 즉, userID가 fromID가 됨
			var toID = '<%= toID %>';
			var chatContent = $('#chatContent').val();
			$.ajax({
				type: "POST",
				url: "./chatSubmitServlet",
				data: {
					fromID: encodeURIComponent(fromID),
					toID: encodeURIComponent(toID),
					chatContent: encodeURIComponent(chatContent),
				},
				success: function(result) {
					if(result == 1) {
						autoClosingAlert("#successMessage", 2000);
					} else if (result == 0) {
						autoClosingAlert("#dangerMessage", 2000);
					} else {
						autoClosingAlert("#warningMessage", 2000);
					}
				}
			});
			$('#chatContent').val(''); //메시지를 보냈으므로 메시지창을 비워주도록 함
		}
		
		var lastID = 0; //lastID : 가장 마지막 채팅 데이터의 ChatID
		
		//채팅 리스트를 불러오는 함수
		function chatListFunction(type) {
			var fromID = '<%= userID %>';
			var toID = '<%= toID %>';
			$.ajax({
				type: "POST",
				url: "./chatListServlet",
				data: {
					fromID: encodeURIComponent(fromID),
					toID: encodeURIComponent(toID),
					listType: type
				},
				success: function(data) {
					if (data == "") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for (var i=0; i<result.length; i++) {
						if(result[i][0].value == fromID) { //현재 메시지를 보낸 사람의 ID가 자기자신의 ID와 동일하다면
							result[i][0].value = '나'; //'나'라고 출력되도록 함
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
					
					//ChatListServlet에서 last에 해당되는 ChatID를 가져오도록 함
					lastID = Number(parsed.last);
				}
			});
		}
		
		//채팅 내용을 화면에 출력할 수 있도록 해주는 함수 생성
		function addChat(chatName, chatContent, chatTime) {
			
			//메시지를 전송한 사용자의 이름이 '나'일 경우에는 아래 문장이 실행되도록 함
			//나의 프로필 사진을 담고 있는 fromProfile이 출력되도록 하기 위함
			if(chatName == '나') {
			$('#chatList').append('<div class="row">' +
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 100px; height: 70px;" src="<%= fromProfile %>" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading">' +
					chatName +
					'<span class="small pull-right">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
		} else {
			//메시지를 전송한 사용자의 이름이 '나'가 아닐 경우에는 아래 문장이 실행되도록 함(상대방이 나에게 메시지를 보낸 경우를 의미)
			//대화 상대방의 프로필 사진을 담고 있는 toProfile이 출력되도록 하기 위함
			$('#chatList').append('<div class="row">' +
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 100px; height: 70px;" src="<%= toProfile %>" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading">' +
					chatName +
					'<span class="small pull-right">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
		}	
			$('#chatList').scrollTop($('#chatList')[0].scrollHeight); //메시지가 올 때마다 스크롤을 가장 아래쪽으로 내려주도록 함
		}
		
		//몇초 간격으로 새로운 메시지를 계속해서 가져오도록 하는 함수
		function getInfiniteChat() {
			
			//setInterval() : 일정 시간마다 반복 실행되는 함수
			setInterval(function() {
				chatListFunction(lastID);
			}, 3000); //3000 : 3초
		}
		
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
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">회원찾기</a></li>
				<li><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
			</ul>
			<%
				if (userID != null) {
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
	
	<!-- 실시간 채팅창 생성 -->
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					
					<div id="chat" class="panel-collapse collapse in">
						<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height: 600px;">
						</div>
						<div class="portlet-footer">
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="메시지를 입력하세요" maxlength="100"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 채팅 알림창 생성 -->
	<div class="alert alert-success" id="successMessage" style="display: none;">
		<strong>메시지 전송에 성공했습니다.</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display: none;">
		<strong>내용을 입력해주세요</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage" style="display: none;">
		<strong>데이터베이스 오류가 발생했습니다.</strong>
	</div>
	
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
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		//modal창을 띄워준 다음 세션 파기
		//즉, 단 한번만 modal창을 사용자에게 보여줄 수 있도록 함
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script type="text/javascript">
		//세션과 상관없이 반드시 실행되어야 하는 부분이므로, 스크립트를 별도로 분리
		//채팅 리스트가 웹 페이지에서 보여지도록 함
		$(document).ready(function() {
			getUnread();
			chatListFunction('0');
			getInfiniteChat();
			getInfiniteUnread();
		});
	</script>
</body>
</html>