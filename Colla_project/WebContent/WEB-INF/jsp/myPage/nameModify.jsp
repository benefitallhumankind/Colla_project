<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
   String contextPath = request.getContextPath();
   request.setAttribute("contextPath", contextPath);
%>
<title>개인정보</title>
<link rel="stylesheet" type="text/css" href="css/reset.css"/>
<link rel="stylesheet" type="text/css" href="css/base.css"/>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"
   integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
   crossorigin="anonymous"></script>
</script>
<script type="text/javascript">

</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>이름 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
					<p>이름을 변경해주세요!</p>
					<form action="modifyMember" class="profileImgForm" enctype="multipart/form-data" method="post">
						<div>
							<input type="hidden" name="type" value="memberName">
							<input type="text" name="name" value="${member.name}" class="content">
						</div>
						<div class="row btns">
							<button class="btn">적용</button>
							<a href="myPageAccountForm" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>

	</div><!-- end wsBody -->
</body>
</html>