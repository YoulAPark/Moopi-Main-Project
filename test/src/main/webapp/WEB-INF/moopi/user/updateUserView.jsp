<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">

<title>Moopi</title>


<! ------------------------------------------------ Bootstrap, jQuery CDN -------------------------------------------------->
<!-- Favicon-->
<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
<!-- Bootstrap icons-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"
	rel="stylesheet" />
<!-- Core theme CSS (includes Bootstrap)-->
<link href="/css/styles.css" rel="stylesheet" />
<!-------------------------------------------------------------------------------------------------------------------------->

<!-- 구글폰트api -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Gaegu:wght@300&display=swap"
	rel="stylesheet">


<!-- 필수 Core theme CSS (includes Bootstrap)-->
<link href="/css/admin/styles.css" rel="stylesheet" />

<! -- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

<!-- 스윗얼럿 -->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<!-------------------------------------------------------------------------------------------------------------------------->

<script>

// # 새 창으로 모바일번호 인증 띄우기 --------------------------------------------------------------------------------------------------------------------------
					
		
		function updatePN() {
			
			var popWin;
			var userId = $("#userId").val();
		
			popWin = window.open(
					"getMobileAuth?",
					"childForm",
					"left=460, top=300, width=580, height=550, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");	
			
			function setChildTest() {
				openWin.document.getElementById("cInput").value = document.getElementById("pnNum").value;				
       		}
       		
		}
	
<!-------------------------------------------------------------------------------------------------------------------------->

//-- [중간완료] 비밀번호 일치 Ajax 실행  --------------------------------------------------------------------------------------------------------------------------
		
		$(function(){
		
			$("#password1").keyup(function(){
				
				var regex = /^[A-Za-z\d]{8,12}$/;
				var result = regex.exec($("#password1").val());
				
				if(result != null){
                    $('#pwd_right').text("");
                    $("#updateBtn").attr("disabled", false);
                }else{
                    $('#pwd_right').text("비밀번호는 영어대소문자와 숫자를 포함하여 8-11자리이상으로 작성해주세요");
                    $('#pwd_right').css("color","red");
                    $("#updateBtn").attr("disabled", false);
                }
			
				$('#pwd_check').text('');
				$("#updateBtn").attr("disabled", false);
			});
		
			$("#password2").keyup(function(){				
					if ($("#password1").val() != $("#password2").val()){					
						$('#pwd_check').text('');
						$('#pwd_check').text('비밀번호가 일치하지 않습니다.');
						$('#pwd_check').css("color","red")
						$("#updateBtn").attr("disabled", true);

					}else{
						$('#pwd_check').text('');
						$('#pwd_check').text('비밀번호가 일치합니다.');
						$('#pwd_check').css("color","black")
						$("#updateBtn").attr("disabled", false);
						
			}
		}); 
	});
<!----------------------------------------updateUserPwd--------------------------------------------------------------------------------->
// [완료] by.율아
// 내 정보보기 - 계정정보수정
// 수정type : 1)모바일번호, 2)비밀번호
	function edit(type){
		
		var userId = $("#userId").val();
		var phone = $("#pInput").val();	
		var password = $("#password1").val();
		
		// "type==1" : phone / 모바일번호수정
		if(type == 1){
			$.ajax ({
				url : "/user/json/updateUser/"+type,
				type : "POST",
				contentType : "application/JSON",
				dataType : "text",
				data : JSON.stringify ({ "userId" : userId, "phone" : phone }),
				success : function(data, state) {
						swal("success","모바일번호 수정이 완료되었습니다","success");
						$('.LabelPhone').text(data);
				}	
			});	
		
		// "type==2" : password / 비밀번호수정
		}else if(type == 2){
			
			$.ajax ({
				url : "/user/json/updateUser/"+type,
				type : "POST",
				contentType : "application/JSON",
				dataType : "text",
				data : JSON.stringify ({ "userId" : userId, "password" : password }),
				success : function(data, state) {
						swal("success","비밀번호 수정이 완료되었습니다","success");
				}	
			});	
		}
	}




<!-- [완료] 모바일번호수정 -->	
/* 	function editPN() {
		var userId = $("#userId").val();
		var phone = $("#pInput").val();	
		$.ajax ({
			url : "/user/json/updateUserPhone",
			type : "POST",
			contentType : "application/JSON",
			dataType : "text",
			data : JSON.stringify ({ "userId" : userId, "phone" : phone }),
			success : function(data, state) {
					swal("success","모바일번호 수정이 완료되었습니다","success");
					$('.LabelPhone').text(data);
			}	
		});	
	}

<!-- [완료] 비밀번호수정 -->
	function editPW() {
		var userId = $("#userId").val();
		var password = $("#password1").val();	
		$.ajax ({
			url : "/user/json/updateUserPWD",
			type : "POST",
			contentType : "application/JSON",
			dataType : "text",
			data : JSON.stringify ({ "userId" : userId, "password" : password }),
			success : function(data, state) {
					swal("success","비밀번호 수정이 완료되었습니다","success");
			}	
		});	
	} */
	
<!-- 모달 회원탈퇴 -->
	 function fncLeave() {
     
     	var userId = $("#userId").val();
     	var userRole = $("#userRole").val();
     	var stateReason = $("input[name='leaveReason']").val();
   	
     	/* alert("유저아이디 : "+userId);
     	alert("유저롤 : "+userRole);
     	alert("탈퇴사유 : "+stateReason); */
     	
     	location.href = "/user/updateLeaveUser?userId="+userId+"&userRole="+userRole+"&stateReason="+stateReason;
     	//$("form").attr("method" , "POST").attr("action" , "/user/updateLeaveUser").submit();
     	
     } 
</script>
<style>
body {
	padding-top: 100px;
}

//
padding-top: 200px ; .etcContent {
	position: relative;
	font-size: 15px;
	text-align: center;
	font-weight: 340;
	padding-down: 100px;
}

.etcName {
	position: relative;
	font-size: 15px;
	text-align: left;
	font-weight: 340;
}

.updateUserAccount {
	font-family: "NanumGothic";
	text-align: center;
	font-size: 30px;
	padding: 15px;
}

.LabelId {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 20px;
	padding-top: -15px;
}

.LabelName, .LabelPhone {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 20px;
	padding-top: 5px;
}

.LabelBirth {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 20px;
	padding-top: -10px;
	display: inline-block
}

.LabelAge {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 20px;
	padding-top: -20px;
	display: inline-block
}

.LabelPhoneNum {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
	padding-top: 10px
}

.LabelPwdNum {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
}

#newPW {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
	padding-top: -50px;
}

.editPhoneNum {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
	padding-top: 20px
}

#mobileAuthBtn {
	border: 1px solid gray;
	top: -50px;
	font-size: 12px;
	width: 68px;
	width: 69px;
	text-align: center;
}

.LabelPwd1Num {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
	padding-top: 25px;
	paddint-down: 8px;
}

.nowPwd1 {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
}

#password1 {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
}

.editPwd2 {
	font-family: "NanumGothic";
	text-align: left;
	font-size: 16px;
	padding-top: 25px;
}

.check_font {
	position: fixed;
	font-family: "NanumGothic";
	text-align: left;
	font-size: 12px;
}

#updateBtn {
	border: 1px solid gray;
	font-size: 12px;
	right: 19px;
	width: 68px;
}

.MB {
	padding-bottom: 24px;
}

.editMobileContent {
	font-size: 12px;
	text-align: left;
	font-weight: 340;
	top: -24px;
}

.updateProfile {
	position: relative;
	font-size: 36px;
	text-align: center;
	font-weight: 340;
}

.etcContent {
	position: relative;
	font-size: 15px;
	text-align: center;
	font-weight: 340;
}

.etcName {
	position: relative;
	font-size: 15px;
	text-align: left;
	font-weight: 340;
}

.modal-title {
	font-weight: 700;
	font-size: 24px;
}

.h4 {
	font-size: 18px;
}

.delete_p {
	font-weight: 340;
	color: gray;
}

.container px-5 my-5 {
	background-color: #d6d5d5;
}

#leaveReason {
	width: 430px;
	height: 100px;
}

#updatebtn {
	position: relative;
	left: 381px;
	top: -48px;
	width: 80px;
}

#updateContent {
	position: relative;
	left: 381px;
	top: -28px;
	width: 80px;
}

#adrSearch {
	position: relative;
	left: 381px;
	top: -28px;
	width: 80px;
}

#editBtn {
	position: relative;
	left: 381px;
	top: 0px;
	width: 80px;
}

.leaveUser {
	width: 100px;
}

.updateProfile {
	position: relative;
	font-size: 36px;
	text-align: center;
	font-weight: 340;
}

.etcContent {
	position: relative;
	font-size: 15px;
	text-align: center;
	font-weight: 340;
}

#staticBackdrop {
	top: 0%;
	margin-top: -100%;
	width: 640px;
}

//
모달Body
		.modal-body {
	width: 300%;
	top: 30%;
	padding: 50px;
}

.inforhead {
	font-size: 24px;
	font-weight: bold;
	line-height: 34px;
	margin-bottom: 16px;
}
</style>
</head>
<body>

	<!-- Tool Bar ---------------------------------------------------------------------------------------------------------------->
	<jsp:include page="../layout/toolbar.jsp" />
	<!---------------------------------------------------------------------------------------------------------------------------->
	<div id="wrapper">
		<!-- 리스트 뷰 -->
		<div class="container">
			<div class="row multi-columns-row">
				<div class="row">
					<div class="col-xs-3 col-sm-3 col-md-3">
						<!-- [left toolbar] -------------------------------------------------------->
						<jsp:include page="../layout/userToolbar.jsp" />
						<!----------------------------------------------------------------->
					</div>
					<div class="col-xs-9 col-sm-9 col-md-9">

						<div class="inforhead">내 정보</div>

						<!-- 수정창 시작 -->
						<div
							class="mx-auto h-full flex flex-1 justify-center items-center">
							<div class="w-full max-w-lg">
								<div class="leading-loose">
									<form class="max-w-xl m-4 p-10 bg-white rounded shadow-xl">

										<input type="hidden" class="form-control" id="userId"
											name="userId" value="${dbUser.userId}"> <input
											type="hidden" class="form-control" id="passwordConfirm"
											name="passwordConfirm" value="${dbUser.password}">
										<div>
											<h1 class="updateProfile">계정정보수정</h1>
											<p class="etcContent">변경하실 사항을 입력해주신 후 변경버튼을 눌러주세요</p>
										</div>
										<div>
											<div form-group class="userInformation">
												<p class="etcName">아이디</p>
												<h6 class="LabelId block text-sm text-gray-00">
													${dbUser.userId}</label>
												</h6>
												<p class="etcName">닉네임</p>
												<h6 class="LabelName block text-sm text-gray-00">
													${dbUser.userName}</label>
												</h6>
												<p class="etcName">모바일번호</p>
												<h6 class="LabelPhone block text-sm text-gray-00">
													${dbUser.phone}</label>
												</h6>
												<p class="etcName">생년월일 / 나이</p>
												<h6 class="LabelBirth block text-sm text-gray-00">
													${dbUser.birth} / ${dbUser.age} 세</label>
												</h6>
												<%-- <h6 class="LabelAge block text-sm text-gray-00">
													/ ${dbUser.age} 세</label>
												</h6> --%>
											</div>
										</div>

										<div class="MobileNum">
											<div class="MB">
												<h6 class="LabelPhoneNum block text-sm text-gray-00">
													모바일번호</label>
												</h6>
											</div>
											<div class="phoneNumDown">
												<input
													class="editPhoneNum w-full px-3 py-1 text-gray-700 bg-gray-200 rounded"
													id="pInput" name="phone" type="text"
													value=${dbUser.phone
								} onClick="updatePN()"
													readonly>
											</div>
											<div class="d-flex">
												<div class="editMobileContent">
													<p class="editMC">모바일번호 변경을 원하신다면 위의 칸을 눌러주세요</p>
												</div>
												<div class="mobileAuthBtn ms-auto">
													<button type="button" id="mobileAuthBtn" class="micro_btn"
														onClick="edit(1)">변경하기</button>
												</div>
											</div>
										</div>

										<div>
											<h6 class="LabelnewPwd block text-sm text-gray-00" id="newPW">
												새 비밀번호</label>
											</h6>
										</div>

										<div class="editPwd">
											<div class="editPwd1">
												<input
													class="w-full px-3 py-1 text-gray-700 bg-gray-200 rounded"
													id="password1" name="password" type="password"
													placeholder="새 비밀번호를 입력해주세요">
											</div>
											<div class="check_font" id="pwd_right"
												style="font-size: 12px"></div>
											<div class="editPwd2">
												<input
													class="newPwd2 w-full px-3 py-1 text-gray-700 bg-gray-200 rounded"
													id="password2" name="password2" type="password"
													placeholder="새 비밀번호를 한번 더 입력해주세요">
											</div>
											<div class="check_font" id="pwd_check"></div>

											<div class="d-flex justify-content-end">
												<button type="button" id="updateBtn" class="micro_btn"
													onClick="javascript:edit(2)">변경하기</button>
											</div>
										</div>

										<div class="d-flex justify-content-end"
											style="padding-top: 10px;">
											<button type="button" class="btn btn-light leaveUser"
												data-bs-toggle="modal" data-bs-target="#staticBackdrop">회원탈퇴</button>
										</div>
									</form>
								</div>
							</div>
						</div>
						<!-- 수정창 끝 -->
					</div>
				</div>
			</div>
		</div>



		<!-- Modal -->
		<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static"
			data-bs-keyboard="false" tabindex="-1"
			aria-labelledby="staticBackdropLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h2 class="modal-title" id="staticBackdropLabel">정말 무피를
							떠나실건가요?</h2>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<div class="modal-body">
						<form id="deleteUser">
							<!-- !!!! -->
							<input type="hidden" id="deleteId" name="userId"
								value="${dbUser.userId}" /> <input type="hidden" id="userRole"
								name="userRole" value="${dbUser.userRole}" /> <input
								type="hidden" id="stateReason" name="stateReason"
								value="${dbUser.stateReason}" />
							<h4 class="h4">회원탈퇴 신청 전 아래 사항을 확인 부탁드립니다 😊</h4>

							<div class="delete_p" style="margin-top: 10px;">
								<p>1. 신청일부터 30일 후 회원탈퇴가 처리되며, 회원탈퇴 처리 전까지 저희 무피사이트를 찾아주셔서
									로그인 진행을 해주신다면 그 신청을 철회할 수 있습니다.</p>
								<p>2. 회원탈퇴 후 기존 계정으로 회원가입을 신청할 수 없습니다.</p>
								<p>3. 회원탈퇴 시 가입한 모임, 코인 등 회원이 가진 권리는 모두 소멸합니다. 회원탈퇴 후 잔여코인과
									관련한 환불이 불가하므로 필요한 경우 탈퇴 전에 환불을 신청해주세요.</p>
								<p>4. 회원탈퇴 시 회사가 보관하고 있는 회원 데이터는 모두 영구적으로 삭제됩니다. 다만, 관련 법령에
									따라 회사가 보관할 의무가 있는 정보 또는 자료는 일정기간 동안 보관됩니다.</p>
								<p>5. 회원탈퇴 후 저희 무피사이트에 게시한 게시물을 편집하거나 삭제할 수 없습니다. 필요한 경우 신청
									전 게시물을 편집하거나 삭제해주세요.</p>
							</div>

							<div class="container mx-auto h-full flex flex-1"margin: 0px;>
								<div class="pwd" style="margin-top: 40px;">
									<h4>사유를 입력해주세요</h4>
									<label class="block text-sm text-gray-00"
										style="margin-top: 10px;"></label> <input type="text"
										class="w-full px-30 py-1 text-gray-700 bg-gray-200 rounded"
										id="leaveReason" max-width: 500px; name="leaveReason">
								</div>
							</div>
						</form>
					</div>

					<div class="modal-footer">
						<button type="button"
							class="btn btn-light text-black font-light bg-gray-300"
							style="width: 500px;" data-bs-dismiss="modal">뒤로가기</button>
						<button type="button"
							class="btn btn-secondary text-white font-light bg-gray-900"
							style="width: 500px;" onclick="javascript:fncLeave()">탈퇴하기</button>
					</div>
				</div>
			</div>
		</div>

	</div>


	<jsp:include page="../layout/footer.jsp"></jsp:include>
	<!-- Bootstrap core JS-->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Core theme JS-->
	<script src="/js/scripts.js"></script>

</body>
</html>