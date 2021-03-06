package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.WorkspaceInviteDao;
import model.WorkspaceInvite;

@Service
public class WorkspaceInviteService {
	@Autowired
	private WorkspaceInviteDao wiDao;
	
	public boolean addWorkspaceInvite(String targetUser,int wNum) {
		boolean result = false;
		WorkspaceInvite wi = new WorkspaceInvite();
		wi.setWiTargetUser(targetUser);
		wi.setwNum(wNum);
		if(wiDao.insertWorkspaceInvite(wi)>0) {
			result = true;
		}
		return result;
	}
	
	public boolean removeWorkspaceInvite(String targetUser, int wNum) {
		boolean result = false;
		if(wiDao.deleteWorkspaceInvite(targetUser, wNum)>0) {
			result = true;
		}
		return result;
	}
	
	public List<WorkspaceInvite> getWorkspaceInviteByTargetUser(String targetUser,int wNum) {
		return wiDao.selectWorkspaceInvite(targetUser,wNum);
	}
	
	public List<WorkspaceInvite> getAllWiList(){
		return wiDao.selectAllWorkspaceInvite();
	}
}
