<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="EUC-KR">
	
	<title>�α��� ȭ��</title>
	
	<link rel="stylesheet" href="/css/admin.css" type="text/css">
	
	<!-- CDN(Content Delivery Network) ȣ��Ʈ ��� -->
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script type="text/javascript">
	   
	$(function(){
		$("#kakaologin").on("click" , function() {
			loginWithKakao();
		});
	});
		Kakao.init('c1172a908282d12c8eb6283ce9e4baaa');
		function loginWithKakao() {
			// �α��� â�� ���ϴ�.
			Kakao.Auth.login({
				success : function(authObj) {
					Kakao.API.request({
						url : '/v2/user/me',
						success : function(res) {
							kakaocheck(res);
						},
						fail : function(error) {
							alert(JSON.stringify(error));
						}
					});
				},
				fail : function(err) {
					alert(JSON.stringify(err));
				}
			});
		};

		function kakaocheck(res) {
			var kakaotoken = res.id;
			alert(res.id);

			$.ajax({
				url : "/user/json/kakaocheck/" + kakaotoken ,
				method : "GET",
				dataType : "json",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData, status) {
					if (JSONData.userId != null) {
						kakaologin(JSONData.userId, JSONData.password);
					} else {
						alert("īī�������̾ȵ�ȸ���Դϴ�!");
					}
				}
			});
		}

		function kakaologin(id, password) {

			$.ajax({
				url : "/user/json/kakaologin/" + id + "/" + password,
				method : "GET",
				dataType : "json",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData, status) {
					$(parent.document.location).attr("href", "/index.jsp");
					window.close();
				}
			});
		}

		$(function() {

			//==> DOM Object GET 3���� ��� ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$("#userId").focus();

			//==>"Login"  Event ����
			$("img[src='/images/btn_login.gif']")
					.on(
							"click",
							function() {

								var id = $("input:text").val();
								var pw = $("input:password").val();

								if (id == null || id.length < 1) {
									alert('ID �� �Է����� �����̽��ϴ�.');
									$("input:text").focus();
									return;
								}

								if (pw == null || pw.length < 1) {
									alert('�н����带 �Է����� �����̽��ϴ�.');
									$("input:password").focus();
									return;
								}

								////////////////////////////////////////////////// �߰� , ����� �κ� ////////////////////////////////////////////////////////////
								//$("form").attr("method","POST").attr("action","/user/login").attr("target","_parent").submit();
								////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								$
										.ajax({
											url : "/user/json/login",
											method : "POST",
											dataType : "json",
											headers : {
												"Accept" : "application/json",
												"Content-Type" : "application/json"
											},
											data : JSON.stringify({
												userId : id,
												password : pw
											}),
											success : function(JSONData, status) {

												//Debug...
												//alert(status);
												//alert("JSONData : \n"+JSONData);
												//alert( "JSON.stringify(JSONData) : \n"+JSON.stringify(JSONData) );
												//alert( JSONData != null );

												if (JSONData != null) {
													//[���1]
													//$(window.parent.document.location).attr("href","/index.jsp");

													//[���2]
													//window.parent.document.location.reload();

													//[���3]
													$(
															window.parent.frames["topFrame"].document.location)
															.attr("href",
																	"/layout/top.jsp");
													$(
															window.parent.frames["leftFrame"].document.location)
															.attr("href",
																	"/layout/left.jsp");
													$(
															window.parent.frames["rightFrame"].document.location)
															.attr(
																	"href",
																	"/user/getUser?userId="
																			+ JSONData.userId);

													//==> ��� 1 , 2 , 3 ��� ����
												} else {
													alert("���̵� , �н����带 Ȯ���Ͻð� �ٽ� �α���...");
												}
											}
										});
								////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

							});
		});

		//============= ȸ��������ȭ���̵� =============
		$(function() {
			//==> �߰��Ⱥκ� : "addUser"  Event ����
			$("img[src='/images/btn_add.gif']").on("click", function() {
				self.location = "/user/addUser"
			});
		});
	</script>		
	
</head>

<body bgcolor="#ffffff" text="#000000" >

<form>

<div align="center" >

<TABLE WITH="100%" HEIGHT="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0">
<TR>
<TD ALIGN="CENTER" VALIGN="MIDDLE">

<table width="650" height="390" border="5" cellpadding="0" cellspacing="0" bordercolor="#D6CDB7">
  <tr> 
    <td width="10" height="5" align="left" valign="top" bordercolor="#D6CDB7">
    	<table width="650" height="390" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="305">
            <img src="/images/logo-spring.png" width="305" height="390"/>
          </td>
          <td width="345" align="left" valign="top" background="/images/login02.gif">
          	<table width="100%" height="220" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="30" height="100">&nbsp;</td>
                <td width="100" height="100">&nbsp;</td>
                <td height="100">&nbsp;</td>
                <td width="20" height="100">&nbsp;</td>
              </tr>
              <tr> 
                <td width="30" height="50">&nbsp;</td>
                <td width="100" height="50">
                	<img src="/images/text_login.gif" width="91" height="32"/>
                </td>
                <td height="50">&nbsp;</td>
                <td width="20" height="50">&nbsp;</td>
              </tr>
              <tr> 
                <td width="200" height="50" colspan="4"></td>
              </tr>              
              <tr> 
                <td width="30" height="30">&nbsp;</td>
                <td width="100" height="30">
                	<img src="/images/text_id.gif" width="100" height="30"/>
                </td>
                <td height="30">
                  <input 	type="text" name="userId"  id="userId"  class="ct_input_g" 
                  				style="width:180px; height:19px"  maxLength='50'/>          
          		</td>
                <td width="20" height="30">&nbsp;</td>
              </tr>
              <tr> 
                <td width="30" height="30">&nbsp;</td>
                <td width="100" height="30">
                	<img src="/images/text_pas.gif" width="100" height="30"/>
                </td>
                <td height="30">                    
                    <input 	type="password" name="password" class="ct_input_g" 
                    				style="width:180px; height:19px"  maxLength="50" />
                </td>
                <td width="20" height="30">&nbsp;</td>
              </tr>
              <tr> 
                <td width="30" height="20">&nbsp;</td>
                <td width="100" height="20">&nbsp;</td>
                <td height="20" align="center">
   				    <table width="136" height="20" border="0" cellpadding="0" cellspacing="0">
                       <tr> 
                         <td width="56">
                         		<img src="/images/btn_login.gif" width="56" height="20" border="0"/>
                         </td>
                         <td width="10">&nbsp;</td>
                         <td width="70">
                       			<img src="/images/btn_add.gif" width="70" height="20" border="0">
                         </td>
                         <td width="10">&nbsp;</td>
                         <td width="10">
                       			<img id = "kakaologin" src="/images/kakao_login_medium.png">
                         </td>
                       </tr>
                     
                     </table>
                      <table width="136" height="20" border="0" cellpadding="0" cellspacing="0">
                       <tr> 
                         <td width="56">
                         īī������α���
                         		<img src="/images/kakaolink_btn_medium.png" width="50" height="50" border="0"/>
                         </td>
                     </table>
                 </td>
                 <td width="20" height="20">&nbsp;</td>
                </tr>
              </table>
            </td>
      	</tr>                            
      </table>
      </td>
  </tr>
</table>
</TD>
</TR>
</TABLE>

</div>

</form>

</body>

</html>