<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.*" %>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<html>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<head>
<%

HumresService hs=(HumresService)BaseContext.getBean("humresService");
request.setCharacterEncoding("UTF-8");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/highslide/highslide.css" />
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/highslide/highslide.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/openhrm/openhrm.js"></script>
    <script type="text/javascript">
	function getImageResult(o)
	{
		 hs.graphicsDir = '<%=request.getContextPath()%>/js/highslide/graphics/';
         hs.wrapperClassName = 'wide-border';
		hs.fadeInOut = true;
		hs.headingEval = 'this.a.title';
		var hrefimg = document.getElementById("resourceimghref").href;
		if(hrefimg.indexOf("void(0)")!=-1)
		{
			void(0);
			return false;
		}
		else
		{
			return hs.expand(o);
		}
	}

</script>
<style type="text/css">
table{
	width: 100%;
	border-collapse: separate;
	border-spacing: 1px;
	border-bottom-width:1px;
}
</style>
</head>
<body>
 <div id="mainsupports" style="position:absolute;display:none;z-index:10;width:400px">
<table width="373" height="216" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
<td rowspan="13" bgcolor="#AAAAAA">
<table width="100%" height="100%" border="0" cellpadding="0"
       cellspacing="1">
<tr>
<td bgcolor="#FFFFFF">
<table width="100%" height="210" border="0" cellpadding="0"
       cellspacing="0" style="padding-bottom:6px;">
<tr>
<td width="40%" align="center" valign="middle">
    <table width="114" height="179" border="0" align="center"
           cellpadding="0" cellspacing="0">
        <tr>
            <td height="130" align="center" valign="middle"
                 width="110px" style="padding-left:10px;"  >
                <table width="130px" height="130" border="1" align="center"
                       cellpadding="0" cellspacing="1">
                    <tr>
                        <td height="100%" align="center" valign="middle"
                            bgcolor="#FFFFFF">
                            <a id='resourceimghref' href="javascript:void(0);"
                               onclick="return getImageResult(this);" onFocus="this.blur()"> <img
                                    id='resourceimg' src="<%=request.getContextPath()%>/images/base/main.gif" border=0 width="100px"
                                    height="115">
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td height="18" style="padding-left:5px;">

                <table width="100%" border="0" cellspacing="0"
                       cellpadding="0">
                    <tr>
                        <td width="25%" class="STYLE4">
                            <div align="right">
                                <img src="<%=request.getContextPath()%>/images/application/admin/08.gif"
                                     width="16" height="16" align="absmiddle"
                                     title="<%=labelService.getLabelNameByKeyId("402883d934c1cde80134c1cde8c20000")%>"><!-- 个人信息 -->
                            </div>
                        </td>
                        <td width="81%" class="STYLE4" style="padding-left:10px;">
                            <div align="left"><!-- 个人信息 -->
                                <a id="viewHumres" href="javascript:openhrmresource();"><%=labelService.getLabelNameByKeyId("402883d934c1cde80134c1cde8c20000")%>
                                </a>
                            </div>
                        </td>
                    </tr>
                </table>


            </td>
        </tr>

        <tr>
            <td height="18" style="padding-left:5px;">
                   <%
                String sqlopenhrm="select *from emailsetinfo where isdelete=0";
                   List listopenhrm= baseJdbcDao.getJdbcTemplate().queryForList(sqlopenhrm);
                    if(listopenhrm.size()>0){
                %>
             <table width="100%" border="0" cellspacing="0"
                       cellpadding="0" style="margin-top:6px;margin-bottom:2px;">
                    <tr>
                        <td width="25%" class="STYLE4">
                            <div align="right">
                                <img src="<%=request.getContextPath()%>/images/silk/email.gif"
                                     width="16" height="16" align="absmiddle"
                                     title="<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0021")%>"><!-- 发送邮件 -->
                            </div>
                        </td>
                        <td width="81%" class="STYLE4" style="padding-left:10px;">
                            <div align="left">
                                <a href="javascript:openemail();"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0021")%><!-- 发送邮件 -->
                                </a>
                            </div>
                        </td>
                    </tr>
                </table>
                <%}%>
            </td>
        </tr>
        <tr>
            <td height="18" style="padding-left:5px;">

                <table width="100%" border="0" cellspacing="0"
                       cellpadding="0">
                    <tr>
                        <td width="25%" class="STYLE4">
                            <div align="right"></div>
                        </td>
                        <td width="81%" class="STYLE4" style="padding-left:10px;">
                        </td>
                    </tr>
                </table>


            </td>
        </tr>
           <tr>
            <td height="18" style="padding-left:5px;">

                <table width="100%" border="0" cellspacing="0"
                       cellpadding="0">
                    <tr>
                        <td width="25%" class="STYLE4">
                            <div align="right"></div>
                        </td>
                        <td width="81%" class="STYLE4" style="padding-left:10px;">
                            <div align="left"></div>
                        </td>
                    </tr>
                </table>


            </td>
        </tr>

    </table>
</td>
<td width="60%">
    <table width="100%" border="0" cellspacing="0"
           cellpadding="0" onselectstart="return false">
        <tr>
            <td height="15" colspan="2">
                <img align="right" id="closetext" style="color: #262626; cursor:hand"
                     src="<%=request.getContextPath()%>/images/silk/cross2.gif" width="15"
                     height="15" onclick="javascript:closediv();">
            </td>
        </tr>
        <tr>
            <td width="20%" height="25">
                <div align="center">
                	<div id="rtxDiv"></div>
                    <!-- <img id="isonline"
                         src="<%=request.getContextPath()%>/images/base/inline.gif" width="20"
                         height="20">
                    -->
                </div>
            </td>
            <td width="80%">
                <span class="STYLE6" id="result0"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                  <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%>:&nbsp &nbsp</span><!-- 姓名 -->
                </div>
            </td>
            <td class="simplehrmhead"
                style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
                <span class="STYLE6" id="result1"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                    <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b773ff0b0000c")%>:&nbsp &nbsp</span><!--性别  -->
                </div>
            </td>
            <td class="simplehrmhead">
                <span class="STYLE6" id="result2"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                    <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402883d934c1d2bb0134c1d2bc1c0000")%>:&nbsp &nbsp</span><!-- 手机 -->
                </div>
            </td>
            <td class="simplehrmhead"
                style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
                <span class="STYLE6" id="result3"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                    <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402883d934c1d3e30134c1d3e41f0000")%>:&nbsp &nbsp</span><!-- 电话 -->
                </div>
            </td>
            <td class="simplehrmhead"
                style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
                <span class="STYLE6" id="result4"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                    <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402883d934c1d57a0134c1d57b100000")%>:&nbsp &nbsp</span><!-- 邮件 -->
                </div>
            </td>
            <td class="simplehrmhead"
                style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
                <span class="STYLE6" id="result5"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                    <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%>:&nbsp &nbsp</span><!-- 部门 -->
                </div>
            </td>
            <td class="simplehrmhead"
                style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
                <span class="STYLE6" id="result6"></span>
            </td>
        </tr>
        <tr>
            <td class="simplehrmhead" height="25">
                <div align="right">
                    <span class="STYLE6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0022")%>:&nbsp &nbsp</span><!-- 上级 -->
                </div>
            </td>
            <td class="simplehrmhead"
                style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
                <span class="STYLE6" id="result7"></span>
            </td>
        </tr>
    </table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</div>
</body>
<script type="text/javascript">
    function getResource(objid){
    if(objid=='')
    return;
        Ext.Ajax.request({
            url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=gethrmvalue&id='+objid,
                     success: function(res) {
                    var str=res.responseText;
					var obj=Ext.decode(str);
					
					M('result0').innerHTML=obj.ip;
					M('result1').innerHTML=obj.objname;
					M('result2').innerHTML=obj.selname;
					M('result3').innerHTML=obj.tel2;
					M('result4').innerHTML=obj.tel3;
					M('result5').innerHTML=obj.email;
					M('result6').innerHTML=obj.orgid;
					M('result7').innerHTML=obj.superior;
					var attachid=obj.attachid;
					if(attachid!=''){
						M("resourceimg").src=contextPath+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+attachid+"&amp;download=1";
						M("resourceimghref").href=contextPath+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+attachid+"&amp;download=1";
					}else{
						M("resourceimg").src=contextPath+"/images/base/main.gif";
						M("resourceimghref").href="void(0)";
					}
					if(typeof(obj.logonName)=='string' && obj.logonName!=''){
						M('rtxDiv').innerHTML='';
						var img=document.createElement('img');
						M('rtxDiv').appendChild(img);
						img.width=16;img.width=16;
						img.onload=function(){RAP(''+obj.logonName);};//+obj.logonName
						img.src=contextPath+'/rtx/images/'+(obj.ip=='0'?'rtxoff.gif':'rtxon.gif');
					}else{
						var imgStr='<img src="'+contextPath+'/images/base/';
						imgStr+=(obj.ip=='0')?'outline.gif':'inline.gif';
						imgStr+='" title="'+(obj.ip=='0'?'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0023")%>':'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0024")%>')+'"/>';//离线   在线
						M('rtxDiv').innerHTML=imgStr;
					}
					if(obj.ip!='0')M("result0").innerHTML=obj.ip;
					var viewHumres = document.getElementById("viewHumres");
					viewHumres.setAttribute("href", "javascript:openhrmresource('"+obj.viewHumresUrl+"');");
					
			}
		});
	}
</script>
<!--RTX感知必须先加载一次RAP('username')函数,才能启用.-->
<%if(hs.useRTX()){
	out.write("<img align=\"absbottom\" style=\"visibility:hidden;\" width=16 height=16 src=\"/rtx/images/blank.gif\" onload=\"RAP('abdasdf');\">");
}%>
</html>

