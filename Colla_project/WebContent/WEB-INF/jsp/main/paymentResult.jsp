<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerMain.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
	<script>
		var paymentInfo;
		function dataFunction(info){
			paymentInfo = info;
			$("#paymentInfo").text(info);
		}
	</script>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/inc/headerMain.jsp" %>
		<section id="main-cover">
			<div id="container">
				<h1>카카오 페이 결제가 정상적으로 완료되었습니다!</h1>
				<p id="paymentInfo"></p>
				<div>
					<p>결제일시 : ${info.approved_at }</p>
					<p>주문번호 : ${info.partner_order_id }</p>
					<p>상품명 : ${info.item_name}</p>
					<p>상품수량 : ${info.quantity }</p>
					<p>결제금액 : ${info.amount.total }</p>
					<p>결제방법 : ${info.payment_method_type}</p>
				
				</div>
			</div>
		</section>
		
		<%@ include file="/WEB-INF/jsp/inc/footerMain.jsp" %>
	</div>
</body>
</html>