package com.gathertask.dao;


import java.sql.ResultSet;
import java.util.Hashtable;
import org.apache.log4j.Logger;

import com.afunms.indicators.model.NodeGatherIndicators;
import com.database.DBManager;
import com.database.config.SystemConfig;






public class Taskdao {
	
	
	Logger logger=Logger.getLogger(Taskdao.class);
	

	/**
	 * 获取需要采集的采集指标
	 * 当agentid 的id为自然数的时候，就人物是agent的模式采集，
	 * 当agent的id为-1 的时候
	 * @return 采集的任务列表
	 */
	public Hashtable GetRunTaskList()
	{
		
		
		String sql="select b.* from topo_host_node a ,nms_gather_indicators_node b where a.id=b.nodeid and a.managed=1 and b.classpath like 'com%'";
		
		//Agent模式
		int agentid=-1;
		String Systemtype=SystemConfig.getConfigInfomation("Agentconfig", "Systemtype");
		
		
		if(Systemtype.trim().equals("agent"))
		{//agent 采集机器
           
			
			try{
				agentid=Integer.parseInt(SystemConfig.getConfigInfomation("Agentconfig", "AGENTID"));
				
			}catch(Exception e)
			{
				//agentid=-1;
			}
			sql="select b.* from topo_host_node a ,nms_gather_indicators_node b ,nms_node_agent c where a.id=b.nodeid and a.managed=1 and b.classpath like 'com%' and c.nodeid=b.nodeid and c.agentid='"+agentid+"'";
			System.out.println("===agent="+agentid);		
			
		}else if(Systemtype.trim().equals("standalone"))
		{//standalone 单机版本
			
		   sql="select b.* from topo_host_node a ,nms_gather_indicators_node b where a.id=b.nodeid and a.managed=1 and b.classpath like 'com%'";
		}else if(Systemtype.trim().equals("webserver"))
		  {//webserver 界面服务不做人物采集
			
			sql="";
		  }
		
		
		DBManager manager=null;
		Hashtable list=new Hashtable();
		if(sql.trim().length()>0)
		{
		try {
			manager=new DBManager();

			
			ResultSet rs =manager.executeQuery(sql);
			//list=manager.executeQuerykeyoneListHashMap(sql, "id");
			while (rs.next()) {
				NodeGatherIndicators nodeGatherIndicators = new NodeGatherIndicators();
				nodeGatherIndicators.setId(rs.getInt("id"));
				nodeGatherIndicators.setNodeid(rs.getString("nodeid"));
				nodeGatherIndicators.setName(rs.getString("name"));
				nodeGatherIndicators.setType(rs.getString("type"));
				nodeGatherIndicators.setSubtype(rs.getString("subtype"));
				nodeGatherIndicators.setAlias(rs.getString("alias"));
				nodeGatherIndicators.setDescription(rs.getString("description"));
				nodeGatherIndicators.setCategory(rs.getString("category"));
				nodeGatherIndicators.setIsDefault(rs.getString("isDefault"));
				nodeGatherIndicators.setIsCollection(rs.getString("isCollection"));
				nodeGatherIndicators.setPoll_interval(rs.getString("poll_interval"));
				nodeGatherIndicators.setInterval_unit(rs.getString("interval_unit"));
				nodeGatherIndicators.setClasspath(rs.getString("classpath"));
				list.put(rs.getInt("id")+"", nodeGatherIndicators);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		}finally{
			
			
			if(manager!=null)
				manager.close();
		}
		}
		//logger.info(list.toString());
		
		return list;	
	}
	
	
	
	
	public static void main(String[] arg)
	{
		
		Taskdao dao=new Taskdao();
		Hashtable table=new Hashtable();
		table=dao.GetRunTaskList();
		dao.logger.info(table);
		
	}

		
}
