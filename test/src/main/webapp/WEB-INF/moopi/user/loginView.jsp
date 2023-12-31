<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Moopi </title>

<!-- Core theme CSS (includes Bootstrap)-->
	<link href="/css/styles.css" rel="stylesheet" />
	
<! -- jQuery CDN -->	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>

<!-- 구글폰트api -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gaegu:wght@300&display=swap" rel="stylesheet">

<!-- 스윗얼럿 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<!-- Favicon-->
<link rel="icon" type="image/x-icon" href="assets/favicon.ico" />

<!-- Bootstrap icons-->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
	
<!-- 카카오로그인 -->
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<!-- [완료] by.율아 -->
<!-- Google Login API : People API -->
<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
<meta name="google-signin-client_id" 
	  content="959630660117-f5d12kulu8hloob7jid8f0jfeenr57sv.apps.googleusercontent.com">

<!-- 네이버로그인 -->
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js"></script>

<!-- 모달 -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="/js/scripts.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
	

<!-------------------------------------------------------------------------------------------------------------------------->
<script>
	
	// 로그인시 api 및 key
	// 카카오 API 키 : 2e00cfe75ad365584acc76b588be8d74
	// 구글 Client ID : 959630660117-f5d12kulu8hloob7jid8f0jfeenr57sv.apps.googleusercontent.com
	// 구글 키 : AIzaSyD3N7qWQr_bjwh9Lw-fLaK8bW5GtqbvAV8
	// 네이버 : MJJpKOvtYqXuhtTnhQtq

// [완료] by.율아
// [로그인처리]
// [로그인적합성체크] : 유저롤이 4,5,6번일 경우 경고 alert 창 출력
// 아이디입력, 비밀번호입력, userRole에 따른 로그인처리
	function fncLogin() {		
		
		var id=$('input[name=userId]').val();
		var password=$('input[name=password]').val();		

		// 아이디를 입력하지 않았을 경우
		if(id == null || id.length < 1) {
			swal("아이디를 입력하지 않으셨습니다.","아이디를 다시 확인해주세요","warning");
			$('input[name=userId]').focus();
			return;
		}
		
		// 비밀번호를 입력하지 않았을 경우
		if(password == null || password.length < 1) {
			swal('비밀번호를 입력하지 않으셨습니다.',"비밀번호를 다시 확인해주세요","warning");
			$('input[name=password]').focus();
			return;
		}
		
			// ajax를 사용하여 유저의 상태에 따른 결과창을 출력한다.
			$.ajax({
				url : "/user/json/getRole",
				method : "POST",
				contentType : "application/JSON",
				dataType : "JSON",				
				data : JSON.stringify({"userId" : id}),
				success : function(data, state) {	
					
					// (userRole==6) 영구탈퇴회원이 로그인을 시도했을 경우
					if(data.userRole == 6){
						swal("이미 탈퇴하신 회원입니다","새로 가입을 진행해주세요","warning");
						return;

					// (userRole==5) 복구탈퇴회원이 로그인을 시도했을 경우
					} else if(data.userRole == 5){
						popWin = window.open(
								"/user/updateRestoreUser?userId="+data.userId
										+"&profileImage="+data.profileImage
										+"&nickname="+data.nickname,
								"popWin",
								"left=460, top=300, width=600, height=465, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");
					
					// (userRole==4) 블랙회원이 로그인을 시도했을 경우
					} else if(data.userRole == 4) {
						popWin = window.open(
								"/user/getBlackUser?userId="+data.userId
										+"&profileImage="+data.profileImage
										+"&nickname="+data.nickname
										+"&stateReason="+data.stateReason,
								"popWin",
								"left=460, top=300, width=600, height=465, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");
					
					// 그 외의 로그인이 가능한 유저롤의 경우
					} else {			
						$("form").attr("method", "POST").attr("action", "/user/loginUser").submit();
					}
					
				}	
			});
					
	}	
	
// [회원가입 네비게이션]								
	$(function() {	
			$( "input[name='addUser']" ).on("click", function() {
				location.href="/user/addUserView";
			});
	});

// [완료] by.율아
// 구글 로그인 기능 구현 < Google people API >
// API 라이브러리 URL : https://developers.google.com/resources/api-libraries/documentation/people/v1/java/latest/
// 구글 Client ID : 959630660117-f5d12kulu8hloob7jid8f0jfeenr57sv.apps.googleusercontent.com	
		
		// 1. init function() 실행
		function init() {			
			gapi.load('auth2', function() {
					
					// gapi.auth2.init() : GoogleAuth 개체 초기화하는 작업
					gapi.auth2.init();				
					options = new gapi.auth2.SigninOptionsBuilder();
					options.setPrompt('select_account');
											
					 // Google에 등록된 email과 profile을 받아온다.
					options.setScope('email profile openid https://www.googleapis.com/auth/user.birthday.read');
										
					// 인스턴스의 함수 호출 - element에 로그인 기능 추가
									        
					// googleLogin : Body의 id 값을 따라간다.  
					// options : options = new gapi.auth2.SigninOptionsBuilder();
					// onSignIn function 
					// onSignInFailure function
					gapi.auth2.getAuthInstance().attachClickHandler('googleLogin', options, googleSign, onSignInFailure);
			}) //End gapi.load
		} //End init function

		// [완료] by.율아
		// 구글 로그인 기능 구현 < Google people API >
		// API 라이브러리 URL : https://developers.google.com/resources/api-libraries/documentation/people/v1/java/latest/
		// 구글 Client ID : 959630660117-f5d12kulu8hloob7jid8f0jfeenr57sv.apps.googleusercontent.com	
		// 구글 가입, 로그인 진행시 function()
		function googleSign(googleUser) {
			
			// token 발급을 진행한다.
			var access_token = googleUser.getAuthResponse().access_token 		
				
			// Ajax를 사용하여 Google OAuth 동의 화면을 출력한다.
			$.ajax({		    	
			    	
					// 구글 선택동의 창 출력	
					// 'personFields : userDefined' => 반환 될 필드 사용자정의로 제한
					url : 'https://people.googleapis.com/v1/people/me',
					data: { personFields:'userDefined', 
							key:'AIzaSyD3N7qWQr_bjwh9Lw-fLaK8bW5GtqbvAV8', 
							'access_token': access_token},
					method:'GET',
					
					success : function(data) {
						var profile = googleUser.getBasicProfile();
						var userId = profile.getId();
						location.href = "/user/googleLogin?userId="+userId
					},
					
					error : function(data) {
						console.log(e);
					}
					
					});
		} //End onSignIn Function   
        
<!--- [구현중] 네이버로그인 API --------------------------------------------------------------------------------------------------------->	
	
	function NaverLogin() { 
				
			var naverLogin = new naver.LoginWithNaverId ({
			
				clientId: "MJJpKOvtYqXuhtTnhQtq",
				callbackUrl: "http://localhost:8080/user/addUserInfo?userdId="+userId,
				isPopup: true,
				loginButton: {color: "green", type: 3, height: 45}

			});

				naverLogin.init(function naverlogin() {
		
				// Client Id 값, RedirectURI 지정
					var naver_id_login = new naver_id_login("MJJpKOvtYqXuhtTnhQtq", "http://localhost:8080/user/addUserInfo?userId="+userId);
		
				// 접근 토큰 값 출력 [콘솔창 정상출력 확인 완료]
					console.log("네이버 토큰 확인 : "+naver_id_login.oauthParams.access_token);	
					console.log("state 확인 : "+naver_id_login.oauthParams.state);
					console.log("토큰 타입 확인 : "+naver_id_login.oauthParams.token_type);
					console.log("expires_in 확인 : "+naver_id_login.oauthParams.expires_in);
					
					alert("URL로 주어지는 기본적인 토큰 값 출력완료");
					alert("네이버 토큰 확인 : "+naver_id_login.oauthParams.access_token);	
					alert("state 확인 : "+naver_id_login.oauthParams.state);
					alert("토큰 타입 확인 : "+naver_id_login.oauthParams.token_type);
					alert("expires_in 확인 : "+naver_id_login.oauthParams.expires_in);
		
		
				// 네이버 사용자 프로필 조회 - naverSignInCallback function 호출
					naver_id_login.get_naver_userprofile("naverSignInCallback()"); 
					
					function naverSignInCallback() {		
						
						if(naver_id_login.getProfileData('id')){
							var userId = naver_id_login.getProfileData('id');
							console.log("아이디 : "+userId);	
							alert("아이디 : "+userId);	
							
							$.ajax({
								
								type : "GET",
								url : currentHostPath + '/user/addUserInfo?userId="+userId',
								data : {
									naverId : 'naverId',	
								},
								success : function(data) {
									console.log("성공");
								},
								error : function(data) {
									console.log("실패");
								}
								
							});
														
						} else {
							alert("ERROR");
							window.close();
						}//End if문
										
			 		}//End naverSignInCallback
			
			});
		

		//$("form").attr("method" , "POST").attr("action" , "/user/naverlogin").submit();
	}
	
// [카카오로그인]
	
		$("#custom-login-btn").on("click" , function() {
			KakaoLogin();
		});
		
		function KakaoLogin() { 		
			// 카카오 API key
			Kakao.init('2e00cfe75ad365584acc76b588be8d74');
			Kakao.Auth.login({	
				scope : 'account_email',
				success : function(authObj) {				
					
					Kakao.API.request({				
					       url: '/v2/user/me',				       
						success: function(response){
							console.log("아이디 : "+response.id);
							console.log("카카오계정 : "+response.kakao_account);
							console.log("이메일주소 : "+response.kakao_account['email']);
							//console.log("성별 : "+response.kakao_account['gender']);	
							//console.log("생일 : "+response.kakao_account['birthday']);				
							var userId = response.id;	
							//var gender = response.gender;
							//var birth = response.birthday;						
							location.href = "/user/kakaoLogin?userId="+userId;			
						} //End response function					
					}) //End API.request				
				} //End authObj Function			
			}) //End Auth.login		
		} //End Function	
	
// 카카오로그아웃(토큰종료) : 현재 미사용 필요시 해당 구현품 사용할 것
	
		function KakaoLogout() {
			
			if (Kakao.Auth.getAccessToken()) {
				Kakao.API.request({
					url : '/v1/user/unlink',					
					success : function(response) {
						alert("로그아웃 성공하였습니다.");
						console.log(response)
					}, fail : function(error) {
						console.log(error)
					},
				})				
				Kakao.Auth.setAccessToken(undefined)
			}
		}

// [아이디찾기]
	function findId() {	
		$(".forgot-Id").fadeIn();
		var popWin;
		var findId = $("#findId").val();		
		popWin = window.open(
					"getMobileAuth?findId",
					"childForm",
					"left=460, top=300, width=580, height=550, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");									
	}


// [비밀번호찾기]	
	function findPwd() {
		$(".forgot-pass").fadeIn();			
		var popWin;
		var id=$('input[name=userId]').val();
		var findPwd = $("#findPwd").val();	
		popWin = window.open(
					"searchUserPwd?findPwd",
					"childForm",
					"left=460, top=300, width=580, height=515, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");									
	}
		
</script>		
   
	<style>
	
	html {	
		height:100%;
	}
	
	body {	
		position: relative; 
		width : 100%;
		height : 100%;
		background-color : white;
	}
	
	.realCenter {
		position : absolute;
		top : 50%;
		left : 50%;
		margin:-300px 0 0 -150px
	}
			

	
	#MP {
		text-align : center;
	}
	

		

	</style>
	
	<style type="text/css">
		a:link { color: gray; text-decoration: none;}
		a:visited { color: black; text-decoration: none;}
		a:hover { color: red; text-decoration: none;}
	</style>
	
	
	
</head>

<body>

	<!-- Tool Bar ---------------------------------------------------------------------------------------------------------------->
	<!---------------------------------------------------------------------------------------------------------------------------->

	<!-- 화면구성 div Start ---------------------------------------------------------------------------------------------------------------->
	<input type="hidden" class="form-control" id="userRole" name="userRole" value="${user.userRole}" readonly>

	<div class="realCenter">	

						
							<div class="mb-4" >
								<h3 class="row align-items-center justify-content-center">Moopi</h3><br>
								<p class="mb-4" id="MP">Move People</p>
							</div>
					
							<form class="AddUserCenter" action="#" method="post">
								
								<!-- 아이디입력 -->
								<div class="form-group first">
									<label for="userId">ID</label>
									<input type="text" class="form-control" id="userId" name="userId" style="width:350px";>
								</div>
								
								<!-- 패스워드입력 -->
								<div class="form-group last mb-3">
									<label for="password">Password</label>
									<input type="password" class="form-control" id="password" name="password">
								</div>
								
								<!-- 아이디찾기 -->
								<div class="d-flex mb-2 align-items-center">
									<a href="javascript:findId();" class="forgot-Id">Forgot Id?</a></span>											
								</div>
						
								<!-- 패스워드찾기 -->
								<div class="d-flex mb-4 align-items-center">
									<a href="javascript:findPwd();" id="findPwd" class="forgot-pass">Forgot Password?</a>
								</div>

								<!-- 로그인버튼 -->
								<div style="text-align : center;">
									<a><input type="button" value="Login" class="btn btn-block btn-basic" onClick="javascript:fncLogin()"></a>
								</div>
								<div style="text-align : center;">	
									<a href="/user/addUserView" style="color:black;">회원가입</a>
								</div>
								
								<!-- 회색글씨 -->
								<span class="d-block text-center my-3 text-muted">&mdash; or &mdash;</span>
								
								<!-- [완료] by.율아 -->
								<!-- 타 사 로그인 기능 : Google, Kakao, Naver -->
								<div class="social-login">
									<a class="Kakao btn d-flex justify-content-center align-items-center" name="kakaoLogin" onclick="KakaoLogin()">
										<img src="../images/API/kakao_btn.png" width="200" name="kakaoLogin">
										<span class="icon-Kakao mr-3"></span>
									</a>
									<a class="kakao btn d-flex justify-content-center align-items-center" id="naverIdLogin" onclick="NaverLogin()">
										<img src="../images/API/naver_btn.png" width="200"name="naverLogin">
										<span class="icon-Naver mr-3"></span>
									</a>
									<!-- [완료] by.율아 -->
									<!-- Google Login 관련하여 Body 지정 -->
									<a class="google btn d-flex justify-content-center align-items-center" id="googleLogin" onclick="googleSign(googleUser)">
										<img src="../images/API/google_btn.png" width="200" name="googleLogin">
										<span class="icon-Google mr-3"></span>
									</a>
										
								</div>
							</form>
						</div>
					</div>
					</div>

<script>
	$('h3:contains("Moopi")').on('click', function(){
		location.href = "/";
	})
	
	// 엔터 로그인
	$('input[name=userId]').keydown(function (key) {
 
        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
        	fncLogin();
        }
 
    });
	
	$('input[name=password]').keydown(function (key) {
 
        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
        	fncLogin();
        }
 
    });


</script>

</body>
</html>