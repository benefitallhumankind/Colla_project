package controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.View;

import controller.MemberController.inner;
import mail.MailReceive;
import mail.MailSend;
import service.FileService;

@Controller
public class MainController {
	
	@Autowired
	private FileService fService;
	
	@RequestMapping("/loading")
	public String showLoading() {
		return "/main/loading";
	}
	@RequestMapping("/main")
	public String main() {
		return "/main/main";
	}
	@RequestMapping("/error")
	public String error() {
		return "/error/error";
	}
	@RequestMapping("/download")
	public View download(String name) {
		return fService.getDownload(name);
	}
	@RequestMapping(value="/collaInfo")
	public String showColla() {
		return "/main/collaInfo";
	}

	@RequestMapping(value="/pricing")
	public String showPricing() {
		return "/main/pricing";
	}
	@RequestMapping(value="/faq")
	public String showFaq() {
		return "/main/faq";
	}
	@RequestMapping(value="/aboutUs")
	public String showAboutUs() {
		return "/main/aboutUs";
	}
	//FAQ 메일 전송
	@ResponseBody
	@RequestMapping(value="/sendFAQMail", method = RequestMethod.POST)
	public boolean sendFAQMail(HttpSession session, String name, String email, String title, String content) {
		System.out.println(name+"이 메일을 보냈음");
		Thread innerTest = new Thread(new inner(name, email, title, content, session));
		innerTest.start();
		return true;
	}
	//메일 발송을 위한 스레드 
	public class inner implements Runnable {
		String name;
		String email;
		String title;
		String content;
		HttpSession session;
		public inner(String name, String email, String title, String content, HttpSession session) {
			this.name = name;
			this.email = email;
			this.title = title;
			this.content = content;
			this.session = session;
		}
		@Override
		public void run() {
			MailReceive ms = new MailReceive();
			ms.MailReceive(name, email, title, content);
		}
	}
}
