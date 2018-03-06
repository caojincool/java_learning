<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ taglib uri="/WEB-INF/tags/eweaver.tld" prefix="ew"%>
<%@ page import="com.eweaver.sysinterface.ds.model.*"%>
<%@ page import="com.eweaver.sysinterface.ds.service.*"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<html>  

<head>  
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  
  <script src="/js/jquery/1.6.2/jquery.min.js"/></script>
  <script src="/js/jquery/1.6.2/jq.eweaver.js"/></script>

</head> 
 <body>
		<div>
			<ew:entity 
			    fields="name,interfaceCode,configurl,description" 
			    tags="text,text,text,textarea" 
			    subject="接口类型配置" 
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=save" 
			    names="接口类型名称,接口类型编码,接口配置URL,接口类型描述"
			>
			</ew:entity>
		</div>
	</body>
	<script>
	var id = '<%=request.getParameter("id")%>';
	$(document).ready(
		function(){
		    var loadUrl = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=load';		    
		    loadFromDb(loadUrl,'id='+id);
			$('#submit').click(function(){
			    var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceMetaAction?action=save';
				saveToUrl('#EweaverForm',url,function(data){
					if(data && data.length == 32) {
					    $('#ew_id').val(data);
					    alert('保存成功');
					}
				});			
			});
		}
	);
	
	</script>
</html> 