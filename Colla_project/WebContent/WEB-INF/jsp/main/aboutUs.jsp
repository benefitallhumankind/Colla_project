<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>
<title>aboutUs</title>
<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
<link rel="stylesheet" type="text/css" href="css/main.css"/>
<link rel="stylesheet" type="text/css" href="css/animate.css"/>
<script>
//두번째 섹션 animate
$(window).scroll(function() { //(윈도우 객체)사용자가 스크롤함
	$('#aboutUs-history-ani').each(function(){
	var imagePos = $(this).offset().top; //좌표
	var topOfWindow = $(window).scrollTop(); //수직 위치(윈도우 객체의 스크롤이 몇 픽셀 이동?)
		if (imagePos < topOfWindow+300) {
			$(this).css({visibility:"visible"});
			$(this).children('.head-body').addClass("animated fadeInUp");
		}
	});
});

$(function() {
	$(".box").each(function() {
		$(this).on("mousewheel DOMMouseScroll", function(e) {
			e.preventDefault();
			var delta = 0;
			if(!event) {
				event = window.event;
			}
			if(event.wheelDelta) {
				delta = event.wheelDelta / 120;
			} else if(event.detail) {
				delta = -event.detail/3;
			} 
			var moveTop = null;
			if(delta < 0) { //위에서 아래로
				if($(this).next() != undefined) {
					moveTop = $(this).next().offset().top;
				}
			} else { //아래서 위로
				if($(this).index() > 0) {
					if($(this).prev() != undefined) {
						moveTop = $(this).prev().offset().top;
					}
				}
			}
			$("html, body").stop().animate({
				scrollTop: moveTop + 'px'
			}, {
				duration: 800, complete: function () {
				}
			});
		})
	})
	
	//미경 시작
	$(".aboutUs-card").on("mouseover",function(){
		$(this).find('li').addClass("animated fadeInUp");
	});

});// end onload
</script>
</head>
<body>
	<div id="wrap" >
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<div id="aboutUsAll">
			<section id="aboutUs-cover" class="box">
				<div id="container">
					<div id="aboutUs-cover-ani">
						<div class="head-title" lang="en"> &quot;Share Your Thinking&quot; </div>
						<div class="head-body">
							<div>
								<p class="aboutUs-content-title animated fadeIn">한 모금의 시원한 콜라 같은 협업도구</p>
								<img class="animated fadeIn" src="${contextPath }/img/COLLA_LOGO_500px.png" />
								<p class="animated fadeInRight">
									COLLA의 로고는 한 모금의 시원한 콜라 같은 협업도구(Collaboration)라는 의미를 담고 있습니다.
									그 의미처럼 COLLA는 서로의 생각을 쉽게 공유하고 빠르게 전달할 수 있는 서비스를 제공합니다.
									<b style="font-weight: 900;">질수없조</b>는 이러한 도구를 지속적으로 개발하여 세상에 제공하고자 합니다.
								</p>
							</div>
							<div>
								<p class="aboutUs-content-title animated fadeIn">국내 최대 규모의 B2B 솔루션 선두주자</p>
								<p class="animated fadeInLeft">
									COLLA는 2019년 4월 비트교육센터의 최종 프로젝트로 시작되었던 프로젝트입니다.
									두 가지 사훈을 내걸고 COLLA는 2019년 세계 100대 스타트업 기업 부문 업계 1위의 영예를 누렸습니다.<br>
									<span>고객 가치 중심의 IT솔루션을 제공하겠습니다.<br>접점을 확장하여 더 편리한 세상을 만들겠습니다.</span><br>
								</p>
								<img class="animated fadeIn"  src="${contextPath }/img/etcMark.png" />
							</div>
						</div>
						<div class="head-caption"></div>
					</div>
				</div>
			</section>
			<section id="aboutUs-history" class="box">
				<div class="container">
					<div id="aboutUs-history-ani">
						<div class="head-title"> 회사 연혁 </div>
						<div class="head-body clearFix">
							<img src="${contextPath }/img/aboutHistory1.jpg" alt="회사소개 이미지" />
							<ul>
								<li>
									<p>2019.10</p>
									<p>COLLA 서비스 시작</p>
								</li>
								<li>
									<p>2019.09</p>
									<p>사내 COLLA 단체 활동복 제작 보급</p>
								</li>
								<li>
									<p>2019.08</p>
									<p>COLLA 서비스 개발 시작</p>
								</li>
								<li>
									<p>2019.07</p>
									<p>강남 랑데자뷰(주)에서 티타임 체결</p>
								</li>
								<li>
									<p>2019.07</p>
									<p>강남 땀땀(주)에서 팀 회식 체결</p>
								</li>
								<li>
									<p>2019.06</p>
									<p>곱창집에서 팀 회식 제결<p>
								</li>
								<li>
									<p>2019.05</p>
									<p>테이블나인(주)에서 팀 회식 체결</p>
								</li>
								<li>
									<p>2019.04</p>
									<p>질수없조 팀 결성</p>
								</li>
							</ul>
							<div class="head-caption"></div>
						</div>
					</div>
				</div>
			</section>
			<section id="aboutUs-member" class="box">
				<div id="container">
					<div id="aboutUs-member-ani">
						<div class="head-title"> 팀원소개 </div>
						<div class="head-body">
							<div class="clearFix">
								<div class="memberInfo">
									<div class="aboutUs-card">
										<div class="front card">
											<div>
												<img src="${contextPath }/img/memberTK.jpg" />
											</div>
											<p>CEO</p>
											<p>이태권</p>
										 </div>
										<div class="back card">
											<ul>
												<li>Main</li>
												<li>Board</li>
												<li>Chat</li>
												<li>Pay</li>
												<li>Server</li>
											</ul>
										</div>
									</div>
									
								</div>
								<div class="memberInfo">
									<div class="aboutUs-card">
										<div class="front card">
									 		<div>
												<img src="${contextPath }/img/memberMK.jpg" />
											</div>
											<p>Software Engineer</p>
											<p>김미경</p>
										 </div>
										<div class="back card">
											<ul>
												<li>My Page</li>
												<li>Chat</li>
												<li>Project</li>
												<li>Login</li>
												<li>Join</li>
											</ul>
										</div>
									</div>
									
								</div>
								<div class="memberInfo">
									<div class="aboutUs-card">
										<div class="front card">
									 		<div>
												<img src="${contextPath }/img/memberSB.jpg" />
											</div>
											<p>Software Engineer</p>
											<p>김수빈</p>
										 </div>
										<div class="back card">
											<ul>
												<li>Chat</li>
												<li>Workspace</li>
												<li>Project</li>
												<li>Alarm</li>
												<li>Design</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="memberInfo">
									<div class="aboutUs-card">
										<div class="front card">
									 		<div>
												<img src="${contextPath }/img/memberHS.jpg" />
											</div>
											<p>Software Engineer</p>
											<p>박혜선</p>
										 </div>
										<div class="back card">
											<ul>
												<li>Calendar</li>
												<li>Main</li>
												<li>Project</li>
												<li>Login</li>
												<li>Join</li>
											</ul>
										</div>
									</div>
								</div>
							<div class="head-caption"></div>
						</div>
					</div>
				</div>
			</section>
			<div class="box"><%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %></div>
		</div>
	</div>
</body>
</html>