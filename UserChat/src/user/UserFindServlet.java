package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//회원가입을 수행하는 서블릿
@WebServlet("/UserFindServlet")
public class UserFindServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		
		//데이터 체크 및 예외 처리
		if(userID == null || userID.equals("")) {
			response.getWriter().write("-1");
		} else if(new UserDAO().registerCheck(userID) == 0) {
			try {
				response.getWriter().write(find(userID));
			} catch (Exception e) {
				e.printStackTrace();
				response.getWriter().write("-1");
			}
		} else {
			response.getWriter().write("-1");
		}
	}
	
	//회원찾기 화면에서 사용자의 프로필 사진을 출력할 수 있도록 하는 함수 생성
	public String find(String userID) throws Exception {
		StringBuffer result = new StringBuffer("");
		result.append("{\"userProfile\":\"" + new UserDAO().getProfile(userID) + "\"}");
		return result.toString();
	}

}