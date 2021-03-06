<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="com.afunms.config.dao.IpaddressPanelDao"%>
<%@page import="com.afunms.config.model.IpaddressPanel"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@page import="com.afunms.config.dao.PanelModelDao"%>
<%@page import="com.afunms.config.model.PanelModel"%>
<%@page import="com.afunms.topology.model.HostNode"%>
<%@page import="com.afunms.topology.dao.HostNodeDao"%>
<%
  String rootPath = request.getContextPath();
  String myip = request.getParameter("myip");
  String myport = request.getParameter("myport");
  String myUser = request.getParameter("myUser");
  String myPassword = request.getParameter("myPassword");
  String mysid = request.getParameter("sid");
  String id = request.getParameter("id");
  String dbPage = request.getParameter("dbPage");
  String subtype = request.getParameter("subtype");
  String toolsubtype = "";
  String nodeid = id;
  if(subtype.equals("Oracle")){
  	nodeid = mysid;
  	toolsubtype = "oracle";
  }else{
  	toolsubtype = subtype;
  }
%>
			<table class="tool-bar">
				<tr>
					<td>
						<table class="tool-bar-header">
		                	<tr>
			                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
			                	<td class="tool-bar-title">工具</td>
			                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
			       			</tr>
			        	</table>
					</td>
				</tr>
				<tr>
					<td>
						<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
											
												<ul>
													<li><img src="<%=rootPath%>/resource/image/toolbar/ping.gif">&nbsp;<a href="javascript:void(null)" onClick='window.open("<%=rootPath%>/oracle.do?action=isOracleOK&id=<%=id%>&myip=<%=myip %>&myport=<%=myport %>&myUser=<%=myUser %>&myPassword=<%=myPassword %>&sid=<%=mysid %>","oneping", "height=400, width= 500, top=300, left=100")'>可用性检测</a></li>
													<li><img src="<%=rootPath%>/resource/image/menu/stbj.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/DBQueryServlet?id=<%=id%>&myip=<%=myip %>&myport=<%=myport %>&myUser=<%=myUser %>&myPassword=<%=myPassword %>&sid=<%=mysid %>","exesql", "height=600, width= 800, top=300, left=100")'>SQL执行工具</a></li>
													<!-- <li><img src="<%=rootPath%>/resource/image/toolbar/ping.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/oracle.do?action=sychronizeData&dbPage=<%=dbPage %>&id=<%=id %>&myip=<%=myip %>&myport=<%=myport %>&myUser=<%=myUser %>&myPassword=<%=myPassword %>&sid=<%=mysid %>","oneping", "height=400, width= 500, top=300, left=100")'>数据同步</a></li> -->
													<li><img src="<%=rootPath%>/resource/image/topo/button_refresh_bg.gif">&nbsp;<a href="#"  id="process" >数据同步</a></li>
													
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table class="detail-content-footer">
							<tr>
								<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
             					<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table class="tool-bar">
				<tr>
					<td>
						<table class="tool-bar-header">
		                	<tr>
			                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
			                	<td class="tool-bar-title">性能监视配置</td>
			                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
			       			</tr>
			        	</table>
					</td>
				</tr>
				<tr>
					<td>
						<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/toolbar/jszbfzpz.gif" border=0>&nbsp;
													<a href="javascript:void(null)" onClick='window.open("<%=rootPath%>/nodeGatherIndicators.do?action=list&nodeid=<%=nodeid%>&type=db&subtype=<%=toolsubtype%>","oneping", "height=600, width= 1000, top=300, left=100,scrollbars=yes")'>性能监视项配置</a></li>
													<li><img src="<%=rootPath%>/resource/image/toolbar/jszbfzpz.gif">&nbsp;
													<a href="javascript:void(null)" onClick='window.open("<%=rootPath%>/alarmIndicatorsNode.do?action=list&nodeid=<%=nodeid%>&type=db&subtype=<%=toolsubtype%>","oneping", "height=600, width= 1000, top=300, left=100,scrollbars=yes")'>监视指标阀值配置</a></li>
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table class="detail-content-footer">
							<tr>
								<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
             										<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
							</tr>
							
						</table>
					</td>
				</tr>
			</table>
			
			<table class="tool-bar">
				<tr>
					<td>
						<table class="tool-bar-header">
		                	<tr>
			                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
			                	<td class="tool-bar-title">报表管理</td>
			                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
			       			</tr>
			        	</table>
					</td>
				</tr>
				<tr>
					<td><%if(subtype.equalsIgnoreCase("Oracle")){%>
						<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/oracle.do?action=dboraReportdownusable&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>可用性报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/oracle.do?action=dbReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>性能报表</a></li><!-- jhl add -->
													<!--  <li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("#","onetelnet", "height=0, width= 0, top=0, left= 0")'>配置报表</a></li> -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/oracle.do?action=oracleCldReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>综合报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/oracle.do?action=oracleManagerEventReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>事件报表</a></li>
												</ul>
												
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} else if(subtype.equalsIgnoreCase("SQLServer")){ %>
						<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sqlserver.do?action=SqlServerManagerRep&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>可用性报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sqlserver.do?action=SqlServerManagerNatureRep&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>性能报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sqlserver.do?action=SqlServerManagerCldRep&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>综合报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sqlserver.do?action=SqlServerManagerEventReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>事件报表</a></li>
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} else if(subtype.equalsIgnoreCase("MySql")){%>
							<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/mysql.do?action=mysqlManagerPingReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>可用性报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/mysql.do?action=mysqlManagerNatureReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>性能报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/mysql.do?action=mysqlManagerCldReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>综合报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/mysql.do?action=mysqlManagerEventReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>事件报表</a></li>
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} else if(subtype.equalsIgnoreCase("DB2")){ %>
							<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/db2.do?action=db2ManagerPingReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>可用性报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/db2.do?action=db2ManagerNatureReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>性能报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/db2.do?action=db2ManagerCldReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>综合报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/db2.do?action=db2ManagerEventReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>事件报表</a></li>
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} else if(subtype.equalsIgnoreCase("Sybase")) {%>
						<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sybase.do?action=sybaseManagerPingReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>可用性报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sybase.do?action=sybaseManagerNatureReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>性能报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sybase.do?action=sybaseManagerCldReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>综合报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/sybase.do?action=sybaseManagerEventReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>事件报表</a></li>
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} else if(subtype.equalsIgnoreCase("Informix")) {%>
						<table class="tool-bar-body">
							<tr>
								<td>
									<table class="tool-bar-body-list">
										<tr>
											<td>
												<ul>
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/informix.do?action=informixManagerPingReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>可用性报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/informix.do?action=informixManagerNatureReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>性能报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/informix.do?action=informixManagerCldReport&ipaddress=<%=myip%>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>综合报表</a></li><!-- jhl add -->
													<li><img src="<%=rootPath%>/resource/image/menu/ywbb.gif">&nbsp;<a href="#" onClick='window.open("<%=rootPath%>/informix.do?action=informixManagerEventReport&ipaddress=<%=myip%>&id=<%=id %>","portScanWindow","width=800,height=470,scrollbars=yes,resizable=yes")'>事件报表</a></li>
												</ul>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} %>
					</td>
				</tr>
				<tr>
					<td>
						<table class="detail-content-footer">
							<tr>
								<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
             					<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>