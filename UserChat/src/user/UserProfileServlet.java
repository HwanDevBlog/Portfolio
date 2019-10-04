package user;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

//������ ���� ���� ������ �����ϴ� ����
@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		
		//D:\Java\DEV\workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\UserChat�� upload ���� �߰�
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "���� ũ��� 10MB�� �ʰ��� �� �����ϴ�.");
			response.sendRedirect("profileUpdate.jsp");
			return;
		}
		
		String userID = multi.getParameter("userID");
		
		//���ǰ� ����
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		//���ǰ� ���� ���, �̻��� ���� ��� ���� ���ε� ����
		String fileName = "";
		File file = multi.getFile("userProfile");
		if(file != null) {
			
			//���� Ȯ���ڸ� Ȯ���� ���� ���� ����
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif")) {
				String prev = new UserDAO().getUser(userID).getUserProfile();
				File prevFile = new File(savePath + "/" + prev);
				if(prevFile.exists()) { //������ ����ڰ� ����� ������ ������ �����Ѵٸ�
					prevFile.delete(); //������ ���� ������ ����, ������ ����ڰ� ����صξ��� ������ ������ �����ϵ��� ��
				}
				fileName = file.getName();
			} else {
				if(file.exists()) { //������ Ȯ���ڸ��� jpg, png, gif�� �ƴ� ������ �����Ѵٸ�
					file.delete(); //�ش� ������ �����ϵ��� ��
				}
				session.setAttribute("messageType", "���� �޽���");
				session.setAttribute("messageContent", "�̹��� ������ ���ϸ� ���ε��� �� �ֽ��ϴ�.");
				response.sendRedirect("profileUpdate.jsp");
				return;
			}
		}
		//����������, ������ ������ ������ �����ͺ��̽��� ������Ʈ ó��
		new UserDAO().profile(userID, fileName);

		session.setAttribute("messageType", "���� �޽���");
		session.setAttribute("messageContent", "������ ���� ������ �Ϸ�Ǿ����ϴ�.");
		response.sendRedirect("profileUpdate.jsp");
		return;
	}

}