package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.ChatRoomDao;
import dao.ChatRoomMemberDao;
import model.ChatRoomMember;

@Service
public class ChatRoomMemberService {
	@Autowired
	private ChatRoomMemberDao crmDao;
	@Autowired
	private ChatRoomDao crDao;
	public boolean addChatRoomMember(int crNum,int mNum,int wNum) {//workspace만들었을때, chatroom만들었을때, chatroom 초대됐을때, 프로젝트초대됐을때
		boolean result = false;
		ChatRoomMember crm = new ChatRoomMember();
		crm.setCrNum(crNum);
		crm.setmNum(mNum);
		crm.setwNum(wNum);
		if(crmDao.insertChatRoomMember(crm)>0) {
			result = true;
		}
		return result;
	}
	public boolean modifyChatRoomMember(ChatRoomMember crm) {
		boolean result = false;
		if(crmDao.updateChatRoomMember(crm)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeChatRoomMember(int crmNum) {
		boolean result = false;
		if(crmDao.deleteChatRoomMember(crmNum)>0) {
			result = true;
		}
		return result;
	}
	public boolean removeAllChatRoomMemberByMnum(int mNum) {
		boolean result = false;
		if(crmDao.deleteAllChatRoomMemberByMnum(mNum)>0) {
			result = true;
			crDao.deleteEmptyChatRoom();
		}
		return result;
	}
	public boolean removeChatRoomMemberByWnumMnum(int wNum,int mNum) {
		boolean result= false;
		if(crmDao.deleteChatRoomMemberByWnumMnum(wNum, mNum)>0) {
			result = true;
			crDao.deleteEmptyChatRoom();
			
		}
		return result;
	}
	public boolean removeChatRoomMemberByCrNumMnum(int crNum,int mNum) {
		boolean result = false;
		if(crmDao.deleteChatRoomMemberByCrNumMnum(crNum, mNum)>0) {
			result = true;
			//사람없는 채팅방 지우기 실행
			crDao.deleteEmptyChatRoom();
			System.out.println("사람없는 채팅방 지우기 성공");
		}
		return result;
	}
	public ChatRoomMember getChatRoomMember(int crmNum) {
		return crmDao.selectChatRoomMember(crmNum);
	}
	public ChatRoomMember getChatRoomMemberByAnother(int crNum,int wNum,int mNum) {
		return crmDao.selectChatRoomMemberByAnother(crNum, wNum,mNum);
	}
	public ChatRoomMember getChatRoomMemberByCrNumMnum(int crNum,int mNum) {
		return crmDao.selectChatRoomMemberByCrNumMnum(crNum, mNum);
	}
	public List<ChatRoomMember> getAllChatRoomMember(){
		return crmDao.selectAllChatRoomMember();
	}
	public List<ChatRoomMember> getAllChatRoomMemberByCrNum(int crNum){
		return crmDao.selectAllChatRoomMemberByCrNum(crNum);
	}
	public List<ChatRoomMember> getAllChatRoomMemberByWnum(int wNum){
		return crmDao.selectAllChatRoomMemberBywNum(wNum);
	}
}
