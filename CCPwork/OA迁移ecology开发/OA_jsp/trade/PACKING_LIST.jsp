﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html> 
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*,java.text.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<head>
<style type="text/css">
<!--
.STYLE1 {
	font-family: "微软雅黑";
	font-size: 30.4px;
	font-weight: bold;
}
.STYLE2 {font-family: "微软雅黑";font-size: 20.9px;}
.STYLE3 {font-family: "微软雅黑";font-size: 13.3px;}
.STYLE6 {font-family: "微软雅黑"; font-size: 22.8px; }
.STYLE8 {
	font-family: "微软雅黑";
	font-size: 24.7px;
	font-weight: bold;
}
.STYLE11 {font-family: "微软雅黑"; font-weight: bold; font-size: 17.1px;}
body {
	margin-left: 30px;
	margin-right: 30px;
}
.STYLE13 {
	font-family: "微软雅黑";
	font-size: 20.9px;
	font-weight: bold;
}
.STYLE14 {
	font-size: 17.1px;
	font-weight: bold;
}
table tr td{line-height: 38px;}
-->
</style>
</head>
<body>
<%
//根据requestid来获取外销联络单相关数据
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String sql = "select u1.*,u2.describe describe1,u3.describe describe2,u4.pcategory,u1.cocode,u1.boxtype from uf_tr_expboxmain u1 left join uf_tr_gkwhd u2 on u1.departure = u2.requestid left join uf_tr_gkwhd u3 on u1.destport = u3.requestid left join uf_tr_prodcate u4 on u4.requestid = u1.goodsgroup where u1.requestid = '"+requestid+"'";
List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
String expno = "";
String reqdate = "";
String soldname = "";
String soldaddr = "";
String linkphone = "";
String linkfax = "";
String shipping = "";
String vessel = "";
String vesselno = "";
String departure = "";
String destport = "";
String saildate = "";
String goodsgroup = "";
String str1 = "";
String str2 = "";
String tel1 = "";
String fax1 = "";
String cocode = "";
String boxtype = "";
String cbms = "";
String stocktotal = "";
String packtotal = "";
String lotno = "";
if (list.size() > 0) {
	Map map001 = (Map) list.get(0);
	expno = StringHelper.null2String(map001.get("expno"));//出口编号
	reqdate = StringHelper.null2String(map001.get("reqdate"));//经办日期
	soldname = StringHelper.null2String(map001.get("soldname"));//售达方名称
	soldaddr = StringHelper.null2String(map001.get("soldaddr"));//售达方地址
	linkphone = StringHelper.null2String(map001.get("linkphone"));//收货人电话
	linkfax = StringHelper.null2String(map001.get("linkfax"));//收货人传真
	shipping = StringHelper.null2String(map001.get("shipping"));//shipping marks
	if ("".equals(shipping)) {
		shipping = "N/M";
	}
	vessel = StringHelper.null2String(map001.get("vessel"));//船名
	vesselno = StringHelper.null2String(map001.get("vesselno"));//航次
	departure = StringHelper.null2String(map001.get("describe1"));//起运港
	destport = StringHelper.null2String(map001.get("describe2"));//目的港
	saildate = StringHelper.null2String(map001.get("saildate"));//实际开航日
	goodsgroup = StringHelper.null2String(map001.get("pcategory"));//产品大类
	cocode = StringHelper.null2String(map001.get("cocode"));//公司代码
	boxtype = StringHelper.null2String(map001.get("boxtype"));//整箱拼箱  
	cbms = StringHelper.null2String(map001.get("cbmtotal"));//材积cbm合计
	stocktotal = StringHelper.null2String(map001.get("stocktotal"));//托盘数合计
	packtotal = StringHelper.null2String(map001.get("packtotal"));//木箱数/包数/桶数合计
	lotno = StringHelper.null2String(map001.get("lotno"));//LOTNO
	if(cocode.equals("1010")){
		str1 = "CHANG CHUN CHEMICAL (JIANGSU) CO.,LTD.";
		str2 = "Changchun Rd,Riverside Industrial Park,Changshu Econnmic Development Zone,"+"<BR>"+"Jiangsu Province,China 215537";
		tel1 = "86-512-52648000";
		fax1 = "86-512-52645556";
	}else if(cocode.equals("1030")){
		str1 = "ADEKA FINE CHEMICAL (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1020")){
		str1 = "CHANG CHUN SB (CHANGSHU)CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1050")){
		str1 = "CHANG CHUN TOK (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1060")){
		str1 = "U-PICA RESIN (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "86-512-52648000";
		fax1 = "86-512-52642268";
	}else if(cocode.equals("2010")){
		str1 = "CHANG CHUN CHEMICAL (PANJIN) CO.,LTD.";
		str2 = "LiaoBin Coastal Economic Zoon,PanJin, Liaoning Province，China P.C.:124211";
		tel1 = "86-427-6775001";
		fax1 = "86-427-6775012";
	}else if(cocode.equals("7010")){
		str1 = "DAIREN CHEMICAL (JIANGSU) CO., LTD.";
		str2 = "No.1,Dalian Road. Yangzhou Chemical Industry Park, 211900"+"<BR>"+"Yizheng,Jiangsu, China";
		tel1 = "002-86-514-83268888";
		fax1 = "002-86-514-83298833";
	}
	
}
 %>
<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object> 
<table width="100%%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="7"><input id="print" type="button" value="打印" onclick="print();" /><input id="printforview" type="button" value="打印预览" onclick="printforview();" /></td>
    <td colspan="1" align="left"><span align="center" class="STYLE3"><font style="line-height:1.5;">编号：CQCB07518MK<BR>版本：1.0</font></span></td>
  </tr>
  <tr>
    <td colspan="8" align="center"><span class="STYLE1"><%=str1 %></span></td>
  </tr>
  <tr>
    <td colspan="8" align="center"><span class="STYLE2"><%=str2 %></span></td>
  </tr>
  <tr>
    <td width="8%" align="right"><span class="STYLE6">TEL:</span></td>
    <td colspan="2" align="left"><span class="STYLE6"><%=tel1 %></span></td>
    <td colspan="2">&nbsp;</td>
    <td colspan="3" align="left"><span class="STYLE6">FAX:&nbsp;<%=fax1 %></span></td>
  </tr>  
  <!--tr>
    <td width="14%" align="right"><span class="STYLE6">TEL:</span></td>
    <td colspan="2" align="left"><span class="STYLE6"><%=tel1 %></span></td>
    <td colspan="2">&nbsp;</td>
    <td width="14%" align="right"><span class="STYLE6">FAX:</span></td>
    <td colspan="2" align="left"><span class="STYLE6"><%=fax1 %></span></td>
  </tr-->
  <tr>
    
    <td width="8%">&nbsp;</td>
    <td colspan=3 width="20%">&nbsp;</td>
    <td width="15%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
    <td width="20%">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="8" width="100px"></td>
  </tr>
  <tr>
    <!--td>&nbsp;</td>
    <td>&nbsp;</td-->
    <td colspan="8" align="center"><span class="STYLE8"><u>PACKING LIST</u> </span></td>
    <!--td>&nbsp;</td>
    <td>&nbsp;</td-->
  </tr>
  <tr>
    <td colspan="8" width="100px"></td>
  </tr>
  <tr>
    <td colspan="3" align="left"><span class="STYLE13">INVOICE NO.: </span>&nbsp;<span class="STYLE2"><%=expno %></span></td>
    <td colspan="2"></td>
    <!--td>&nbsp;</td-->
    <td colspan="3" align="right"><span class="STYLE13">DATE:</span>&nbsp;<span class="STYLE2"><%=reqdate %></span></td>
  </tr>
  <tr>
    <td colspan="4" align="left"><span class="STYLE13">CONSIGNED TO: </span> <span class="STYLE2">&nbsp;</span></td>
    <td colspan="4" align="left"><span class="STYLE13">SHIPPING MARKS&amp;NOS:</span></td>
  </tr>
  <tr>
    <td colspan="4" align="left" valign="top"><textarea class="input_txt" index="1" style="overflow-y:visible;width:600px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;"><%=soldname %>  <%=soldaddr %></textarea></td>
    <td colspan="4" align="left" valign="top"><textarea class="input_txt" index="2" style="overflow-y:visible;width:500px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;"><%=shipping %></textarea></td>
  </tr>  
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">TEL:&nbsp;</span><input class="input_txt" index="3" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=linkphone %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">FAX:</span>&nbsp;<input class="input_txt" index="4" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=linkfax %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">SHIPPED PER S.S: </span>&nbsp;<span class="STYLE2"><%=vessel %>&nbsp;&nbsp;<%=vesselno %></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">FROM:&nbsp;</span><input class="input_txt" index="5" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=departure %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">TO:</span>&nbsp;<input class="input_txt" index="6" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=destport %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">SAILING ON/ABOUT: </span>&nbsp;<span class="STYLE2"><%=saildate %></span></td>
  </tr>  
  <tr>
    <td height="27" align="left" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">NOS.</span></td>
    <td colspan="3" align="left" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">DESCRIPTION</span></td>
    <td colspan="1" align="left" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">QUANTITY</span></td>
    <td align="center" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">N.W.(KG)</span></td>
    <td align="left" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">G.W.(KG)</span></td>
    <td align="center" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">MEAST(CBM)</span></td>
  </tr>
  <tr><!-- 产品大类 -->
    <td align="left" ><span class="STYLE2"></span></td>
    <td colspan="7" align="left"><input class="input_txt" index="7" style="width:700px;border: 0px;border-bottom: 1px solid;text-align:left;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=goodsgroup %>"/> <span class="STYLE2"></span></td>
    <!--td width="8%" align="left" style="border-bottom:inset 1px #000000;"><span class="STYLE2"></span></td>
    <td width="7%" align="left" style="border-bottom:inset 1px #000000;"><span class="STYLE2"></span></td>
    <td align="center" style="border-bottom:inset 1px #000000;"><span class="STYLE2"></span></td>
    <td align="left" style="border-bottom:inset 1px #000000;"><span class="STYLE2"></span></td>
    <td align="center" style="border-bottom:inset 1px #000000;"><span class="STYLE2"></span></td-->
  </tr>
  <%
  String sql1 = "select * from uf_tr_packtype where requestid = '"+requestid+"' order by sno asc";
  List list1 = baseJdbcDao.getJdbcTemplate().queryForList(sql1);
  int traynums = 0;  
  int packsums = 0;  
  
  Double nws = 0.00;
  Double gws = 0.00;
  DecimalFormat df = new DecimalFormat("0.00");
  for(int i = 0;i < list1.size();i++){
  	Map map001 = (Map) list1.get(i);
	String trayno = StringHelper.null2String(map001.get("trayno"));//托盘号段
	String stockno = StringHelper.null2String(map001.get("stockno"));//物料号
	if(cocode.equals("1010")){
		stockno = stockno.replace("_X", "");
		stockno = stockno.replace("_Y", "");
	}
	String nw = StringHelper.null2String(map001.get("nw"));//净重
	nws += NumberHelper.string2Double(nw,0);	
	String gw = StringHelper.null2String(map001.get("gw"));//毛重
	gws += NumberHelper.string2Double(gw,0);
	String cbm = StringHelper.null2String(map001.get("cbm"));//cbm
	traynums += NumberHelper.getIntegerValue(StringHelper.null2String(map001.get("traynum"))); 	
	packsums += NumberHelper.getIntegerValue(StringHelper.null2String(map001.get("packsum")));  	
  %>
  <tr>
    <td align="left" style="border-bottom:inset 0px #000000;"><span class="STYLE2">NO.<%=i+1 %>)</span></td>
    <td colspan="3" style="border-bottom:inset 0px #000000;" align="left"><input class="input_txt" index="7" style="width:100%;border: 0px;border-bottom: 1px solid;text-align:left;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=stockno %>"/><span class="STYLE2"></span></td>
    <td width="8%" align="left" style="border-bottom:inset 0px #000000;"><span class="STYLE2"><%=nw %>&nbsp;</span></td>
    <!--td width="7%" align="left" style="border-bottom:inset 1px #000000;"><span class="STYLE2">&nbsp;</span></td-->
    <td align="center" style="border-bottom:inset 0px #000000;"><span class="STYLE2"><%=nw %></span></td>
    <td align="left" style="border-bottom:inset 0px #000000;"><span class="STYLE2"><%=gw %></span></td>
    <td align="center" style="border-bottom:inset 0px #000000;"><span class="STYLE2"><%=cbm %></span></td>
  </tr>
  <%
  }
  %>
  <tr>
    <td height="20" colspan="4" style="border-bottom:inset 1px #000000;border-top:inset 1px #000000;"><span class="STYLE2">TOTAL</span><input class="input_txt" index="7" style="width:370px;border: 0px;border-bottom: 1px solid;text-align:center;font-size:20.9px;font-family:微软雅黑;" type="text" value="<%=stocktotal %>&nbsp;&nbsp;PALLETS&nbsp;&nbsp;(&nbsp;&nbsp;<%=packtotal %>&nbsp;&nbsp;IRON DRUMS&nbsp;&nbsp;)"/>  </td>
    <td align="left" style="border-bottom:inset 1px #000000;border-top:inset 1px #000000;"><span class="STYLE2"><%=df.format(nws) %>&nbsp;</span></td>
    <!--td style="border-bottom:inset 1px #000000;"><span class="STYLE2">&nbsp;</span></td-->
    <td align="center" style="border-bottom:inset 1px #000000;border-top:inset 1px #000000;"><span class="STYLE2"><%=df.format(nws) %></span></td>
    <td align="left" style="border-bottom:inset 1px #000000;border-top:inset 1px #000000;"><span class="STYLE2"><%=df.format(gws) %></span></td>
    <td align="center" style="border-bottom:inset 1px #000000;border-top:inset 1px #000000;"><span class="STYLE2"><%=cbms %></span></td>
  </tr>
  <tr>
    <td colspan="8"><span class="STYLE13">TOTAL:</span> <input class="input_txt" index="9" style="width:700px;border: 0px;border-bottom: 1px solid;text-align:left;font-size:20.9px;font-family:微软雅黑;" type="text" value="&nbsp;&nbsp;<%=traynums %>&nbsp;&nbsp;PALLETS&nbsp;&nbsp;(&nbsp;&nbsp;<%=packsums %>&nbsp;&nbsp;IRON DRUMS&nbsp;&nbsp;)"/> </td>
  </tr>
  <%
  String voucherno = "";
  String purcherno = "";
  String sql2 = "select voucherno,purcherno from uf_tr_shipment where requestid = '"+requestid+"'";
  List list2 = baseJdbcDao.getJdbcTemplate().queryForList(sql2);
  for(int j = 0;j < list2.size();j++){
  	Map map001 = (Map) list2.get(j);
  	//整箱 40285a90497eab1501498806ac4738c4
  	if(boxtype.equals("40285a90497eab1501498806ac4738c4")){
  		voucherno = StringHelper.null2String(map001.get("voucherno"));//销售订单号
		purcherno = StringHelper.null2String(map001.get("purcherno"));//采购订单编号
		break;
  	}else{
	  	if(list2.size() - j == 1){
			voucherno += StringHelper.null2String(map001.get("voucherno"));//销售订单号
			purcherno += StringHelper.null2String(map001.get("purcherno"));//采购订单编号
	  	}else{
			voucherno += StringHelper.null2String(map001.get("voucherno")) + ",";//销售订单号
			purcherno += StringHelper.null2String(map001.get("purcherno")) + ",";//采购订单编号
	  	}
  	}
  }
   %>
  <tr>
    <td colspan="8" valign="bottom"><span class="STYLE13">SAP NO:</span>&nbsp;<textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;"><%=voucherno %></textarea><!--span class="STYLE2"><%=voucherno %></span--></td>
  </tr>
  <tr>
    <td colspan="8"><span class="STYLE13">PO NO:</span>&nbsp;<textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;"><%=purcherno %></textarea><!--span class="STYLE2"><%=purcherno %></span--></td>
  </tr>
  <tr>
    <td colspan="8"><textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;">LOT NO:&nbsp;<%=lotno %></textarea></td>
  </tr> 
  <tr>
    <td colspan="8" align="left" valign="top"><textarea class="input_txt" index="1" style="overflow-y:visible;width:100%;border: 0px;border-bottom: 1px solid;font-size:20.9px;font-family:微软雅黑;"></textarea></td>    
  </tr> 
  <tr>
    <td height="80" colspan="2" align="left" style="padding-left:50px;"><span class="STYLE7"></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left" valign="bottom"><SPAN><BR><BR><BR><BR><BR></SPAN><textarea class="input_txt" index="1" style="overflow-y:visible;width:600px;border: 0px;border-bottom: 1px solid;font-size:25px;font-family:微软雅黑;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</textarea></td>    
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4"><span class="STYLE13"><%=str1 %></span></td>
  </tr>
  <tr>
    <td height="30" colspan="8"></td>
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4" style="border-bottom:inset 2px #000000;height:60px;"></td>
  </tr>  
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4"><span class="STYLE13">(Authorized Signature)</span></td>
  </tr>
</table>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<script type="text/javascript">
var HKEY_Root,HKEY_Path,HKEY_Key; 
HKEY_Root="HKEY_CURRENT_USER"; 
HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\"; 
//设置网页打印的页眉页脚为空 
function PageSetup_Null() { 
	try { 
		var Wsh=new ActiveXObject("WScript.Shell"); 
		HKEY_Key="header"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="footer"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="margin_left";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_right";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_top";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	    HKEY_Key="margin_bottom";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	} catch(e) {} 
} 
//打印
function print(){
	hideInput();
	PageSetup_Null();
	//打印
	WebBrowser.ExecWB(6,1);
}
//打印预览
function printforview(){
	hideInput();
	PageSetup_Null();
	//打印
	WebBrowser.ExecWB(7,1);
}
//打印前先将输入框隐藏
function hideInput(){
	jQuery(".input_txt").each(function(){
		var index = jQuery(this).attr("index");
		jQuery(this).css("border","0");
		//隐藏打印按钮和打印预览按钮
		jQuery("#print").css("display","none");
		jQuery("#printforview").css("display","none");
	});
}
//修改时将输入框显示
function showInput(){
	jQuery(".input_txt").each(function(){
		var index = jQuery(this).attr("index");
		jQuery(this).css("border-bottom","1px solid");
		//jQuery("#input_txt"+index).css("display","block");
	});
}
</script>
</body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    