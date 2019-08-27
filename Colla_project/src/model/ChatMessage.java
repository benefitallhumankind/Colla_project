package model;

import java.sql.Timestamp;

public class ChatMessage {
	private int cmNum;
	private int crNum;
	private int mNum;
	private String cmContent;
	private Timestamp cmWriteDate;
	public int getCmNum() {
		return cmNum;
	}
	public void setCmNum(int cmNum) {
		this.cmNum = cmNum;
	}
	public int getCrNum() {
		return crNum;
	}
	public void setCrNum(int crNum) {
		this.crNum = crNum;
	}
	public int getmNum() {
		return mNum;
	}
	public void setmNum(int mNum) {
		this.mNum = mNum;
	}
	public String getCmContent() {
		return cmContent;
	}
	public void setCmContent(String cmContent) {
		this.cmContent = cmContent;
	}
	public Timestamp getCmWriteDate() {
		return cmWriteDate;
	}
	public void setCmWriteDate(Timestamp cmWriteDate) {
		this.cmWriteDate = cmWriteDate;
	}
	@Override
	public String toString() {
		return "채팅메세지 [메세지번호 : " + cmNum + ", 채팅방번호 : " + crNum + ", 작성자번호 : " + mNum + ", 메세지내용 : " + cmContent
				+ ", 작성시간 : " + cmWriteDate + "]";
	}
	
}