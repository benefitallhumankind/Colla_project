package controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import model.ChatRoom;
import model.Project;
import model.Workspace;
import service.ChatRoomService;
import service.ProjectService;
import service.WorkspaceService;

@Controller
public class ProjectController {
	@Autowired
	private ProjectService pService;
	@Autowired
	private ChatRoomService crService;
	@Autowired
	private WorkspaceService wService;
	
	@RequestMapping("/projectMain") //projectMain으로 이동
	public String showProjectMain(HttpSession session, int crNum, int wNum) {
		
		List<Project> pList = pService.getAllProjectByWnum(wNum);
		
		Workspace ws = wService.getWorkspace(wNum);
		ChatRoom chatRoom = crService.getChatRoomByCrNum(crNum);
		session.setAttribute("wsName", ws.getName());
		session.setAttribute("currWnum", wNum);
		session.setAttribute("sessionChatRoom", chatRoom);		
		return "/project/projectMain";
	}
	
	//-------------------------------------------------------------------------------CRUD 
	
	@ResponseBody
	@RequestMapping(value="/addProject", method = RequestMethod.POST)
	public int addProject(String pName, int wNum, String pDetail, Date pStartDate, Date pEndDate, int crNum, int mNum) {
		int pNum = pService.addProject(pName, wNum, pDetail, pStartDate, pEndDate, crNum, mNum);
		return pNum;
	}
	@ResponseBody
	@RequestMapping(value="/removeProject", method = RequestMethod.POST)
	public boolean removeProject(int pNum) {
		boolean result = pService.removeProject(pNum);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/modifyProject", method = RequestMethod.POST)
	public boolean modifyProject(Project project) {
		boolean result = pService.modifyProject(project);
		return result;
	}
	@ResponseBody
	@RequestMapping(value="/getProject", method = RequestMethod.POST)
	public Project getProject(int pNum) {
		Project projectTmp = pService.getProject(pNum);
		return projectTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getProjectByCrNum", method = RequestMethod.POST)
	public Project getProjectByCrNum(int crNum) {
		Project projectTmp = pService.getProjectByCrNum(crNum);
		return projectTmp;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProjectByMnum", method = RequestMethod.POST)
	public List<Project> getAllProjectByMnum(int mNum) {
		List<Project> projectList = pService.getAllProjectByMnum(mNum);
		return projectList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProjectByWnum", method = RequestMethod.POST)
	public List<Project> getAllProjectByWnum(int wNum) {
		List<Project> projectList = pService.getAllProjectByWnum(wNum);
		return projectList;
	}
	@ResponseBody
	@RequestMapping(value="/getAllProject", method = RequestMethod.POST)
	public List<Project> getAllProject() {
		List<Project> projectList = pService.getAllProject();
		return projectList;
	}
}
