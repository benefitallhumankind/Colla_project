<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/inc/head.jsp" %>

<title>calSearchList</title>
<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
<link rel="stylesheet" type="text/css" href="css/calMonth.css"/>
<script type="text/javascript">
$(function() {
	var type1 = $("#calType1").prop("checked");
	var type2 = $("#calType2").prop("checked");
	var type3 = $("#calType3").prop("checked");
	
	$("#calType1").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
	$("#calType2").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
	$("#calType3").on("change", function() {
		thisMonthCalendar(today);
		showSchedule(today);
	});
});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/inc/headerWs.jsp"%>
	<%@ include file="/WEB-INF/jsp/inc/navWs.jsp"%>
	<div id="wsBody">
		<div id="wsBodyContainer" class="calendarContainer">
			<div class="calHeader">
				<div>
					<form action="calSearchList" class="calSearch">
						<select name="searchType">
							<option value="1">제목</option>
							<option value="2">내용</option>
							<option value="3">제목+내용</option>
							<option value="4">작성자</option>
						</select> 
						<input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력해주세요.">
						<button type="submit" class="btn" id="searchBtn">
							<i class="fas fa-search"></i>
						</button>
					</form>
				</div>
				<div class="headerCheckboxDiv">
				</div>
				<div class="headerChangeCal">
					<button onclick="location.href='${contextPath}/calMonth?wNum=${sessionScope.currWnum}'" class="btn">달력 전체보기</button>
				</div>
			</div><!-- calHeader 끝 -->
			
			<div class="calendarSearchList">
				<h3>검색 결과</h3>
				<div class="searchList">
					<ul>
						<li class="searchListHead">
							<div>종류</div>
							<div>제목</div>
							<div>내용</div>
							<div>시작일</div>
							<div>종료일</div>
							<div>작성자</div>
						</li>
					<c:forEach items="${searchedCalendarList}" var="schedule">
						<li class="searchListInner">
							<div>${schedule.type}</div>
							<div>${schedule.title}</div>
							<div>${schedule.content}</div>
							<div>${schedule.startDate}</div>
							<div>${schedule.endDate}</div>
							<div>${schedule.mName}</div>
						</li>
					</c:forEach>
					</ul>
				</div><!-- searchList 끝 -->
			
				<!-- 페이징 -->
				<ul id="navigation">
				
					<li class="prevAngle">
						<c:if test="${param.page != 1}">
					 		<a href="calSearchList?page=1&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">
					 			<i class="fas fa-angle-double-left"></i>
					 		</a>
						</c:if>
						<c:if test="${param.page == 1}">
					 		<a href="">
					 			<i class="fas fa-angle-double-left"></i>
					 		</a>
						</c:if>
					</li>
					
					<li class="prevAngle">
						<c:if test="${param.page != 1}">
					 		<a href="calSearchList?page=${param.page-1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">
					 			<i class="fas fa-angle-left"></i>
					 		</a>
						</c:if>	
						<c:if test="${param.page == 1}">
					 		<a href="">
					 			<i class="fas fa-angle-left"></i>
					 		</a>
						</c:if>					
					</li>
					
					<c:forEach var="pageNum" begin="${startPage}" end="${endPage < totalPageCount ? endPage:totalPageCount}">
						<c:choose>
							<c:when test="${pageNum==calInfo.page}">
								<li><a href="" class="currPage">${pageNum}</a></li>
							</c:when>
							<c:otherwise>
								<li><a href="calSearchList?page=${pageNum}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">${pageNum}</a></li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					
					
					<li class="nextAngle">
					 	<c:if test="${calInfo.page < totalPageCount}">
					 		<a href="calSearchList?page=${param.page+1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">
					 			<i class="fas fa-angle-right"></i>
					 		</a>
						</c:if>
						<c:if test="${calInfo.page >= totalPageCount}">
					 		<a href="">
					 			<i class="fas fa-angle-right"></i>
					 		</a>
						</c:if>
					</li>
					
					<li class="nextAngle">
					 	<c:if test="${calInfo.page < totalPageCount}">
					 		<a href="calSearchList?page=${param.totalPageCount}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">
					 			<i class="fas fa-angle-double-right"></i>
					 		</a>
						</c:if>			
						<c:if test="${calInfo.page >= totalPageCount}">
					 		<a href="">
					 			<i class="fas fa-angle-double-right"></i>
					 		</a>
						</c:if>			
					</li>
				</ul><!-- 페이징 끝 -->
			</div><!-- calendarSearchList 끝 -->
		</div>
	</div>
</body>
</html>