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

import user.UserDAO;

@WebServlet("/ChatBoxServlet")
public class ChatBoxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String userID = request.getParameter("userID");
		
		if(userID == null || userID.equals("")) {
			response.getWriter().write("");
		} else {
			try {
				
				//세션값 검증
					//열람하고자 하는 메시지함의 주인이 되는 사용자의 ID와, 현재 로그인된 사용자의 ID가 일치하는지 확인하기 위함
				HttpSession session = request.getSession();
				if(!URLDecoder.decode(userID, "UTF-8").equals((String) session.getAttribute("userID"))) {
					response.getWriter().write("");
					return;
				}
				
				userID = URLDecoder.decode(userID, "UTF-8");
				response.getWriter().write(getBox(userID));
			} catch (Exception e) {
				response.getWriter().write("");
			}

		}
		
	}
	
	//특정한 사용자가 가지는 모든 메시지 목록을 출력하도록 하기 위한 함수 생성
	public String getBox(String userID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getBox(userID);
		
		if(chatList.size() == 0) return "";
		
		for(int i=chatList.size() -1; i>=0; i--) { //메시지함에서 최근 메시지가 최상단에 위치할 수 있도록 하기 위함
			//대화상대별 읽지 않은 메시지의 개수를 출력하기 위해 unread 변수 생성
			String unread = "";
			String userProfile = "";
			if(userID.equals(chatList.get(i).getToID())) {
				unread = chatDAO.getUnreadChat(chatList.get(i).getFromID(), userID) + "";
				if(unread.equals("0")) unread = "";
			}
			
			if(userID.equals(chatList.get(i).getToID())) {
				userProfile = new UserDAO().getProfile(chatList.get(i).getFromID());
			} else {
				userProfile = new UserDAO().getProfile(chatList.get(i).getToID());
			}
			
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"},");
			result.append("{\"value\": \"" + unread + "\"},");
			result.append("{\"value\": \"" + userProfile + "\"}]");
			
			if(i != 0) result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() -1).getChatID() + "\"}");
		return result.toString();
	}
	
}