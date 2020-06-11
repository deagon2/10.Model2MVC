package com.model2.mvc.web.product;

import java.io.File;
import java.io.IOException;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.user.UserService;

@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	//@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	//@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
	//@RequestMapping("/addProductView.do")
	//public String addProductView() throws Exception {	
	@RequestMapping(value="addProduct", method=RequestMethod.GET)
	public String addProduct() throws Exception{
		System.out.println("/addProductView.do");
		
		return "redirect:/product/addProductView.jsp";
	}
	
	//@RequestMapping("/addProduct.do")
	//public String addUser( @ModelAttribute("product") Product product) throws Exception {
	@RequestMapping(value="addProduct", method=RequestMethod.POST)
	public String addProduct(@RequestParam(value="file", required = false) MultipartFile mf ,Product product, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		System.out.println("/product/addProduct : POST");
		
		if(mf != null) {
			System.out.println("fileName : "+ mf);
			System.out.println(product);
			
			String savePath = "C:\\Users\\deago\\git\\10.Model2MVC\\10.Model2MVCShop(Ajax)\\WebContent\\images\\uploadFiles\\";
			
			String originalFileName = mf.getOriginalFilename();
			long fileSize = mf.getSize();
			String safeFile = savePath+originalFileName;
			
			System.out.println("originalFileName : "+originalFileName);
			System.out.println("fileSize : "+fileSize);
			System.out.println("safeFile : "+safeFile);
			
				
			try {
				mf.transferTo(new File(safeFile));
			} catch(IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			product.setFileName(originalFileName);
		
		}
		productService.addProduct(product);
		
		
		
		return "/product/getProduct.jsp";
	}
	
	//@RequestMapping("/listProduct.do")
	//public String listProduct(@ModelAttribute("search") Search search,Model model , HttpServletRequest request) throws Exception{
	@RequestMapping(value="listProduct")
	public String listProduct(@ModelAttribute("search") Search search,Model model , HttpServletRequest request) throws Exception{
		System.out.println("/listProduct.do");
		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		Map<String , Object> map=productService.getProductList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		return "forward:/product/listProduct.jsp";
	}
	
	//@RequestMapping("/updateProductView.do")
	//public String updateProductView(@RequestParam("prodNo") int prodNo, Model model) throws Exception{
	@RequestMapping(value="updateProduct", method=RequestMethod.GET)
	public String updateProduct(@RequestParam("prodNo") int prodNo, Model model) throws Exception{
		System.out.println("/updateProductView.do");
		
		Product product=productService.getProduct(prodNo);
		model.addAttribute("product",product);
		
		return "forward:/product/updateProductView.jsp";
	}
	
	//@RequestMapping("/updateProduct.do")
	//public String updateProduct(@ModelAttribute("product")Product product, Model model , HttpSession session) throws Exception{
	@RequestMapping(value="updateProduct", method=RequestMethod.POST)
	public String updateProduct(@ModelAttribute("product")Product product, Model model , HttpSession session) throws Exception{
		System.out.println("/updateProduct.do");
		
		productService.updateProduct(product);
		
		int prodNo=product.getProdNo();
		
		return "redirect:/product/getProduct?prodNo="+prodNo+"&menu=manage";
	}
	
	//@RequestMapping("/getProduct.do")
	//public String getProduct(@RequestParam("prodNo") int prodNo, Model model) throws Exception{
	@RequestMapping(value="getProduct")	
	public String getProduct(@RequestParam("prodNo") String prodNo, Model model,HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("/getProduct.do");
		
		Product product=productService.getProduct(Integer.parseInt(prodNo));
		
		model.addAttribute("product",product);
		
/*		Cookie[] cookies = request.getCookies();
		if(cookies!=null && cookies.length>0) {
		  for(int i=0;i<cookies.length;i++) {	
			  Cookie cookie = cookies[i];
			if(cookie.getName().equals("history")) {
				cookie.setValue(cookie.getValue()+","+prodNo);
				cookie.setMaxAge(60*60);
				response.addCookie(cookie);
			}else{
			cookie = new Cookie("history",prodNo);
			cookie.setMaxAge(60*60);
			cookie.setPath("/");
			response.addCookie(cookie);		
			}
		  }
		}
*/
		String history=null;
		Cookie[] cookies = request.getCookies();
		if(cookies!=null && cookies.length>0) {
			  for(int i=0;i<cookies.length;i++) {	
				  Cookie cookie = cookies[i];
				if(cookie.getName().equals("history")) {
					history=cookie.getValue();
				}
			  }
		}
		Cookie cookie=new Cookie("history",history+","+prodNo);
		cookie.setPath("/");
		response.addCookie(cookie);	
		
		
		return "forward:/product/getProduct.jsp";
	}

}
