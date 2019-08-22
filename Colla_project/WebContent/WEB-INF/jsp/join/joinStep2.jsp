<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinStep2</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript">
$(function() {
	$("#verifyCodeForm").on("submit", function() {
		var data = $(this).serialize(); 
		$.ajax({
			url: "checkVerifyCode",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("성공");
				} else {
					$("#checkSentence").text("인증 코드가 일치하지 않습니다.");
				}
			}
		}); //end ajax 
		return false;
	})
}); //end onload
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
	<form action="" method="post" id="verifyCodeForm">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		회원가입
		인증 코드 입력
		<input type="text" name="verifycode" placeholder="인증 코드를 입력해주세요.">
		<%-- <input type="hidden" name="emailAddress" value="${param.emailAddress}"> --%>
		<input type="button" onclick="location.href='testMail2'" value="인증 코드 재발송">
		<span id="checkSentence"></span>
		<input type="submit" onclick="location.href='joinStep3'" value="다음단계">
	</form>
	<h3>
		<c:if test='${param.joinStep2 eq "false"}'>
			인증 코드가 일치하지 않습니다.
		</c:if>
	</h3>
</body>
</html>