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

//프로필 사진 수정 역할을 수행하는 서블릿
@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		
		//D:\Java\DEV\workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\UserChat에 upload 폴더 추가
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "파일 크기는 10MB를 초과할 수 없습니다.");
			response.sendRedirect("profileUpdate.jsp");
			return;
		}
		
		String userID = multi.getParameter("userID");
		
		//세션값 검증
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		//세션값 검증 결과, 이상이 없을 경우 파일 업로드 진행
		String fileName = "";
		File file = multi.getFile("userProfile");
		if(file != null) {
			
			//파일 확장자명 확인을 위한 변수 생성
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif")) {
				String prev = new UserDAO().getUser(userID).getUserProfile();
				File prevFile = new File(savePath + "/" + prev);
				if(prevFile.exists()) { //기존에 사용자가 등록한 프로필 사진이 존재한다면
					prevFile.delete(); //프로필 사진 수정을 위해, 기존에 사용자가 등록해두었던 프로필 사진을 삭제하도록 함
				}
				fileName = file.getName();
			} else {
				if(file.exists()) { //파일의 확장자명이 jpg, png, gif가 아닌 파일이 존재한다면
					file.delete(); //해당 파일을 삭제하도록 함
				}
				session.setAttribute("messageType", "오류 메시지");
				session.setAttribute("messageContent", "이미지 형식의 파일만 업로드할 수 있습니다.");
				response.sendRedirect("profileUpdate.jsp");
				return;
			}
		}
		//최종적으로, 수정된 프로필 사진을 데이터베이스에 업데이트 처리
		new UserDAO().profile(userID, fileName);

		session.setAttribute("messageType", "성공 메시지");
		session.setAttribute("messageContent", "프로필 사진 수정이 완료되었습니다.");
		response.sendRedirect("profileUpdate.jsp");
		return;
	}

}