package controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import model.Calendar;
import model.Member;
import service.CalendarService;
import service.ProjectMemberService;
import service.ProjectService;
import service.WorkspaceService;

@Controller
public class CalendarController {
	@Autowired
	private CalendarService calendarService;
	@Autowired
	private ProjectService pService;
	@Autowired
	private ProjectMemberService pmService;
	@Autowired
	private WorkspaceService wService;
	
	@RequestMapping(value="/calMonth", method = RequestMethod.GET)
	public String showCalMonth(HttpSession session, Model model, int wNum) {
		int mNum = ((Member)session.getAttribute("user")).getNum();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("wNum", wNum);
		param.put("mNum", mNum);
		model.addAttribute("userData", param);
		session.setAttribute("currWnum", wNum);
		session.setAttribute("currWname", wService.getWorkspace(wNum).getName());
		return "/calendar/calMonth";
	}
	
	@ResponseBody
	@RequestMapping(value="/showAllCalendar", method=RequestMethod.GET)
	public List<Calendar> showAllCalendar(HttpSession session, boolean type1, boolean type2, boolean type3, boolean type4, String today) {
		int wNum = (int)session.getAttribute("currWnum");
		List<Calendar> cList = calendarService.getAllCalendarByMonth(wNum, today);
		List<Calendar> filteredCList = new ArrayList<Calendar>();
		for(int i=0; i<cList.size(); i++) { //타입 걸러내기
			if(type1) {
				String typeTmp = cList.get(i).getType();
				if(typeTmp.equals("project")) {
					filteredCList.add(cList.get(i));
				}
			}
			if(type2) {
				String typeTmp = cList.get(i).getType();
				if(typeTmp.equals("vacation")) {
					filteredCList.add(cList.get(i));
				}
			}
			if(type3) {
				String typeTmp = cList.get(i).getType();
				if(typeTmp.equals("event")) {
					filteredCList.add(cList.get(i));
				}
			}
			if(type4) {
				String typeTmp = cList.get(i).getType();
				if(typeTmp.equals("etc")) {
					filteredCList.add(cList.get(i));
				}
			}
		}
		return filteredCList;
	}
	
	@ResponseBody
	@RequestMapping(value="/showYearCheckedCalendar", method=RequestMethod.GET)
	public List<Calendar> showYearCheckedCalendar(HttpSession session, boolean type1, boolean type2, boolean type3, boolean type4, String today) {
		int wNum = (int)session.getAttribute("currWnum");
		List<Calendar> cList = calendarService.getAllCalendarByYear(wNum, today);
		List<Calendar> yearCheckedCalendarList = new ArrayList<Calendar>();
		for(int i=0; i<cList.size(); i++) {
			String yearChecked = cList.get(i).getYearCalendar();
			if(yearChecked.equals("1")) {
				yearCheckedCalendarList.add(cList.get(i));
			}
		}
		List<Calendar> filteredCList = new ArrayList<Calendar>();
		for(int i=0; i<yearCheckedCalendarList.size(); i++) {
			if(type1) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("project")) {
					filteredCList.add(yearCheckedCalendarList.get(i));
				}
			}
			if(type2) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("vacation")) {
					filteredCList.add(yearCheckedCalendarList.get(i));
				}
			}
			if(type3) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("event")) {
					filteredCList.add(yearCheckedCalendarList.get(i));
				}
			}
			if(type4) {
				String typeTmp = yearCheckedCalendarList.get(i).getType();
				if(typeTmp.equals("etc")) {
					filteredCList.add(yearCheckedCalendarList.get(i));
				}
			}
		}
		return filteredCList;
	}
	
	@ResponseBody
	@RequestMapping(value="/addSchedule", method = RequestMethod.POST)
	public boolean addSchedule(Calendar calendar) throws ParseException {
		if(calendar.getYearCalendar()!=null && calendar.getYearCalendar().equals("yearCalendar")) {
			calendar.setYearCalendar("1");
		} else {
			calendar.setYearCalendar("0");
		}
		if(calendar.getAnnually()!=null && calendar.getAnnually().equals("annually")) {
			calendar.setAnnually("1");
		} else {
			calendar.setAnnually("0");
		}
		if(calendar.getMonthly()!=null && calendar.getMonthly().equals("monthly")) {
			calendar.setMonthly("1");
		} else {
			calendar.setMonthly("0");
		}
		boolean result = calendarService.addCalendar(calendar);
		String startDateTmp = calendar.getStartDate();
		if(calendar.getAnnually().equals("1")) { //년 반복
			calendarService.addCalendarAnnually(calendar);
		}
		calendar.setStartDate(startDateTmp);
		if(calendar.getMonthly().equals("1")) { //월 반복
			calendarService.addCalendarMonthly(calendar);
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/modifySchedule", method = RequestMethod.POST)
	public boolean modifySchedule(Calendar calendar) throws ParseException {
		if(calendar.getAnnually()!=null && calendar.getAnnually().equals("annually")) {
			calendar.setAnnually("1");
		} else {
			calendar.setAnnually("0");
		}
		if(calendar.getYearCalendar()!=null && calendar.getYearCalendar().equals("yearCalendar")) {
			calendar.setYearCalendar("1");
		} else {
			calendar.setYearCalendar("0");
		}
		if(calendar.getMonthly()!=null && calendar.getMonthly().equals("monthly")) {
			calendar.setMonthly("1");
		} else {
			calendar.setMonthly("0");
		}
		boolean result = calendarService.modifyCalendar(calendar);
		String startDateTmp = calendar.getStartDate();
		if(calendar.getAnnually().equals("1")) { //년 반복
			calendarService.addCalendarAnnually(calendar);
		} 
		calendar.setStartDate(startDateTmp);
		if(calendar.getMonthly().equals("1")) { //월 반복
			calendarService.addCalendarMonthly(calendar);
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/removeSchedule", method = RequestMethod.POST)
	public boolean removeSchedule(Calendar calendar) {
		return calendarService.removeCalendar(calendar.getcNum());
	}
	
	@ResponseBody
	@RequestMapping(value="/selectSchedule", method = RequestMethod.POST)
	public Calendar selectSchedule(Calendar calendar) {
		return calendarService.getCalendar(calendar.getcNum());
	}
	
	@RequestMapping(value="/calSearchList", method = RequestMethod.GET)
	public String showCalSearchList(HttpSession session, Model model, 
			@RequestParam(defaultValue="1")int page,
			@RequestParam(required=false)String searchKeyword, 
			@RequestParam(defaultValue="0")int searchType) {	
		int wNum = (int)session.getAttribute("currWnum");
		Map<String, Object> tmp = new HashMap<String, Object>();
		tmp.put("page", page);
		tmp.put("searchType", searchType);
		tmp.put("searchKeyword", searchKeyword);
		tmp.put("wNum", wNum);
		Map<String, Object> result = calendarService.getAllCalendarSearched(tmp);
		model.addAllAttributes(result);
		session.setAttribute("calInfo", tmp);
		session.setAttribute("currWnum", wNum);
		return "/calendar/calSearchList";
	}
	
	@ResponseBody
	@RequestMapping(value="/getPnum")
	public int getPnum(int cNum) {
		return pService.getPnumByCnum(cNum);
	}
	
	@ResponseBody
	@RequestMapping(value="/isMyProject")
	public boolean isMyProject(int cNum, HttpSession session) {
		int mNum = ((Member)session.getAttribute("user")).getNum();
		int pNum = pService.getPnumByCnum(cNum); 
		if(pmService.getProjectMember(pNum, mNum)==null) {
			return false;
		} else {			
			return true;
		}
	}
}