package controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import model.ChatRoom;
import model.Member;
import model.Project;
import model.ProjectMember;
import model.Workspace;
import service.ChatRoomService;
import service.ProjectMemberService;
import service.ProjectService;
import service.WorkspaceService;

@Controller
public class ProjectController {
	@Autowired
	private ProjectService pService;
	@Autowired
	private ProjectMemberService pmService;
	@Autowired
	private ChatRoomService crService;
	@Autowired
	private WorkspaceService wService;
	
	@RequestMapping("/projectMain") //projectMain으로 이동
	public String showProjectMain(HttpSession session, int wNum, Model model) {
		List<Project> pList = pService.getAllProjectByWnum(wNum); //프로젝트 리스트를 가져온다..
		List<Map<String, Object>> projectList = new ArrayList<Map<String,Object>>();
		for(int i=0; i<pList.size(); i++) { //프로젝트 리스트를 돌면서..
			int pNum = pList.get(i).getpNum();
			List<ProjectMember> pmList = pmService.getAllProjectMemberByPnum(pNum); // 각각의 프로젝트에 속한 멤버 가져오기
			Map<String, Object> pMap = new HashMap<String, Object>();
			pMap.put("pInfo", pList.get(i)); //프로젝트 정보 
			pMap.put("pmList", pmList); //프로젝트 소속 멤버
			projectList.add(pMap);
		}
		model.addAttribute("projectList", projectList);
		Workspace ws = wService.getWorkspace(wNum);
//		ChatRoom chatRoom = crService.getChatRoomByCrNum(crNum);
		session.setAttribute("wsName", ws.getName());
		session.setAttribute("currWnum", wNum);
//		session.setAttribute("sessionChatRoom", chatRoom);		
		return "/project/projectMain";
	}
	
	//-------------------------------------------------------------------------------CRUD 
	
	@RequestMapping(value="/addProject", method = RequestMethod.POST)
	public String addProject(String pName, int wNum, String pDetail, String startDate, String endDate, HttpSession session, HttpServletRequest request) {
		Member member = (Member)session.getAttribute("user");
		int mNum = member.getNum();
		int pNum = pService.addProject(pName, wNum, pDetail, startDate, endDate, mNum); //프로젝트 추가 & 채팅방 추가
		//프로젝트 멤버 추가
		String[] mNumList = request.getParameterValues("mNumList");
		System.out.println("mNumList ? "+mNumList);
		if(mNumList != null) {
			for(String stringMnum : mNumList) {
				int num = Integer.parseInt(stringMnum);
				pmService.addProjectMember(pNum, num);
			}
		}
		return "redirect:projectMain?wNum="+wNum;
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
		System.out.println("modifyProject : "+project);
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