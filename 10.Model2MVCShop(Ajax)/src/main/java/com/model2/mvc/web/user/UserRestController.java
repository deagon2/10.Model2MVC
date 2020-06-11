package com.model2.mvc.web.user;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.user.UserService;


//==> ȸ������ RestController
@RestController
@RequestMapping("/user/*")
public class UserRestController {
	
	///Field
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	//setter Method ���� ����
		
	public UserRestController(){
		System.out.println(this.getClass());
	}
	
	@RequestMapping( value="json/getUser/{userId}", method=RequestMethod.GET )
	public User getUser( @PathVariable String userId ) throws Exception{
		
		System.out.println("/user/json/getUser : GET");
		
		//Business Logic
		return userService.getUser(userId);
	}

	@RequestMapping( value="json/login", method=RequestMethod.POST )
	public User login(	@RequestBody User user,
									HttpSession session ) throws Exception{
	
		System.out.println("/user/json/login : POST");
		//Business Logic
		System.out.println("::"+user);
		User dbUser=userService.getUser(user.getUserId());
		
		if( user.getPassword().equals(dbUser.getPassword())){
			session.setAttribute("user", dbUser);
		}
		
		return dbUser;
	}
	//����Ȯ��
	@RequestMapping( value="json/kakaocheck/{kakaotoken}", method=RequestMethod.GET)
	public User kakaocheck(@PathVariable String kakaotoken,
							HttpSession session) throws Exception{
		System.out.println("kakaocheck => "+kakaotoken);
		User user = userService.kakaocheck(kakaotoken);
		if(user == null) {
			user = new User();
		}
		
		return user;
	}
	//īī�� ���� ����
		@RequestMapping( value="json/updateUserId/{userId}/{kakaotoken}", method=RequestMethod.GET)
		public User updateUserId(@PathVariable String userId,
								@PathVariable String kakaotoken) throws Exception{
			System.out.println("updateUserId => "+userId+" : "+kakaotoken);

			userService.updateUserId(userId, kakaotoken);
			User user = userService.getUser(userId);
			
			return user;
		}
	//īī���α���	
		@RequestMapping( value="json/kakaologin/{userId}/{password}", method=RequestMethod.GET )
		public User kakaologin(	@PathVariable String userId,
							@PathVariable String password,
										HttpSession session ) throws Exception{
		
			System.out.println("/user/json/kakaologin : GET");
			//Business Logic
			System.out.println("::"+userId);
			User dbUser=userService.getUser(userId);
			
			if( password.equals(dbUser.getPassword())){
				session.setAttribute("user", dbUser);
			}
			
			return dbUser;
		}
}