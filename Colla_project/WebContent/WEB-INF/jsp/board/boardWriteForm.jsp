<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/base.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="${contextPath}/lib/ckeditor4/ckeditor.js"></script>


</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp" %>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp" %>
	<script>
		$(function(){
			CKEDITOR.replace('content',{
				filebrowserImageUploadUrl: "${contextPath}/board/ckeditorUpload",
			});
			
			$("#writeForm").submit(function(){
				if( !$("#pw").val().trim() ){
					alert("글을 수정하고 삭제할 때 사용하실\n비밀번호를 입력해주세요.");
					$("#pw").focus().val("");
					return false;
				} else if (!$("#title").val().trim()){
					alert("제목을 입력해주세요.");
					$("#title").focus().val("");
					return false;
				} else if (!$("#content").val().trim()){
					alert("내용을 입력해주세요.");
					$("#content").focus().val("");
					return false;
				}
			});
		});
	</script>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<h3>게시글 작성</h3>
		<div id="inputWrap">
			<form id="writeForm" action="${contextPath}/board/write" method="post" enctype="multipart/form-data">
				<div class="row">
					<label>
						말머리
						<select id="boardType" name="boardType">
							<option value="default">일반</option>
							<option value="notice">공지</option>
							<option value="anonymous">익명</option>
						</select>
					</label>
					<label>
						글 비밀번호
						<input id="pw" type="password" name="pw" placeholder="글 비밀번호를 입력해주세요">
					</label>
				</div>
				<div class="row">
					<label>
						제목
						<input id="title" type="text" name="title" placeholder="제목을 입력해주세요">
					</label>
				</div>
				<div class="row">
					<label>
						내용
						<textarea id="content" name="content" cols="70" rows="10"></textarea>
					</label>
				</div>
				<div class="row">
					<label>
						파일 첨부
						<input multiple="multiple" id="file" type="file" name="file" >
					</label>
				</div>
				<div id="btns">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<button>등록</button>
					<a href="list?page=${listInf.page}&keyword=${listInf.keyword}&keywordType=${listInf.type}">취소</a>
				</div>
			</form>
		</div>
	</div>
</body>
</html>