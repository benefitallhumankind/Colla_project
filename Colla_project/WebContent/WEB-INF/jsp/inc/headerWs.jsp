<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="member" value="<%=request.getSession().getAttribute(\"user\")%>" />
<script>
var sock;
var stompClient;
var msgInfo;

function socketConnect(){
	sock = new SockJS("${contextPath}/chat");
	stompClient = Stomp.over(sock);
	stompClient.connect({},function(){
<%----------------------------------------채팅메시지 구독부분----------------------------------------------%>
		var crNum = $("#crNum").val();

		if($("#pageType").val()=="chatroom"){
			//현재 workspace 로그인중인 멤버
			stompClient.subscribe("/category/concurrentVisitor/${sessionScope.user.num}", function(data){
				let cv = JSON.parse(data.body);
				showLoginNow(cv.mNum,cv.isLogin);
			});
		}
		
		//일반메세지 구독
		stompClient.subscribe("/category/msg/"+crNum,function(cm){
				msgInfo = JSON.parse(cm.body);
				addMsg(msgInfo);
				$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
		});

		//알림구독
		var userNum = ${sessionScope.user.num};
		$.ajax({
			url : "${contextPath}/getSetAlarmInfo",
			data : {"mNum":userNum},
			dataType : "json",
			success : function(setAlarmInfo){	
			},
			error : function(){
				alert("알림정보가져오기 에러발생");
			}
		});
		stompClient.subscribe("/category/alarm/"+userNum, function(alarm){
					alarmInfo = JSON.parse(alarm.body);
					$.ajax({
						url : "${contextPath}/hasAlarm",
						data : {"mNum":userNum},
						dataType : "json",
						success : function(alarmList){
							if(alarmList!=""){
								$.each(alarmList,function(idx,alarm){
									$("#emptyAlarmMsg").remove();
									drawAlarmList(alarm);
									$(".alarmInfoDiv").show();
									$(".alarmInfo").show();
									return false;
								});
							}
						},
						error : function(){
							alert("알람리스트 불러오기 에러발생");
						}
					});
				$("#alarmOn").show();
		});
<%-----------------------------------------------------------------------------------------------------%>
		
		//중복로그인알림
		stompClient.subscribe("/category/loginMsg/" + ${member.num},function(data){
			if(data.body=="duplicated"){
		        window.location.href="/logout?type=duplicated";
			}
	    });// end subcribe
	    
	  	//system 문구 출력
		stompClient.subscribe("/category/systemMsg/"+crNum,function(cm){
			msgInfo = JSON.parse(cm.body);
			addSystemMsg(msgInfo);
			$("#chatArea").scrollTop($("#chatArea")[0].scrollHeight);
	    });
	});
}

var hasNewAlarm;
function drawAlarmList(alarm){
	var alarmType;
	if(alarm.aType=="reply"){
		alarmType = "댓글";
	}else if(alarm.aType=="notice"){
		alarmType = "공지";
	}else if(alarm.aType=="cInvite"){
		alarmType = "채팅방 초대";
	}else if(alarm.aType=="wInvite"){
		alarmType = "워크스페이스 초대";
	}else if(alarm.aType=="pInvite"){
		alarmType = "프로젝트 초대";
	}else if(alarm.aType=="todo"){
		alarmType = "할 일 생성";
	}
	var alarmInfoArea = $("#alarmInfoArea");
	var alarmProfileImg = $("<div class='profileImg'><img alt='프로필사진' src='${contextPath}/showProfileImg?num="+alarm.mNumFrom+"'></div>");
	var alarmInfoDiv = $("<div class='alarmInfoDiv'></div>");
	var date = new Date(alarm.aRegDate);
	var alarmTime = date.getFullYear()+"-"+(Number(date.getMonth())+Number(1))+"-"+date.getDate()+" "+date.getHours()+"시"+date.getMinutes()+"분";
	var alarmInfo = $("<div class='alarmInfo'></div>");
	var aTagInAlarmInfo;
	if(alarm.aType=="wInvite"){
		aTagInAlarmInfo = $("<a class='goToURLaTag openInviteAcceptModal' href='#' onclick='openInviteAcceptModal("+alarm.aNum+","+alarm.wNum+",\""+alarm.aType+"\","+alarm.aDnum+");'>"+alarm.mNameFrom+"님의 "+alarmType+"알림 </a>");
	}else{
		aTagInAlarmInfo = $("<a class='goToURLaTag' href='${contextPath}/goToTargetURL?aNum="
				+alarm.aNum+"&wNum="+alarm.wNum+"&aType="+alarm.aType+"&aDnum="+alarm.aDnum+"'>"+alarm.mNameFrom+"님의 "+alarmType
				+"알림 </a>");	
	}
	
	alarmInfo.append(aTagInAlarmInfo);
	var deleteThisAlarm = $("<div class='deleteThisAlarm' onclick='deleteThisAlarm("+alarm.aNum+");'><i class='fas fa-times'></i></div>");
	alarmInfo.append(deleteThisAlarm);
	var alarmTimeDiv = $("<div class='alarmRegDate'>"+alarmTime+"</div>");
	alarmInfo.append(alarmTimeDiv);
	
	alarmInfoDiv.append(alarmProfileImg);
	alarmInfoDiv.append(alarmInfo);
	alarmInfoArea.append(alarmInfoDiv);
	
	return false;
}

function openInviteAcceptModal(aNum,wNum,aType,aDnum){
	$(".inviteWsmList").empty();
	$("#inviteAcceptModal").fadeIn(100);
	$("#iAnum").val(aNum);
	$("#iWnum").val(wNum);
	$("#iAtype").val(aType);
	$("#iAdNum").val(aDnum);
	$.ajax({
		url : "${contextPath}/getWname",
		data : {"wNum":wNum},
		dataType : "json",
		success : function(inviteInfoMap){
			var wsmList = inviteInfoMap.wsmList;
			var wName = inviteInfoMap.wName;
			$(".inviteWsName").text("\""+wName+"\" 초대 요청을 받았습니다");
			var inviteWsmListUL = $(".inviteWsmList");
			
			$.each(wsmList,function(idx,wsm){
				var mLi = $("<li class='mLi'></li>");
				var mLiProfile = $("<div class='profileImg' align='center'><img alt='프로필사진' src='${contextPath}/showProfileImg?num="+wsm.num+"' onclick='showProfileInfoModal(${m.num})'></div><p>"+wsm.name+"</p>");
				mLi.append(mLiProfile);
				inviteWsmListUL.append(mLi);
			});
		}
	});
}

function deleteThisAlarm(aNum){
	var userNum = ${sessionScope.user.num};
	var alarmInfoArea = $("#alarmInfoArea");
	$.ajax({
		url : "${contextPath}/deleteThisAlarm",
		data : {"aNum":aNum,"mNum":userNum},
		dataType : "json",
		success : function(alarmList){
			alarmInfoArea.empty();
			var total = alarmList.length;
			$.each(alarmList,function(idx,alarm){
				drawAlarmList(alarm);
				$(".alarmInfoDiv").show();
				$(".alarmInfo").show();
			});
			if(total==0){
				var emptyAlarmMsg = $("<div id='emptyAlarmMsg' align='center'>알림이 없습니다.</div>");
				alarmInfoArea.append(emptyAlarmMsg);
				$("#alarmOn").hide();
			}
		},
		error : function(){
			alert("알람 삭제 에러발생");
		}
	});
}

function deleteAllAlarm(mNum){
	var alarmInfoArea = $("#alarmInfoArea");
	
	$.ajax({
		url : "${contextPath}/deleteAllAlarm",
		data : {"mNum":mNum},
		dataType : "json",
		success : function(result){
			if(result){
				alert("전체 알림 삭제 완료");
				alarmInfoArea.empty();
				var emptyAlarmMsg = $("<div id='emptyAlarmMsg' align='center'>알림이 없습니다.</div>");
				$("#alarmOn").hide();
				alarmInfoArea.append(emptyAlarmMsg);	
			}else{
				alert("삭제할 알림이 없습니다.")
			}
		},
		error : function(){
			alert("전체 알림 삭제 에러발생");
		}
	});
}

$(function(){
	socketConnect();
	$("#denyInvite").on("click",function(){
		var aNum = $("#iAnum").val();
		deleteThisAlarm(aNum);
		$("#inviteAcceptModal").fadeOut(100);
	});
	
	$("#closeInviteAcceptModal").on("click",function(){
		$("#inviteAcceptModal").fadeOut(100);
		return false;
	});
	//화면 켜졌을때 알람 있으면 가져오기
	var mNum = ${member.num};
	$.ajax({
		url : "${contextPath}/hasAlarm",
		data : {"mNum":mNum},
		dataType : "json",
		success : function(alarmList){
			if(alarmList!=""){
				$("#alarmOn").show();
				$.each(alarmList,function(idx,alarm){
					drawAlarmList(alarm);
				});
			}else{
				var alarmInfoArea = $("#alarmInfoArea");
				var emptyAlarmMsg = $("<div id='emptyAlarmMsg' align='center'>알림이 없습니다.</div>");
				alarmInfoArea.append(emptyAlarmMsg);
			}
		},
		error : function(){
			alert("알람리스트 불러오기 에러발생");
		}
	});
	
	var alarmToggleVal=0;
	$("#alarmDiv").on("click",function(){
		//알람Info 모달이 없을때
		if(alarmToggleVal==0){
			var mNum = ${sessionScope.user.num};
			var deleteAllBtn = $("<div id='deleteAllAlarm' onclick='deleteAllAlarm("+mNum+");' align='center'>전체 알림 삭제</div>");
			$("#alarmInfoArea").append(deleteAllBtn);	
			$("#alarmInfoArea").slideDown();
				alarmToggleVal = 1;
				
		//알람Info 모달 나와있어서 눌러서 끌때
		}else{
			$("#alarmInfoArea").slideUp();
				alarmToggleVal = 0;	
			$("#deleteAllAlarm").remove();
		}
	});
	
	var pageType = $("#pageType").val();
	if(pageType=="chatroom"){
		//헤더에 채팅방과 워크스페이스 정보 바꾸기
		var isDefault = $("#isDefault").val();
		if(isDefault==1){ //기본채팅방이면
			$("#chatRoomInfo > p").text("기본채팅방");
			$(".addCrMember").hide();
		}else{
		 	var crName = $("#crName").val();
		 	$("#chatRoomInfo > p").text(crName);
		}
	}else if(pageType=="workspace"){
		$("#chatRoomInfo > p").text("워크스페이스");
	}else if(pageType=="project"){
		var wName = "${sessionScope.currWname}";
		$("#chatRoomInfo > p").text(wName+" 프로젝트");
	}else if(pageType=="todoList"){
		$("#chatRoomInfo > p").text("Todo List");
	}else{
		$("#chatRoomInfo > p").text("${sessionScope.currWname}");
	}
	
	$(".header").mousedown(function(){
		$(".attachModal").draggable();
	});
	$(".header").on("mouseup",function(){
		$(".attachModal").draggable("destroy");
	});
}); //onload function end
</script>

<div id="wsMainHeader">
	<div class="container">
		<div id="chatRoomInfo">
			<p>페이지 이름</p>
		</div>
		<div id="alarmDiv">
			<div id="alarmOn"></div>
			<i class="fas fa-bell"></i>
		</div>
	</div>
	<div id="alarmInfoArea" class="collaScroll">
	</div>
	
<%-----------------------------------------------워크스페이스 초대 수락모달---------------------------------------------%>
	<div id="inviteAcceptModal" class="attachModal ui-widget-content">
			<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<g><path fill="#fff"
							d="M250.4,0.8C112.7,0.8,1,112.4,1,250.2c0,137.7,111.7,249.4,249.4,249.4c137.7,0,249.4-111.7,249.4-249.4
							C499.8,112.4,388.1,0.8,250.4,0.8z M383.8,326.3c-62,0-101.4-14.1-117.6-46.3c-17.1-34.1-2.3-75.4,13.2-104.1
							c-22.4,3-38.4,9.2-47.8,18.3c-11.2,10.9-13.6,26.7-16.3,45c-3.1,20.8-6.6,44.4-25.3,62.4c-19.8,19.1-51.6,26.9-100.2,24.6l1.8-39.7		
							c35.9,1.6,59.7-2.9,70.8-13.6c8.9-8.6,11.1-22.9,13.5-39.6c6.3-42,14.8-99.4,141.4-99.4h41L333,166c-12.6,16-45.4,68.2-31.2,96.2	
							c9.2,18.3,41.5,25.6,91.2,24.2l1.1,39.8C390.5,326.2,387.1,326.3,383.8,326.3z" /></g>
							</svg>
							<div class="loginBox-Head">
								<h3 style='font-weight: bolder; font-size: 24px' class="inviteWsName"></h3>
							</div>
						</div>
						<!--파도 시작-->
						<div>
							<svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
							viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
							<defs>
							<path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
							</defs>
								<g class="parallax">
								<use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
								<use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
								<use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
								</g>
							</svg>
						</div><!--파도 end-->
			</div><!--header end-->

			<form action="goToTargetURL" id="inviteWsFormByModal">
			<input type="hidden" id="iAnum" name="aNum">
			<input type="hidden" id="iWnum" name="wNum">
			<input type="hidden" id="iAtype" name="aType">
			<input type="hidden" id="iAdNum" name="aDnum">
			<div class="modalBody">
					<h4>워크스페이스 멤버</h4>
					<ul class="inviteWsmList"></ul>
			</div> <!-- end modalBody -->
			<div id="modalBtnDiv">
				<input type ="submit" id="acceptInvite" value="수락하기">
				<input type ="button" id="denyInvite" onclick='location.href="#"' value="거절하기">
				<button id="closeInviteAcceptModal">닫기</button>
			</div>
			</form>
	</div><!-- end inviteAcceptModal -->
</div>
