<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>(주)한국기업 커뮤니티 사이트</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

	<script type="text/javascript">
		//아이디 중복체크 함수 생성
		function registerCheckFunction() {
			var userID = $('#userID').val();
			$.ajax({
				type: 'POST',
				url: './UserRegisterCheckServlet',
				data: {userID: userID},
				success: function(result) {
					if(result == 1) {
						$('#checkMessage').html('사용할 수 있는 아이디입니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
					} else {
						$('#checkMessage').html('사용할 수 없는 아이디입니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
					}
					$('#checkModal').modal("show");
				}
			});
		}
		
		//비밀번호 체크 함수 생성
		function passwordCheckFunction() {
			var userPassword1 = $('#userPassword1').val();
			var userPassword2 = $('#userPassword2').val();
			if(userPassword1 != userPassword2) {
				$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
			} else {
				$('#passwordCheckMessage').html('');
			}
		}
	</script>
</head>
<body>
	<%
		//userID를 통한 세션 관리
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		if (userID != null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있는 상태입니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
	
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
						<li class="active"><a href="join.jsp">회원가입</a></li>
					</ul>
				<li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	
	<!-- 회원가입 양식 생성 -->
	<div class="container">
		<form method="post" action="./userRegister">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead><!-- table header -->
					<tr>
						<th colspan="3"><h4>회원가입</h4>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><input class="form-control" type="text" id="userID" name="userID" maxlength="20" placeholder="아이디를 입력하세요"></td>
						<td style="width: 110px;"><button class="btn btn-primary" onclick="registerCheckFunction();" type="button">중복체크</button>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" type="password" id="userPassword1" name="userPassword1" maxlength="20" placeholder="비밀번호를 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호 확인</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" type="password" id="userPassword2" name="userPassword2" maxlength="20" placeholder="비밀번호를 다시 한번 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>이름</h5></td>
						<td colspan="2"><input class="form-control" type="text" id="userName" name="userName" maxlength="20" placeholder="이름을 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>나이</h5></td>
						<td colspan="2"><input class="form-control" type="number" id="userAge" name="userAge" maxlength="20" placeholder="나이를 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>성별</h5></td>
						<td colspan="2">
							<div class="form-group" style="text-align: center; margin: 0 auto;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary active">
										<input type="radio" name="userGender" autocomplete="off" value="남자" checked>남자
									</label>
									<label class="btn btn-primary">
										<input type="radio" name="userGender" autocomplete="off" value="여자">여자
									</label>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>이메일</h5></td>
						<td colspan="2"><input class="form-control" type="email" id="userEmail" name="userEmail" maxlength="20" placeholder="이메일을 입력하세요"></td>
					</tr>
					<tr>
						<td style="text-align: Left;" colspan="3">
						<h5 style="color: red;" id="passwordCheckMessage"></h5>
						<input class="btn btn-primary pull-right" type="submit" value="가입완료">
						</td>
					</tr>
				</tbody>
		</form>
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
	
	<!-- 중복체크를 할 때마다 중복여부에 따라서 실제 사용자의 화면에 띄워지게 되는 modal창 생성 -->
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
</body>
</html>