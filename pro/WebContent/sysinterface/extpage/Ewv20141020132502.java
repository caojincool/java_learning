package com.eweaver.sysinterface.extclass; 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141020132502 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
     String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
     String issave = params.getParamValueStr("issave");//是否保存 
     String isundo = params.getParamValueStr("isundo");//是否撤回 
     String formid = params.getParamValueStr("formid");//流程关联表单ID 
     String editmode = params.getParamValueStr("editmode");//编辑模式 
     String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
     String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 
     String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select rectype,orgname,nums from uf_hr_unitchange where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
	for(int s=0;s<list.size();s++){
		Map map = (Map)list.get(s);
		String rectype = StringHelper.null2String(map.get("rectype"));
		String orgname = StringHelper.null2String(map.get("orgname"));
		String nums = StringHelper.null2String(map.get("nums"));
		String upsql = "";
		if (rectype.equals("40285a8f4888284e0148985baae2007f"))
		{
			upsql = "update stationinfo set maxnum=maxnum+to_number('"+nums+"') where id='"+orgname+"'";
		} else upsql = "update stationinfo set maxnum=maxnum-to_number('"+nums+"') where id='"+orgname+"'";
		baseJdbc.update(upsql);
	}//for end
	}//if end
 } 
 }
