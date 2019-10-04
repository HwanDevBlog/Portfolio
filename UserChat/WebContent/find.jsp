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
	
	<!-- 실제로 회원을 찾을 수 있도록 ajax를 이용한 자바스크립트 함수 생성 -->
	<script type="text/javascript">
		function findFunction() {
			var userID = $('#findID').val();
			$.ajax({
				type: "POST",
				url: './UserFindServlet',
				data: {userID: userID},
				success: function(result) {
					if(result == -1) {
						$('#checkMessage').html('회원을 찾을 수 없습니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();
					}
					else {
						$('#checkMessage').html('회원찾기에 성공했습니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
						var data = JSON.parse(result);
						var profile = data.userProfile;
						getFriend(userID, profile);
					}
					$('#checkModal').modal("show");
				}
			});
		}
		
		//회원찾기 결과를 보여주는 자바스크립트 함수 생성
		function getFriend(findID, userProfile) {
			$('#friendResult').html('<thead>' +
					'<tr>' +
					'<th><h4>검색 결과</h4></th>' +
					'</tr>' +
					'</thead>' +
					'<tbody>' +
					'<tr>' +
					'<td style="text-align: center;">' +
					'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="' + userProfile + '">' +
					'<h3>' + findID +
						'</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) +
						'" class="btn btn-primary pull-right">' + '메시지 보내기</a></td>' +
					'</tr>' +
					'</tbody>');
		}
		
		//회원찾기 결과가 없을 때, html 내용을 지워주는 함수 생성
		function failFriend() {
			$('#friendResult').html('');
		}
		
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
		
		//4초 간격으로 읽지 않은 메시지의 개수를 계속해서 가져오도록 하는 함수 생성
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
				<li class="active"><a href="find.jsp">회원찾기</a></li>
				<li><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
			</ul>
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
		</div>
	</nav>
	
	<!-- 회원찾기 화면 생성 -->
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
			<thead>
				<tr>
					<th colspan="2"><h4>회원찾기</h4></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 110px;"><h5>회원 아이디</h5></td>
					<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="찾을 아이디를 입력하세요"></td>
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">검색</button></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<!-- 회원찾기 결과 화면 생성 -->
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
		</table>
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
	
	<!-- 회원찾기 관련 체크 modal창 생성 -->
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="ture">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading"><!-- modal header -->
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="ture">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							확인 메시지
						</h4>
					</div><!-- //modal header -->
					<div id="checkMessage" class="modal-body"><!-- modal body -->
					</div><!-- //modal body -->
					<div class="modal-footer"><!-- modal footer -->
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div><!-- //modal footer -->
				</div>
			</div>
		</div>
	</div><!-- modal 디자인 제작 종료 -->
	<%
		if(userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread();
				getInfiniteUnread();
			});
		</script>
	<%
		}
	%>
</body>
</html>