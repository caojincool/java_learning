<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
	String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
	
	HumresService humresService = (HumresService)BaseContext.getBean("humresService");
	
	DataService dataService = new DataService();
	String sql = "select * from graphVersion where workflowid = '"+workflowid+"' order by createtime desc";
	List<Map<String, Object>> dataVersionList = dataService.getValues(sql);
%>
<html>
<head>
 <title></title>
 <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>

<style type="text/css">
 /**
 * Handsontable 0.9.19
 * Handsontable is a simple jQuery plugin for editable tables with basic copy-paste compatibility with Excel and Google Docs
 *
 * Copyright 2012, Marcin Warpechowski
 * Licensed under the MIT license.
 * http://handsontable.com/
 *
 * Date: Tue Oct 01 2013 13:17:18 GMT+0200 (Central European Daylight Time)
 */

.handsontable {
  position: relative;
  font-family: Arial, Helvetica, sans-serif;
  line-height: 1.3em;
  font-size: 13px;
}

.handsontable.htAutoColumnSize {
  visibility: hidden;
  left: 0;
  position: absolute;
  top: 0;
}

.handsontable table,
.handsontable tbody,
.handsontable thead,
.handsontable td,
.handsontable th,
.handsontable div
{
  box-sizing: content-box;
  -webkit-box-sizing: content-box;
  -moz-box-sizing: content-box;
}

.handsontable table.htCore {
  border-collapse: separate; /*it must be separate, otherwise there are offset miscalculations in WebKit: http://stackoverflow.com/questions/2655987/border-collapse-differences-in-ff-and-webkit*/
  position: relative;
  /*this actually only changes appearance of user selection - does not make text unselectable
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -o-user-select: none;
  -ms-user-select: none;
  /*user-select: none; /*no browser supports unprefixed version*/
  border-spacing: 0;
  margin: 0;
  border-width: 0;
  table-layout: fixed;
  width: 0;
  outline-width: 0;
  /* reset bootstrap table style. for more info see: https://github.com/warpech/jquery-handsontable/issues/224 */
  max-width: none;
  max-height: none;
}

.handsontable col {
  width: 50px;
}

.handsontable col.rowHeader {
  width: 50px;
}

.handsontable th,
.handsontable td {
  border-right: 1px solid #CCC;
  border-bottom: 1px solid #CCC;
  height: 22px;
  empty-cells: show;
  line-height: 21px;
  padding: 0 4px 0 4px; /* top, bottom padding different than 0 is handled poorly by FF with HTML5 doctype */
  background-color: #FFF;
  font-size: 12px;
  vertical-align: top;
  overflow: hidden;
  outline-width: 0;
  white-space: pre-line; /* preserve new line character in cell */
}

.handsontable td.htInvalid {
  -webkit-transition: background 0.75s ease;
  transition: background 0.75s ease;
  background-color: #ff4c42;
}

.handsontable th:last-child {
  /*Foundation framework fix*/
  border-right: 1px solid #CCC;
  border-bottom: 1px solid #CCC;
}

.handsontable tr:first-child th.htNoFrame,
.handsontable th:first-child.htNoFrame,
.handsontable th.htNoFrame {
  border-left-width: 0;
  background-color: white;
  border-color: #FFF;
}

.handsontable th:first-child,
.handsontable td:first-child,
.handsontable .htNoFrame + th,
.handsontable .htNoFrame + td {
  border-left: 1px solid #CCC;
}

.handsontable tr:first-child th,
.handsontable tr:first-child td {
  border-top: 1px solid #CCC;
}

.handsontable thead tr:last-child th {
  border-bottom-width: 0;
}

.handsontable thead tr.lastChild th {
  border-bottom-width: 0;
}

.handsontable th {
  background-color: #EEE;
  color: #222;
  text-align: center;
  font-weight: normal;
  white-space: nowrap;
}

.handsontable th .small {
  font-size: 12px;
}

.handsontable thead th {
  padding: 0;
}

.handsontable th.active {
  background-color: #CCC;
}

.handsontable thead th .relative {
  position: relative;
  padding: 2px 4px;
}

/* plugins */

.handsontable .manualColumnMover {
  position: absolute;
  left: 0;
  top: 0;
  background-color: transparent;
  width: 5px;
  height: 25px;
  z-index: 999;
  cursor: move;
}

.handsontable th .manualColumnMover:hover,
.handsontable th .manualColumnMover.active {
  background-color: #88F;
}

.handsontable .manualColumnResizer {
  position: absolute;
  top: 0;
  cursor: col-resize;
}

.handsontable .manualColumnResizerHandle {
  background-color: transparent;
  width: 5px;
  height: 25px;
}

.handsontable .manualColumnResizer:hover .manualColumnResizerHandle,
.handsontable .manualColumnResizer.active .manualColumnResizerHandle {
  background-color: #AAB;
}

.handsontable .manualColumnResizerLine {
  position: absolute;
  right: 0;
  top: 0;
  background-color: #AAB;
  display: none;
  width: 0;
  border-right: 1px dashed #777;
}

.handsontable .manualColumnResizer.active .manualColumnResizerLine {
  display: block;
}

.handsontable .columnSorting:hover {
  text-decoration: underline;
  cursor: pointer;
}

/* border line */
.handsontable .wtBorder {
  position: absolute;
  font-size: 0;
}

.handsontable td.area {
  background-color: #EEF4FF;
}

/* fill handle */
.handsontable .wtBorder.corner {
  font-size: 0;
  cursor: crosshair;
}

.handsontable .htBorder.htFillBorder {
  background: red;
  width: 1px;
  height: 1px;
}

.handsontableInput {
  border: 2px solid #5292F7;
  outline-width: 0;
  margin: 0;
  padding: 1px 4px 0 2px;
  font-family: Arial, Helvetica, sans-serif; /*repeat from .handsontable (inherit doesn't work with IE<8) */
  line-height: 1.3em; /*repeat from .handsontable (inherit doesn't work with IE<8) */
  font-size: 13px;
  -webkit-box-shadow: 1px 2px 5px rgba(0, 0, 0, 0.4);
  box-shadow: 1px 2px 5px rgba(0, 0, 0, 0.4);
  resize: none;

  /*below are needed to overwrite stuff added by jQuery UI Bootstrap theme*/
  display: inline-block;
  font-size: 13px;
  color: #000;
  border-radius: 0;
}

.handsontableInputHolder {
  position: absolute;
  top: 0;
  left: 0;
  width: 1px;
  height: 1px;
}

/*
TextRenderer readOnly cell
*/
.handsontable .htDimmed {
  font-style: italic;
  color: #777;
}

/*
AutocompleteRenderer down arrow
*/
.handsontable .htAutocomplete {
  position: relative;
  padding-right: 20px;
}

.handsontable .htAutocompleteArrow {
  position: absolute;
  top: 0;
  right: 0;
  font-size: 10px;
  color: #EEE;
  cursor: default;
  width: 16px;
  text-align: center;
}

.handsontable td .htAutocompleteArrow:hover {
  color: #777;
}

/*
CheckboxRenderer
*/
.handsontable .htCheckboxRendererInput.noValue {
  opacity: 0.5;
}

/*
NumericRenderer
*/
.handsontable .htNumeric {
  text-align: right;
}

/* typeahead rules. Needed only if you are using the autocomplete feature */
.handsontable .typeahead {
  position: absolute;
  font-family: Arial, Helvetica, sans-serif;
  line-height: 1.3em;
  font-size: 13px;
  z-index: 10;
  top: 100%;
  left: 0;
  float: left;
  display: none;
  min-width: 160px;
  padding: 4px 0;
  margin: 2px 0 0 0;
  list-style: none;
  background-color: white;
  border-color: #CCC;
  border-color: rgba(0, 0, 0, 0.2);
  border-style: solid;
  border-width: 1px;
  -webkit-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
  -webkit-background-clip: padding-box;
  background-clip: padding-box;
  border-radius: 4px;
}

.handsontable .typeahead li {
  line-height: 18px;
  min-height: 18px;
  display: list-item;
  margin: 0;
}

.handsontable .typeahead a {
  display: block;
  padding: 3px 15px;
  clear: both;
  font-weight: normal;
  line-height: 18px;
  min-height: 18px;
  color: #333;
  white-space: nowrap;
}

.handsontable .typeahead li > a:hover,
.handsontable .typeahead .active > a,
.handsontable .typeahead .active > a:hover {
  color: white;
  text-decoration: none;
  background-color: #08C;
}

.handsontable .typeahead a {
  color: #08C;
  text-decoration: none;
}

/*context menu rules*/
ul.context-menu-list {
  color: black;
}

ul.context-menu-list li {
  margin-bottom: 0; /*Foundation framework fix*/
}

/**
 * dragdealer
 */

.handsontable .dragdealer {
  position: relative;
  width: 9px;
  height: 9px;
  background: #F8F8F8;
  border: 1px solid #DDD;
}

.handsontable .dragdealer .handle {
  position: absolute;
  width: 9px;
  height: 9px;
  background: #C5C5C5;
}

.handsontable .dragdealer .disabled {
  background: #898989;
}
/*!
 * jQuery contextMenu - Plugin for simple contextMenu handling
 *
 * Version: 1.6.5
 *
 * Authors: Rodney Rehm, Addy Osmani (patches for FF)
 * Web: http://medialize.github.com/jQuery-contextMenu/
 *
 * Licensed under
 *   MIT License http://www.opensource.org/licenses/mit-license
 *   GPL v3 http://opensource.org/licenses/GPL-3.0
 *
 */

.context-menu-list {
    margin:0; 
    padding:0;
    
    min-width: 120px;
    max-width: 250px;
    display: inline-block;
    position: absolute;
    list-style-type: none;
    
    border: 1px solid #DDD;
    background: #EEE;
    
    -webkit-box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
       -moz-box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
        -ms-box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
         -o-box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
    
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
}

.context-menu-item {
    padding: 2px 2px 2px 24px;
    background-color: #EEE;
    position: relative;
    -webkit-user-select: none;
       -moz-user-select: -moz-none;
        -ms-user-select: none;
            user-select: none;
}

.context-menu-separator {
    padding-bottom:0;
    border-bottom: 1px solid #DDD;
}

.context-menu-item > label > input,
.context-menu-item > label > textarea {
    -webkit-user-select: text;
       -moz-user-select: text;
        -ms-user-select: text;
            user-select: text;
}

.context-menu-item.hover {
    cursor: pointer;
    background-color: #39F;
}

.context-menu-item.disabled {
    color: #666;
}

.context-menu-input.hover,
.context-menu-item.disabled.hover {
    cursor: default;
    background-color: #EEE;
}

.context-menu-submenu:after {
    content: ">";
    color: #666;
    position: absolute;
    top: 0;
    right: 3px;
    z-index: 1;
}

/* icons
    #protip:
    In case you want to use sprites for icons (which I would suggest you do) have a look at
    http://css-tricks.com/13224-pseudo-spriting/ to get an idea of how to implement 
    .context-menu-item.icon:before {}
 */
.context-menu-item.icon { min-height: 18px; background-repeat: no-repeat; background-position: 4px 2px; }
.context-menu-item.icon-edit { background-image: url(images/page_white_edit.png); }
.context-menu-item.icon-cut { background-image: url(images/cut.png); }
.context-menu-item.icon-copy { background-image: url(images/page_white_copy.png); }
.context-menu-item.icon-paste { background-image: url(images/page_white_paste.png); }
.context-menu-item.icon-delete { background-image: url(images/page_white_delete.png); }
.context-menu-item.icon-add { background-image: url(images/page_white_add.png); }
.context-menu-item.icon-quit { background-image: url(images/door.png); }

/* vertically align inside labels */
.context-menu-input > label > * { vertical-align: top; }

/* position checkboxes and radios as icons */
.context-menu-input > label > input[type="checkbox"],
.context-menu-input > label > input[type="radio"] {
    margin-left: -17px;
}
.context-menu-input > label > span {
    margin-left: 5px;
}

.context-menu-input > label,
.context-menu-input > label > input[type="text"],
.context-menu-input > label > textarea,
.context-menu-input > label > select {
    display: block;
    width: 100%;
    
    -webkit-box-sizing: border-box;
       -moz-box-sizing: border-box;
        -ms-box-sizing: border-box;
         -o-box-sizing: border-box;
            box-sizing: border-box;
}

.context-menu-input > label > textarea {
    height: 100px;
}
.context-menu-item > .context-menu-list {
    display: none;
    /* re-positioned by js */
    right: -5px;
    top: 5px;
}

.context-menu-item.hover > .context-menu-list {
    display: block;
}

.context-menu-accesskey {
    text-decoration: underline;
}
 
</style>


 <style type="text/css">
 	body{
 		padding: 5px 10px;
 	}
 	.cbox{
		height:13px; 
		vertical-align:text-top; 
		margin-top:1px;
	}
	input.btn{
		margin-left: 0px;
		margin-right: 8px;
	}
 </style>

 <script type="text/javascript">
 	function setValueToParent(value){
        window.parent.returnValue = value;
        window.parent.close();
    }
 	
 	function onSubmit(){
 		var result = $("input[name='graphVersionId']:checked").val();
 		if(!result){
 			result = "";
 		}
 		setValueToParent(result);
 	}
 	
 	function onClear(){
 		setValueToParent("");
 	}
 	
 	function onClose(){
 		window.parent.close();
 	}
 	
 	function doDelete(id){
 		if(!confirm("确定要删除吗？")){
 			return;
 		}
 		$.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI("/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=deleteGraphVersion&graphVersionId="+id),
		 	data: "{}",
		 	success: function(responseText, textStatus) 
		 	{
		 		if(responseText == "1"){
		 			jQuery("#tr_" + id).remove();
		 		}else{
		 			alert("操作失败");
		 		}
		 	},
		 	error: function (XMLHttpRequest, textStatus, errorThrown) {
			}
		});
 	}
 </script>
</head>
<body>
	<%
		pagemenustr += "{S,确定,javascript:onSubmit()}";
	    pagemenustr += "{M,关闭,javascript:onClose()}";
	%>
	<div id="pagemenubar" style="z-index:100;"></div>
	<%@ include file="/base/pagemenu.jsp"%>
	<div style="padding: 8px 0px;">
		提示：如果想从以下某个版本中还原数据，请点击单选按钮选择指定的版本后，单击确定按钮来完成此操作。
	</div>
	<table class="handsontable">
		<thead>
			<tr>
				<th width="3%"><div class="relative"><span class="colHeader"></span></div></th>
				<th width="32%"><div class="relative"><span class="colHeader">版本说明</span></div></th>
				<th width="25%"><div class="relative"><span class="colHeader">创建人</span></div></th>
				<th width="25%"><div class="relative"><span class="colHeader">创建时间</span></div></th>
				<th width="15%"><div class="relative"><span class="colHeader">操作</span></div></th>
			</tr>
		</thead>
		<tbody>
			<%for(Map<String,Object> dataVersion : dataVersionList){
				String createman = StringHelper.null2String(dataVersion.get("createman"));
			%>
			<tr id="tr_<%=StringHelper.null2String(dataVersion.get("id")) %>">
				<td align="center"><input type="radio" name="graphVersionId" style="margin-top: 4px;" value="<%=StringHelper.null2String(dataVersion.get("id")) %>"/></td>
				<td><%=StringHelper.null2String(dataVersion.get("versiondesc")) %></td>
				<td><%=StringHelper.null2String(humresService.getHrmresNameById(createman)) %></td>
				<td><%=StringHelper.null2String(dataVersion.get("createtime")) %></td>
				<td><a href="javascript:doDelete('<%=StringHelper.null2String(dataVersion.get("id")) %>');">删除</a></td>
			</tr>
			<%} %>
			
			<%if(dataVersionList.isEmpty()){%>
			<tr>
				<td colspan="5" align="center" style="color: red;font-size: 13px;">当前并无版本被保存</td>
			</tr>	
			<%} %>
		</tbody>		
		</table>
</body>
</html>