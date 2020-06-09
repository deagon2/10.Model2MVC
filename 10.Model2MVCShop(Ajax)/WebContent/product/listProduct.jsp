<%@ page contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>��ǰ �����ȸ</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">


function fncGetList(currentPage) {
	//document.getElementById("currentPage").value = currentPage;
   	$("#currentPage").val(currentPage)
	//document.detailForm.submit();		
	$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${param.menu}").submit();
}
//==> �߰��Ⱥκ� : "�˻�" ,  userId link  Event ���� �� ó��
	$(function() {
			 
			//==> �˻� Event ����ó���κ�
			//==> DOM Object GET 3���� ��� ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			//==> 1 �� 3 ��� ���� : $("tagName.className:filter�Լ�")�����. 
			 $( "td.ct_btn01:contains('�˻�')" ).on("click" , function() {
				//Debug..
				//alert(  $( "td.ct_btn01:contains('�˻�')" ).html() );
				fncGetList(1);
			});
			
			$(".ct_list_pop td:nth-child(3)").on("click",function(){
				var prodNo=$(this).data('prodno');
				var proTranCode=$(this).data('protrancode');
				var prodName=$(this).data('prodname');
				
				if('${param.menu}'=='manage'){
					self.location ="/product/updateProduct?prodNo="+prodNo+"&menu=${param.menu}";
					

				}else if('${param.menu}'=='search' && proTranCode=='0'){
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
										+"��ǰ�� : "+JSONData.prodName+"<br/>"
										+"��ǰ������: "+JSONData.prodDetail+"<br/>"
										+"�������� : "+JSONData.manuDate+"<br/>"
										+"���� : "+JSONData.price+"<br/>"
										+"<a href='/purchase/addPurchase?prodNo="+prodNo+"'>[����]</a>"
										+"</h3>";
										
									$("h3").remove();
									$("#"+prodName+"").html(displayValue);
								}
						
					});
				}	
			})
			
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
					��ǰ ����					
					</td>
				</c:if>
				<c:if test="${param.menu=='search'}">	
					<td width="93%" class="ct_ttl01">					
					��ǰ �����ȸ					
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
	<option value="0" ${! empty search.searchCondition && search.searchCondition==0 ? "selected" : ""}>��ǰ��ȣ</option>
	<option value="1" ${! empty search.searchCondition && search.searchCondition==1 ? "selected" : ""}>��ǰ��</option>
	<option value="2" ${! empty search.searchCondition && search.searchCondition==2 ? "selected" : ""}>��ǰ����</option>
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
						<!-- <a href="javascript:fncGetList('1');">�˻�</a> -->
						�˻�
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
		<td colspan="11" >��ü ${resultPage.totalCount} �Ǽ�, ���� ${resultPage.currentPage}  ������</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ��</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">����</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">�������</td>	
	</tr>
	
	<c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center">${ i }</td>
			<td></td>
			<!--������ �Ӽ��� ����
	������ �Ӽ��� ������ ������ ���� hidden���� �±׸� ���ܵΰ� �����͸� ������ �ʿ䰡 �������ٴ� �� �Դϴ�.
	 ���� �ξ� HTML ��ũ��Ʈ�� ���������ϴ�.
	  ���� �ϳ��� HTML ��ҿ��� ���� ������ �Ӽ��� ���ÿ� ����� ���� �ֽ��ϴ�.
	<input type="text" data-value="001"  data-code="c03"  id="username"> 
							(value�� ���ǼӼ�)  (code�� ���ǼӼ�)
   ��ó: https://dololak.tistory.com/364 [�ڳ����� ����� �ִ� ���]
				�±� �ȿ� ���� �ִ� ������� 
			    data- �� ���ϴ� ������Ÿ���� ���Ƿ� ���Ͽ� ������ �ְ�����. �빮�ڴ� �ȵ�.  -->
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
				�Ǹ���
			</c:when>
			
			<c:when test="${param.menu=='manage'}">
				<c:if test="${product.proTranCode=='1  '}">
					���ſϷ� <%-- <a href="/purchase/updateTranCodeByProd?prodNo=${product.prodNo}&tranCode=2">����ϱ�</a> --%>
					  &nbsp;&nbsp;&nbsp;&nbsp;
					  <span id = "tranCode" data-prodno="${product.prodNo}">����ϱ�</span>
					<!--sapn ���� �̾������, div���� ������ �����ļ�����.  -->
				</c:if>
				<c:if test="${product.proTranCode=='2'}">
					�����
				</c:if>
				<c:if test="${product.proTranCode=='3'}">
					��ۿϷ�
				</c:if>			
			</c:when>
			
			<c:when test="${param.menu=='search' && user.role=='admin'}">
				<c:if test="${product.proTranCode=='1'}">
					���ſϷ�
				</c:if>
				<c:if test="${product.proTranCode=='2'}">
					�����
				</c:if>
				<c:if test="${product.proTranCode=='3  '}">
					��ۿϷ�
				</c:if>	
			</c:when>
			
			<c:otherwise>
				������
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
<!--  ������ Navigator �� -->

</form>

</div>
</body>
</html>
