package dao;

import java.util.List;

import model.ChatMessage;

public interface ChatMessageDao {
	//cm = 메세지번호, cr = 채팅방번호
	public int insertChatMessage(ChatMessage chatMessage);
	public int deleteChatMessage(int cmNum); //메시지번호로 메시지삭제
	public ChatMessage selectChatMessageByCmNum(int cmNum);//메시지번호로 메시지 한개 선택
	public List<ChatMessage> selectAllChatMessageByCrNum(int crNum);//채팅방번호로 해당채팅방의 전체메시지 선택
	
}