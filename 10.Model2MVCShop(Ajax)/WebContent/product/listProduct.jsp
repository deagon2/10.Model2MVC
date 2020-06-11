<%@ page contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">


function fncGetList(currentPage) {
	//document.getElementById("currentPage").value = currentPage;
   	$("#currentPage").val(currentPage)
	//document.detailForm.submit();		
	$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${param.menu}").submit();
}
//==> 추가된부분 : "검색" ,  userId link  Event 연결 및 처리
	$(function() {
			 
			//==> 검색 Event 연결처리부분
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			//==> 1 과 3 방법 조합 : $("tagName.className:filter함수")사용함. 
			 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
				//Debug..
				//alert(  $( "td.ct_btn01:contains('검색')" ).html() );
				fncGetList(1);
			});
			
			$(".ct_list_pop td:nth-child(3)").on("click",function(){
				var prodNo=$(this).data('prodno');
				var proTranCode=$(this).data('protrancode');
				var prodName=$(this).data('prodname');
				
				if('${param.menu}'=='manage'){
					url	=  "<a href='/product/updateProduct?prodNo="+prodNo+"'>[수정]</a>"
				}else if('${param.menu}'=='search' && proTranCode=='0'){	
					url = "<a href='/purchase/addPurchase?prodNo="+prodNo+"'>[구매]</a>"
				}
					$.ajax(
							{
								url : "/product/json/getProduct/"+prodNo,
								method : "GET" ,
								dataType : "json" ,
								headers : {
									"Accept" : "application/json",
									"Content-Type" : "application/json"
								},
								success : function(JSONData , status) {
									
									var displayValue = "<h3>"
										+"상품명 : "+JSONData.prodName+"<br/>"
										+"상품상세정보: "+JSONData.prodDetail+"<br/>"
										+"제조일자 : "+JSONData.manuDate+"<br/>"
										+"가격 : "+JSONData.price+"<br/>"
										+"상품이미지 : <img src=\"../images/uploadFiles/"+JSONData.fileName+"\"><br/>"
										+url
										+"</h3>";
										
									$("h3").remove();
									$("#"+prodName+"").html(displayValue);
								}
						
					});
				});	
			
			$("#tranCode").on("click",function(){
			var prodNo=$(this).data('prodno');
			self.location ="/purchase/updateTranCodeByProd?prodNo="+prodNo+"&tranCode=2";
			})
			$( ".ct_list_pop td:nth-child(3)" ).css("color" , "blue");
			
		});
			
 
 
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">


<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<c:if test="${param.menu=='manage'}">
					<td width="93%" class="ct_ttl01">					
					상품 관리					
					</td>
				</c:if>
				<c:if test="${param.menu=='search'}">	
					<td width="93%" class="ct_ttl01">					
					상품 목록조회					
					</td>
				</c:if>	
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>



<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
		<select name="searchCondition" class="ct_input_g" style="width:80px">
	<option value="0" ${! empty search.searchCondition && search.searchCondition==0 ? "selected" : ""}>상품번호</option>
	<option value="1" ${! empty search.searchCondition && search.searchCondition==1 ? "selected" : ""}>상품명</option>
	<option value="2" ${! empty search.searchCondition && search.searchCondition==2 ? "selected" : ""}>상품가격</option>
	</select>
			
			<input type="text" name="searchKeyword"  
			value="${! empty search.searchKeyword ? search.searchKeyword : ""}" 
			class="ct_input_g" style="width:200px; height:19px" />
		</td>
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!-- <a href="javascript:fncGetList('1');">검색</a> -->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	
	<tr>
		<td colspan="11" >전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage}  페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	
	<c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center">${ i }</td>
			<td></td>
			<!--데이터 속성의 장점
	데이터 속성의 장점은 이전과 같이 hidden으로 태그를 숨겨두고 데이터를 저장할 필요가 없어졌다는 점 입니다.
	 따라서 훨씬 HTML 스크립트가 간결해집니다.
	  또한 하나의 HTML 요소에는 여러 데이터 속성을 동시에 사용할 수도 있습니다.
	<input type="text" data-value="001"  data-code="c03"  id="username"> 
							(value가 임의속성)  (code가 임의속성)
   출처: https://dololak.tistory.com/364 [코끼리를 냉장고에 넣는 방법]
				태그 안에 쓸수 있는 기능으로 
			    data- 로 원하는 데이터타입을 임의로 정하여 보낼수 있게해줌. 대문자는 안됨.  -->
			<td align="left" data-prodno="${product.prodNo}"
							 data-protrancode="${product.proTranCode}"
							 data-prodname="${product.prodName}">
							${product.prodName}</td>
			<td></td>
			<td align="left">${product.price}</td>
			<td></td>
			<td align="left">${product.regDate}</td>
			<td></td>
			<td align="left">
		
		<c:choose>
			<c:when test="${product.proTranCode=='0'}">
				판매중
			</c:when>
			
			<c:when test="${param.menu=='manage'}">
				<c:if test="${product.proTranCode=='1  '}">
					구매완료 <%-- <a href="/purchase/updateTranCodeByProd?prodNo=${product.prodNo}&tranCode=2">배송하기</a> --%>
					  &nbsp;&nbsp;&nbsp;&nbsp;
					  <span id = "tranCode" data-prodno="${product.prodNo}">배송하기</span>
					<!--sapn 쓰면 이어써지고, div쓰면 밑으로 엔터쳐서나옴.  -->
				</c:if>
				<c:if test="${product.proTranCode=='2'}">
					배송중
				</c:if>
				<c:if test="${product.proTranCode=='3'}">
					배송완료
				</c:if>			
			</c:when>
			
			<c:when test="${param.menu=='search' && user.role=='admin'}">
				<c:if test="${product.proTranCode=='1'}">
					구매완료
				</c:if>
				<c:if test="${product.proTranCode=='2'}">
					배송중
				</c:if>
				<c:if test="${product.proTranCode=='3  '}">
					배송완료
				</c:if>	
			</c:when>
			
			<c:otherwise>
				재고없음
			</c:otherwise>	
		</c:choose>
	
			</td>	
		</tr>
		<tr>
			<td id = "${product.prodName}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>			
	</c:forEach>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		<input type="hidden" id="currentPage" name="currentPage" value=""/>
		
			<jsp:include page="../common/pageNavigator.jsp"/>	
		
		

    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>
