<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.layout.ShowFlow" %>
<%@ page import="com.eweaver.workflow.stamp.model.Stampinfo" %>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.StampinfoService" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%
	
	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
	String categoryid = StringHelper.null2String(request.getParameter("categoryid")).trim();
	String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
	DataService dateService=new DataService();
	String layoutsql = "select printlayoutid from category where id ='"+categoryid+"'";
	String layoutid="";
	String printid ="";
	boolean isf = false;
	String margs = "";
	if("402865fa4945073e0149454e9ea000ae".equals(categoryid)){
		printid = dateService.getValue("select a.shipout from uf_lo_ladingmain a where a.requestid = '"+requestid+"'");
		//layoutid = "402864d24adcace4014addaa38df0007";
		dateService.executeSql("update uf_lo_ladingmain set printman='"+eweaveruser.getHumres().getId()+"',printtime=to_char(sysdate,'yyyy-MM-dd hh24:mi:ss'),printtimes=nvl(printtimes,0)+1 where requestid= '"+requestid+"'");
		//40285a904a17fd75014a18e6bd85267c运入
		//40285a904a17fd75014a18e6bd85267b运出
		layoutid = "40285a904a17fd75014a18e6bd85267b".equals(printid)?"402865fa4945073e0149455483d100b2":"402865fa4945073e014945dec19801dd";
		isf = true;
		margs = "0";
	}else if ("402864d14955f99901495670edda00b8".equals(categoryid)){
		printid = dateService.getValue("select b.billtype from uf_lo_provedoc b where requestid = '"+requestid+"'");
		dateService.executeSql("update uf_lo_provedoc set printman='"+eweaveruser.getHumres().getId()+"',printtime=to_char(sysdate,'yyyy-MM-dd hh24:mi:ss'),printnum=nvl(printnum,0)+1 where requestid= '"+requestid+"'");
		layoutid = "402864d14955f9990149560956f50005".equals(printid)?"40285a9049d58e9e0149e5a264b04c0e":"40285a9049d58e9e0149e5d0a95f4fe5";
	}else{
		layoutid=dateService.getValue(layoutsql);
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>打印</title>
    <script src='/dwr/interface/FormlayoutService.js'></script>
    <script src='/dwr/engine.js'></script>
    <script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
var topBar=null;
WeaverUtil.load(function(){
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addFill();
});
function printPrv ()
{  
	var isprint = true;
	try{
	       Ext.Ajax.request({
	    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.weight.servlet.IsPrintAction',
	    	    params: {
	    	    	action : "formbase",
	    	    	requestid : "<%=requestid%>"
	    	    },
	    	    success: function(response){  //success中用response接受后台的数据
	    	    	if('noable' == response.responseText){
	    	    		isprint = false;
	    	    		alert("打印次数已超，如要继续打印，请向管理员申请！");
	    	    		
	    	    	}
	    	    		if(isprint){
	    	    		  //var url="/workflow/request/workflowprintQ.jsp";
	    	    		  var url="/workflow/request/formbaseprintQ.jsp";
	    	    		  document.EweaverPrint.action=url;
	    	    		  document.EweaverPrint.target="printframe";
	    	    		  document.EweaverPrint.submit();
	    	    		}
	    	    }
	    	   }); 
	   }catch(e){
	   }
}
</script>
<body onload="//loadEvent()">
<div id='pagemenubar'></div>
<form action="" name="EweaverPrint"  method="post" target="">
<input type="hidden" name="opType" value="preview">
<input type="hidden" name="requestid" value="<%=requestid %>">
<input type="hidden" name="layoutid" value="<%=layoutid%>">
<input type="hidden" name="categoryid" value="<%=categoryid%>">
<TABLE style="WIDTH: 100%" cellSpacing=0 cellPadding=0 border=1>
<COLGROUP><STRONG>
<COL width="15%">
<COL width="35%">
<COL width="15%">
<COL width="35%"></COLGROUP>
<TBODY>
<TR height=25 <% if(!LabelCustomService.isEnabledMultiLanguage()){ //未启用多语言%> style="display: none;" <% } %>>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883dd3680eb50013680eb5178028e") %><!-- 字段名称显示方式 -->: </TD>
<TD class=FieldValue colspan=3><%=labelService.getLabelNameByKeyId("402883dd3680eb50013680eb51780290")%><!-- 可选的方式 -->:&nbsp;

            <select name="printType" id="printType" style="width:180">
            	<%
            		DataService ds = new DataService();
            		String sql = "select id,objname from SELECTITEM where TYPEID='402883d1366808440136685bda100047' and ISDELETE=0 order by DSPORDER";
            		List list = ds.getValues(sql);
            		for(int i=0;i<list.size();i++){
            			Map map = (Map)list.get(i);
            			String opinionid = StringHelper.null2String(map.get("id"));
            			String opinionObjname = StringHelper.null2String(map.get("objname"));
            			sql = "select labelname from LabelCustom where keyword='"+opinionid+"' and language='"+language+"'";
            			String labelCustomName = ds.getValue(sql);
            			if(!StringHelper.isEmpty(labelCustomName)){
            				opinionObjname = labelCustomName;
            			}
            	%>
            			 <option value="<%=opinionid %>" <%if(opinionid.equals("402883d1366808440136685cf8cb0048")&&language.equals("zh_CN")){%>selected="selected" <% }else if(opinionid.equals("402883d1366808440136685cf8cc0049")&&language.equals("en_US")){%>selected="selected"<%} %>><%=opinionObjname %></option>
            	 <%}%>
            </select>
 
</TD></TR>

<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001e") %><!-- 打印方向 -->: </TD>
<TD class=FieldValue><INPUT type="radio" class=InputStyle2 value="0"  name="printdirection">&nbsp;<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001f") %><!-- 横向 -->&nbsp;&nbsp;&nbsp;<INPUT type="radio" class=InputStyle2 checked value="1" name="printdirection">&nbsp;<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270020") %><!-- 纵向 --></TD>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270021") %><!-- 缩放比率 -->: </TD>
<TD class=FieldValue><select width="80%" class=InputStyle2 name="zoom">
<option value="2.0" >2.0</option>
<option value="1.5" >1.5</option>
<option value="1.4" >1.4</option>
<option value="1.3" >1.3</option>
<option value="1.2" >1.2</option>
<option value="1.1" >1.1</option>
<option value="1.0" selected>1.0</option>
<option value="0.9" <%if(isf){ %>selected<%}%>>0.9</option>
<option value="0.8" >0.8</option>
<option value="0.7" >0.7</option>
<option value="0.6" >0.6</option>
<option value="0.5" >0.5</option>
</select>
</TD></tr>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270022") %><!-- 左边距(毫米) -->: </TD>
<TD class=FieldValue><INPUT type="text" class=InputStyle2 style="WIDTH: 80%" value="<%=margs %>" name="leftsize">&nbsp;</TD>
<TD class=FieldName noWrap align=right><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280023") %><!-- 右边距(毫米) -->: </TD>
<TD class=FieldValue><INPUT type="text" class=InputStyle2 style="WIDTH: 80%" value="<%=margs %>" name="rightsize">&nbsp;</TD></TR>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9d231f0016") %><!-- 页眉 -->: </TD>
<TD class=FieldValue colspan=3><INPUT class=InputStyle2 style="WIDTH: 80%" value="" name="header">&nbsp;</TD>
</tr>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71c673ca002a") %><!-- 页脚 -->: </TD>
<TD class=FieldValue colspan=3><INPUT class=InputStyle2 style="WIDTH: 80%" value="&b&p/&P" name="footer">&nbsp;</TD>
</TR>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280024") %><!-- 显示纸张对话框 -->: </TD>
<TD class=FieldValue><INPUT class=InputStyle2  type="checkbox" value="" name="pagedialog">&nbsp;</TD></TD>
<TD vAlign=bottom><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280025") %><!-- 显示打印对话框 -->: </TD>
<TD class=FieldValue >
<P><INPUT type="checkbox" class=InputStyle2 value="" name="printdialog" checked></P></TD></TR></TBODY></TABLE>
<div style="display:none" id="repContainer">
</div>
</form>
<iframe name="printframe" id="printframe"  src="" style="display:none"></iframe>
</body>
 <script>
function loadEvent(){
	document.EweaverForm.submit();
}

function showLayoutcallback(data){
    DWRUtil.removeAllOptions("printLayout");
	var printLayout=document.forms[0].printLayout;
	var oOption = document.createElement("OPTION");
	printLayout.options.add(oOption);
	oOption.innerText ="未选择";
	oOption.value = "";
	DWRUtil.addOptions("printLayout",data,"id","layoutname");
}
</script>

</html> 

 
			