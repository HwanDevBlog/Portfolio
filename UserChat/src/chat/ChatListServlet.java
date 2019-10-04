package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//두명의 사용자가 주고받은 대화를 반환하는 역할을 수행하는 서블릿
@WebServlet("/ChatListServlet")
public class ChatListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String fromID = request.getParameter("fromID");
		String toID = request.getParameter("toID");
		String listType = request.getParameter("listType");
		
		if(fromID == null || fromID.equals("") || toID == null || toID.equals("")
				|| listType == null || listType.equals("")) {
			response.getWriter().write("");
		} else if (listType.equals("ten")) {
			//fromID와 toID는 한글로 작성되있을 수도 있기 때문에, URLDecoder를 활용하여 UTF-8으로 디코딩하였음
			response.getWriter().write(getTen(URLDecoder.decode(fromID, "UTF-8"), URLDecoder.decode(toID, "UTF-8")));
		} else {
			try {
				
				//세션값 검증
				HttpSession session = request.getSession();
				if(!URLDecoder.decode(fromID, "UTF-8").equals((String) session.getAttribute("userID"))) {
					response.getWriter().write("");
					return;
				}
				
				response.getWriter().write(getID(URLDecoder.decode(fromID, "UTF-8"), URLDecoder.decode(toID, "UTF-8"), listType));
			} catch (Exception e) {
				response.getWriter().write("");
			}
		}
		
	}
	
	//최근 메시지 100개까지 가져올 수 있도록 하는 함수 생성
	//함수명은 최근 메시지 10개까지 가져온다는 의미에서 getTen이라고 만들었지만, 100개까지 가져올 수 있도록 수정하였음
	public String getTen(String fromID, String toID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getChatListByRecent(fromID, toID, 100);
		
		if(chatList.size() == 0) return "";
		
		for(int i=0; i<chatList.size(); i++) {
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			
			//배열의 마지막 원소가 아니라면 그 다음 원소가 있다는 것을 알려주기 위해서 ","를 찍어주도록 함
			if(i != chatList.size() -1) result.append(",");
		}
		//chatList 중 가장 마지막에 해당되는 데이터의 ChatID를 가져오도록 함
		result.append("], \"last\":\"" + chatList.get(chatList.size() -1).getChatID() + "\"}");
		
		//getTen 함수가 실행되었다는 뜻은 사용자가 메시지함을 확인하였고, 그로 인해 채팅 내역이 불러와진 것을 의미하므로
		//readChat 함수를 통해 메시지를 읽음 처리
		chatDAO.readChat(fromID, toID);
		
		return result.toString();
	}
	
	public String getID(String fromID, String toID, String chatID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getChatListByID(fromID, toID, chatID);
		
		if(chatList.size() == 0) return "";
		
		for(int i=0; i<chatList.size(); i++) {
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"}]");
			
			if(i != chatList.size() -1) result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() -1).getChatID() + "\"}");
		
		chatDAO.readChat(fromID, toID);
		
		return result.toString();
	}

}