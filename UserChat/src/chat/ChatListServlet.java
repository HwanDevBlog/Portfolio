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

//�θ��� ����ڰ� �ְ���� ��ȭ�� ��ȯ�ϴ� ������ �����ϴ� ����
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
			//fromID�� toID�� �ѱ۷� �ۼ������� ���� �ֱ� ������, URLDecoder�� Ȱ���Ͽ� UTF-8���� ���ڵ��Ͽ���
			response.getWriter().write(getTen(URLDecoder.decode(fromID, "UTF-8"), URLDecoder.decode(toID, "UTF-8")));
		} else {
			try {
				
				//���ǰ� ����
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
	
	//�ֱ� �޽��� 100������ ������ �� �ֵ��� �ϴ� �Լ� ����
	//�Լ����� �ֱ� �޽��� 10������ �����´ٴ� �ǹ̿��� getTen�̶�� ���������, 100������ ������ �� �ֵ��� �����Ͽ���
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
			
			//�迭�� ������ ���Ұ� �ƴ϶�� �� ���� ���Ұ� �ִٴ� ���� �˷��ֱ� ���ؼ� ","�� ����ֵ��� ��
			if(i != chatList.size() -1) result.append(",");
		}
		//chatList �� ���� �������� �ش�Ǵ� �������� ChatID�� ���������� ��
		result.append("], \"last\":\"" + chatList.get(chatList.size() -1).getChatID() + "\"}");
		
		//getTen �Լ��� ����Ǿ��ٴ� ���� ����ڰ� �޽������� Ȯ���Ͽ���, �׷� ���� ä�� ������ �ҷ����� ���� �ǹ��ϹǷ�
		//readChat �Լ��� ���� �޽����� ���� ó��
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