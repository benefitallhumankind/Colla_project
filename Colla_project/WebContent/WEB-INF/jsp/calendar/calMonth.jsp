<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
String contextPath = request.getContextPath();
request.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>calMonth</title>
<style type="text/css">
.addScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}
.detailScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffd9dc;}
.modifyScheduleModal{display: none; width: 300px; height: 250px; top: 10%; left: 10%; position: absolute; background-color: #ffe8ea;}
</style>
<script src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
<script type="text/javascript">

var today = new Date();
var date = new Date();
$(function() {
	thisMonthCalendar(today);
	tmpShowSchedule();
	//추가
	$("#addScheduleButton").on("click", function() {
		$("#addScheduleForm").show("slow");
	});
	$("#addScheduleFormClose").on("click", function() {
		$("#addScheduleForm").hide("slow");
	});
	//수정
	$("#modifyScheduleButton").on("click", function() {
		$("#detailScheduleForm").show("slow");
	});
	//상세 모달에서 수정 버튼을 눌렀을 때
	$("#detailModifyButton").on("click", function() {
		var data = $("#detailScheduleForm").serialize();
		$("#detailScheduleForm").hide("fast");
		$("#modifyScheduleForm").show("slow");
	});
	//수정 모달에서 수정 버튼을 눌렀을 때
	$("#modifyButton").on("click", function() {
		var data = $("#modifyScheduleForm").serialize();
		$.ajax({
			url: "modifySchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("수정 성공");
				} else {
					alert("수정 실패");
				}
			},
			error: function(request, status, error) {
				alert("request:"+request+"\n"
						+"status:"+status+"\n"
						+"error:"+error+"\n");
			}
		});
	})
	//삭제
	$("#delete").on("click", function() {
		var data = $("#detailScheduleForm").serialize();
		$.ajax({
			url: "removeSchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("삭제 성공");
				} else {
					alert("삭제 실패");
				}
			},
			error: function(request, status, error) {
				alert("request:"+request+"\n"
						+"status:"+status+"\n"
						+"error:"+error+"\n");
			}
		});
	})
	//상세보기
	$("#detailScheduleFormClose").on("click", function() {
		$("#detailScheduleForm").hide("slow");
		$("#addScheduleForm").hide("slow");
	});
	//닫기
	$("#modifyScheduleFormClose").on("click", function() {
		$("#modifyScheduleForm").hide("slow");
	});
	//추가
	$("#addScheduleForm").on("submit", function() {
		var data = $(this).serialize();
		$.ajax({
			url: "addSchedule",
			data: data,
			type: "post",
			dataType: "json",
			success: function(result) {
				if(result) {
					alert("성공!");
					$("#addScheduleForm").hide("slow");
				} else {
					alert("실패..");
				}
			},
			error: function(request, status, error) {
				alert("request:"+request+"\n"
						+"status:"+status+"\n"
						+"error:"+error+"\n");
			}
		}); //end ajax
		return false;
	});
	//타입 지정
	$("#calType1").on("change", function() {
		thisMonthCalendar(today);
		tmpShowSchedule();
	});
	$("#calType2").on("change", function() {
		thisMonthCalendar(today);
		tmpShowSchedule();
	});
	$("#calType3").on("change", function() {
		thisMonthCalendar(today);
		tmpShowSchedule();
	});
	//원하는 날짜로 달력 이동
	$("#wantedCalendarForm").on("submit", function() {
		var wantedYear = $("#wantedYear").val();
		var wantedMonth = $("#wantedMonth").val();
		var wantedDate = $("#wantedDate").val();
		console.log(wantedYear+" "+wantedMonth+" "+wantedDate);
		moveToWantedCalendar(wantedYear, wantedMonth, wantedDate);
	});
});

function thisMonthCalendar(today) {
	alert(today);
	var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
	var lastDay = new Date(today.getFullYear(), today.getMonth()+1, 0);
	var calMonthTitle = $("#calMonthTitle");
	calMonthTitle.html(today.getFullYear()+"년 "+(today.getMonth()+1)+"월");
	var month = today.getMonth()+1;
	if((today.getMonth()+1)<10) {
		var month = "0"+(today.getMonth()+1);
	}
	var calendar = "<table border = '1'>";
	calendar += "<tr>";
	calendar += "<th width=\"150\">일</th>";
	calendar += "<th width=\"150\">월</th>";
	calendar += "<th width=\"150\">화</th>";
	calendar += "<th width=\"150\">수</th>";
	calendar += "<th width=\"150\">목</th>";
	calendar += "<th width=\"150\">금</th>";
	calendar += "<th width=\"150\">토</th>";
	calendar += "</tr>";
	var firstDayOfWeek = firstDay.getDay();
	var lastDayDate = lastDay.getDate();
	var numOfWeekRow = Math.ceil((lastDayDate+firstDayOfWeek)/7);
	var dateCount = 1;
	for(var i=0; i<numOfWeekRow; i++) {
		calendar += "<tr>";
		for(var j=0; j<7; j++) {
			if(j<firstDayOfWeek && i==0 || dateCount>lastDayDate) {
				calendar += "<td>&nbsp;</td>";
			} else {
				if(dateCount<10) {
					calendar += "<td id="+today.getFullYear()+month+"0"+dateCount+">"+dateCount+"</td>";
				} else {
					calendar += "<td id="+today.getFullYear()+month+dateCount+">"+dateCount+"</td>";
				}
				dateCount++;
			}
		}
		calendar += "</tr>";
	};
	calendar += "</table>";
	var calMonthBody = $("#calMonthBody"); 
	calMonthBody.html(calendar);	
}

function tmpShowSchedule() {
	var t1 = $("#calType1").prop("checked");
	var t2 = $("#calType2").prop("checked");
	var t3 = $("#calType3").prop("checked");
	console.log(t1+" "+t2+" "+t3);
	$.ajax({ 
		url:"showAllCalendar",
		data: {"t1":t1, "t2":t2, "t3":t3},
		type:"get",
		dataType:"json",
		success: function(allCalendar) {
			for(var i in allCalendar) {
				var title = allCalendar[i].title;
				var btn = $("<button>"+title+"</button>");			
				(function(ii) {
					var title = allCalendar[ii].title;
					var startDateStr = allCalendar[ii].startDate;
					var startDateYMD = startDateStr.substring(0, 10);
					var endDateStr = allCalendar[ii].endDate;
					var endDateYMD = endDateStr.substring(0, 10);
					var year = startDateStr.substring(0, 4);
					var month = startDateStr.substring(5, 7);
					var date = startDateStr.substring(8, 10);
					var dateNumber = year+month+date;
					$("#"+dateNumber).append(btn);
					btn.on("click", function() {
						$("#detailScheduleForm").show("slow");
						$("#detailCNum").val(allCalendar[ii].cNum);
						$("#modifyCNum").val(allCalendar[ii].cNum);
						$("#detailTitle").val(title);
						$("#modifyTitle").val(title);
						$("#detailStartDate").val(startDateYMD);
						$("#modifyStartDate").val(startDateYMD);
						$("#detailEndDate").val(endDateYMD);
						$("#modifyEndDate").val(endDateYMD);
						$("#detailContent").val(allCalendar[ii].content);
						$("#modifyContent").val(allCalendar[ii].content);
						
						var yearCalendarTmp = allCalendar[ii].yearCalendar;						
						$("#modifyYearCalendar").prop("checked", change(yearCalendarTmp));
						var annuallyTmp = allCalendar[ii].annually;
						$("#modifyAnnually").prop("checked", change(annuallyTmp));
						var monthlyTmp = allCalendar[ii].monthly;
						$("#modifyMonthly").prop("checked", change(monthlyTmp));
					});	
				})(i)
			}
		}
	});
}

function moveToWantedCalendar(wantedYear, wantedMonth, wantedDate) {
	today = new Date(wantedYear, wantedMonth, wantedDate);
	alert("move : "+today);
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function preMonthCalendar() {
	today = new Date(today.getFullYear(), today.getMonth()-1, today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function nextMonthCalendar() {
	today = new Date(today.getFullYear(), today.getMonth()+1, today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function preYearCalendar() {
	today = new Date(today.getFullYear()-1, today.getMonth(), today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}
function nextYearCalendar() {
	today = new Date(today.getFullYear()+1, today.getMonth(), today.getDate());
	thisMonthCalendar(today);
	tmpShowSchedule();
}

function change(param) {
	if(param == "1") {
		param = true;
	} else {
		param = false;
	}
	return param;
}
</script>
</head>
<body>
	<form action="calSearchList">
		<input type="text" name="searchKeyword" placeholder="검색어를 입력해주세요.">
		<input type="submit" value="검색">
	</form>
	<button type="button" id="addScheduleButton">일정 추가</button>
	<label><input type="checkbox" name="calType" id="calType1" value="project" checked="checked">프로젝트</label>
	<label><input type="checkbox" name="calType" id="calType2" value="vacation" checked="checked">휴가</label>
	<label><input type="checkbox" name="calType" id="calType3" value="event" checked="checked">행사</label>
	<button onclick="location.href='${contextPath}/calMonth'">월간</button>
	<button onclick="location.href='${contextPath}/calYear'">연간</button><br>
	
	<button onclick="preYearCalendar()">작년</button>
	<button onclick="preMonthCalendar()">이전 달</button>
	<h1 id="calMonthTitle"></h1>
	<button onclick="nextMonthCalendar()">다음 달</button>
	<button onclick="nextYearCalendar()">내년</button>
	
	<form id="wantedCalendarForm">
		<input type="text" id="wantedYear">년
		<input type="text" id="wantedMonth">월
		<input type="text" id="wantedDate">일
		<input type="submit" value="이동">
	</form>
	
	<div id="calMonthBody"></div>
	<!-- 일정 추가 모달 -->
	<form id="addScheduleForm" class="addScheduleModal">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="hidden" name="mNum" id="mNum" value="1">
		<input type="hidden" name="wNum" id="wNum" value="1">
		제목<input type="text" name="title" id="title"><br>
		기간
		(시작날짜)<input type="date" name="startDate" id="startDate"><br>
 		(시작날짜)<input type="date" name="endDate" id="endDate"><br>
		상세<textarea rows="5" cols="21" name="content" id="content"></textarea><br>
		타입<select name="type">
			<option value="project">프로젝트</option>
			<option value="vacation">휴가</option>
			<option value="event">행사</option>
			</select><br>
		<label><input type="checkbox" name="yearCalendar" id="1" value="yearCalendar">연간 달력 표시</label><br>
		<label><input type="checkbox" name="annually" id="2" value="annually">매년 반복</label>
		<label><input type="checkbox" name="monthly" id="3" value="monthly">매월 반복</label><br>
		<input type="button" id="addScheduleFormClose" value="닫기">
		<input type="submit" id="add" value="추가">
	</form>
	
	<!-- 일정 상세 모달 -->
	<form id="detailScheduleForm" class="detailScheduleModal">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="text" name="cNum" id="detailCNum">
		<input type="hidden" name="mNum" id="mNum" value="1">
		<input type="hidden" name="wNum" id="wNum" value="1">
		제목<input type="text" name="title" id="detailTitle" readonly="readonly"><br>
		기간
		(시작날짜)<input type="date" name="startDate" id="detailStartDate" readonly="readonly"><br>
 		(시작날짜)<input type="date" name="endDate" id="detailEndDate" readonly="readonly"><br>	
		상세<textarea rows="5" cols="21" name="content" id="detailContent" readonly="readonly"></textarea><br>
		타입<select name="type" id="detailType">
			<option value="project">프로젝트</option>
			<option value="vacation">휴가</option>
			<option value="event">행사</option>
			</select><br>
		<label><input type="checkbox" name="yearCalendar" value="yearCalendar">연간 달력 표시</label><br>
		<label><input type="checkbox" name="annually" value="annually">매년 반복</label>
		<label><input type="checkbox" name="monthly" value="monthly">매월 반복</label><br>
		<input type="button" id="detailScheduleFormClose" value="닫기">
		<input type="button" id="delete" value="삭제">
		<input type="button" id="detailModifyButton" value="수정">
	</form>
	
	<!-- 일정 수정 모달 -->
	<form id="modifyScheduleForm" class="modifyScheduleModal">
 		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
 		<input type="hidden" name="cNum" id="modifyCNum">
		<input type="hidden" name="mNum" id="mNum" value="1">
		<input type="hidden" name="wNum" id="wNum" value="1">
		제목<input type="text" name="title" id="modifyTitle"><br>
		기간
		(시작날짜)<input type="date" name="startDate" id="modifyStartDate"><br>
 		(시작날짜)<input type="date" name="endDate" id="modifyEndDate"><br>	
		상세<textarea rows="5" cols="21" name="content" id="modifyContent"></textarea><br>
		타입<select name="type" id="modifyType">
			<option value="project">프로젝트</option>
			<option value="vacation">휴가</option>
			<option value="event">행사</option>
			</select><br>
		<label><input type="checkbox" name="yearCalendar" id="modifyYearCalendar" value="yearCalendar">연간 달력 표시</label><br>
		<label><input type="checkbox" name="annually" id="modifyAnnually" value="annually">매년 반복</label>
		<label><input type="checkbox" name="monthly" id="modifyMonthly" value="monthly">매월 반복</label><br>
		<input type="button" id="modifyScheduleFormClose" value="닫기">
		<input type="button" id="modifyButton" value="수정">
	</form>
	
</body>
</html>
