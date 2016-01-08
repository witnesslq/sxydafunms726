<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="com.afunms.topology.model.HostNode"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@page import="com.afunms.common.util.*" %>
<%@page import="com.afunms.topology.model.MonitorHostDTO"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.afunms.topology.model.MonitorNetDTO"%>
<%@page import="com.afunms.topology.model.MonitorNodeDTO"%>
<%@ include file="/include/globe.inc"%>
<%@page import="com.afunms.polling.node.*"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.polling.impl.*"%>
<%@page import="com.afunms.polling.api.*"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.topology.dao.*"%>
<%@page import="com.afunms.topology.model.*"%>
<%@page import="com.afunms.monitor.item.base.MoidConstants"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@ page import="com.afunms.polling.api.I_Portconfig"%>
<%@ page import="com.afunms.polling.om.Portconfig"%>
<%@ page import="com.afunms.polling.om.*"%>
<%@ page import="com.afunms.polling.impl.PortconfigManager"%>
<%@page import="com.afunms.report.jfree.ChartCreator"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="com.afunms.monitor.item.base.*"%>
<%@page import="com.afunms.monitor.executor.base.*"%>
<%@page import="com.afunms.config.model.*"%>
<%@page import="com.afunms.config.dao.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.afunms.indicators.util.NodeUtil"%>
<%@page import="com.afunms.indicators.model.NodeDTO"%>
<%@page import="com.afunms.detail.net.service.NetService"%>
<%@page import="com.afunms.temp.model.NodeTemp"%>
<%@ page import="com.afunms.polling.loader.HostLoader"%>

<%
	String runmodel = PollingEngine.getCollectwebflag();
	String rootPath = request.getContextPath();
	List list = (List) request.getAttribute("list");
	JspPage jp = (JspPage) request.getAttribute("page");

	String field = (String) request.getAttribute("field");
	String sorttype = (String) request.getAttribute("sorttype");
	if (sorttype == null || sorttype.trim().length() == 0) {
		sorttype = "";
	}
	String flag = (String) request.getAttribute("flag");
	String category = (String) request.getAttribute("category");

	String nameImg = "";

	String categoryImg = "";

	String ipaddressImg = "";

	String pingImg = "";

	String cpuImg = "";

	String memoryImg = "";

	String swapImg = "";

	String inutilhdxImg = "";

	String oututilhdxImg = "";

	String imgSrc = "";

	String memcollecttime = "";
	String pingcollecttime = "";
	String responsevalue = "";
	String collecttime = "";
	String pingvalue = "0";
	String cpuUsed = "0";
	String cpuUnUsed = "";
	if (cpuUsed.equals("0"))
		cpuUnUsed = "100";
	String memeryUsed = "0";

	String memeryUnUsed = "";
	if (memeryUsed.equals("0"))
		memeryUnUsed = "100";
	String pingValue = "0";

	if ("desc".equals(sorttype)) {
		imgSrc = "/afunms/resource/image/btn_up2.gif";
	} else if ("asc".equals(sorttype)) {
		imgSrc = "/afunms/resource/image/btn_up1.gif";
	}

	if ("name".equals(field)) {
		nameImg = "<img src='" + imgSrc + "'>";
	}
	if ("category".equals(field)) {
		categoryImg = "<img src='" + imgSrc + "'>";
	}
	if ("ipaddress".equals(field)) {
		ipaddressImg = "<img src='" + imgSrc + "'>";
	}
	if ("ping".equals(field)) {
		pingImg = "<img src='" + imgSrc + "'>";
	}
	if ("cpu".equals(field)) {
		cpuImg = "<img src='" + imgSrc + "'>";
	}
	if ("memory".equals(field)) {
		memoryImg = "<img src='" + imgSrc + "'>";
	}

	if ("swap".equals(field)) {
		swapImg = "<img src='" + imgSrc + "'>";
	}
	if ("inutilhdx".equals(field)) {
		inutilhdxImg = "<img src='" + imgSrc + "'>";
	}
	if ("oututilhdx".equals(field)) {
		oututilhdxImg = "<img src='" + imgSrc + "'>";
	}

	String treeBid = (String) request.getAttribute("treeBid");
%>


<html>
	<head>
	
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">    
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath()%>css/global/global.css" rel="stylesheet" type="text/css"/>
		<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/resource/js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/resource/js/jquery.qtip-1.0.0-rc3.min.js"></script>
		<style>  
			.detailInfo{
				position: absolute;
				width:250px;
				height:142px;
				background: url('<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath()%>/image/detailInfobg.gif');
				background-repeat:no-repeat;
				display:none;
				filter: progid:DXImageTransform.Microsoft.Shadow(color=gray,direction=135); 
				z-index:100;
			}
			.detailInfoHead{
				height: 30px;
				color: white;
			}
			.detailInfoHeadLeft{
				width: 36px;
				margin: 3px;
			}
			.selectCss{  
				width:115px;
				z-index: -1;
			}
			
			#zindexDiv{
				position:absolute;
				z-index:50;
				margin-left:33px;
				margin-top:2px;
				width:expression(this.nextSibling.offsetWidth-45);
				height:expression(this.nextSibling.offsetHeight-10);
				top:expression(this.nextSibling.offsetTop);
				left:expression(this.nextSibling.offsetLeft);
				background-color:transparent;
				display: none;
			}
			
		</style>
		<script language="JavaScript">

			//��������
			var node="";
			var ipaddress="";
			var operate="";
			/**
			*���ݴ����id��ʾ�Ҽ��˵�
			*/
			function showMenu(id,nodeid,ip)
			{	
				ipaddress=ip;
				node=nodeid;
				//operate=oper;
			    if("" == id)
			    {
			        popMenu(itemMenu,100,"100");
			    }
			    else
			    {
			        popMenu(itemMenu,100,"1111");
			    }
			    event.returnValue=false;
			    event.cancelBubble=true;
			    return false;
			}
			/**
			*��ʾ�����˵�
			*menuDiv:�Ҽ��˵�������
			*width:����ʾ�Ŀ���
			*rowControlString:�п����ַ�����0��ʾ����ʾ��1��ʾ��ʾ���硰101�������ʾ��1��3����ʾ����2�в���ʾ
			*/
			function popMenu(menuDiv,width,rowControlString)
			{
			    //���������˵�
			    var pop=window.createPopup();
			    //���õ����˵�������
			    pop.document.body.innerHTML=menuDiv.innerHTML;
			    var rowObjs=pop.document.body.all[0].rows;
			    //��õ����˵�������
			    var rowCount=rowObjs.length;
			    //alert("rowCount==>"+rowCount+",rowControlString==>"+rowControlString);
			    //ѭ������ÿ�е�����
			    for(var i=0;i<rowObjs.length;i++)
			    {
			        //������ø��в���ʾ����������һ
			        var hide=rowControlString.charAt(i)!='1';
			        if(hide){
			            rowCount--;
			        }
			        //�����Ƿ���ʾ����
			        rowObjs[i].style.display=(hide)?"none":"";
			        //������껬�����ʱ��Ч��
			        rowObjs[i].cells[0].onmouseover=function()
			        {
			            this.style.background="#397DBD";
			            this.style.color="white";
			        }
			        //������껬������ʱ��Ч��
			        rowObjs[i].cells[0].onmouseout=function(){
			            this.style.background="#F1F1F1";
			            this.style.color="black";
			        }
			    }
			    //���β˵��Ĳ˵�
			    pop.document.oncontextmenu=function()
			    {
			            return false; 
			    }
			    //ѡ���Ҽ��˵���һ��󣬲˵�����
			    pop.document.onclick=function()
			    {
			        pop.hide();
			    }
			    //��ʾ�˵�
			    pop.show(event.clientX-1,event.clientY,width,rowCount*25,document.body);
			    return true;
			}
			function detail()
			{
			    location.href="<%=rootPath%>/detail/dispatcher.jsp?id=net"+node+"&flag=1";
			}
			function ping()
			{
				window.open("<%=rootPath%>/tool/ping.jsp?ipaddress="+ipaddress,"oneping", "height=400, width= 500, top=300, left=100");
				//window.open('/nms/netutil/ping.jsp?ipaddress='+ipaddress);
			}
			function traceroute()
			{
				window.open("<%=rootPath%>/tool/tracerouter.jsp?ipaddress="+ipaddress,"newtracerouter", "height=400, width= 500, top=300, left=100");
				//window.open('/nms/netutil/tracerouter.jsp?ipaddress='+ipaddress);
			}
			function telnet()
			{
				window.open('<%=rootPath%>/perform.do?action=telnet&ipaddress='+ipaddress,'onetelnet', 'height=0, width= 0, top=0, left= 0');
				//window.open('/nms/netutil/tracerouter.jsp?ipaddress='+ipaddress);
			}	
			function clickMenu()
			{
			}
		</script>
		<script type="text/javascript">
			var curpage= <%=jp.getCurrentPage()%>;
  			var totalpages = <%=jp.getPageTotal()%>;
  			var delAction = "<%=rootPath%>/perform.do?action=delete";
  			var listAction = "<%=rootPath%>/perform.do?action=monitornodelist";
  			
  			
  			
			function toAdd(){
				mainForm.action = "<%=rootPath%>/perform.do?action=ready_add";
				mainForm.submit();
			}
			  
			function doCancelManage(){  
     			mainForm.action = "<%=rootPath%>/perform.do?action=cancelmanage";
     			mainForm.submit();
	  		}
	  		
	  		function doQuery(){ 
	  			window.location.reload(true); 
  			}
  			
  			function doSearch(){  
				mainForm.action = "<%=rootPath%>/perform.do?action=monitornodelist";
     			mainForm.submit();
  			}
  			
  			function showCpu(id , ip){  
				CreateWindow("<%=rootPath%>/detail/net_cpu_month.jsp?id=" + 2 + "&ip=" +ip);
  			}
  			
  			function showMemery(type , id , ip){  
  			    if(type=="4"){
  			        CreateWindow("<%=rootPath%>/detail/host_memory_month.jsp?id=" + 2 + "&ip=" +ip);
  			    } else {
  			        CreateWindow("<%=rootPath%>/detail/net_memory_month.jsp?id=" + 2 + "&ip=" +ip);
  			    }
  			}
  			
  			function showPing(id , ip){  
				CreateWindow("<%=rootPath%>/detail/net_ping_month.jsp?id=" + 2 + "&ip=" +ip);
  			}
  			
  			function showFlux(id , ip){  
				CreateWindow("<%=rootPath%>/detail/net_flux_month.jsp?id=" + 2 + "&ip=" +ip);
  			}
  			
  			function CreateWindow(url){
				msgWindow=window.open(url,"protypeWindow","toolbar=no,width=850,height=450,directories=no,status=no,scrollbars=yes,menubar=no")
			}
			
			function showSort(fieldValue){  
				var field = document.getElementById('field');
				field.value = fieldValue;
				
				mainForm.action = "<%=rootPath%>/perform.do?action=monitornodelist";
     			mainForm.submit();
  			}
  			
  			//�����豸��ip��ַ
			function modifyIpAliasajax(ipaddress){
				var t = document.getElementById('ipalias'+ipaddress);
				var ipalias = t.options[t.selectedIndex].text;//��ȡ�������ֵ
				$.ajax({
						type:"GET",
						dataType:"json",
						url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=modifyIpAlias&ipaddress="+ipaddress+"&ipalias="+ipalias,
						success:function(data){
							window.alert("�޸ĳɹ���");
						}
					});
			}
			$(document).ready(function(){
				//$("#testbtn").bind("click",function(){
				//	gzmajax();
				//});
			//setInterval(modifyIpAliasajax,60000);
			});
			
			//��������
			var x;
			var y;
			/**********************************
			��ȡ����xy��ֵ
			**********************************/
			if (navigator.appName == 'Netscape')
			 {
				document.captureEvents(Event.MOUSEMOVE);
				document.onmousemove = netscapeMouseMove;
			}
			
			function netscapeMouseMove(e) {
				if (e.screenX != x && e.screenY != y)
				 {
					x = e.screenX;
					y = e.screenY;
				} 
			}
			
			function micro$oftMouseMove() {
				if (window.event.x != x && window.event.y != y){
					x = window.event.x;
					y = window.event.y;
				}
			}
			
			/**********************************************************
			�õ������ʵĽ�������ʽ���ַ���
			����:
				used��ʹ����
				unused:δʹ����
				color:��ʹ������ĸ澯������ɫ
			**********************************************************/
			function getPercentTableStr(used, unused ,color){
				var tableStr = '<table><tr><td>'+used+'%</td><td width=80><table height=15 width=\"100%\" border=1 bgcolor=#ffffff><tr><td width='+used+'% bgcolor='+color
					+'></td><td width='+unused+'% bgcolor=#ffffff ></td></tr></table></td><td>&nbsp;</td></table>';
				return tableStr;						                      					
			}
			
			/**********************************************************
			����ƶ���ip��ַ��֮����ʾ�豸����ϸ��ϢƯ������
			������
				�豸�����豸ID��ɵ��ַ���  ��net10  ��ʾidΪ10�������豸
			***********************************************************/
			function showDetailInfo(typeAndId){ 
				var htmlTable = '�������ڼ����У����Ժ�';
				var lay = document.getElementById('deviceDetailInfo');
				var detailType_flag = document.getElementById('detailTypeflag_'+typeAndId);
				var tt = getoffset(detailType_flag);
	           	var x = tt[1];
	           	var y = tt[0];
	           	lay.style.left = x+10;
	           	lay.style.top = y+10;
           		$.ajax({
					type:"POST",
					dataType:"json",
					data:"id="+typeAndId+"&nowtime="+(new Date()),
					url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=getDeviceDetailInfo",
					success:function(data){
					 	 if(data.result != null && data.result == "true"){
					 	 	//��ʾiframe��
					 	 	var cpuTableStr = getPercentTableStr(data.cpuvalue, data.cpuUnusedvalue, data.cpuValueColor);
					 	 	var memoryTableStr = getPercentTableStr(data.memoryvalue, data.memoryUnusedvalue, data.memoryValueColor);
							htmlTable = '<div><table cellspacing=\"2\" cellpadding=\"0\"><tr><td class=\'detailInfoHeadLeft\'>&nbsp;</td><td colspan=\'2\' class=\'detailInfoHead\'>'+data.deviceName+'</td></tr><tr><td class=\'detailInfoHeadLeft\'>&nbsp;</td><td>�豸IP��ַ��</td><td>'
								+data.ipaddress+'</td></tr><tr><td class=\'detailInfoHeadLeft\'>&nbsp;</td><td>�豸���</td><td>'
								+data.nodeType+'</td></tr><tr><td class=\'detailInfoHeadLeft\'>&nbsp;</td><td>ƽ����Ӧʱ�䣺</td><td>'+data.avgresponse+'ms</td></tr><tr><td class=\'detailInfoHeadLeft\'>&nbsp;</td><td>CPU�����ʣ�</td><td>'
								+cpuTableStr+'</td></tr><tr><td class=\'detailInfoHeadLeft\'>&nbsp;</td><td>�ڴ������ʣ�</td><td>'+memoryTableStr+'</td></tr></table></div>';
           					lay.innerHTML = htmlTable;
           					//var elmt = document.getElementById('detailType_'+typeAndId);
				           	lay.style.display = "block";
				           	
					 	 	var zindexDiv = document.getElementById('zindexDiv');
							zindexDiv.style.display = "block";
						}  
					}	
				});
			}
			
			/**********************************************************
			����ƶ���ip��ַ��֮�������豸����ϸ��ϢƯ������
			***********************************************************/
			function unShowDetailInfo(){
				var lay = document.getElementById('deviceDetailInfo');
				var zindexDiv = document.getElementById('zindexDiv');
				lay.style.display = "none";
				zindexDiv.style.display = "none";
			}
			
			/**********************************************************
			�õ�Ԫ�ص�ƫ������������
			**********************************************************/
			function getoffset(e){  
				var rec = new Array(1); 
				//rec[0]  = y - 40; 
				//rec[1] = x;
				var x = e.offsetLeft;
				var y = e.offsetTop;   
   				while(e = e.offsetParent){ 
       				x += e.offsetLeft;   
       				y += e.offsetTop; 
    			} 
    			rec[0]  = y - 40; 
				rec[1] = x + 60;
				return rec;
			} 
			
			/*******************************************************
			����� ,������ʾ��Ϣdiv
			******************************************************/
			document.onclick = function(){ 
				unShowDetailInfo();
			} 
			
		</script>
	</head>
	<%
		//System.out.println("======jp.getPageTotal()=====111======" + jp.getPageTotal());
	%>
	<!-- onMousemove="micro$oftMouseMove()" -->
	<body id="body" class="body"  leftmargin="0" topmargin="0" >
		<!-- ��������������Ҫ��ʾ���Ҽ��˵� -->
		<div id="itemMenu" style="display: none";>
		<table border="1" width="100%" height="100%" bgcolor="#F1F1F1"
			style="border: thin;font-size: 12px" cellspacing="0">
			<tr>
				<td style="cursor: default; border: outset 1;" align="center"
					onclick="parent.detail();">�鿴״̬</td>
			</tr>
			<tr>
				<td style="cursor: default; border: outset 1;" align="center"
					onclick="parent.ping();">ping</td>
			</tr>
			<tr>
				<td style="cursor: default; border: outset 1;" align="center"
					onclick="parent.traceroute()">traceroute</td>
			</tr>
			<tr>
				<td style="cursor: default; border: outset 1;" align="center"
					onclick="parent.telnet()">telnet</td>
			</tr>		
			<tr>
				<td style="cursor: default; border: outset 1;" align="center"
					onclick="parent.clickMenu()">�ر�</td>
			</tr>
		</table>
		</div>
		<!-- �Ҽ��˵�����-->
		<!-- ����ƶ���IP��ַ��֮���豸��ϸ -->
		<iframe id="zindexDiv" frameborder="0" ></iframe>
		<div id="deviceDetailInfo" class="detailInfo"></div>
		<div id="deviceDetailInfoTest" class="detailInfo"></div>
		<form id="mainForm" method="post" name="mainForm">
			<input type="hidden" id="flag" name="flag" value="<%=flag%>">
			<input type=hidden id="category" name="category" value="<%=category%>">
			<input type=hidden id="treeBid" name="treeBid" value="<%=treeBid%>">
			<table id="body-container" class="body-container" height="100%">
				<tr>
					<td class="td-container-main">
						<table id="container-main" class="container-main">
							<tr>
								<td class="td-container-main-content">
									<table id="container-main-content" class="container-main-content">
										<tr>
											<td>
												<table id="content-header" class="content-header">
								                	<tr>
									                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
									                	<td class="content-title">&nbsp;��Դ >> ���ܼ��� >> ���Ӷ���һ�� >> �豸�б� </td>
									                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
									       			</tr>
									        	</table>
		        							</td>
		        						</tr>
		        						<tr>
		        							<td>
		        								<table id="content-body" class="content-body">
		        									<tr>
														<td>
															<table>
																<tr>
													    			<td  class="body-data-title">
							    										<jsp:include page="../common/page.jsp">
																			<jsp:param name="curpage" value="<%=jp.getCurrentPage()%>"/>
																			<jsp:param name="pagetotal" value="<%=jp.getPageTotal()%>"/>
							  										 	</jsp:include>
							        								</td>
							        							</tr>
															</table>
														</td>
													</tr> 
													<tr>
														<td >
															<table>
																<tr>
																	<td class="body-data-title" style="text-align: left;" >
																	
																		&nbsp;
																		<B>��&nbsp;&nbsp;ѯ:</B>
							        									<SELECT name="key"> 
								          									<OPTION value="alias" selected>����</OPTION>
								          									<OPTION value="ip_address">IP��ַ</OPTION>
								          									<OPTION value="sys_oid">ϵͳOID</OPTION>          
								          									<OPTION value="type">�ͺ�</OPTION>
								          								</SELECT>&nbsp;<b>=</b>&nbsp; 
								          								<INPUT type="text" name="value" width="15" class="formStyle">
								          								<INPUT type="button" class="formStyle" value="��    ѯ" onclick=" return doSearch()">
								          							</td>            
																	<td class="body-data-title" style="text-align: right;">
																		<INPUT type="button" value="��    ��" onclick=" return toAdd()">
																		<INPUT type="button" value="ɾ    ��" onclick=" return toDelete()">
																		<INPUT type="button" value="ȡ������" onclick=" return doCancelManage()">
														                <INPUT type="button" value="ˢ    ��" onclick=" return doQuery()">
														                &nbsp;&nbsp;&nbsp;
											  						</td>
																</tr>
															</table>
											  			</td>
													</tr>
		        									<tr>
		        										<td>
		        											<table>
		        												<tr>
		        													<input type="hidden" id="field" name="field" value="<%=field%>">
		        													<input type="hidden" id="sorttype" name="sorttype" value="<%=sorttype%>"> 
		        													<td align="center" class="body-data-title" width="5%"><INPUT type="checkbox" id="checkall" name="checkall" onclick="javascript:chkall()">���</td>
		        													<td align="center" class="body-data-title" width="9%"><a href="#" onclick="showSort('name')">����</a><%=nameImg%></td>
		        													<td align="center" class="body-data-title" width="4%"><a href="#" onclick="showSort('category')">����</a><%=categoryImg%></td>
		        													<td align="center" class="body-data-title" width="10%"><a href="#" onclick="showSort('ipaddress')">IP��ַ</a><%=ipaddressImg%></td>
		        													<td align="center" class="body-data-title" width="6%"><a href="#" onclick="showSort('ping')">������</a><%=pingImg%></td>
		        													<td align="center" class="body-data-title" width="10%"><a href="#" onclick="showSort('cpu')">CPU(%)</a><%=cpuImg%></td>
		        													<td align="center" class="body-data-title" width="10%"><a href="#" onclick="showSort('memory')">�ڴ�(%)</a><%=memoryImg%></td>
		        													<td align="center" class="body-data-title" width="10%"><a href="#" onclick="showSort('swap')">�����ڴ�(%)</a><%=swapImg%></td>
		        													<!-- 
		        													<td align="center" class="body-data-title" width="12%"><a href="#" onclick="showSort('inutilhdx')">��������(KB/S)</a><%=inutilhdxImg%></td>
		        													<td align="center" class="body-data-title" width="12%"><a href="#" onclick="showSort('oututilhdx')">�������(KB/S)</a><%=oututilhdxImg%></td>
		        													
		        													 -->
		        													<%--<td align="center" class="body-data-title" width="10%">�澯</td> --%>
		        													<!--<td align="center" class="body-data-title" width="6%">�ӿ�����</td>   -->
		        													<td align="center" class="body-data-title" width="6%">�ɼ���ʽ</td>
		        													<td align="center" class="body-data-title" width="5%">����</td>
		        												</tr>
		        												<%
		        													if (list != null && list.size() > 0) {
		        														for (int i = 0; i < list.size(); i++) {
		        															MonitorNodeDTO monitorNodeDTO = (MonitorNodeDTO) list
		        																	.get(i);
		        															pingValue = monitorNodeDTO.getPingValue();
		        															cpuUsed = monitorNodeDTO.getCpuValue();
		        															cpuUnUsed = String.valueOf(100 - Double.valueOf(cpuUsed));
		        															memeryUsed = monitorNodeDTO.getMemoryValue();
		        															memeryUnUsed = String.valueOf(100 - Double
		        																	.valueOf(memeryUsed));
		        															String cpuValueColor = monitorNodeDTO.getCpuValueColor();
		        															String memeryValueColor = monitorNodeDTO
		        																	.getMemoryValueColor();
		        															String status = monitorNodeDTO.getStatus();
		        															
		        															//System.out.println("====color==="+monitorNodeDTO.getCpuValueColor()+"=="+monitorNodeDTO.getSwapmemorycolor()+"="+monitorNodeDTO.getMemoryValueColor());
		        															String statusImg = "";

		        															String swapColor = monitorNodeDTO.getSwapmemorycolor();
		        															String swapvalue = monitorNodeDTO.getSwapmemoryvalue();
		        															String Swapunuser="0";
		        															
		        															
		        															if(null!=swapvalue && "null"!=swapvalue)
		        																{
		        																
		        																
		        															 Swapunuser = String.valueOf(100 - Double.valueOf(swapvalue));
		        															// System.out.println("===========swap="+swapvalue);
		        																//System.out.println("===========Swapunuser="+Swapunuser);
		        																}else
		        																	{
		        																	Swapunuser="100";
		        																	swapvalue="0";
		        																	
		        																	// System.out.println("===========swap="+swapvalue);
				        															// System.out.println("===========Swapunuser="+Swapunuser);
		        																	}
		        															

		        															if ("1".equals(status)) {
		        																statusImg = "alarm_level_1.gif";
		        															} else if ("2".equals(status)) {
		        																statusImg = "alarm_level_2.gif";
		        															} else if ("3".equals(status)) {
		        																statusImg = "alert.gif";
		        															} else {
		        																statusImg = "status_ok.gif";
		        															}
		        															//Hashtable eventListSummary = monitorNodeDTO.getEventListSummary();
		        															//String generalAlarm = (String)eventListSummary.get("generalAlarm");
		        															//String urgentAlarm = (String)eventListSummary.get("urgentAlarm");
		        															//String seriousAlarm = (String)eventListSummary.get("seriousAlarm");
		        															//System.out.println("==============1441");
		        												%>
					        									            <tr <%=onmouseoverstyle%>>
						        									            <td align="center" class="body-data-list"><INPUT type="checkbox" id="checkbox" name="checkbox" value="<%=monitorNodeDTO.getId()%>"><%=jp.getStartRow() + i%></td>
					        													<td align="left" class="body-data-list">
					        														<img src="<%=rootPath%>/resource/image/topo/<%=statusImg%>">&nbsp;
					        														<a href="<%=rootPath%>/detail/dispatcher.jsp?id=net<%=monitorNodeDTO.getId()%>&flag=1" >
					        															<span id='detailType_net<%=monitorNodeDTO.getId()%>'>
					        																<%=monitorNodeDTO.getAlias()%>
					        															</span>
					        															<span id='detailTypeflag_net<%=monitorNodeDTO.getId()%>'></span><%-- ��ʾ��Ϣ����ı�־λ��--%>
					        														</a>
					        														<!-- <a href="<%=rootPath%>/detail/dispatcher.jsp?id=net<%=monitorNodeDTO.getId()%>&flag=1" >
					        															<span id='detailType_net<%=monitorNodeDTO.getId()%>' onmouseover="showDetailInfo('net<%=monitorNodeDTO.getId()%>')" onmouseout="unShowDetailInfo();">
					        																<%=monitorNodeDTO.getAlias()%>
					        															</span>
					        															<span id='detailTypeflag_net<%=monitorNodeDTO.getId()%>'></span><%-- ��ʾ��Ϣ����ı�־λ��--%>
					        														</a>
					        														 -->
					        													</td>
					        													<td align="center" class="body-data-list"><%=monitorNodeDTO.getCategory()%></td>
					        													<td align="left" class="body-data-list">
					        														<table>
													                      				<tr>
													                      					<td>  
								        														<select  class="selectCss" name="ipalias<%=monitorNodeDTO.getIpAddress()%>">
														                  							<option selected><%=monitorNodeDTO.getIpAddress()%></option>
														                  							<%
														                  								IpAliasDao ipdao = new IpAliasDao();
														                  										List iplist = ipdao.loadByIpaddress(monitorNodeDTO
														                  												.getIpAddress());
														                  										ipdao.close();
														                  										ipdao = new IpAliasDao();
														                  										IpAlias ipalias = ipdao.getByIpAndUsedFlag(monitorNodeDTO
														                  												.getIpAddress(), "1");
														                  										ipdao.close();
														                  										if (iplist == null)
														                  											iplist = new ArrayList();
														                  										for (int j = 0; j < iplist.size(); j++) {
														                  											IpAlias voTemp = (IpAlias) iplist.get(j);
														                  							%>
									      																				<option <%if (ipalias != null
								&& ipalias.getAliasip().equals(
										voTemp.getAliasip())) {%>selected<%}%>><%=voTemp.getAliasip()%></option>
									       															<%
									       																}
									       															%>
									       														</select>
									       													</td>
									       													<td>&nbsp;</td>
									       													<td>
								                    											<img href="#" src="<%=rootPath%>/resource/image/menu/xgmm.gif" style="cursor:hand" onclick="modifyIpAliasajax('<%=monitorNodeDTO.getIpAddress()%>');"/>
                    																		</td>
                    																	</tr>
												                      				</table> 
                    															</td>
					        													<td align="center" class="body-data-list">
					        														<table>
													                      				<tr>
													                      					<td align="center" width="50%"><%=pingValue%>%</td>
													                      					<td align="center" width="50%"><img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showPing("<%=monitorNodeDTO.getId()%>" , "<%=monitorNodeDTO.getIpAddress()%>")' width=15></td>
													                      				</tr>
												                      				</table>
					        													</td>
					        													<td align="center" class="body-data-list">
					        														<table>
													                      				<tr>
													                      					<td><%=cpuUsed%>%</td>
													                      					<td width=150>
													                      						<table border=1 height=15 width="100%" bgcolor=#ffffff>
																                      				<tr>
																                      					<td width="<%=cpuUsed%>%" bgcolor="<%=cpuValueColor%>"></td>
																                      					<td width="<%=cpuUnUsed%>%" bgcolor=#ffffff></td>
																                      				</tr>
															                      				</table>
													                      					</td>
													                      					<td><img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showCpu("<%=monitorNodeDTO.getId()%>" , "<%=monitorNodeDTO.getIpAddress()%>")' width=15></td>
													                      				</tr>
												                      				</table>
					        													</td>
					        													<td align="center" class="body-data-list" >
					        														<table>
													                      				<tr>
													                      					<td><%=memeryUsed%>%</td>
													                      					<td width=150>
													                      						<table border=1 height=15 width="100%" bgcolor=#ffffff>
																                      				<tr>
																                      					<td width="<%=memeryUsed%>%" bgcolor="<%=memeryValueColor%>"></td>
																                      					<td width="<%=memeryUnUsed%>%" bgcolor=#ffffff></td>
																                      				</tr>
															                      				</table>
													                      					</td>
													                      					<td><img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showMemery("<%=monitorNodeDTO.getSubtype()%>" , "<%=monitorNodeDTO.getId()%>" , "<%=monitorNodeDTO.getIpAddress()%>")' width=15></td>
													                      				</tr>
												                      				</table>
					        													</td>
					        													
					        														<td align="center" class="body-data-list" >
					        														<table>
													                      				<tr>
													                      					<td><%=swapvalue%>%</td>
													                      					<td width=150>
													                      						<table border=1 height=15 width="100%" bgcolor=#ffffff>
																                      				<tr>
																                      					<td width="<%=swapvalue%>%" bgcolor="<%=swapColor%>"></td>
																                      					<td width="<%=Swapunuser%>%" bgcolor=#ffffff></td>
																                      				</tr>
															                      				</table>
													                      					</td>
													                      					<td><img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showMemery("<%=monitorNodeDTO.getSubtype()%>" , "<%=monitorNodeDTO.getId()%>" , "<%=monitorNodeDTO.getIpAddress()%>")' width=15></td>
													                      				</tr>
												                      				</table>
					        													</td>
					        													<!--  
					        													<td align="center" class="body-data-list">
					        														<table>
													                      				<tr>
													                      					<td align="center" width="50%"><%=monitorNodeDTO.getInutilhdxValue()%></td>
													                      					<td align="center" width="50%"><img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showFlux("<%=monitorNodeDTO.getId()%>" , "<%=monitorNodeDTO.getIpAddress()%>")' width=15></td>
													                      				</tr>
												                      				</table>
					        													</td>
					        													<td align="center" class="body-data-list">
					        														<table>
													                      				<tr>
													                      					<td align="center" width="50%"><%=monitorNodeDTO.getOututilhdxValue()%></td>
													                      					<td align="center" width="50%"><img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showFlux("<%=monitorNodeDTO.getId()%>" , "<%=monitorNodeDTO.getIpAddress()%>")' width=15></td>
													                      				</tr>
												                      				</table></td>
												                      				
												                      				-->
					        													<%-- <td align="center" class="body-data-list">
					        														<table>
													                      				<tr>
													                      					<td align="center">
													                      						<table border=1 height=15 bgcolor=#ffffff>
																                      				<tr>
																                      					<td width="30%" bgcolor="#ffff00" align="center"><%=generalAlarm%></td>
																                      					<td width="30%" bgcolor="orange" align="center"><%=urgentAlarm%></td>
																                      					<td width="30%" bgcolor="#ff0000" align="center"><%=seriousAlarm%></td>
																                      				</tr>
															                      				</table>
													                      					</td>
													                      				</tr>
												                      				</table>
					        													</td>--%>
					        													<!--  <td align="center" class="body-data-list"><%=monitorNodeDTO.getEntityNumber()%></td> --> 
					        													<td align="center" class="body-data-list"><%=monitorNodeDTO.getCollectType()%></td>
					        													<td align="center" class="body-data-list">
																					<img src="<%=rootPath%>/resource/image/status.gif" border="0" width=15 oncontextmenu=showMenu('2','<%=monitorNodeDTO.getId()%>','<%=monitorNodeDTO.getIpAddress()%>') alt="�Ҽ�����">
																				</td>
				        													</tr>
					        									            <%
					        									            	}
					        									            	}
					        									            %>
		        											</table>
		        										</td>
		        									</tr>
		        								</table>
		        							</td>
		        						</tr>
		        						<tr>
		        							<td>
		        								<table id="content-footer" class="content-footer">
		        									<tr>
		        										<td>
		        											<table width="100%" border="0" cellspacing="0" cellpadding="0">
									                  			<tr>
									                    			<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
									                    			<td></td>
									                    			<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
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
					</td>
				</tr>
			</table>
		</form>
		<script type="text/javascript">
		
			// Create the tooltips only on document load
			/**
			var corners = 'bottomLeft';   
			var opposites = 'topMiddle';     
			function showDetailInfo(nodeId){
		      //ajax�첽��ȡ�豸����ϸ��Ϣ
		      var htmlTable = '<div><table><tr><td>���ݼ�����...</td></tr></table></div>';
		      
		      $.ajax({
				type:"POST",
				dataType:"json",
				data:"id="+nodeId+"&nowtime="+(new Date()),
				url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=getDeviceDetailInfo",
				success:function(data){
				 	 if(data.result == "true"){ 
						alert(data.ipaddress);
						htmlTable = '<div><table><tr><td>'+data.nodeType+'</td><td>'+data.ipaddress+'</td></tr></table></div>';
					}
				 }	
			});
			alert($("#detailType_"+nodeId));
	      $("#detailType_"+nodeId).qtip({                    
	        content: '<div><table><tr><td>���ݼ�����...</td></tr></table></div>',        
	        position: {              
	          corner: {              
	            tooltip: corners,    
	            target: opposites    
	          },
	          adjust: {   
          		screen: true  
	          }                        
	        },                       
	        show: {                  
	          when: false,           
	          ready: true,
	          solo: true  
	        },                       
	        hide: 'mouseout',  
	        style: {                 
	          border: {              
	            width: 5,            
	            radius: 10           
	          },                     
	          padding: 10,           
	          textAlign: 'center',   
	          tip: true,             
	          name: 'light'
	        }                       
	      });                      
		} */  
	</script>
	</body>
</html>