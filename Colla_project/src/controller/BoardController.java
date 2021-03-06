package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import model.Board;
import model.BoardFile;
import model.Member;
import model.SetAlarm;
import model.Workspace;
import service.AlarmService;
import service.BoardService;
import service.FileService;
import service.MemberService;
import service.SetAlarmService;
import service.WorkspaceService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Resource(name="uploadPath")
	private String UPLOAD_PATH;
	
	@Autowired
	private BoardService bService;
	
	@Autowired
	private FileService fService;
	
	@Autowired
	private MemberService mService;
	
	@Autowired
	private WorkspaceService wService;
	
	@Autowired
	private SimpMessagingTemplate smt;
	
	@Autowired
	private AlarmService aService;
	
	@Autowired
	private SetAlarmService saService;
	
	@RequestMapping("/ckeditorUpload")
	public String ckeditorUpload(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam MultipartFile upload) throws Exception{
		
		UUID uuid = UUID.randomUUID();
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String fileName = upload.getOriginalFilename();
		String uuidName = uuid+"_"+fileName;
		byte[] bytes = upload.getBytes();
		
		String uploadPath = UPLOAD_PATH + "boardImg\\";
		OutputStream out = new FileOutputStream(new File(uploadPath + uuidName));
		out.write(bytes);
		
		PrintWriter printWriter = response.getWriter();
		String fileUrl = UPLOAD_PATH + fileName;
		printWriter.println("{\"filename\" : \""+fileName+"\", \"uploaded\" : 1, \"url\":\""+fileUrl+"\"}");
		printWriter.flush();		
		
		
		return null;
	}
	
	@RequestMapping("/list")
	public String showBoardList(
			HttpSession session, 
			Model model,
			@RequestParam(value="page", defaultValue="1") int page,
			@RequestParam(value="keywordType", defaultValue = "0") int type,
			@RequestParam(value="keyword", required = false) String keyword,
			@RequestParam(value="wNum", required = false)String wNum
			) {
		int wNum2 = 0;
		if( wNum == null || wNum.equals("")) {
			if( session.getAttribute("currWnum")!= null ) {
				wNum2 = Integer.parseInt((String)session.getAttribute("currWnum"));
			}			
		} else {
			session.setAttribute("currWnum", Integer.parseInt(wNum));
			wNum2 = Integer.parseInt(wNum);
		}
		session.setAttribute("currWnum", wNum);
		if(wNum2 == 0) {
			return "/workspace";
		}
		Map<String, Object> param = new HashMap<String, Object>();
		if(page<=0) {
			page=1;
		}
		param.put("wNum", wNum2);
		param.put("page", page);
		param.put("type",type);
		param.put("keyword",keyword);
		Workspace currWs = wService.getWorkspace(wNum2);
		List<Board> bList = bService.getBoardListPage(param);
		model.addAttribute("bList", bList);
		session.setAttribute("currWname", currWs.getName());
		session.setAttribute("listInf", param);
		return "/board/boardList";
	}
	
	@RequestMapping("/view")
	public String showBoardView(
			HttpSession session, 
			Model model,
			int num
			) {
		bService.readCntUp(num);
		Board board = bService.getBoardByBnum(num);
		List<BoardFile> fList = fService.getFilesByBnum(num);
		model.addAttribute("board", board);
		model.addAttribute("fList", fList);
		return "/board/boardView";
	}

	@RequestMapping(value="/checkPass", method = RequestMethod.GET)
	public String showCheckPass(
			Model model,
			String mode,
			int bNum
			) {
		Map<String, Object> updateMap = new HashMap<String, Object>();
		if(mode.equals("modify") || mode.equals("delete")) {
			updateMap.put("mode", mode);
			updateMap.put("bNum", bNum);
			model.addAttribute("updateMap", updateMap);
			return "/board/boardCheckPass";
		} else {
			return "redirect:error";
		}
	}
	
	@RequestMapping(value="/checkPass", method = RequestMethod.POST)
	public String showUpdate(
			Model model,
			String pw,
			int bNum,
			String mode,
			HttpSession session
			) {
		String view = "redirect:error";
		if(bService.getBoardByBnum(bNum)!=null) {
			Board board = bService.getBoardByBnum(bNum);
			if(board.getbPw().equals(pw)) {
				//비밀번호 일치
				session.setAttribute("pwConfirmedBnum", bNum);
				if(mode.equals("modify")) {
					model.addAttribute("bNum", bNum);
					view = "redirect:modify";
				} else if(mode.equals("delete")) {
					if(bService.removeBoard(bNum)) {
						fService.removeBoardFile(bNum);
						view = "redirect:list";
					}
				}
			} else {
				//비밀번호 불일치
				model.addAttribute("bNum", bNum);
				model.addAttribute("mode", mode);
				view = "redirect:checkPass?msg=false";
			}
		}
		return view;
	}

	@RequestMapping(value="/modify", method = RequestMethod.GET)
	public String showModifyForm(HttpSession session, Model model, int bNum) {
		if(session.getAttribute("pwConfirmedBnum") != null && (int)session.getAttribute("pwConfirmedBnum")==bNum) {
			List<BoardFile> fList = fService.getFilesByBnum(bNum);
			model.addAttribute("board", bService.getBoardByBnum(bNum));
			model.addAttribute("fList", fList);
			
			session.removeAttribute("pwConfirmedBnum");
			return "/board/boardModifyForm";
		} else {
			return "redirect:error";
		}
	}

	@RequestMapping(value="/modify", method = RequestMethod.POST)
	public String modifyBoard(
			int bNum,
			String title,
			String content,
			String boardType,
			MultipartHttpServletRequest multifileReq
			) {
		Board board = new Board();
		board.setbNum(bNum);
		board.setbContent(content);
		board.setbTitle(title);
		board.setbType(boardType);
		
		if(bService.modifyBoard(board)) {
			List<MultipartFile> fList = multifileReq.getFiles("file");
			if(fList.size() > 0) {
				fService.removeBoardFile(bNum);
				fileSave(board.getbNum(), fList);
			}
			return "redirect:/board/view?num="+bNum;
		}
		return "redirect:error";
	}
	
	@RequestMapping(value="/write", method = RequestMethod.GET)
	public String showWriteForm(HttpSession session, Model model) {
		return "/board/boardWriteForm";
	}
	
	@RequestMapping(value="/write", method = RequestMethod.POST)
	public String writeNewBoard(
			Principal principal,
			HttpSession session, 
			Model model,
			String boardType,
			String pw,
			String title,
			String content,
			MultipartHttpServletRequest multifileReq
			) {
		int wNum = Integer.parseInt((String)session.getAttribute("currWnum"));
		if(boardType.equals("anonymous") || boardType.equals("default") || boardType.equals("notice")) {
			String usermail = principal.getName();
			int mNum = mService.getMemberByEmail(usermail).getNum();
			Board board = new Board();
			Member user = (Member)session.getAttribute("user");
			board.setbTitle(title);
			board.setmNum(mNum);
			board.setwNum(wNum);
			board.setbContent(content);
			board.setbPw(pw);
			board.setbType(boardType);
			if(bService.addBoard(board)) {	
				List<MultipartFile> fList = multifileReq.getFiles("file");
				fileSave(board.getbNum(), fList);
				
				//notice인 경우 simpmessaging
				if(boardType.equals("notice")) {
					List<Member> thisWsmList = mService.getAllMemberByWnum(wNum);
					for(Member m : thisWsmList) {
						if(m.getNum()!=user.getNum()) {
							//나한텐 알림X
							SetAlarm setAlarm = saService.getSetAlarm(m.getNum());
							if(setAlarm.getNotice()==1) {
								int aNum = aService.addAlarm(wNum, m.getNum(), user.getNum(), "notice", board.getbNum());
								smt.convertAndSend("/category/alarm/"+m.getNum(),aService.getAlarm(aNum));
							}							
						}
					}
				}
				return "redirect:/board/view?num="+board.getbNum();
			}
			
		}else {
			//타입 설정 오류
			return "redirct:error";
		}
		return "redirect:/board/list?wNum="+wNum;
	}
	
	private void fileSave(int bNum, List<MultipartFile> fList) {
		for(MultipartFile mf : fList) {
			if(mf.getSize() != 0) {
				String originFileName = mf.getOriginalFilename();//원본파일명
				UUID uuid = UUID.randomUUID();
				
				//시스템시간(ms) + uuid + 원본파일명
				String saveFileName = "" + System.currentTimeMillis() + uuid +"_"+ originFileName;
				String saveFile = UPLOAD_PATH + saveFileName;
				
				try {
					//서버(path)에 저장
					mf.transferTo(new File(saveFile));
					
					//DB에 게시판번호, 이름 저장
					BoardFile bf = new BoardFile();
					bf.setbNum(bNum);
					bf.setFileName(saveFileName);						
					fService.addFiles(bf);
					
				} catch(IllegalStateException e) {
					e.printStackTrace();
				} catch(IOException e) {
					e.printStackTrace();
				}
			}			
		}
	}
}
