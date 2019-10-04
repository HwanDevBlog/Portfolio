package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//메시지 전송 역할을 수행하는 서블릿
@WebServlet("/ChatSubmitServlet")
public class ChatSubmitServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String fromID = request.getParameter("fromID");
		String toID = request.getParameter("toID");
		String chatContent = request.getParameter("chatContent");
		
		if(fromID == null || fromID.equals("") || toID == null || toID.equals("")
				|| chatContent == null || chatContent.equals("")) {
			response.getWriter().write("0");
		} else if(fromID.equals(toID)) { //보내는 사람과 받는 사람의 ID가 동일하다면
			response.getWriter().write("-1"); //오류가 발생했음을 알려주도록 함(자기자신에게 메시지를 보낼 수 없도록 함)
		} else {
			fromID = URLDecoder.decode(fromID, "UTF-8");
			toID = URLDecoder.decode(toID, "UTF-8");
			
			//세션값 검증
			HttpSession session = request.getSession();
			if(!URLDecoder.decode(fromID, "UTF-8").equals((String) session.getAttribute("userID"))) {
				response.getWriter().write("");
				return;
			}
			
			chatContent = URLDecoder.decode(chatContent, "UTF-8");
			
			response.getWriter().write(new ChatDAO().submit(fromID, toID, chatContent) + "");
		}
		
	}

}