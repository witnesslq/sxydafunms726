package com.afunms.polling.snmp.temperature;

/*
 * @author yangjun@dhcc.com.cn
 *
 */

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import com.afunms.common.util.ShareData;
import com.afunms.common.util.SnmpUtils;
import com.afunms.indicators.model.NodeGatherIndicators;
import com.afunms.monitor.executor.base.SnmpMonitor;
import com.afunms.monitor.item.base.MonitoredItem;
import com.afunms.polling.PollingEngine;
import com.afunms.polling.base.Node;
import com.afunms.polling.node.Host;
import com.afunms.polling.om.Interfacecollectdata;
import com.afunms.topology.model.HostNode;
import com.gatherResulttosql.NetDatatempTemperatureRtosql;
import com.gatherResulttosql.NetTemperatureResultTosql;


/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class CiscoIronportTemperatureSnmp extends SnmpMonitor {
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	/**
	 * 
	 */
	public CiscoIronportTemperatureSnmp() {
	}

	   public void collectData(Node node,MonitoredItem item){
		   
	   }
	   public void collectData(HostNode node){
		   
	   }
	/* (non-Javadoc)
	 * @see com.dhcc.webnms.host.snmp.AbstractSnmp#collectData()
	 */
	public Hashtable collect_Data(NodeGatherIndicators alarmIndicatorsNode) {
		Hashtable returnHash=new Hashtable();
		Vector temperatureVector=new Vector();
		Host node = (Host)PollingEngine.getInstance().getNodeByID(Integer.parseInt(alarmIndicatorsNode.getNodeid()));
		if(node == null)return null;
		try {
			Interfacecollectdata interfacedata = new Interfacecollectdata();
			Calendar date=Calendar.getInstance();
			Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(node.getIpAddress());
			if(ipAllData == null)ipAllData = new Hashtable();
			
			  try{
				  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				  com.afunms.polling.base.Node snmpnode = (com.afunms.polling.base.Node)PollingEngine.getInstance().getNodeByIP(node.getIpAddress());
				  Date cc = date.getTime();
				  String time = sdf.format(cc);
				  snmpnode.setLastTime(time);
			  }catch(Exception e){
				  
			  }
			  try {
				  //-------------------------------------------------------------------------------------------温度 start
		   		  if(node.getSysOid().startsWith("1.3.6.1.4.1.15497.")){
		   			String[][] valueArray = null;
		   			String[] oids =                
						  new String[] {               
							"1.3.6.1.4.1.15497.1.1.1.9.1.3",//温度描述
							"1.3.6.1.4.1.15497.1.1.1.9.1.2",//温度
							"1.3.6.1.4.1.15497.1.1.1.9.1.1"//索引
		   			};
		   			valueArray = SnmpUtils.getTemperatureTableData(node.getIpAddress(), node.getCommunity(), oids, node.getSnmpversion(), 3, 1000);
					if(valueArray != null){
					   	  for(int i=0;i<valueArray.length;i++)
					   	  {
					   		String _value = valueArray[i][1];
					   		String index = valueArray[i][2];
					   		String desc = valueArray[i][0];
					   		int value=0;
					   		
							//allvalue = allvalue+Integer.parseInt(_value);
							if(_value != null){
								value=Integer.parseInt(_value);
								if(value > 0){
									//flag = flag +1;
							   		List alist = new ArrayList();
							   		alist.add(index);
							   		alist.add(_value);
							   		alist.add(desc);
							   		//内存
							   		  //temperatureList.add(alist);				   		
							   		  interfacedata = new Interfacecollectdata();
							   		  interfacedata.setIpaddress(node.getIpAddress());
							   		  interfacedata.setCollecttime(date);
							   		  interfacedata.setCategory("Temperature");
							   		  interfacedata.setEntity(index);
							   		  interfacedata.setSubentity(desc);
							   		  interfacedata.setRestype("dynamic");
							   		  interfacedata.setUnit("度");		
							   		  interfacedata.setThevalue(_value+"");
									  //SysLogger.info(node.getIpAddress()+" 温度： "+_value);
									  temperatureVector.addElement(interfacedata);	
								}
							}
					   		//SysLogger.info(host.getIpAddress()+"  "+index+"   value="+value);
					   	  }
					}
		   		  } 
		   	  }
		   	  catch(Exception e)
		   	  {
		   	  }	   	  
		   	  //-------------------------------------------------------------------------------------------温度 end
			}catch(Exception e){
			}
		
//		Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(node.getIpAddress());
//		if(ipAllData == null)ipAllData = new Hashtable();
//		ipAllData.put("temperature",temperatureVector);
//	    ShareData.getSharedata().put(node.getIpAddress(), ipAllData);
//	    returnHash.put("temperature", temperatureVector);
			if (!(ShareData.getSharedata().containsKey(node.getIpAddress()))) {
				Hashtable ipAllData = new Hashtable();
				if (ipAllData == null) ipAllData = new Hashtable();
				if (temperatureVector != null && temperatureVector.size() > 0) ipAllData.put("temperature", temperatureVector);
					ShareData.getSharedata().put(node.getIpAddress(), ipAllData);
			} else{
				if (temperatureVector != null && temperatureVector.size() > 0) ((Hashtable) ShareData.getSharedata().get(node.getIpAddress())) .put("temperature", temperatureVector);
			}	
			returnHash.put("temperature",temperatureVector);	
//	    ipAllData=null;
	    temperatureVector=null;
	    
//	  把采集结果生成sql
	    NetTemperatureResultTosql tosql=new NetTemperatureResultTosql();
	    tosql.CreateResultTosql(returnHash, node.getIpAddress());
	    NetDatatempTemperatureRtosql temptosql=new NetDatatempTemperatureRtosql();
	    temptosql.CreateResultTosql(returnHash, node);
	    return returnHash;
	}
}





