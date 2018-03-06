<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
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
<%@ page import="com.eweaver.base.keyinfo.service.KeyinfoService" %>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.stamp.service.StampinfoService" %>
<%@ page import="com.eweaver.workflow.stamp.model.Stampinfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.word.service.WordModuleService" %>
<%@ page import="com.eweaver.word.model.WordModule" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.personalSignature.service.PersonalSignatureService" %>
<%@ page import="com.eweaver.base.personalSignature.model.PersonalSignature" %>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    StampinfoService stampinfoService = (StampinfoService) BaseContext.getBean("stampinfoService");
    ImginfoService imginfoService = (ImginfoService) BaseContext.getBean("imginfoService");
    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
    DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
    WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    RequestfreeService requestfreeService = (RequestfreeService)BaseContext.getBean("requestfreeService");
	PersonalSignatureService personalSignatureService = (PersonalSignatureService)BaseContext.getBean("personalSignatureService");
    this.forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
    this.formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
    RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
    this.baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    WordModuleService wordModuleService=(WordModuleService)BaseContext.getBean("wordModuleService");
    Setitem gmode=setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
    String graphmode ="0";
    String stampinfoid="";
   	boolean ismovestamp=false;
    boolean isstamp=false;
    List listmove=new ArrayList();
    if(gmode!=null&&!StringHelper.isEmpty(gmode.getItemvalue())){
       graphmode=gmode.getItemvalue();
    }
	WorkflowService ws = (WorkflowService)BaseContext.getBean("workflowService");
    ws.setIsNotify(false);
    KeyinfoService keyinfoService = (KeyinfoService)BaseContext.getBean("keyinfoService");
    FormService fs = (FormService)BaseContext.getBean("formService");
    RequestlogService logService = (RequestlogService)BaseContext.getBean("requestlogService");
    RequestbaseService requestbaseService = (RequestbaseService)BaseContext.getBean("requestbaseService");
    PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
    String tabStr="";
   
    //工作流的所有参数列表
	Map workflowparameters = new HashMap();
 
    String imgaction="/ServiceAction/com.eweaver.workflow.stamp.servlet.StampAction?action=getimags&userid="+eweaveruser.getId()+"";
	String workflowid = StringHelper.null2String(request.getParameter("workflowid")).trim();
	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
	String nodeid = StringHelper.null2String(request.getParameter("nodeid")).trim();
	String tabId = StringHelper.null2String(request.getParameter("tabId")).trim();
	if(StringHelper.isEmpty(tabId))tabId=(!StringHelper.isEmpty(requestid))?requestid:workflowid;
	String action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestlogAction?action=getrelog&requestid="+requestid;
	if(StringHelper.isEmpty(nodeid))	nodeid = requestbaseService.getNodeid(requestid);
	String curnodeids="";
	if(!StringHelper.isEmpty(requestid))
	{
		List nodelist = logService.getCurrentNodeIds(requestid);
		curnodeids=StringHelper.ArrayList2String((ArrayList)nodelist,",");
	}
	String undousers = logService.getOperatorList0Str(nodeid,requestid,null);
	boolean docPermission = undousers.contains(currentuser.getId());//当前未操作用户需要添加权限
	workflowparameters.put("docPermission",docPermission);
	String sql2="update notifyreceiverlink set readed=1 where objid='"+requestid+"' and humresid='"+eweaveruser.getId()+"'";
	this.baseJdbcDao.getJdbcTemplate().execute(sql2);//对未查看提醒的去除提醒标记
	
	//去除流程反馈标记
	sql2 = "update requestoperatormark set feedback='0' where requestid='"+requestid+"' and userid='"+eweaveruser.getId()+"'";
	baseJdbcDao.getJdbcTemplate().execute(sql2);
	
	if(StringHelper.null2String(request.getParameter("from")).trim().equals("report")){
       if(ws.getRequestbaseDao().getRequestbase(requestid)==null){
                  request.getRequestDispatcher("/workflow/request/formbase.jsp").forward(request,response);
                  return;
       }
       if(ws.getRequestbaseDao().getRequestbase(requestid).getId()==null){
                  request.getRequestDispatcher("/workflow/request/formbase.jsp").forward(request,response);
                  return;
    }
    }
	String isapprove = StringHelper.null2String(request.getParameter("isapprove"));

    workflowparameters.put("workflowid", workflowid);
    workflowparameters.put("requestid", requestid);
    workflowparameters.put("nodeid", nodeid);
    workflowparameters.put("requesthost", " http://" + StringHelper.getRequestHost(request));
    workflowparameters.put("contextpath", request.getContextPath());
	String msg = StringHelper.null2String(request.getParameter("msg")).trim();
	String targeturl = StringHelper.null2String(request.getParameter("targeturl")).trim();
	String bNewworkflow = "1"; //是否新建工作流

	if(!StringHelper.isEmpty(requestid)){
		bNewworkflow = "0";
	}
	workflowparameters.put("bNewworkflow",bNewworkflow);
	//处理权限
	//是否督办
	boolean issupervise = permissiondetailService.checkOpttype(requestid,7);
	if(bNewworkflow.equals("0")){
		boolean isauth = permissiondetailService.checkOpttype(requestid,3);
		if(!isauth){
            List list = baseJdbcDao.executeSqlForList("select * from requestoperators where requestid='"+requestid+"' and userid='"+currentuser.getId()+"'");
            if(list.size()==0){
				if(!issupervise){
                	response.sendRedirect("/nopermit.jsp");
                	return;
            	}
           	}
		}
	}

	Requestbase requestbase = null;
	if(!StringHelper.isEmpty(requestid)){
		requestbase = requestbaseService.getRequestbaseById(requestid);
		if(requestbase.getIsdelete().intValue()==1){
			response.sendRedirect("/nodata.jsp");
			return;
		}
	}

	//处理输入参数
	Map initparameters = new HashMap();
	for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
		String pName = e.nextElement().toString().trim();
		String pValue = StringHelper.trimToNull(request.getParameter(pName));
		if(!StringHelper.isEmpty(pName))
			initparameters.put(pName,pValue);
	}

	workflowparameters.put("initparameters",initparameters);
	//处理输入参数完成

	String viewmode = StringHelper.null2String(request.getParameter("viewmode"));
	if(StringHelper.isEmpty(viewmode))
		viewmode = "0";

	String editmode = StringHelper.null2String(request.getParameter("editmode"));
	if(StringHelper.isEmpty(editmode))
		editmode = "0";

	boolean canreject = false;
	String rejectid = "";



	workflowparameters = ws.WorkflowView(workflowparameters);
	int optlevel = NumberHelper.string2Int(StringHelper.null2String(workflowparameters.get("optlevel")),0);

	Nodeinfo nodeinfo = (Nodeinfo)workflowparameters.get("nodeinfo");
	Workflowinfo workflowinfo = (Workflowinfo)workflowparameters.get("workflowinfo");
    if(workflowinfo.getIsactive()==0){
        out.println(labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0075"));//此流程已停用或正在维护
        return;}
	String formid=workflowinfo.getFormid();
    String stampfield=nodeinfo.getStampfield();//盖章位置的字段
	//是否公文流程
	boolean isDocFlow=StringHelper.null2String(workflowinfo.getIsDoc()).equalsIgnoreCase("1");
	String docTemplate="";
	boolean isDocEdit=false;
	boolean isDocVestige=false;
	if(isDocFlow){
		docTemplate=StringHelper.null2String(workflowinfo.getDocTemplate());
		if(!StringHelper.isEmpty(docTemplate)){
			WordModule wm=wordModuleService.getWordModule(docTemplate);
			docTemplate=StringHelper.null2String(wm.getAttachid());
		}//end.if
		isDocVestige=StringHelper.null2String(nodeinfo.getIsDocVestige()).equalsIgnoreCase("1");
	}
	//节点属性为自由流转或者为生成的自由流转节点
	String nodeAttrFree = StringHelper.null2String(nodeinfo.getIsfree());
	boolean nodeIsFree = requestfreeService.isFreeNode(nodeinfo.getId());
	boolean canfree = "1".equals(nodeAttrFree) || nodeIsFree ? true : false;
	
	String savebuttonname = StringHelper.null2String(nodeinfo.getSavebuttonname());
	String submitbuttonname = StringHelper.null2String(nodeinfo.getSubmitbuttonname());
	Integer ynawoke = nodeinfo.getYnawoke();
	String awokeinfo = StringHelper.null2String(nodeinfo.getAwokeinfo());
	int bAwoke = 0;
	if(StringHelper.isEmpty(submitbuttonname))
		submitbuttonname = labelService.getLabelName("提交");
	if(StringHelper.isEmpty(savebuttonname))
		savebuttonname = labelService.getLabelName("保存");
	if(StringHelper.isEmpty(awokeinfo))
		awokeinfo = labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0048");//您确定要提交吗？
	if(	ynawoke !=null && ynawoke.intValue()==1)
		bAwoke = 1;
	Requestbase wb = (Requestbase)workflowparameters.get("requestbase");
	//处理创建权限
	nodeid = StringHelper.null2String(workflowparameters.get("nodeid"));
	workflowid = StringHelper.null2String(workflowparameters.get("workflowid"));
	if(bNewworkflow.equals("1")){
		boolean isauth = permissiondetailService.checkOpttype(nodeid,2);
		if(!isauth){
			response.sendRedirect("/nopermit.jsp");
			return;
		}
	}
	if(optlevel == 2 && StringHelper.null2String(nodeinfo.getIsreject()).equals("1")){
		canreject = true;
		rejectid = StringHelper.null2String(nodeinfo.getRejectnode());
	}
	List rejectnodelist = (List)workflowparameters.get("rejectnodelist");
	String requestname = StringHelper.null2String(wb.getRequestname());
	String requestlevel = StringHelper.null2String(wb.getRequestlevel());
	if(optlevel==0){
		requestname = StringHelper.null2String(workflowinfo.getDeftitle());
		requestlevel = "402881eb0c42cba0010c42ff38860008";
	}
	//新建文档的ｔａｒｇｅｔｕｒｌ
	String targeturlfordoc = "/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addrefdoc&docid=";
	//流程结束后处理权限
	int isfinished = 0;
	if(wb.getIsfinished()!=null){
		isfinished = wb.getIsfinished().intValue();
	}
	//to do...
	int righttype = 0;
	String objid = requestid;
	String objtable = "requestbase";
	if (!StringHelper.isEmpty(objid) && !StringHelper.isEmpty(objtable)) {
		righttype = permissiondetailService.getOpttype(objid);
	}
	int canundo = 0;
	if(optlevel==1 && isfinished != 1 && !nodeIsFree){
		String canundoworkflow = StringHelper.null2String(workflowparameters.get("canundoworkflow"));
		if(canundoworkflow.equals("1"))
			canundo = 1;
		if(canundoworkflow.equals("2"))
			canundo = 2;
		if(canundoworkflow.equals("3"))
			canundo = 3;
	}
	int canedit = 0;
	if(isfinished==1 &&  righttype%15 == 0){
		canedit = 1;
	}
	workflowparameters.put("bviewmode","2");
	if((optlevel == 1 || isfinished !=0) && (canedit!=1 || !editmode.equals("1")) ){
		workflowparameters.put("bviewmode","1");
	}
	if(editmode.equals("1") ){
		workflowparameters.put("editmode","1");
	}
	String bView = "0";
	String divsumH = "150";
	boolean bNotify = ws.isNotify(requestid,currentuser.getId(),nodeid);
    if(bNotify)
    optlevel=2;
    if(optlevel==1 || isfinished==1){
		bView = "1";
		divsumH = "30";
	}
	if(viewmode.equals("1"))
		divsumH = "30";

	if(editmode.equals("1")&&canedit==1){
		bView = "0";
		divsumH = "150";
	}
	if(bNotify && optlevel == 2 && isfinished ==0){
		bView = "1";
		canreject = false;
	}
	workflowparameters.put("bView",bView);
	workflowparameters.put("bWorkflowform","1");
	//流程节点调用布局，以后要修改
/***
	if(workflowid.equals("402880302c7746da012c77bd799b020c")&&nodeid.equals("402880302c77c978012c77d4153e0004")){
		workflowparameters.remove("bView");
		workflowparameters.put("bView","0");
		workflowparameters.remove("bviewmode");
		workflowparameters.put("bviewmode","2");
		workflowparameters.put("issalewf","1");
	}
****/
	workflowparameters = fs.WorkflowView(workflowparameters);
	String layoutid = StringHelper.null2String(workflowparameters.get("layoutid"));
	String curnodeid = StringHelper.null2String(workflowparameters.get("curnodeid"));
	String needcheckfields = StringHelper.null2String(workflowparameters.get("needcheck"));
	String formcontent = StringHelper.null2String(workflowparameters.get("formcontent"));
	String fieldcalscript = StringHelper.null2String(workflowparameters.get("fieldcalscript"));
    String triggercalscript=StringHelper.null2String(workflowparameters.get("triggercalscript"));
    String onaddrowscript = StringHelper.null2String(workflowparameters.get("onaddrowscript"));
    String resetdetailformtablescript = StringHelper.null2String(workflowparameters.get("resetdetailformtablescript"));
    String ufscript=StringHelper.null2String(workflowparameters.get("ufscript"));
    String directscript=StringHelper.null2String(workflowparameters.get("directscript"));
    //依次逐个会签检测
    Requeststep requeststep = (Requeststep)workflowparameters.get("currentrequeststep");
     if(requeststep!=null&&!StringHelper.isEmpty(requeststep.getId())){
    Nodeinfo node = nodeinfoService.get(curnodeid);
    if(node!=null&&node.getId()!=null&&node.getNodetype()!=1){
        List listobj = baseJdbcDao.executeSqlForList("select * from requeststatus where curstepid='"+requeststep.getId()+"'");
        if(listobj.size()==0&&optlevel != 1 && isfinished ==0){
            optlevel = 1;
        }
    }  }
	List nodeinfolist = nodeinfoService.getNodelistByworkflowid(nodeinfo.getWorkflowid());
	Iterator nodeinfolistit = nodeinfolist.iterator();
	String docbaseid="";
	String wordmodulefield="";
	String attachid="";
	String headname ="";
	boolean isRedHead=StringHelper.null2String(nodeinfo.getWorddochead()).equalsIgnoreCase("1");
	if(isRedHead){
		attachid=StringHelper.null2String(nodeinfo.getWordmoduleid());//wordmoduleid
	}
	Setitem setitemForward=setitemService.getSetitem("402888534deft8d001besxe952edgy17");
	String canForward = setitemForward.getItemvalue();
	String docexclusionMsg="";
	if(optlevel != 1 && isfinished ==0) {
		if(!bNotify){
			if(!"40288148118236b1011182b9cad0057d".equals(workflowinfo.getId())){
				pagemenustr += "addBtn(tb,'"+submitbuttonname+"','S','accept',function(){onSubmit(0),id='submit0'});";
			   // if(!StringHelper.isEmpty(requestid)){//
				String isshow = StringHelper.null2String(nodeinfo.getIsShowFeedback());
			   if(!StringHelper.isEmpty(isshow)&&nodeinfo.getIsShowFeedback()==1){
				   pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0076")+"','T','accept',function(){document.getElementById('isfeedback').value=1,onSubmit(0),id='submit0'});";//提交并反馈
			   }
           // }
	//            pagemenustr += "addBtn(tb,'"+labelService.getLabelName("提交并反馈")+"','S','accept',function(){onSubmit(9)});";
            
			if(isDocFlow){
			 	isDocEdit=StringHelper.null2String(nodeinfo.getDocCanEdit()).equalsIgnoreCase("1");
				//独占
				DocexclusionService docexclusionService = (DocexclusionService)BaseContext.getBean("docexclusionService");
				if(isDocEdit&&!bNewworkflow.equals("1"))
				{
					Docexclusion docexclusion=docexclusionService.getDocexclusion(requestid);
					//设置为打开
					if(docexclusion==null||docexclusion.getId()==null)
					{
						docexclusion= new Docexclusion();
						//docexclusion.setId(requestid);
						docexclusion.setObjid(requestid);
						docexclusion.setUserid(currentuser.getId());
						docexclusion.setOpentime(DateHelper.getCurDateTime());
						docexclusion.setOpenstatus(Integer.valueOf(1));
						docexclusionService.getDocexclusionDao().save(docexclusion);
					}
					else
					{
				
						String docexclusionid=docexclusion.getId();
						if(docexclusion.getOpenstatus().equals(Integer.valueOf(1))&&!docexclusion.getUserid().equals(currentuser.getId()))
						{
							boolean bool=true;
							/*Vector humresList=BaseContext.getOnlineuserids();
							  for (int i=0;i<humresList.size();i++){
								String  uid = (String)humresList.get(i);
								if(uid.equals(docexclusion.getUserid()))
								{
									bool=false;
									break;
								}
							  }*/
							String currusers = logService.getOperatorList0Str(nodeinfo.getId(),requestid,null);
							/*for(int k=0,sizek=curruserslist.size();k<sizek;k++)
							{
								Map mk =(Map)curruserslist.get(k);
								currusers=currusers+StringHelper.null2String(mk.get("id"));
								
							}*/
							if(currusers.indexOf(docexclusion.getUserid())<0)
							{
								docexclusion.setId(docexclusionid);
								docexclusion.setOpenstatus(Integer.valueOf(0));
								docexclusionService.getDocexclusionDao().save(docexclusion);
								bool=false;	
							}
							if(bool)
							{
								HumresService humresService=(HumresService) BaseContext.getBean("humresService");
								docexclusionMsg="alert('正文正在被用户["+humresService.getHumresById(docexclusion.getUserid()).getObjname()+" "+docexclusion.getOpentime()+"]编辑中，您只能查看！');";
								//文档设为不可编辑
								isDocEdit=false;
							}
							else
							{
								docexclusion.setId(docexclusionid);
								docexclusion.setUserid(currentuser.getId());
								docexclusion.setOpentime(DateHelper.getCurDateTime());
								docexclusion.setOpenstatus(Integer.valueOf(1));
								docexclusionService.getDocexclusionDao().save(docexclusion);
							
							}

						}
						else
						{
							docexclusion.setId(docexclusionid);
							docexclusion.setUserid(currentuser.getId());
							docexclusion.setOpentime(DateHelper.getCurDateTime());
							docexclusion.setOpenstatus(Integer.valueOf(1));
							docexclusionService.getDocexclusionDao().save(docexclusion);
						}
					}
				}
			}
		}
        pagemenustr += "addBtn(tb,'"+savebuttonname+"','C','disk',function(){javascript:onSubmit(1)});";
	}

	if(!bNotify||"1".equals(canForward) && !nodeIsFree){
		if(nodeinfo.getNodetype() != 1||bView.equals("1")){
			if(nodeinfo.getIsforward().intValue()==1){
			pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("此节点添加知会人")+">"+labelService.getLabelName("转发")+"</span>','R','arrow_branch',function(){_addPerson(1)});";
			}

			if("1".equals(nodeinfo.getIstemporary())){
				if(!StringHelper.isEmpty(nodeinfo.getIstemporarytext())){
					pagemenustr +=  "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("此节点添加会签人")+">"+StringHelper.null2String(nodeinfo.getIstemporarytext())+"</span>','H','arrow_join',function(){_addPerson(3)});";
				}else{
					pagemenustr +=  "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("此节点添加会签人")+">"+labelService.getLabelName("添加会签人")+"</span>','H','arrow_join',function(){_addPerson(3)});";
				}
			}
			if("1".equals(nodeinfo.getIstemporary2())){
				if (!StringHelper.isEmpty(nodeinfo.getIstemporarytext2())) {
					pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("此节点添加不会签的人")+">"+StringHelper.null2String(nodeinfo.getIstemporarytext2())+"</span>','F','arrow_switch',function(){_addPerson(2)});";
				} else {
					pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("此节点添加不会签的人")+">"+labelService.getLabelName("添加非会签人")+"</span>','F','arrow_switch',function(){_addPerson(2)});";

				}
			}

		}
		if(nodeinfo.getNodetype() != 1||bView.equals("1")) {
			 if("1".equals(nodeinfo.getIstemporary3())){
				 if(!StringHelper.isEmpty(nodeinfo.getIstemporarytext3())){
					 pagemenustr +="addBtn(tb,'<span ext:qtip="+labelService.getLabelName("把自己的操作权给别人 自己不再是节点操作者")+">"+StringHelper.null2String(nodeinfo.getIstemporarytext3())+"</span>','T','arrow_ew',function(){_addPerson(4)});";

				 }else{
					 pagemenustr +="addBtn(tb,'<span ext:qtip="+labelService.getLabelName("把自己的操作权给别人 自己不再是节点操作者")+">"+labelService.getLabelName("移交")+"</span>','T','arrow_ew',function(){_addPerson(4)});";

				 }
			 }
		}

    }
	if(canfree && StringHelper.isID(requestid)){
		pagemenustr += "addBtn(tb,'"+labelService.getLabelName("自由流转")+"','F','accept',function(){onFree()});";
	}
}else{
    Setitem setitemHForward=setitemService.getSetitem("402888534deft8d001besxe952edgy18");
    String canHForward = setitemHForward.getItemvalue();
    String sql = "select stepid from requestlog where requestid = '"+requestid+"' and operator = '"+currentuser.getId()+"' and logtype<>'C13F7456ADD44158A810A54233C69461' ";
    List<Map> requestlogList =baseJdbcDao.executeSqlForList(sql);
    if((requestlogList.size()!=0&&"1".equals(canHForward))||(bNotify&&"1".equals(canForward))){
        if(nodeinfo.getIsforward().intValue()==1){
        pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("此节点添加知会人")+">"+labelService.getLabelName("转发")+"</span>','R','arrow_branch',function(){_addPerson(1)});";
        }
    }
}
if(canreject) {
	pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("把别人提交的流程退回去")+">"+labelService.getLabelName("退回")+"</span>','B','arrow_redo',function(){onReject();if(tabPanel)tabPanel.setActiveTab(0);});";
}
if(canedit==1 && !editmode.equals("1")){
		pagemenustr +="addBtn(tb,'"+labelService.getLabelName("编辑")+"','E','script_edit',function(){location.href='/workflow/request/workflow.jsp?requestid="+requestid+"&viewmode="+viewmode+"&editmode=1'});";
}

if(optlevel != 1&&bNotify){
		String hsql = "select * from Requeststep a , Requestoperators b where a.id = b.stepid "
				+ " and b.userid = '"
				+ currentuser.getId()
				+ "' and a.requestid = '"
				+ requestid
				+ "' and b.issubmit!=1 order by b.operatelevel";
		List<Map> rlist = baseJdbcDao.executeSqlForList(hsql);
    if(rlist.size()!=0){
	    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("提交")+"','S','accept',function(){onSubmit()});";
    }
}
if(canedit==1 && editmode.equals("1")){
	pagemenustr += "addBtn(tb,'"+labelService.getLabelName("提交")+"','S','accept',function(){onSubmit(2)});";
}

//如果有督办权限就有提交按钮
if(issupervise){
	pagemenustr += "addBtn(tb,'"+labelService.getLabelName("FB445239E75A44339AD1433D1048EA93")+"','S','accept',function(){onSubmit(6)});";
}

if(!bNotify&&canundo==1){
	pagemenustr +="addBtn(tb,'<span ext:qtip="+labelService.getLabelNameByKeyId("40288035248eb3e801248eb53be60003")+">"+labelService.getLabelNameByKeyId("4028690a0f60fbe6010f6124fcb40041")+"</span>','U','arrow_undo',function(){onSubmit(3)});";
} else if(!bNotify&&canundo==2){
	pagemenustr +="addBtn(tb,'<span ext:qtip="+labelService.getLabelNameByKeyId("402883f635850b880135850b887f0019")+">"+labelService.getLabelNameByKeyId("4028690a0f60fbe6010f6124fcb40041")+"</span>','U','arrow_undo',function(){onSubmit(4)});";
} else if(!bNotify&&canundo==3){
	pagemenustr +="addBtn(tb,'<span ext:qtip="+labelService.getLabelNameByKeyId("402883f635850b880135850b887f001a")+">"+labelService.getLabelNameByKeyId("402883f635850b880135850b887f001b")+"</span>','U','arrow_undo',function(){onSubmit(5)});";
}
if(isfinished ==1 && !editmode.equals("1") && righttype%165 == 0 &&!StringHelper.isEmpty(objid) && !StringHelper.isEmpty(objtable)){
   if(nodeinfo.getSharepmethod().intValue()==0){
	   tabStr +="addTab(contentPanel,'/base/security/addpermission.jsp?objtable="+objtable+"&istype=0&objid="+objid+"','"+labelService.getLabelNameByKeyId("402881ed0c29ccef010c2a9592ac0019")+"','script_key');";

   }else{
	   pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ed0c29ccef010c2a9592ac0019")+"','D','script_key',function(){top.leftFrame.onUrl('/base/security/addpermission.jsp?objtable="+objtable+"&istype=0&objid="+objid+"','"+labelService.getLabelNameByKeyId("402881ed0c29ccef010c2a9592ac0019")+"','tab"+nodeinfo.getId()+"')});";

   }
}
if(isfinished ==1 && !editmode.equals("1") &&!StringHelper.isEmpty(objid) && !StringHelper.isEmpty(objtable) ){
      if(nodeinfo.getPlistmethod().intValue()==0){
          tabStr += "addTab(contentPanel,'/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable="+objtable+"&objid="+objid+"','"+labelService.getLabelName("权限列表")+"','script_go');";
      }else{
          pagemenustr +="addBtn(tb,'"+labelService.getLabelName("权限列表")+"','L','script_go',function(){top.leftFrame.onUrl('/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable="+objtable+"&objid="+objid+"','"+labelService.getLabelName("权限列表")+"','tab"+nodeinfo.getId()+"')});";

      }

}
if((isfinished ==1 && !editmode.equals("1") && righttype%105 == 0)||(nodeinfo.getNodetype() == 1&&!bNewworkflow.equals("1")&&bView.equals("0")&&optlevel == 2)){
	pagemenustr += "addBtn(tb,'"+labelService.getLabelName("删除")+"','D','delete',function(){onDelete();});";
}
if(optlevel==1){
	//pagemenustr +="addBtn(tb,'"+labelService.getLabelName("切换视图")+"','V','table_multiple',function(){location.href='"+request.getContextPath()+"/workflow/request/workflow.jsp?requestid="+requestid+"&viewmode="+(viewmode.equals("1")?"0":"1")+"'});";
}
if(!viewmode.equals("1")){
    if(nodeinfo.getFlowchartmethod().intValue()==1){  //流程图按钮
    if(graphmode.equals("0")){
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("流程图")+"','F','application_view_icons',function(){top.leftFrame.onUrl('/workflow/request/workflowchart.jsp?workflowid="+workflowid+"&requestid="+requestid+"','"+labelService.getLabelName("流程图")+"','tab"+nodeinfo.getId()+"')});";
    }else{
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("流程图")+"','F','application_view_icons',function(){top.leftFrame.onUrl('/wfdesigner/viewers/graphviewer.jsp?workflowid="+workflowid+"&requestid="+requestid+"','"+labelService.getLabelName("流程图")+"','tab"+nodeinfo.getId()+"')});";

    }
    }else if(nodeinfo.getFlowchartmethod().intValue()==0){    ////流程图tab页
       if(graphmode.equals("0")){
        tabStr += "addTab(contentPanel,'/workflow/request/workflowchart.jsp?workflowid="+workflowid+"&requestid="+requestid+"','"+labelService.getLabelName("流程图")+"','application_view_icons');";
    }else{
        tabStr += "addTab(contentPanel,'/wfdesigner/viewers/graphviewer.jsp?workflowid="+workflowid+"&requestid="+requestid+"','"+labelService.getLabelName("流程图")+"','application_view_icons');";

    }
    }
}
if(!viewmode.equals("1")&&optlevel != 0){ //流程流转按钮
    if(nodeinfo.getPflowmethod().intValue()==1){
        pagemenustr += "addBtn(tb,'"+labelService.getLabelName("流程流转")+"','F','application_xp',function(){top.leftFrame.onUrl('/workflow/request/pflowdisplay.jsp?requestid="+requestid+"','"+labelService.getLabelName("流程流转")+"','tab"+nodeinfo.getId()+"')});";

    }else if(nodeinfo.getPflowmethod().intValue()==0){
        tabStr += "addTab(contentPanel,'/workflow/request/pflowdisplay.jsp?requestid="+requestid+"','"+labelService.getLabelName("流程流转")+"','application_xp');";

    }
 }

if((optlevel != 1 && isfinished ==0&&!bNotify&&!bNewworkflow.equals("1"))||(canedit==1 && editmode.equals("1"))) {
	if(nodeinfo.getImportDetail().intValue()==1){
		pagemenustr += "addBtn(tb,'"+labelService.getLabelName("导入明细")+"','E','application_xp',function(){importDetail('"+requestid+"','"+workflowid+"','"+layoutid+"')});";

	}else if(nodeinfo.getImportDetail().intValue()==0){
		tabStr += "addTab(contentPanel,'/workflow/form/exportdrecordbyexcel.jsp?requestid="+requestid+"&workflowid="+workflowid+"&layoutid="+layoutid+"','"+labelService.getLabelName("导入明细")+"','script_go');";
	}
}

if(requestid.length()!=0){
	if(nodeinfo.getIsprint()!=null && nodeinfo.getIsprint().equals(1)){
		pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("点击打印按钮后会先跳转到打印设置页面，用户选择打印布局后，才转到真正的打印页")+">"+labelService.getLabelName("打印")+"</span>','P','printer',function(){onUrl('/workflow/request/workflowprintpre.jsp?requestid="+requestid+"&nodeid="+nodeid+"','打印','tab402881eb0bcd354e010bcdc91c700028') });";
		//pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("快速打印是程序取代了用户选择打印布局的步骤，默认选择一个打印布局,直接跳到打印页")+">"+labelService.getLabelName("快速打印")+"</span>','Q','printer',function(){quickPrint()});";
	}
	Forminfo forminfo=this.forminfoService.getForminfoById(formid);
	paravaluehm.put("tableName",forminfo.getObjtablename());
	paravaluehm.put("{id}",requestid);
	paravaluehm.put("{typeid}",nodeid);
}

if(requestid.length()!=0){
	if(nodeinfo.getIsexcelexp()!=null && nodeinfo.getIsexcelexp().equals(1)){
		pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("仅仅只能导出这个布局中的数据信息")+">"+labelService.getLabelName("EXCEL导出")+"</span>','E','excelexp',function(){onExcelExp();});";
	}
}
//****************************流转公文下载菜单(start)*****************************//
//****************************流转公文下载菜单(end)*****************************//
String _users = "4028814811785b8a01117888b7400053,40287e8e11fbe7b30111fc03f06600bc,402881481178227e011178338fc10010,40288148118236b1011182cd5a62063f";
String orgid0 = "";
String curdate0 = "";
DataService dataService = new DataService();
if ("40288148118d1c9301119163c0e22158".equals(workflowinfo.getId()) && ("40287e8e1236a4210112395c6f892081".equals(nodeid) || _users.contains(currentuser.getId()))) {
	String notdeletesql = "  and not exists(select 'X' from requestbase w where a.requestid=w.id and w.isdelete=1)";
	String mailsql = "select top 1 * from ufi6f7a61174303719625 a where a.requestid = '" + requestid + "' " + notdeletesql + " order by id desc";
   Map mailmap = (Map) dataService.getValuesForMap(mailsql);
	orgid0 = StringHelper.null2String(mailmap.get("field001"));
	curdate0 = StringHelper.null2String(mailmap.get("field002"));
	tabStr += "addTab(contentPanel,'/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=4028488213048b28011305de50104af9&@time="+curdate0+"&@companyid="+orgid0+"','"+labelService.getLabelName("报表信息")+"','application_xp');";

}
//校验是否可以催办此流程
if(requestid.length()>0&&nodeinfoService.checkHasten(requestid)){
	pagemenustr += "addBtn(tb,'<span ext:qtip="+labelService.getLabelName("A0A4AF4A96EC44B797349141351FBE26")+">"+labelService.getLabelName("33E4BECD81804740996795483D473EEB")+"</span>','E','excelexp',function(){onHasten();});";
}
if("40288148118d1c9301119163c0e22158".equals(workflowinfo.getId())&&("40287e8e1236a4210112395c6f892081".equals(nodeid)||_users.contains(currentuser.getId()))){
	viewmode = "0";
}
PagemenuService _pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");
if(pagemenuorder.equals("0")) {
    ArrayList<String> menuList=_pagemenuService.getPagemenuStrExt(nodeid,paravaluehm);
	pagemenustr = menuList.get(0) + pagemenustr;
    tabStr+=menuList.get(1);
}else{
    ArrayList<String> menuList=_pagemenuService.getPagemenuStrExt(nodeid,paravaluehm);
	pagemenustr = pagemenustr + menuList.get(0);
    tabStr+=menuList.get(1);
}
if(!StringHelper.isEmpty(layoutid)){
	paravaluehm.put("{id}",requestid);
	paravaluehm.put("{typeid}",layoutid);
	ArrayList<String> menuList=_pagemenuService.getPagemenuStrExt(layoutid,paravaluehm);
	pagemenustr += menuList.get(0);
	tabStr += menuList.get(1);
}
if (!StringHelper.isEmpty(workflowid)) {
	paravaluehm.put("{workflowid}",workflowid);
	ArrayList<String> menuList = _pagemenuService.getPagemenuStrExt(workflowid, paravaluehm);
	pagemenustr += menuList.get(0);
	tabStr += menuList.get(1);
}
String sqlmove="from Stampinfo where requestid='"+requestid+"' and nodeid='"+nodeid+"'";
listmove=stampinfoService.getStampinfos(sqlmove);
//String pagemenubarstr = _pagemenuService.getPagemenuBarstr(pagemenustr);
//pagemenubarstr=pagemenubarstr.replace("\\\"","\"") ;
%>
<html>
<head>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/WorkflowService.js'></script>
<script src='/dwr/interface/WordModuleService.js'></script>
<script src='/dwr/interface/RequestlogService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script  type='text/javascript' src='/js/workflow.js'></script>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<script type="text/javascript" src="/js/ext/examples/grid/RowExpander.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/chooser/chooser.js"></script>
<script language="JavaScript" src="/chart/bindows_gauges/bindows_gauges.js"></script>
<script language="JavaScript" src="/chart/fusionchart/FusionCharts.js"></script>
<link rel="stylesheet" type="text/css" href="/js/chooser/chooser.css"/>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/aop.pack.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" src="/js/table.js"></script>
<style>
	.x-panel-btns-ct {
	  padding: 0px;
	}
	.x-panel-btns-ct table {width:0}
	#pagemenubar table {width:0}
	.x-toolbar table {width:0}
	.x-grid3-row-body{white-space:normal;}
	.x-layout-collapsed{
	z-index:20;
	border-bottom:#98c0f4 0px solid  ;
	position:absolute;
	border-left:#98c0f4 0px solid;
	overflow:hidden;
	border-top:#98c0f4 0px solid;
	border-right:#98c0f4 0px solid
}
</style>
<script type="text/javascript">
var caldelay=200;
var needformatted = true;
var imgid;
var stampx;
var stampy;
Ext.SSL_SECURE_URL='about:blank';
var myMask;
//refresh message reminder tab
Ext.grid.RowExpander.override({expandAll:function(){
	var g = this.grid;
	var exp = this;
	g.getStore().each(function(rec) {

	var rowIndex = g.getStore().indexOfId(rec.id) ;
	var row = g.view.getRow(rowIndex);
	//if (rec.get('message') != '')
		exp.toggleRow(row);
	})
}});
var dlg0;
var daliog0;
var daliog1;
var btn;
var defaultTab=null;
var tb=null;
<%
if(isSysAdmin)
{
	//pagemenustr +="tb.add('->');";
	pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0077")+"','T','page_white_gear',function(){toSet('"+workflowid+"','workflow')});";//流程设置
	%>
	function toSet(soureid,souretype)
	{
		var url='/base/toSet.jsp?soureid='+soureid+'&souretype='+souretype
		onUrl(url,'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001b") %>',soureid);//设置
	}
	<%
}
%>

Ext.onReady(function(){
	myMask = new Ext.LoadMask(Ext.getBody(),{msg:'<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260000") %>'});//请稍候...
	btn = new Ext.Button({
		text: "<%=labelService.getLabelName("盖章")%>",
		tooltip:'<%=labelService.getLabelName("盖完章才能提交")%>',
		iconCls:Ext.ux.iconMgr.getIcon('shading'),
		handler: choose
	});
	Ext.QuickTips.init();
	 var commentstore = new Ext.data.JsonStore({
		url:'<%=action%>',
		root: 'result',
		totalProperty: 'totalCount',
		baseParams:{showmore:'1'},
		fields: ['Datatime','operator','point','opertype','message','nodeid','nextopername']

	});
	commentstore.on('load',function(commentstore,recs){
		var id = '<%=requestid%>';
		if (id!=null && id.length!=0){
		var html='<table class="tableApprovalOpinions" width="100%" border="0" cellspacing="0" cellpadding="0">';
		html=html+'<tr class="bg">';
		html=html+'<th width="20%" align="left" style="border-left:solid 1px #ebe7d1"><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76b1f3260037") %></th>';//节点
		html=html+'<th width="32%" align="left"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260001") %></th>';//意见
		html=html+'<th width="30%"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260002") %></th>';//操作时间
		html=html+'<th width="9%" ><%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %></th>';//操作
		html=html+'<th width="10%"style="border-right:solid 1px #ebe7d1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260003") %></th>';//接收
		html=html+'</tr>';
		for(var i = 0; i < recs.length; i++)
		{
			var td_id='res'+i;
			html=html+'<tr>';  
			html=html+'<td align=left style="border-left:solid 1px #ebe7d1">'+recs[i].get('point')+'</td>'; 
			html=html+'<td align=left>'+recs[i].get('message')+'</td>'; 
			html=html+'<td align=left>'+recs[i].get('operator')+'  '+recs[i].get('Datatime')+'</td>';
			html=html+'<td align=left>'+recs[i].get('opertype')+'</td>'; 
			html=html+'<td align=left style="border-right:solid 1px #ebe7d1">'+uniquestr(recs[i].get('nextopername'),',')+'</td>'; 
			//html=html+'<td align=left id='+td_id+'><span><a href="javascript:getNodeUsers(\''+recs[i].get('nextopername')+'\',\'<%=requestid%>\',1,\''+td_id+'\')"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %></a></span></td>';//显示 
			html=html+'</tr>';
			
		}
		html=html+'</table>';
		if(document.getElementById("requestlogsdiv"))document.getElementById("requestlogsdiv").innerHTML=html;
		}
	});	
	commentstore.load();
    var layoutTabs=initTabs();
    if(layoutTabs.length==0){//如果没有自定义Tab页,则默认添加
    	layoutTabs.push({title:"",tbar:['-'],autoScroll:true,contentEl:'tab1'});
    }
    defaultTab=layoutTabs[0];
	var _defaultTitle=Ext.isEmpty(defaultTab.title)?'<%=labelService.getLabelName("表单信息")%>':defaultTab.title;
 	delete defaultTab.title;
    defaultTab.tbar= ['-'];
    defaultTab=new Ext.Panel(defaultTab);
    layoutTabs.shift();
	var c = new Ext.Container({
	   autoEl: {},
	  title:_defaultTitle,iconCls:Ext.ux.iconMgr.getIcon('application'),
	   //renderTo: Ext.get('EweaverForm'),
	   width:Ext.lib.Dom.getViewportWidth(),
	   height: Ext.lib.Dom.getViewportHeight(),
	   layout: 'border',
	<% if(bNewworkflow.equals("1") ||(optlevel == 2 && isfinished == 0)) {%>
	   items: [defaultTab]
	<%}else{%>
		items: [defaultTab]
	<%}%>
	});
	var contentPanel = new Ext.TabPanel({
		region:'center',
		id:'tabPanel',
		renderTo: Ext.get('EweaverForm'),
		deferredRender:false,
		enableTabScroll:true,
		autoScroll:true,
		activeTab:0,
		items:[c].concat(layoutTabs)
	});
	tb = defaultTab.getTopToolbar();
	<%if(!pagemenustr.equals("")){%>
	<%=pagemenustr%>
	<%
	String hql="from Stampinfo where userid='"+eweaveruser.getId()+"' and requestid='"+requestid+"' and nodeid='"+nodeid+"'" ;
	List list=stampinfoService.getStampinfos(hql);
	%>
	<%
	if(nodeinfo.getIsstamp()==null)
	nodeinfo.setIsstamp(0);
	if(nodeinfo.getIsstamp()==1){
	if(list.size()>0){
	%>

	//tb.add(btn);
	<%}else{
		if(optlevel != 1 && isfinished ==0&&!bNotify) {
		isstamp=true;
		%>
		tb.add(btn);
	<%}}}}%>
	<%if(nodeinfo.getId()!=null && nodeinfo.getNodetype()!=1){
		Setitem isdisplayworkflowno = setitemService.getSetitem("402883c9369ff2be01369ff2c8a5026f");
		if("1".equals(isdisplayworkflowno.getItemvalue())){
			String flowno = dataService.getValue("select objno from requestbase where id='"+requestid+"' ");
			String workflowtitle = labelService.getLabelNameByKeyId("D96406C2F6444FE08A43A7CA7BCFF2BC");
	%>
		tb.add('->');
		tb.addText('<%=workflowtitle%>:');
		tb.addText('<%=flowno%>');
	<%}}%>
	
	// <!-- begin 添加选择提醒方式 供流程操作者选择 -->
	     <%
			boolean bRtx = StringHelper.null2String(setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048").getItemvalue()).equals("1");
			boolean bSMS = StringHelper.null2String(setitemService.getSetitem("402881a10e5e787f010e5f1eabeb0011").getItemvalue()).equals("1");
			boolean bEmail = StringHelper.null2String(setitemService.getSetitem("402881a10e5e787f010e5f1f4a4e0013").getItemvalue()).equals("1");
			int isemail =0;//NumberHelper.getIntegerValue(requestbase.getIsemail());
			int issms =0;//NumberHelper.getIntegerValue(requestbase.getIssms());
			int ispopup =0;//NumberHelper.getIntegerValue(requestbase.getIspopup());
			int isrtx =0;//NumberHelper.getIntegerValue(requestbase.getIsrtx());
			if((StringHelper.null2String(workflowinfo.getRemindtype()).equals("4028819d0e521bf9010e5238bec2000d")) && (bRtx || bSMS || bEmail)) {%>
			tb.add('->');
		     <%
		     if(NumberHelper.getIntegerValue(workflowinfo.getSelemail())==1 && bEmail){
		     %>
		     tb.add('<input type=\"checkbox\" <% if (isemail==1){%> <%="checked"%> <%}%> name=\"isemail_cbox\" id=\"isemail_cbox\" value=\"0\" onClick=\"javascript:setRemindtype(\'isemail\')\">邮件提醒');   
		     <%} if(NumberHelper.getIntegerValue(workflowinfo.getSelsms())==1 && bSMS){%>
		     tb.add('<input type=\"checkbox\" <% if (issms==1){%> <%="checked"%> <%}%> name=\"issms_cbox\"  id=\"issms_cbox\" value=\"0\" onClick=\"javascript:setRemindtype(\'issms\')\">短消息提醒');   
		     <%} if(NumberHelper.getIntegerValue(workflowinfo.getSelpopup())==1){%>
		     tb.add('<input type=\"checkbox\" <% if (ispopup==1){%> <%="checked"%> <%}%> name=\"ispopup_cbox\"  id=\"ispopup_cbox\" value=\"0\" onClick=\"javascript:setRemindtype(\'ispopup\')\">弹出式提醒');   
		     <%} if(NumberHelper.getIntegerValue(workflowinfo.getSelrtx())==1 &&bRtx){%>
		     tb.add('<input type=\"checkbox\" <% if (isrtx==1){%> <%="checked"%> <%}%> name=\"isrtx_cbox\"  id=\"isrtx_cbox\" value=\"0\" onClick=\"javascript:setRemindtype(\'isrtx\')\">rtx提醒');   
		     <%}%>
	     <%}%>
// <!-- end 添加选择提醒方式 供流程操作者选择 -->
	
	<%//如果是公文则添加公文WebOffice编辑框
	if(isDocFlow){%>
		contentPanel.add({
		title:"<%=labelService.getLabelName("正文内容")%>",
		contentEl:'webOfficeDiv',
		closable:false
		});
		LoadWorkflowDoc();
	 <%if(!bNewworkflow.equals("1")){%>
		 contentPanel.setActiveTab(1);
	 <%}}%>
    //Viewport
    //ie6 bug
    Ext.get('tab1').setVisible(true);
       <% if(bNewworkflow.equals("1") ||(optlevel == 2 && isfinished == 0)) {%>
			Ext.get('divsum').setVisible(true);
       <%}%>
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
	Ext.EventManager.on(window, 'resize', function(){
		if(Ext.getDom('DocWebOffice')){
			Ext.getDom('DocWebOffice').style.height=(Ext.getBody().getSize().height-10)+'px';;
		}
	});
    <%=tabStr%>
	dlg0 = new Ext.Window({
		layout:'border',
		closeAction:'close',
		plain: true,
		modal :true,
		width:400,
		height:300,
		items: new Ext.Panel({
			region:'center',
			autoScroll:true,
			html:Ext.get('dialog0').dom.innerHTML
		}),
		listeners:{'beforecolose':function(win){
			win.hide();
			return false;
		}}
	});
	daliog0 = new Ext.Window({
		 layout:'border',
		 closeAction:'hide',
		 plain: true,
		 modal :true,
		 width:viewport.getSize().width*0.5,
		 height:viewport.getSize().height*0.6,
		 buttons: [{
			 text     : '<%=labelService.getLabelName("关闭")%>',
			 handler  : function(){
				 daliog0.hide();
			 }

		 }],
		 items:[{
		 id:'dlgpanel',
		 region:'center',
		 xtype     :'iframepanel',
		 frameConfig: {
			 autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
			 eventsFollowFrameLinks : false
		 },
		 autoScroll:true
		}]
	 });
	daliog1 = new Ext.Window({
		 layout:'border',
		 closeAction:'hide',
		 plain: true,
		 modal :true,
		 width:viewport.getSize().width*0.75,
		 height:viewport.getSize().height*0.8,
		 buttons: [{
			 text     : '<%=labelService.getLabelName("关闭&刷新表单")%>',
			 handler  : function(){
				 document.location.reload();
				 daliog1.hide();
			 }

		 }],
		 items:[{
		 id:'dlgpanel',
		 region:'center',
		 xtype     :'iframepanel',
		 frameConfig: {
			 autoCreate:{id:'dlgframe1', name:'dlgframe1', frameborder:0} ,
			 eventsFollowFrameLinks : false
		 },
		 autoScroll:true
		 }]
	});
	publish('refreshtab','tab402880351e44500a011e4465e0cf0023');
	<%if(!StringHelper.isEmpty(msg)){%>
          alert('<%=StringHelper.getDecodeStr(msg)%>');
	<%}%>
	<%if(bNewworkflow.equals("1")){%>
		inputs = document.EweaverForm.getElementsByTagName("input");
		for (i = 0; i < inputs.length; i++) {
			inputel = inputs[i];
			if(inputel.value&&inputel.value!=''){
				WeaverUtil.fire(inputel);
			}
			//inputel.fireEvent('onpropertychange');
		}
	<%}%>
	<%if(isDocFlow&&!bNewworkflow.equals("1")){%>
		Ext.get('webOfficeDiv').setVisible(true);
	<%}%>
});
var needchecklists = "<%=needcheckfields%>";
var requestid = "<%=StringHelper.null2String(requestid)%>";
var workflowid = "<%=StringHelper.null2String(workflowid)%>";
var nodeid = "<%=StringHelper.null2String(nodeid)%>";
//选择提醒
setRemindtype("isemail");
setRemindtype("issms");
setRemindtype("ispopup");
setRemindtype("isrtx");
function setRemindtype(checkName){
  if(checkName=="isemail" && document.all("isemail_cbox")){
              if (document.all("isemail_cbox").checked){
		         document.all("isemail").value='1';
		      }else{
		         document.all("isemail").value='0';
		      }
  }
  if(checkName=="issms" && document.all("issms_cbox")){
              if (document.all("issms_cbox").checked){
		         document.all("issms").value='1';
		      }else{
		         document.all("issms").value='0';
		      }
  }
  if(checkName=="ispopup" && document.all("ispopup_cbox")){
              if (document.all("ispopup_cbox").checked){
		         document.all("ispopup").value='1';
		      }else{
		         document.all("ispopup").value='0';
		      }
  }
  if(checkName=="isrtx" && document.all("isrtx_cbox")){
              if (document.all("isrtx_cbox").checked){
		         document.all("isrtx").value='1';
		      }else{
		         document.all("isrtx").value='0';
		      }
  }
}
//催办
function onHasten(){
	var url='/msg/flowReminders.jsp?requestid=<%=requestid%>';
    this.daliog0.getComponent('dlgpanel').setSrc(""+url);
    this.daliog0.show()
}

//取消独占
function setDocexclusion()
{
	var url='<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocexclusionAction?id=<%=requestid%>&action=close';
    PubUtil.sendXMLRequest(url);  
}   
</script>



</head>
<body  onload="getstamp();<%if(isRedHead)out.println("writeRedObj();");%>" <%if(isDocFlow){%>onunload="unLoadWebOffice();setDocexclusion();" <%}%>>
<div  style="display:none">
	<div id="webOfficeDiv" <%if(!bNewworkflow.equals("1"))out.println("style=\"display:none\"");%>>
	<%if(isDocFlow){%>
	<object id="DocWebOffice" style="left:0px;height:300px" width="100%" classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
	<param name="WebUrl" value="<%=WebOffice.mServerName%>"/>
	<param name="FileName" value="docs"/>
	<param name="FileType" value=".doc"/>
	<param name="UserName" value="<%=currentuser.getObjname()%>"/>
	<param name="ShowMenu" value="<%=isDocEdit?1:1%>"/>
	<param name="ShowToolbar" value="0"/>
	</object>
	<%}%>
	</div>
</div>
<form action="/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=operate" target="_self" enctype="multipart/form-data"  name="EweaverForm"  id="EweaverForm"  method="post" >
<input type="hidden" name="docAttachid" id="docAttachid" value="<%=StringHelper.null2String(wb.getDocAttachid())%>"/>
<input type="hidden" name="isfeedback" id="isfeedback" value="0"/>
<input type="hidden" id="attachid" name="attachid" value="<%=attachid%>"/>
<input type="hidden" id="tabId" name="tabId" value="<%=tabId%>"/>
<div id="dialog0" style="display:none">
	<table>
	<tr>
		<td align="left">
		<%=labelService.getLabelName("您确定要退回该流程吗")%>?<BR><%=labelService.getLabelName("请选择退回的节点")%>:
		</td>
	</tr>
	<%
	String rejectnodeid = "";
	if(canreject && rejectnodelist != null){
		for(int i=0;i<rejectnodelist.size();i++){
			Nodeinfo _nodeinfo = (Nodeinfo)rejectnodelist.get(i);
			String _thisnodeid = StringHelper.null2String(_nodeinfo.getId());
			boolean ischecked = false;
			if(!rejectid.equals("")){
				if(rejectid.equals(_thisnodeid)){
					ischecked = true;
				}else{
					continue;
				}
			}else if(rejectid.equals("") && _nodeinfo.getNodetype().intValue() == 1){
				ischecked = true;
			}
			if(ischecked)
				rejectnodeid = _thisnodeid;
	%>
		<tr>
			<td>
				<input type="radio" value="<%=_thisnodeid%>" id="rejectednode1" name="rejectednode1" <%if(ischecked){%> checked <%}%> onclick="javascript:document.all('rejectednode').value='<%=_thisnodeid%>';"><%=StringHelper.null2String(_nodeinfo.getObjname())%>
			</td>
		</tr>
	<%}
	}%>
		<tr>
			<td align="center">
				<button class='btn' accessKey='O' id="hider0" onclick="changeIsreject(1);dlg0.hide();"><U>O</U>--<%=labelService.getLabelName("确定")%></button>
				<button class='btn' accessKey='C' id="hider1" onclick="changeIsreject(0);dlg0.hide();"><U>C</U>--<%=labelService.getLabelName("取消")%></button>
			</td>
		</tr>
	</table>
	</div>
<div id="divsum" style="display:none">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="requestid" value="<%=requestid%>">
<input type="hidden" name="nodeid" value="<%=nodeid%>">
<input type="hidden" name="curnodeid" value="<%=curnodeid%>">
<input type="hidden" name="curnodeids" value="<%=curnodeids%>">
<input type="hidden" name="optlevel" value="<%=optlevel%>">
<input type="hidden" name="viewmode" value="<%=viewmode%>">
<input type="hidden" name="issave" value="0">
<input type="hidden" name="isundo" value="0">
<input type="hidden" name="editmode" value="<%=editmode%>">
<input type="hidden" name="canedit" value="<%=canedit%>">
<input type="hidden" name="targeturl" value="<%=targeturl%>">
<input type="hidden" name="currentuserid" value="<%=currentuser.getId()%>">
<input type="hidden" name="isnotify" value="<%=bNotify?"1":"0" %>">
<input type="hidden" name="layoutid" value="<%=layoutid%>">
<input type="hidden" name="bNewworkflow" value="<%=bNewworkflow%>">
<input type="hidden" id="bView" name="bView" value="<%=bView%>">
<input type="hidden" id="stampx" name="stampx" >
<input type="hidden" id="stampy" name="stampy" >
<input type="hidden" id="stampid" name="stampid" >
<input type="hidden" name="isreject" id="isreject" value="0">
<input type="hidden" name="rejectednode" id="rejectednode" value="<%=rejectnodeid%>">
<input type="hidden" name="tmpvalue" id="tmpvalue" value="">
<input type="hidden" id="issupervise" name="issupervise" value="0">
<!-- begin 选择提醒方式 add by 2011-09-08 cjl -->
<input type="hidden" id="isemail" name="isemail" value="0" >
<input type="hidden" id="issms" name="issms" value="0">
<input type="hidden" id="ispopup" name="ispopup" value="0">
<input type="hidden" id="isrtx" name="isrtx" value="0">
<!-- end 选择提醒方式 -->
</div>

<div id="tab1" style="display:none">
	<%
	Stampinfo stampinfo = new Stampinfo();
	if (!StringHelper.isEmpty(requestid) && !StringHelper.isEmpty(nodeid)) {
	 String sql = " from Stampinfo where requestid='" + requestid + "'";
	 List list = stampinfoService.getStampinfos(sql);

	 for (int i = 0; i < list.size(); i++) {
		 stampinfo = (Stampinfo) list.get(i);
			  if(nodeid.equals(stampinfo.getNodeid())) {
				  //isstamp=false;
				   stampinfoid=stampinfo.getId();
			  }

		   Imginfo imginfo=new Imginfo();
	if(!StringHelper.isEmpty(stampinfo.getImginfoid())) {
	imginfo=imginfoService.getImginfoDao().getImginfo(stampinfo.getImginfoid());
	Nodeinfo info=nodeinfoService.get(stampinfo.getNodeid());

		 %>
		 <div id="stamp_<%=stampinfo.getNodeid()%>" style='display:none;position:absolute;width:200;height:200 ;left:<%=stampinfo.getStampx()%>;top:<%=stampinfo.getStampy()%>;<%if(!StringHelper.isEmpty(info.getStampfield())&&info.getIsstamp()==1){%>display:none<%}%>' <%if(nodeid.equals(stampinfo.getNodeid())){%>onmousedown="MouseDown(this)" onmousemove="MouseMove()" onmouseup="MouseUp()"<%}%>>
	<%    if(!StringHelper.isEmpty(imginfo.getAttachid()))%>
	<img src=/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imginfo.getAttachid()%>&amp;download=1 >
	<%}%>
	</div>
	<%  }}  %>
	<%if(isstamp){
	if(listmove.size()<1){
		if(StringHelper.isEmpty(nodeinfo.getStampfield())){
		%>
		<div id="stamp_<%=nodeid%>" style='position:absolute;width:200;height:200' onmousedown="MouseDown(this)" onmousemove="MouseMove()" onmouseup="MouseUp()">
		</div>
	<%}}}%>
	<div id="layoutFrame" align="left">
	<%=formcontent%>
	<br>
	<br>
	<%if(!viewmode.equals("1")||!issupervise){ %>
	<input type="hidden" class="InputStyle2" name="requestname" value="<%=requestname%>" />
	<%if(bNewworkflow.equals("1") ||(optlevel == 2 && isfinished == 0)||issupervise) {
		boolean isFirstNode = false; 
		if("1".equals(nodeinfo.getNodetype()+"")){
			isFirstNode = true;
		}
	 %>
	<!--签字意见start-->
	<div id="signView" <%=(StringHelper.null2String(nodeinfo.getIsrexpand()).equals("0"))?" style=\"display:none;\"":"" %>>
	<table width="100%"  cellspacing="0" cellpadding="0" border="1">
	<colgroup>
	<col width="16%"/>	
	<col width="84%"/>	
	</colgroup>	
	<tr>
	<td colspan=2>
	<div align="left" class="requestlog"><h2><%=labelService.getLabelName("签字意见") %><!-- 签字意见 --></h2></div>
	</td>
	</tr>
	<tr>
	
	<td  class="FieldName"><%=labelService.getLabelName("签字意见")%>：(<input type=checkbox onclick="changeremarktype(this)" name="btnchangeremark" id="btnchangeremark"><%=labelService.getLabelName("超文本")%>)<br><br><br><br></td>
	<td style="PADDING-LEFT: 4px;"><%if("0".equals(setitemService.getSetitem("4089487d23f9e66e0123ffe23303253b").getItemvalue())){%>  <%}%> 
  	<select id="personvalue" style="width:90%" name="personvalue" onchange="personalChange(this.options[this.options.selectedIndex].innerText)" >
  	<option></option>
        <%    
                        List signatures=((BaseHibernateDao) personalSignatureService.getPersonalSignatureDao()).find("from PersonalSignature where humresid in('"+BaseContext.getRemoteUser().getId()+"','402881e70be6d209010be75668750014')");
                        for(int i=0;i<signatures.size();i++){
                            PersonalSignature psignature=(PersonalSignature)signatures.get(i);
                       %>
      					<option value="<%=psignature.getId()%>"><%=psignature.getObjvalue()%></option>

     		<%}%>
     </select>
	<textarea class="InputStyle2" style="width:90%; height:100px;" name="remark" id="remark" ></textarea>
	<br><div id="filelist_remarkfiles">
			<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017") %><!-- 附件 -->:<a href="#" class="addfile">
					<input  type="file"  class="addfile" name="remarkfiles" id="remarkfiles"  >
				</a>
		</div>
	<script>
	WeaverUtil.load(function(){
			FCKEditorExt.initEditor('remark',false);
			FCKEditorExt.toolbarExpand(false);
           <%
            if(NumberHelper.getIntegerValue(nodeinfo.getRemarkRequired())==1) {
           %>
           FCKEditorExt.checkText(true,'remark');
           Ext.EventManager.on("remark", 'focus', function(e){
               Ext.getDom('spadsdnIdremark').innerHTML=Ext.isEmpty(Ext.getDom('remark').value)?'<img src="/images/base/checkinput.gif" align="absMiddle">':"";
           });
           Ext.EventManager.on("remark", 'blur', function(e){
               Ext.getDom('spadsdnIdremark').innerHTML=Ext.isEmpty(Ext.getDom('remark').value)?'<img src="/images/base/checkinput.gif" align="absMiddle">':"";
           });
           <%}%>
		});
		/*加载默认签字意见start*/
		FCKEditorExt.complete=function(){
			FCKEditorExt.switchTextMode(false,'remark');
			<%
			String pdefvalue = eweaveruser.getSysuser().getDefvalue();
		 
		 	if(!bNewworkflow.equals("1")){	//非流程新建节点，带出个性签名
		 		
			 	if(!StringHelper.isEmpty(pdefvalue)&&nodeinfo.getRemarkRequired().intValue()==0){
			 		//如果签字意见为必填，则不带出个性签名。
			  		PersonalSignature personalSignature=personalSignatureService.getPersonalSignatureById(pdefvalue);
			  	
	%>
			 		Ext.getDom('remark').value = '<%=personalSignature.getObjvalue()%>';
	<%	 		}else{	%>
					Ext.getDom('remark').value = '';
	<%			}
		 	
		 	}else{ //流程新建节点，默认不带出个性签名
	%>
			 	Ext.getDom('remark').value = '';
	<%	
		 	}
	%>
		 }
		 /*加载默认签字意见end*/
		function personalChange(objtext){
			var btnchangeremark=document.getElementById('btnchangeremark');
			if(btnchangeremark&&btnchangeremark.checked)
			{
			 	Ext.getDom('remark').innerHTML=objtext;
			}
			else
			{
          	 	Ext.getDom('remark').value=objtext;
           	 	Ext.getDom('remark').focus();
           	}
		}
		function changeremarktype(obj){
			if(obj.checked){
				 FCKEditorExt.switchEditMode('remark');
			}else{
				 FCKEditorExt.switchTextMode(false,'remark');
			}
		}
		var multi_selector = new MultiSelector( document.getElementById( 'filelist_remarkfiles' ), 100,-1);
		multi_selector.addElement( document.getElementById( 'remarkfiles' ) );
		</script>
		</td>
	</tr>

	</table>
	</div>
	<% 
	if(StringHelper.null2String(nodeinfo.getIsrexpand()).equals("0")){
	%>
	<div id="signViewC" flag=true class="down"  title="<%=labelService.getLabelNameByKeyId("40288035248eb3e801248ee4664d0016")%> "></div>
	<%}else{%>
	<div id="signViewC" flag=true class="up"  title="<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")+labelService.getLabelNameByKeyId("40288035248eb3e801248edfa9a80014")%> "></div>
	<%}%>
	<%}%>
	<!--签字意见end-->
	<%
	}else{
	%>
		<input type="hidden"  style="width=50%"  name="requestname" value="<%=requestname%>">
		<input type="hidden"  style="width=50%"  name="requestlevel" value="<%=requestlevel%>">
	<%}%>
	<!--审批意见start-->
	<% if (!StringHelper.isEmpty(requestid)){ %>
		<div id="requestlogsdiv" <%=(StringHelper.null2String(nodeinfo.getPflowmethod()).equals("2"))?" style=\"display:none;\"":"" %>></div>
	<% }%>
	<!--审批意见end-->
	</div>
	</div>

  </form>
   <%String requesthost = "http://" + StringHelper.getRequestHost(request);%>
  <script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" ></script>
  <%if(isRedHead){%>
	<iframe src="about:blank" id="webOfficeFrame" style="display:none;width:100px;height:150px;"></iframe>
	<script>
	function writeRedObj()
	{
	//公文套红/加载Word模板时，由于正文已经有WebOffice控件，不能在同一页面内。地
	var frameDoc=Ext.getDom('webOfficeFrame').contentWindow.document;
	var t =[
		'<object id="WebOffice" width="100%" height="500" classid="<%=WebOffice.clsid %>" codebase="<%=WebOffice.codebase %>">',
		'<param name="WebUrl" value="<%=WebOffice.mServerName%>">',
		'<param name="FileName" value="c:\windows\docTemplate.doc">',
		'<param name="FileType" value=".doc">',
		'<param name="UserName" value="<%=currentuser.getId()%>">',
		//'<param name="EditType" value="-1,0,1,0,0,1,0">',
		'<param name="Print" value="0">',
		'<param name="ShowToolBar" value="0">',
		'<param name="ShowMenu" value="0">',
		'</object>'];

		frameDoc.write(t.join(''));
		frameDoc.close();
	}
	</script>
	<%}%>
	<script type="text/javascript">
	var tabPanel = null;
	var moveble=false;
	var chooser;
	function insertImage(data){
	  imgid=data.id;
	  if(!Ext.isEmpty(<%=isDocFlow%>) && <%=isDocFlow%>){//公文盖章
		var imgUrl=location.protocol+'//'+location.host+data.url;
		var office=Ext.getDom('DocWebOffice');
		var hasimg=office.WebDownLoadFile(imgUrl,'d:\\temp_stamp.gif');
		if(hasimg){
			var inlineShape=office.WebObject.Shapes.AddPicture('d:\\temp_stamp.gif',true,true);
			office.WebDelFile('d:\\temp_stamp.gif','');
			try{
			 //imgShape = inlineShape.ConvertToShape();
			 var imgShape = inlineShape;
			 if(imgShape){
				imgShape.Select();
				imgShape.AlternativeText = "<%=labelService.getLabelName("盖章")%>";
				imgShape.PictureFormat.TransparentBackground = true;
				imgShape.PictureFormat.TransparencyColor = 16777215;
				imgShape.Fill.Visible = false;
				imgShape.WrapFormat.Type = 3;
				imgShape.ZOrder(4);
			 }//end.if
			}catch(e){
				pop('<%=labelService.getLabelName("模板错误,请联系管理员")%>','<%=labelService.getLabelName("错误")%>:'+e.description,null,'cancel');
				Ext.getDom('DocWebOffice').style.display='block';return false;
			}
		}
		Ext.getDom('DocWebOffice').style.display='block';
	  }else{//非公文盖章
			moveble=true;
		  if(Ext.get('stamp_'+nodeid).first()) Ext.get('stamp_'+nodeid).first().remove();
		  Ext.DomHelper.append('stamp_'+nodeid, {
			  tag: 'img', src: data.url, style:'margin:10px;visibility:hidden;'
		  }, true).show(true).frame();
		  btn.focus();
	  }//endif.
	};

	function choose(btn){
	  <%if(!StringHelper.isEmpty(nodeinfo.getStampfield())&&nodeinfo.getIsstamp()==1){%>
	  stampfield();
	  <%}%>
	  var flag=false
		Ext.Ajax.request({
				url:'<%=imgaction%>',
			sync:true,
			params:{isstampone:1},     //当章印为1张的时候 点盖章按钮直接生效
				success: function(res) {
					var str=res.responseText;
					if(str.indexOf('images')>-1) //当章印大于两张
					  return;
					var id=str.substring(0,str.indexOf(';'));
					var url=str.substring(str.indexOf(';')+1,str.indexOf(';').length);
					   insertImage({id:id,url:url});
					flag=true;
					}


	});
	 if(!flag){
	  if(!chooser){
		  chooser = new ImageChooser({
			  url:'<%=imgaction%>',
			  width:515,
			  height:350
		  });
	  }
	   chooser.show(btn.getEl(), insertImage);
	  }
	  if(!Ext.isEmpty(<%=isDocFlow%>) && <%=isDocFlow%>){
		//Ext.getDom('DocWebOffice').style.display='none';
	  }

	};
    var win;
    var jq = jQuery.noConflict();
	function _addPerson(persontype){
		EditOK(persontype,encode(FCKEditorExt.getHtml()));
	}
   function EditOK(persontype,remark) {
	   if (persontype != 1 && persontype != 2 && persontype != 3 && persontype != 4)
		   return;
	   var url = "/humres/base/humresbrowserm.jsp";
	   if (persontype == 4)
		   url = "/humres/base/humresbrowser.jsp";
	   var popuptitle = encode("<%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772b02510008") %>");//人事卡片
	   var objid;
	   var objname;

	   if (Ext.isIE) {
		   var b;
		  if(persontype==1){
			  var url='/workflow/request/workflowtransmit.jsp'
			  b = openDialog("/base/popupmain.jsp?url=" + url);
		   }else{
			   b = openDialog("/base/popupmain.jsp?popuptitle=" + popuptitle + "&url=" + url);
		  }
		   if (b == undefined) {
			   return;
		   }

		   objid = getValidStr(b[0]);
		   objname = getValidStr(b[1]);
		   if (objid != "" && objname != "" && objid != undefined && objname != undefined) {

			   var humresid = getEncodeStr(objid);
			   var humresname = getEncodeStr(objname);
				  if(persontype==1){
					 remark=b[2];
				  }
			   var redirectattachid=getEncodeStr(getValidStr(b[3]));//流程转发附件
			   var updatestring = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
			   updatestring += "<data>";
			   updatestring += "<requestid>" + requestid + "</requestid>";
			   updatestring += "<persontype>" + persontype + "</persontype>";
			   updatestring += "<humresid>" + humresid + "</humresid>";
			   updatestring += "<humresname>" + humresname + "</humresname>";
			   updatestring += "<attachid>" + redirectattachid + "</attachid>";
			   updatestring += "<remark>" + remark + "</remark>";
			   updatestring += "<nodeid><%=nodeid%></nodeid>";
			   updatestring += "</data>";
			   myMask.show();
			   Ext.Ajax.request({
				   url:"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addoptperson",
				   params:{
					   updatestring:updatestring,requesthost:'<%=requesthost%>'
				   },
				   success: function(result) {
					   var returnStr = result.responseText;
					   if (id != "") {
						   var showmessage = "";
						   if (persontype == 1)
							   showmessage += "<%=labelService.getLabelName("成功将流程转发给")%>\"" + objname + "\"。";

						   if (persontype == 2)
							   showmessage += "<%=labelService.getLabelName("成功将")%>\"" + objname + "\"<%=labelService.getLabelName("添加为非会签操作人")%>。";

						   if (persontype == 3)
							   showmessage += "<%=labelService.getLabelName("成功将")%>\"" + objname + "\"<%=labelService.getLabelName("添加为会签操作人")%>。";

						   if (persontype == 4) {
							   showmessage = "<%=labelService.getLabelName("成功将流程移交给")%>\"" + objname + "\",<%=labelService.getLabelName("您不再对此流程拥有权限")%>。";
							   top.frames[1].pop(showmessage);
							   var tabpanel = top.frames[1].contentPanel;
							   tabpanel.remove(tabpanel.getActiveTab());
							   myMask.hide();
							   return;
						   }

						   if (returnStr != "") {
							   showmessage = returnStr;
						   }
						   top.frames[1].pop(showmessage);
						   myMask.hide();
						   document.location.reload();
						   return;

					   } else {    //create
						   top.frames[1].pop("<%=labelService.getLabelName("操作失败")%>!");
						   myMask.hide();
					   }
				   }

			   });
		   }
	   } else {
		   var callback = function() {
			   try {
				   id = dialog.getFrameWindow().dialogValue;
			   } catch(e) {
			   }
			   if (id != null) {
				   if (id[0] != '0') {
					   objid = id[0];
					   objname = id[1];
				   }
			   }
		   }
		   if (!win) {
			   win = new Ext.Window({
				   layout:'border',
				   width:Ext.getBody().getWidth() * 0.8,
				   height:Ext.getBody().getHeight() * 0.8,
				   plain: true,
				   modal:true,
				   items: {
					   id:'dialog',
					   region:'center',
					   iconCls:'portalIcon',
					   xtype     :'iframepanel',
					   frameConfig: {
						   autoCreate:{
							   id:'portal',
							   name:'portal',
							   frameborder:0
						   },
						   eventsFollowFrameLinks : false
					   },
					   closable:false,
					   autoScroll:true
				   }
			   });
		   }
		   win.render(Ext.getBody());
		   var dialog = win.getComponent('dialog');
		   dialog.setSrc(url);
		   win.show();
		   win.close = function() {
			   this.hide();
			   win.getComponent('dialog').setSrc('about:blank');
			   callback();
			   if (objid != "" && objname != "" && objid != undefined && objname != undefined) {

				   var humresid = getEncodeStr(objid);
				   var humresname = getEncodeStr(objname);

				   var updatestring = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
				   updatestring += "<data>";
				   updatestring += "<requestid>" + requestid + "</requestid>";
				   updatestring += "<persontype>" + persontype + "</persontype>";
				   updatestring += "<humresid>" + humresid + "</humresid>";
				   updatestring += "<humresname>" + humresname + "</humresname>";
				   updatestring += "<remark>" + remark + "</remark>";
				   updatestring += "<nodeid><%=nodeid%></nodeid>";
				   updatestring += "</data>";
				   myMask.show();
				   Ext.Ajax.request({
					   url:"/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=addoptperson",
					   params:{
						   updatestring:updatestring
					   },
					   success: function(result) {
						   var returnStr = result.responseText;
						   if (id != "") {
							   var showmessage = "";
							   if (persontype == 1)
								   showmessage += "<%=labelService.getLabelName("成功将流程转发给")%>\"" + objname + "\"。";

							   if (persontype == 2)
								   showmessage += "<%=labelService.getLabelName("成功将")%>\"" + objname + "\"<%=labelService.getLabelName("添加为非会签操作人")%>。";

							   if (persontype == 3)
								   showmessage += "<%=labelService.getLabelName("成功将")%>\"" + objname + "\"<%=labelService.getLabelName("添加为会签操作人")%>。";

							   if (persontype == 4) {
								   showmessage = "<%=labelService.getLabelName("成功将流程移交给")%>\"" + objname + "\",<%=labelService.getLabelName("您不再对此流程拥有权限")%>。";
								   top.frames[1].pop(showmessage);
								   var tabpanel = top.frames[1].contentPanel;
								   tabpanel.remove(tabpanel.getActiveTab());
								   myMask.hide();
								   return;
							   }

							   if (returnStr != "") {
								   showmessage = returnStr;
							   }
							   top.frames[1].pop(showmessage);
							   myMask.hide();
							   document.location.reload();
							   return;

						   } else {    //create
							   top.frames[1].pop("<%=labelService.getLabelName("操作失败")%>!");
							   myMask.hide();
						   }
					   }

				   });
			   }
		   }
	   }
  }
  function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
		document.getElementById(inputname.replace("field","input")).value="";
		var fck=param.indexOf("function:");
		if(fck>-1){}else{
			var param = parserRefParam(inputname,param);
		}
		var idsin = document.getElementsByName(inputname)[0].value;
        var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
        }
		var id;
    if(Ext.isIE){
    try{

   // id=openDialog(url,idsin);
    		if(typeof(param)=='undefined'){
	             id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
             }else{
            	 id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&sqlwhere='+param,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
             }
    }catch(e){return}
    if (id!=null) {

    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
  if(fck>-1){
          funcname=param.substring(9);
      scripts="valid="+funcname+"('"+id[0]+"');";
        eval(scripts) ;
        if(!valid){  //valid默认的返回true;
         document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
          }
          }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }else{
    url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    WeaverUtil.fire(document.all(inputname));
                    document.all(inputspan).innerHTML = id[1];
                     if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) {  //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0')
                                document.all(inputspan).innerHTML = '';
                            else
                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

                }
            }
        }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
                plain: true,
                modal:true,
                items: {
                    id:'dialog',
                    region:'center',
                    iconCls:'portalIcon',
                    xtype     :'iframepanel',
                    frameConfig: {
                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                        eventsFollowFrameLinks : false
                    },
                    closable:false,
                    autoScroll:true
                }
            });
        }
        win.close=function(){
				this.hide();
				win.getComponent('dialog').setSrc('about:blank');
				callback();
			}
			win.render(Ext.getBody());
			var dialog = win.getComponent('dialog');
			dialog.setSrc(url);
			win.show();
		}
    }
	var Obj;
	function MouseDown(obj)
	{
	   Obj=obj;
	   Obj.setCapture();
	   Obj.l=event.x-Obj.style.pixelLeft;
	   Obj.t=event.y-Obj.style.pixelTop;
	}
	function MouseMove()
	{
	  if(moveble){
	  if(Obj!=null)
	   {
		 Obj.style.left = event.x-Obj.l;
		 Obj.style.top = event.y-Obj.t;
	   }
	  }
	}
	function MouseUp()
	{
		stampx=document.getElementById('stamp_'+nodeid).style.left;
		stampy=document.getElementById('stamp_'+nodeid).style.top;
	  if(Obj!=null)
	   {
		 Obj.releaseCapture();
		 Obj=null;
	   }
	}
	function stampfield(){
	   if('<%=stampfield%>'!=''&&'<%=isstamp%>'){
			//var el = Ext.get('field_<%=stampfield%>');
			var el = document.getElementsByName('field_<%=stampfield%>')[0];
			var obj = el;
			//var obj = document.getElementById('field_<%=stampfield%>') ;
			if (obj == null) {
				el = Ext.get('field_<%=stampfield%>_0');//出来明细表 是明细表字段显示为明细表第一行的数字
				obj = document.getElementById('field_<%=stampfield%>_0');
			}
			var objdiv = document.getElementById('stamp_<%=nodeid%>');
			//if (el.isDisplayed() == true) {
			//if (obj.type != 'hidden') {    //文本字段隐藏
				// ;
			//} else {
				//el = el.parent();
		//	}
			//} else {
		//	el = el.parent();
			//}
		//	stampx=el.getX();
			//stampy=el.getY();
			//obj.parentNode.innerHTML='<div id="stamp_<%=nodeid%>"></div>'
		}
	}
	function getstamp(){
		<%
		Stampinfo stampinfo2= new Stampinfo();
		if (!StringHelper.isEmpty(requestid) && !StringHelper.isEmpty(nodeid)) {
		 String sql = " from Stampinfo where requestid='" + requestid + "'";
		 List list23 = stampinfoService.getStampinfos(sql);
		 for (int i = 0; i < list23.size(); i++) {
			stampinfo2 = (Stampinfo) list23.get(i);
			if(nodeid.equals(stampinfo2.getNodeid())) {
				stampinfoid=stampinfo2.getId();
			}
			Imginfo imginfo=new Imginfo();
			if(!StringHelper.isEmpty(stampinfo2.getImginfoid())) {
				imginfo=imginfoService.getImginfoDao().getImginfo(stampinfo2.getImginfoid());
				if(!StringHelper.isEmpty(imginfo.getAttachid())){
					Nodeinfo noinfo=nodeinfoService.get(stampinfo2.getNodeid());
					%>
					var obj = document.getElementById('field_<%=noinfo.getStampfield()%>') ;
					if(obj==null){
					  obj=document.getElementById('field_<%=noinfo.getStampfield()%>span') ; //显示布局的多行文本框
					}
					if(typeof(obj)!='undefined'&&obj!=null&&obj!=''){
					obj.parentNode.innerHTML='<div id="stamp_<%=stampinfo2.getNodeid()%>"><img src=/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=imginfo.getAttachid()%>&amp;download=1 ></div>'
		  }
		<%}	}  }}  %>
	}
	
	</script>

  <script language="javascript">
	var tableformatted = false;
	var inputid;
	var spanid;
	var temp;
	[].indexOf || (Array.prototype.indexOf = function(v)
	{
		for(var i = this.length; i-- && this[i] !== v;);
		return i;
	});
	var strSQLs = new Array();
	var strValues = new Array();
	<%=triggercalscript%>
	jq(document).ready(function($){
	<%=ufscript%>
	<%=directscript%>
	$.Autocompleter.Selection = function(field, start, end) {
	if( field.createTextRange ){
		var selRange = field.createTextRange();
		selRange.collapse(true);
		selRange.moveStart("character", start);
		selRange.moveEnd("character", end);
		selRange.select();
		if(inputid==undefined||spanid==undefined)
			return;
		var len=field.value.indexOf("  ");
		var lenspance=field.value.indexOf(" ");
		if(temp==0&&len>0){
		temp=1;
		var  length=field.value.length;
		var data=field.value;
		document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
		document.getElementById('field'+spanid+'span').innerHTML= data.substring(len,length);
			}else if(temp==0&&lenspance>0){
				var data=field.value;
				document.getElementById(inputid).value=data;
				document.getElementById('field'+spanid+'span').innerHTML= data;
			}
			else{
				document.getElementById(inputid).value="";
			}
	} else if( field.setSelectionRange ){
		field.setSelectionRange(start, end);
	} else {
		 if( field.selectionStart ){
		  field.selectionStart = start;
		  field.selectionEnd = end;
		}
	}
		field.focus();
	};
});
function checkdirect(obj)
{
	inputid=obj.id;
	spanid=obj.name;
	temp=0;
}
function checkUnique(obj,param,isonly,fieldname,tablename){
	if(obj.value.trim()=='')
		return;
	if(isonly==1||param=="")
	{
		param="select "+fieldname+" from "+tablename+" where "+fieldname+" = ?";
	}
	param=param.replace("?","'"+obj.value.ReplaceAll("'","''")+"'");
	if(SQL(param)!=''){
		alert('<%=labelService.getLabelNameByKeyId("402883d934c119410134c11941a20000") %>') ;//数据已存在,请重新输入！
		obj.value='';
		obj.focus();
	}
}
var loadXML = function(xmlFile){ 
    var xmlDoc; 
    if(window.ActiveXObject){ 
        var ARR_ACTIVEX = ["MSXML4.DOMDocument","MSXML3.DOMDocument","MSXML2.DOMDocument","MSXML.DOMDocument","Microsoft.XmlDom"]; 
        for (var i = 0;i < ARR_ACTIVEX.length;i++) { 
            try { 
                var objXML = new ActiveXObject(ARR_ACTIVEX[i]); 
                xmlDoc = objXML; 
                break; 
            } catch (e) {} 
        } 
        if (xmlDoc) { 
            xmlDoc.async = false; 
            xmlDoc.loadXML(xmlFile); 
        }else{ 
            return; 
        } 
    }else if (document.implementation && document.implementation.createDocument){//判断是不是遵从标准的浏览器 
        //建立DOM对象的标准方法 
        xmlDoc = document.implementation.createDocument('', '', null); 
        xmlDoc.load(xmlFile); 
    }else{ 
        return null; 
    } 
    return xmlDoc; 
}
function SQL(param){
	param = encode(param);

	if(strSQLs.indexOf(param)!=-1){
		var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
		return retval;
	}else{
		var _url= "/ServiceAction/com.eweaver.base.DataAction?sql="+encodeURIComponent(param);
		//将Msxml.xmldocument加载xml文件改为JQuery自带的Ajax封装类并同步加载
		var xmlrequest=jq.ajax({
			type: "GET",
			async:false,
			url: _url,
			error:function (XMLHttpRequest, textStatus, errorThrown){
					alert('Error:'+errorThrown);
					return '';
				}
			});
		var XMLDoc=xmlrequest.responseXML;//返回结果集的Xmldom对象，即原先new ActiveXObject创建的对象
		var XMLRoot=XMLDoc.documentElement;//返回根结点，在FireFox下不是该属性名称且XMLRoot.text属性也不可用。
		//var retval = getValidStr(XMLRoot.text);
		if(XMLRoot==null)
			XMLRoot = loadXML(xmlrequest.responseText.replace(/&mdash;/g, '-')).documentElement;
		var retval = XMLRoot.firstChild ? getValidStr(XMLRoot.firstChild.nodeValue) : "";
		strSQLs.push(param);
		strValues.push(retval);

		return retval;
	}
}
function onCal(){
	try{
		var rowindex = 0;
		<%=fieldcalscript%>
		function SUM(param){
			var result = 0;
			for(index=0;index<rowindex;index++){
				tmpval = 0;
				try{
				tmpval = eval(param)*1;
				}catch(e){
				tmpval = 0;
				}
				//alert(tmpval);
				result += tmpval;
			}
			rowindex = 0;
			return result;
		}

		function RMB(param){
			var tmpval = eval(param)*1;
			var result =  convertCurrency(tmpval);
			return result;
		}
		function COUNT(param){
			var result = 0;
			for(index=0;index<rowindex;index++){
				tmpval = 0;
				try{
				tmpval = eval(param)*1;
				}catch(e){
				tmpval = 0;
				}
				if(tmpval != 0)
					result ++;
			}
			rowindex = 0;
			return result;
		}
		function PROD(param){
			var result = 1;
			for(index=0;index<rowindex;index++){
				tmpval = 1;
				try{
				tmpval = eval(param)*1;
				}catch(e){
				tmpval = 1;
				}
				//alert(tmpval);
				result = result * tmpval;
			}
			rowindex = 0;
			return result;
		}
		function MAX(param, thisindex){
			this.tempIndex = index;//用于进这个函数志强的index值
			var result = 0;
			for(index=0;index<thisindex;index++){
				tmpval = 0;
				try{
					tmpval = eval(param)*1;
				}catch(e){
					tmpval = 0;
				}
				if(tmpval > result)
					result = tmpval;
			}
			index = this.tempIndex;//还原在被此函数用了的index值
			return result;
		}

	}catch(e){}
}
function onAddRow(){
	onCal();
	try{
		<%=onaddrowscript%>
	}catch(e){}
	handleAddRow();
}
onAddRow();
var task=new Ext.util.DelayedTask(onCal);
//*************************简易Javascript Map(start)*************************//
var objectKey = new Array(100);
var objectValue = new Array(100);
var timevalue = "";
function getMapValue(key){
	for(var i=0;i<objectKey.length;i++){
		if(objectKey[i]==key){
			timevalue = objectValue[i];
		}
	}
}
</SCRIPT>
<SCRIPT FOR = document EVENT = onselectionchange>
	task.delay(caldelay,null,this);
</SCRIPT>
<script>
//*************************简易Javascript Map(end)*************************//

//*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(start)*************************//
<%
List list = formlayoutService.findFormlayoutfieldByLayoutid(layoutid);
Map map = new HashMap();
for (int i = 0; i < list.size(); i++) {
	Formlayoutfield formlayoutfield = (Formlayoutfield) list.get(i);
	if("$currenttime$".equals(formlayoutfield.getFormula()==null?"":formlayoutfield.getFormula().trim())){
%>
	if(document.all("field_<%=formlayoutfield.getFieldname()%>")!=null){
		objectKey[<%=i%>]="field_<%=formlayoutfield.getFieldname()%>";
		objectValue[<%=i%>]=document.all("field_<%=formlayoutfield.getFieldname()%>").value;
	}else{
		var i=0;
		while(document.all("field_<%=formlayoutfield.getFieldname()%>_"+i)!=null){
			objectKey[<%=i++%>]="field_<%=formlayoutfield.getFieldname()%>_"+i;
			objectValue[<%=i++%>]=document.all("field_<%=formlayoutfield.getFieldname()%>_"+i).value;
			i++;
		}
	}
<%
	}
}%>
    //*************************页面加载后将$currenttime$字段的值放置在MAP中保存起来(end)*************************//
<%if(isDocFlow){%>
</script>
<script language="javascript" for=DocWebOffice event="OnMenuClick(vIndex,vCaption)">
  if (vIndex==1){  
    WebOpenLocal();     //打开本地文件
  }
  if (vIndex==2){  
    WebSaveLocal();     //保存本地文件
  }
  if (vIndex==3){
    SaveDocument();     //保存正文到服务器上（不退出）
  }
  if (vIndex==5){  
    WebOpenSignature(); //签名印章
  }
  if (vIndex==6){  
    WebShowSignature(); //验证签章
  }
  if (vIndex==8){  
    WebSaveVersion();   //保存版本
  }
  if (vIndex==9){  
    WebOpenVersion();   //打开版本
  }
  if (vIndex==11){
    SaveDocument();     //保存正文到服务器上
    webform.submit();   //然后退出
  }
  if (vIndex==13){  
    WebOpenPrint();     //打印文档
  }
</script>
<script>
var isDocEdit=<%=isDocEdit%>;
var isDocVestige=<%=isDocVestige%>;
var isDocFlow=<%=isDocFlow%>;
var isPrint=<%=nodeinfo.getIsprint()%>;
function unLoadWebOffice(){
	try{
		if(!Ext.getDom('DocWebOffice')) return;
		var nStatus=Ext.getDom('DocWebOffice').WebClose();
	}catch(e){ alert('window.onbeforeunload error:'+e.description); }
};
function LoadWorkflowDoc(){//wb.getDocAttachid
	//alert('height:'+Ext.getDom('DocWebOffice').style.height);
		var office=Ext.getDom('DocWebOffice');
		if(Ext.isEmpty(office)){alert('iweboffice控件未加载成功！');return;}
		office.style.height=(Ext.getBody().getSize().height-50)+'px';
		office.WebSetMsgByName("OPTION","LOADFILE");
		office.WebSetMsgByName("OFFICEID","<%=wb.getDocAttachid()%>");
		var aid=Ext.getDom('docAttachid').value;
		if(Ext.isEmpty(aid)){//如果为空表示新建文档，则加载模板文档
			aid='<%=docTemplate%>';
		}
		var editType='-1';
		editType+=','+(isDocEdit?'0':'1');
		editType+=','+(isDocVestige?'1,1':'0,0');
		editType+=',0,1';
		editType+=','+(isDocEdit?'1':'0');
	/*	if(isDocVestige){//保留痕迹,
			editType=isDocEdit?'2,3':'0';
		}else{
			editType=isDocEdit?'1':'0';
		}
	*/
		office.EditType=editType;
		if(isDocEdit){
	    	office.AppendMenu("1","<%=labelService.getLabelNameByKeyId("402881e70d962d51010d96fc26cf0006") %>(&L)");//打开本地文件
    		office.AppendMenu("2","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0019") %>(&S)");//保存本地文件
    		office.AppendMenu("3","<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260004") %>(&U)");//保存远程文件
    		office.AppendMenu("12","-");
    		office.AppendMenu("13","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001a") %>(&P)");//打印文档
			office.CopyType="1";
			office.WebToolsEnable('Standard',109,false);
		}else{
			office.WebSetProtect(true,"");//保护控件中的文档
			office.CopyType="1";
			if(isPrint=='1'){
				office.AppendMenu("13","<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001a") %>(&P)");//打印文档
				office.AppendMenu("12","-");
			}
			
		}
		office.DisableMenu("页面设置(&U)...;关于我们(&A)...");
		office.WebSetMsgByName("OFFICEID",aid);
		office.WebOpen();
		<%=docexclusionMsg%>

}

function SaveWorkflowDoc(){
	//如果只读和非套红时不保存直接返回.
	if(!isDocEdit && !isRedHead)return false;
	var office=Ext.getDom('DocWebOffice');

	if(Ext.isEmpty(office))return;
	if(isRedHead){//如果套红则接受修订
		office.WebSetProtect(false,'');
		office.WebObject.AcceptAllRevisions();//套红时接受修订再提交保存
		office.WebSetProtect(true,'');
	}//end.if
	var aid=Ext.getDom('docAttachid').value;
	office.WebSetMsgByName("OPTION","SAVEFILE");
	
		office.WebSetMsgByName("OFFICEID",aid);
	var ret=office.WebSave();
	if(Ext.isEmpty(aid)){
		var status=office.WebGetMsgByName("STATUS");

		if(status=='FAIL'){
			alert('<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260005") %>');//公文保存失败,请联系管理员!
			return false;
		}
		aid=office.WebGetMsgByName("OFFICEID");
		
		Ext.getDom('docAttachid').value=aid;
		//alert(aid);
		//alert('aid:'+Ext.getDom('docAttachid').value);
	}//end.if
}
<%}%>
function onFree(){
	openDialog("free.jsp?requestid=<%=requestid%>&nodeid=<%=nodeid%>");
}
var flag = true;
function onSubmit(issave){
	if (!flag) return;
	//----------------------------------------------------
	//hj 2011.11.7 add (必填项详细信息)
	var tds=document.getElementsByTagName("td");
	for(var v=0;v<tds.length;v++){
		if(tds[v].className=="FieldValue"){
			tds[v].style.backgroundColor="#efefde";
		}
	}
	var imgs=document.getElementsByTagName("img");
	for(var v=0;v<imgs.length;v++){
		if(imgs[v].src.indexOf("checkinput.gif")!=-1){
			imgs[v].parentNode.parentNode.style.backgroundColor="yellow";
		}
	}
	//alert("length:"+imgs.length);
	///-------------------------------------
	
	
	
	<%if(isDocFlow){%>
	
	SaveWorkflowDoc();
	<%}%>
	
    var stampid;
    if(imgid!=''&&typeof(imgid)!='undefined'){
        Ext.Ajax.request({
            url:"/ServiceAction/com.eweaver.workflow.stamp.servlet.StampAction?action=createstamp",
            sync:true,
           params:{stampx:stampx,stampy:stampy,imgid:imgid,nodeid:'<%=nodeid%>',requestid:'<%=requestid%>',stampinfoid:'<%=stampinfoid%>'},
                        success: function(res) {
                              stampid=res.responseText;
                        }
        });
    }else{
        <%if(isstamp&&listmove.size()==0){%>
        Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
        Ext.MessageBox.alert('','<%=labelService.getLabelName("此流程必须要在你盖章的情况下才能提交")%>！！');
        return;
        <%}%>
    }
       if('<%=nodeinfo.getNodetype()%>'==1){ //当节点类型为开始节点
           if(typeof(stampx)!='undefined'&&typeof(stampy)!='undefined'){
            document.getElementById('stampx').value=stampx;
            document.getElementById('stampy').value=stampy;
            document.getElementById('stampid').value=stampid;}
       }
	//needchecklists = "<%=needcheckfields%>";
	checkfields=needchecklists;//填写必须输入的input name，逗号分隔
	
	var checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空
	
	onCal();
	if(issave == 0){
		if(<%=bAwoke%> == 1){
			if(!confirm('<%=awokeinfo%>')){
				document.all("isreject").value = "0";
				return null;
			}
		}
		if(!checkForm(EweaverForm,checkfields,checkmessage)){
			document.all("isreject").value = "0";
			return null;
		}
	    <%if(nodeinfo.getRemarkRequired().intValue()==1){%>
	    	var remarkvalue='';
	    	var remarkobj=Ext.getDom('remark');
	    	if(remarkobj!=null){
	    		remarkvalue=remarkobj.value;
	    	}
	        if(remarkvalue==''||remarkvalue=='null'){
		        Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260006") %>');//签字意见未填写！
		         event.srcElement.disabled = false;
		        return;
	    	}
	   	<%}%>
	}

	if(issave == 1){
		document.all("issave").value = "1";
       <%
          Setitem setitemcheckform=setitemService.getSetitem("40288856895ft8d001beceezxse22952");
          if("1".equals(setitemcheckform.getItemvalue())){%>
        if(!checkForm(EweaverForm,checkfields,checkmessage)){
			document.all("isreject").value = "0";
			return null;
		}
       <%}%>
    }

	if(issave == 3)
		document.all("isundo").value = "1";//查看前撤回
	if(issave == 4)
		document.all("isundo").value = "2";//查看后撤回
	if(issave == 5)
		document.all("isundo").value = "3";//强制收回

    //if(!wordModuleExport()) return;
    <%if(isDocFlow){%>
    if(Ext.isEmpty(issave) || issave==0) wordModuleExport();//issave参数为空或零时表示提交操作
	<%}%>
    /** 不需要默认生成红头，全都从模板中加载，红头即红色表格的模板而已*/
    //addWordDocHead(document.getElementById("attachid").value);

    //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(start)**************************//
    for(var num=0;num<objectKey.length;num++){
        if(objectKey[num]!=""&&objectKey[num]!=null){
            getMapValue(objectKey[num]);
            if(timevalue==document.all(objectKey[num]).value){
                document.all(objectKey[num]).value="$currenttime$";
            }
        }
    }
    //*************************提交之前将用户没有修改的当前时间字段标识一下,交给后台更新(end)**************************//

    //*************************word文档导出处理(start)**************************//

    //*************************word文档导出处理(end)**************************//
	if(typeof(onSubmitBefore)=='function'){
		
		try{
			var submitBefore = onSubmitBefore(issave);
			if(!submitBefore) 
			{
				event.srcElement.disabled = false;
				return;
			}
		}catch(e){alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0055") %>'+e.description);return;}//执行提交前事件函数onSubmitBefore时异常:
	}
	if(issave==6){
	 	var remarkvalue='';
	   	var remarkobj=Ext.getDom('remark');
	   	if(remarkobj!=null){
	   	   remarkvalue=remarkobj.value;
	   	}
	    if(remarkvalue==''||remarkvalue=='null'){
	       Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260006") %>');//签字意见未填写！
	       event.srcElement.disabled = false;
	       return;
	   	}
	}
	//如果是批注，那么issupervise为1  在后台做特殊处理
	if(issave==6){
		EweaverForm.issupervise.value=1;
	}else{
	    EweaverForm.issupervise.value=0;
	}
	document.EweaverForm.submit();
	flag = false;
	document.all("isreject").value = "0";
	document.getElementById('isfeedback').value=0;
}
function onSubmitNoCheck(issave){
	document.EweaverForm.submit();
	document.all("isreject").value = "0";
	document.getElementById('isfeedback').value=0;
}
function onDelete(){
    Ext.Msg.buttonText={yes:'<%=labelService.getLabelName("是")%>',no:'<%=labelService.getLabelName("否")%>'};
    Ext.Msg.confirm('', '<%=labelService.getLabelName("您确定要删除吗")%>?', function (btn, text) {
                if (btn == 'yes') {
                    location.href='/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=delete&requestid=<%=requestid%>&workflowid=<%=workflowid%>';
                }
    });

}

<%if(isDocFlow){%>
function webOfficeVisible(blShow){
	var objs=Ext.query('object[@classid=clsid:23739A7E-5741-4D1C-88D5-D50B18F7C347]');
	for(var i=0;i<objs.length;i++) objs.style.display=(blShw)?'block':'none';

}
function webOfficeHide(){
	webOfficeVisible(false);
}
function webOfficeShow(){
	webOfficeVisible(true);
}
var defaultWfRedTemp='<%=docTemplate%>';//流程设置时指定的的默认红头模板
var wfRedTempId='<%=StringHelper.null2String(nodeinfo.getWfRedTemplate())%>'
var wfRedTemp='<%=this.getFormFieldValue(formid,nodeinfo.getWfRedTemplate(),requestid)%>'
var wordRedTempId='<%=StringHelper.null2String(nodeinfo.getWordRedTemplate())%>';
var wordRedTemp='<%=this.getFormFieldValue(formid,nodeinfo.getWordRedTemplate(),requestid)%>';

/**用于处理正文的套红模板 */
function getContentRedTemplate(){
	var val=null;
	var defaultTempId=defaultWfRedTemp;
	if(Ext.isEmpty(wfRedTempId) || Ext.isEmpty(Ext.getDom('field_'+wfRedTempId)))return defaultTempId;
	var tmp=Ext.getDom('field_'+wfRedTempId).value;
	if(Ext.isEmpty(tmp)){//如果当前表单为空,则检测之前的表单有无设置
		if(Ext.isEmpty(wfRedTemp)){//如果之前表单中的模板未设置则返回流程默认模板
			val=defaultTempId;
		}else val=wfRedTemp;
	}else val=tmp;
	//alert('套红模板ID'+val);
	return val;
}

function getWordRedTemplate(){
	var val=null;
	var defaultTempId='<%=attachid%>';
	var tmp=(Ext.isEmpty(wordRedTempId) || Ext.isEmpty(Ext.getDom('field_'+wordRedTempId)))?'':Ext.getDom('field_'+wordRedTempId).value;
	if(Ext.isEmpty(tmp)){//如果当前表单为空,则检测之前的表单有无设置
		if(Ext.isEmpty(wordRedTemp)){//如果之前表单中的模板未设置则返回流程默认模板
			val=defaultTempId;
		}else val=wordRedTemp;
	}else val=tmp;
	//alert('套红模板ID'+val);
	return val;
}
var isRedHead=<%=isRedHead%>;
function wordModuleExport(item){
	if(!isRedHead)return true;//if(attachid==null||"".equals(attachid)) return true;
	var frameDoc=Ext.getDom('webOfficeFrame').contentWindow.document;
	var office=frameDoc.getElementById('WebOffice');
	var wid=getWordRedTemplate();
	//alert('红头模板ID:'+wid);
	var aid=null;
	DWREngine.setAsync(false);//设置为同步获取数据
	WordModuleService.getAttachByWordModule(wid,function(data){aid=data});
	DWREngine.setAsync(true);
	if(Ext.isEmpty(aid)){
		alert('<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001b") %>:wid:'+wid+',aid:'+aid);//获取套红模板错误
		return true;
	}
	office.WebSetMsgByName("OPTION","LOADFILE");
    office.WebSetMsgByName("OFFICEID",aid);
    office.WebOpen();
    var word=office.WebObject;
	word.AcceptAllRevisions();
    var defaultValue="";
    var hasimg=true;
    for(var i=1;i<=word.Bookmarks.Count;i++){
        var num = word.Bookmarks.Count;
        var name = word.Bookmarks.Item(i).Name;
        var bookmark = word.Bookmarks.Item(i).Range;
        if(name=='Content') continue;
//        alert(name);
        if(name.indexOf("stamp_")!=-1){
            var divObj=document.getElementById(name);
            if(divObj){
                var imgArray = divObj.getElementsByTagName("img");
                for(j=0;j<imgArray.length;j++){
                    imgsrc=imgArray[j].src
//                    alert(imgsrc);
                }
                var hasimg=office.WebDownLoadFile(imgsrc,'d:/'+name+'.gif');
                if(hasimg){
                    bookmark.Select();
//                    alert(bookmark.InlineShapes.Count);
                    inlineShape=bookmark.InlineShapes.AddPicture('d:/'+name+'.gif',false,true);

//                    alert(bookmark.InlineShapes.Count);
//                    document.WebOffice.WebDelFile('d:/'+name+'.gif','');
                    try{
//                    inlineShape.Select();
                    imgShape = inlineShape.ConvertToShape();
                    }catch(e){office.WebClose();pop('<%=labelService.getLabelName("模板错误,请联系管理员")%>','<%=labelService.getLabelName("错误")%>',null,'cancel');return false};
                    imgShape.Select();
                    imgShape.AlternativeText = "<%=labelService.getLabelName("盖章")%>";
                    imgShape.PictureFormat.TransparentBackground = true;
                    imgShape.PictureFormat.TransparencyColor = 16777215;
                    imgShape.Fill.Visible = false;
                    imgShape.WrapFormat.Type = 3;
                    imgShape.ZOrder(4);


                }
            }
        }else{
            if(document.getElementById(name)!=null){
                if(document.getElementById(name).type=="select-one"){
//                    alert(document.getElementById(name).value);
//                    alert(document.getElementById(name).text);
                    defaultValue=document.getElementById(name).options[document.getElementById(name).selectedIndex].text;
                }else if(document.getElementById(name).type=="hidden"){
                   	if(document.getElementById(name+"span"))
						defaultValue=document.getElementById(name+"span").innerText;
					else
						defaultValue=document.getElementById(name).value;
                }else{
                    defaultValue=document.getElementById(name).value;
                }
                bookmark.Text=defaultValue;
                office.WebObject.Bookmarks.Add(name,bookmark);
            }
        }
    }
	//alert('开始套入红头模板文件...');
	office.WebSetProtect(false,"");
	office.WebSetMsgByName("OPTION","INSERTFILE");
    var cid=Ext.getDom('docAttachId').value;
    office.WebSetMsgByName("contentId",cid);
    office.WebInsertFile();
	//word.Protect(2,true,'123');
    office.WebSetMsgByName("FILENAME","套红模板.doc");
    office.WebSetMsgByName("FILETYPE",".doc");
	office.WebSetMsgByName("OFFICEID","");
	word.AcceptAllRevisions();
    office.WebSave();
	//alert('完成红头模板文件的嵌入套红!');
    var attachid = office.WebGetMsgByName("OFFICEID");
    WorkflowService.wordDocCreate('<%=nodeinfo.getId()%>','<%=requestid%>',attachid);
    document.getElementById("attachid").value=attachid;

	addContentRedHead(attachid);//对正文内容进行判断是否套红
	//alert('redhead ok!');
    return true;
}

/**
 * @param aid as String //是指已经套红并生成生成的附件ID
 */
function addContentRedHead(aid){
	var tempId=getContentRedTemplate();
	if(Ext.isEmpty(tempId))return;
	var contentId=Ext.getDom('docAttachId').value;
	var office=Ext.getDom('DocWebOffice');
	if(tempId==getWordRedTemplate()){//如果生成文档红头和正文内容设置红头一致,则直接从文档中加载保存
		office.WebSetMsgByName("OPTION","LOADFILE");
		office.WebSetMsgByName("OFFICEID",aid);
		office.WebOpen();
	}else{//重新对正文内容套红
		office.WebSetMsgByName("OPTION","LOADFILE");
		office.WebSetMsgByName("OFFICEID",tempId);
		office.WebOpen();//打开模板成功
		/**进行套红设置**/
		var word=office.WebObject;
		for(var i=1;i<=word.Bookmarks.Count;i++){
			var num = word.Bookmarks.Count;
			var name = word.Bookmarks.Item(i).Name;
			var bookmark = word.Bookmarks.Item(i).Range;

			if(!Ext.isEmty(Ext.getDom(name))){
				if(document.getElementById(name).type=="select-one"){
					defaultValue=Ext.getDom(name).options[Ext.getDom(name).selectedIndex].text;
                }else if(document.getElementById(name).type=="hidden"){
					defaultValue=document.getElementById(name+"span").innerText;
                }else{
                    defaultValue=document.getElementById(name).value;
                }
                bookmark.Text=defaultValue;
                office.WebObject.Bookmarks.Add(name,bookmark);
            }
		}//end.for.
		office.WebSetMsgByName("OPTION","INSERTFILE");
	    office.WebSetMsgByName("contentId",contentId);
	    office.WebInsertFile();
	    word.AcceptAllRevisions();
	}//end if
	office.WebSetMsgByName("OFFICEID",contentId);
	office.WebSave();
}
function checkFileSize(filepath,maxSize){
    var size=getFileSize(filepath);
    if(size>maxSize)
    return false;
    return true;
}
function getFileSize(filepath){
	 if(filepath=='')
	 {
		return null;
	 }
	 try
	 {
		 filecheck.FilePath=filepath;
		 var size=filecheck.getFileSize()/(1024*1024);
		 return size;
	 }
	 catch(e)
	 {
		alert(e);
		return null;
	}
 return null;
 }
<%}%>
function a_OnMouseOut(icon){
	document.all("oc_divMenuDivision"+icon).style.visibility = "hidden"

}
function b_OnClick(icon){
	document.all("oc_divMenuDivision"+icon).style.visibility = ""

}
function quickPrint(){
	<%
		String printlayoutid = layoutid;
		List<Formlayout> formlayoutListObj = formlayoutService.findFormlayout("from Formlayout where typeid=3 and formid='"+formid+"'");
		if(formlayoutListObj.size()!=0){
			Formlayout formlayout = formlayoutListObj.get(0);
			printlayoutid = formlayout.getId();
		}
	%>
	var newwin=window.open("/workflow/request/workflowprint.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&show=1,2&printLayout=<%=printlayoutid%>",'','width='+screen.width+',height='+screen.height+',left=0,top=0,toolbar =no, menubar=yes, scrollbars=yes, resizable=yes, location=no, status=no');
}
function newrefobj(inputname, inputspan, doctype, viewurl, isneed, docdir) {
	params = ""
	targeturl = "<%=URLEncoder.encode(targeturlfordoc, "UTF-8")%>"
	//params = getRefobjParams(inputname,doctype) ;
	var id;
	try {
		id = openDialog("/base/popupmain.jsp?url=/document/base/docbasecreate.jsp?categoryid=" + docdir + "&doctypeid=" + doctype + params + "&targetUrl=" + targeturl);

	} catch(e) {
		return;
	}
	if (id != null) {

		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
		} else {
			document.all(inputname).value = '';
			if (isneed == '0')
				document.all(inputspan).innerHTML = '';
			else
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
		}
	}
}
var catchers;
function getmsgcatcher(){
	DWREngine.setAsync(false);
	RequestlogService.getOperatorList0Str('<%=nodeid%>','<%=requestid%>','',returncallback);
	DWREngine.setAsync(true);
}
function returncallback(data){
	catchers = data;
}
function sendMsg(msg,humres,type){
	  if(!humres){
		  getmsgcatcher();
		  humres=catchers;
	  }
	  this.daliog0.getComponent('dlgpanel').setSrc('/msg/createmsg.jsp?catcher='+humres+'&objid=<%=requestid%>&msg='+encodeURIComponent(msg));
	  this.daliog0.show();
}
function importDetail(requestid,workflowid,layoutid){
	  this.daliog1.getComponent('dlgpanel').setSrc('/workflow/form/exportdrecordbyexcel.jsp?requestid='+requestid+'&workflowid='+workflowid+'&layoutid='+layoutid);
	  this.daliog1.show();
}
function loadView1(vid, cid, _params, _callback) {
	if (Ext.isEmpty(_params)) _params = ''; 
	var ofg = { 
		url: '/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?action=partview', 
		method: 'post', 
	   // sync: false,
		success: function(resp, opt) { 
			document.getElementById(cid).innerHTML = resp.responseText; 
			if (typeof(_callback) == 'function') _callback(); 
		}, 
		failure: function(resp, opt) { 
			alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0058") %>{' + vid + '}<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0059") %>:' + resp); //视图模板     加载错误
		}, 
		params: { 
			id: vid, 
			where: _params 
		} 
	}; 
	Ext.Ajax.request(ofg); 
}
function loadView(vid,cid,_params,_callback){
	if(Ext.isEmpty(_params))_params='';
	$(cid).style.height="50px";
	$(cid).style.width="100%";
	var myMask = new Ext.LoadMask($(cid), {msg:"<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0057") %>",removeMask:true});//请稍等,数据加载中...
	var ofg={
		url: '/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerAction?action=partview',
		method:'POST',
		timeout:180000,//三分钟
		success:function(resp,opt){
			myMask.hide();
			var ret=resp.getResponseHeader.ret;
			if(parseInt(ret)<0){
				opt.failure(resp,opt);
			}else{
				$(cid).innerHTML=resp.responseText;
				if(typeof(_callback)=='function')_callback();
			}
		},
		failure:function(resp,opt){
			myMask.hide();
			alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0058") %>{'+vid+'}<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0059") %>:'+resp);
			$(cid).innerHTML='<pre>'+resp.responseText+'</pre>';			
		},
		//headers:{ 'my-header': 'foo'}
		params:{id:vid,where:_params}
	};
	myMask.show();
	Ext.Ajax.request(ofg);
}//end fun.
 function selectAll (obj,formid) {
	 var objname = "check_node_"+formid;
	 var checks = document.getElementsByName(objname);
	 for(var i = 0 ; i < checks.length ; i ++) {
		checks[i].checked = obj.checked;
	 }
 }
	 
function addrowbyexcel(id) {

	var ids=window.showModalDialog(contextPath+'/base/popupmain.jsp?url='+contextPath+'/document/file/fileuploadbrowser.jsp?mode=1');
	if(!ids) {
		return;
	}
	var docid = ids[0];
	var myMask = new Ext.LoadMask(Ext.getBody(), {
			msg: '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005a") %>',//正在导入,请稍后...
			removeMask: true //完成后移除
		});
	myMask.show();
	Ext.Ajax.request({    
		   url : contextPath+'/ServiceAction/com.eweaver.workflow.request.servlet.XlsFormAction',    
		   //params :参数列表    
		   timeout:300000,
		   params : {    
				 //取得所选第一行中id列的值    
				  docid:docid,
				  formid:id    
			},    
			//success:响应成功后的回调函数    
		   success : function(response) {    
				// 解码JSON格式数据为一个对象.返回的数据为json数据.{id:'1'}  
				 myMask.hide();
				// alert('0');
				if(response.responseText == '') {
					alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005b") %>');//文件内容为空,请选择正确的文件
					return;
				}
				var respText = eval(response.responseText);   
				//alert(response.responseText);
				var j = 0;
				var l = (respText.length);
				if(l > 0) {
					 var el = document.getElementsByTagName('input');       
					 var len = el.length;     
					  
					 for(var i=0; i<len; i++) {               
						if((el[i].type=='checkbox') && (el[i].name=='check_node_'+id)) {      
							el[i].checked = true;       
							maxIndex = el[i].value;    
						}       
					 }      
					 delrow(id);     	 
				}
				//alert(response.responseText);
				for(var one = 0; one < l; one++) { 
					//maxIndex = one;
					//alert(respText[one].length);
					var ll = respText[one].length;
					//if(one > 0) {
						addrow(id); 
						maxIndex++;
					//}
					for(var key = 0;key < ll;key ++)  {
						if(respText[one][key]) {
							var cellid = respText[one][key].id;
							var obj = Ext.getDom('field_'+cellid+'_'+maxIndex); 
							var objspan = Ext.getDom('field_'+cellid+'_'+maxIndex+'span'); 
							if(objspan && obj.type == 'hidden') { 
								objspan.innerHTML = respText[one][key].value; 	
								obj.value=respText[one][key].value;										
							}
							//alert(obj.type);
							if(obj && obj.type == 'text'){ 
								obj.value=respText[one][key].value;
							}
						}
				}  
					
				}
				 //alert('1');
			},    
	   //failure:处理当http返回是404或500的错误,不是业务错误       
		   failure : function(response) {    
					   Ext.Msg.alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>');//错误, 无法访问后台
					myMask.hide();
		   }    
	})   
}
function impmaintablebyexcel(id) {
var ids=openDialog('/base/popupmain.jsp?url=/document/file/fileuploadbrowser.jsp?mode=1');
if(!ids) return;
var docid = ids[0];
var myMask = new Ext.LoadMask(Ext.getBody(), {
					msg: '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005a") %>',//正在导入,请稍后...
					removeMask: true //完成后移除
});
myMask.show();
Ext.Ajax.request({    
  url : '/ServiceAction/com.eweaver.workflow.request.servlet.XlsFormAction?action=impmaintable',    
 //params :参数列表    
 params : {    
	   //取得所选第一行中id列的值    
		docid:docid,
		formid:id    
  },    
  //success:响应成功后的回调函数    
  success : function(response) {    
  // 解码JSON格式数据为一个对象.返回的数据为json数据.{id:'1'}  
	 myMask.hide();
	 if(response.responseText == '') {
		alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005b") %>');//文件内容为空,请选择正确的文件
		return;
	}
	var respText = eval(response.responseText);   
	var j = 0;
	var l = (respText.length);
	for(var one = 0; one < l; one++) { 
		var ll = respText[one].length;
		for(var key = 0;key < ll;key ++)  {
			if(respText[one][key]) {
				var cellid = respText[one][key].id;
				var obj = Ext.getDom('field_'+cellid); 
				var objspan = Ext.getDom('field_'+cellid+'span'); 
				//alert(obj.tagName);
				if(objspan && obj.type == 'hidden') { 
					objspan.innerHTML = respText[one][key].value; 	
					obj.value=respText[one][key].value;										
				} else if(obj && (obj.type == 'text' || obj.tagName == 'SELECT' )){ 
					obj.value=respText[one][key].value;
				} else if(obj && obj.type == 'checkbox'){ 
					obj.value=respText[one][key].value;
					if(obj.value == '1') {
						obj.checked=true;
					} else {
						obj.checked=false;
					}
				} else if(obj && obj.tagName == 'TEXTAREA'){ 
						obj.innerText=respText[one][key].value;										
				}
					alert(respText[one][key].id + ':' + respText[one][key].value);
			   }
			}  
		}
		alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005d") %>');//导入完毕！
	},
	failure : function(response) {   
		myMask.hide(); 
		Ext.Msg.alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>");//错误, 无法访问后台
	}    
})   
}
/*opttype: 1 当前操作者; 2 当前操作者;3 */
function getNodeUsers(nodeid,requestid,opttype,id)
{
	var td_id='#'+id;
	if (nodeid.length>0){
	//alert("下个节点操作人员:"+nodeid);
		nodeid = uniquestr(nodeid,',');
		$(td_id).html(nodeid);
	}

}
function uniquestr(str,splitstr){
	var o = str.split(splitstr);
	var array = new Array();
	var k =0;
	for(var i=0;i<o.length;i++){
		if(array == "" || array.toString().match(new RegExp(o[i],"g")) == null){
			array[k] =o[i];
			array.sort();
			k++;
		}
	}
	return array.toString();
}
function closediv(){
	jq("#msgwin").hide();
}
function onExcelExp(){
	var sign = 0 ;
	if(confirm("是否需要导出流转信息")){
      sign = 1;
	}
    var url="/workflow/request/workflow2office.jsp?";
    var newwin=window.open(url+"requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&show=1,2&printLayout=<%=printlayoutid%>&sign="+sign,'','width='+screen.width+',height='+screen.height+',left=0,top=0,toolbar =no, menubar=yes, scrollbars=yes, resizable=yes, location=no, status=no');
}
//签字意见显示隐藏js
$(document).ready(function(){
    	 $("#signViewC").css("cursor","hand");
    	 $('#signViewC').mouseover(function(event) {
        	 if($(this).attr("flag")){
  				$(this).removeClass('down').addClass('down-over');
            }else{
  				$(this).removeClass('up').addClass('up-over');
            }
  		});
  		$('#signViewC').mouseout(function() {
  			if($(this).attr("flag")){
	  			$(this).removeClass('down-over').addClass('down');
  	  	  	}else{
	  			$(this).removeClass('up-over').addClass('up');
  	  	  	 }
  		});
    	 
    	 $("#signViewC").click(function(){
    		 if(!blockSignView()){
    	            $("#signViewC").attr("flag",true);
    	            $("#signViewC").attr("title","<%=labelService.getLabelNameByKeyId("40288035248eb3e801248ee4664d0016")%>");
    	            $("#signView").slideUp("fast",function(){
    	            	$('#signViewC').removeClass('up-over').addClass('down');
        	        });
    	         }
         });
      });
     function blockSignView(){
    	 if ($("#signViewC").attr("flag")) {
    		 $("#signViewC").attr("flag",false);
    	            $("#signViewC").attr("title","<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")+labelService.getLabelNameByKeyId("40288035248eb3e801248edfa9a80014")%>");
    		 $("#signView").slideDown("fast",function(){
    			 $('#signViewC').removeClass('down-over').addClass('up');
        	 });
        	setTimeout(function(){document.getElementById('remark').focus();},500);
        	return true;
         } 
         return false;
     }
</script>



</body>
</html>

<%!
private BaseJdbcDao baseJdbcDao =null;
private ForminfoService forminfoService =null;
private FormfieldService formfieldService=null;
/** 获取红头模板 */
private String getFormFieldValue(String formid,String fieldId,String reqId){
	if(StringHelper.isEmpty(fieldId))return "";
	Forminfo form=this.forminfoService.getForminfoById(formid);
	Formfield field=this.formfieldService.getFormfieldById(fieldId);
	String fieldName=field.getFieldname().toUpperCase();
	String sql="select "+fieldName+" from "+ form.getObjtablename()+" where requestid='"+reqId+"'";
	Map m=this.baseJdbcDao.getJdbcTemplate().queryForMap(sql);
	return StringHelper.null2String(m.get(fieldName));
}
%>