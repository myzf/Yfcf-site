## auditAction.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.action;

import java.util.Date;
import java.util.Map;

import com.ibm.gbs.ai.portal.framework.server.context.BeanHolder;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.exception.BizException;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

import cn.com.yto56.coresystem.module.business.stlcommon.action.StlCommonAction;
import cn.com.yto56.coresystem.module.business.stlexporter.StlExporterExecutor;
import cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.INewEffectiveCheckBillAuditBiz;
import cn.com.yto56.coresystem.module.commons.stl.util.DateUtil;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;


/**
* 账单审核
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public class ${entityName}BillAuditAction extends StlCommonAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 注入i${entityName}BillAuditBiz
	 */
	private I${entityName}BillAuditBiz i${entityName}BillAuditBiz;
	
	/**
	 * 开始时间
	 */
	private String beginTime;
	/**
	 * 结束时间
	 */
	private String overTime;
	
	/**
	 * 审核界面初始化
	 * @return
	 */
	public String initStart(){
		return SUCCESS;
	}
	
	/**
	 * 审核界面 ----账单查询
	 * @author  ${authorName}
	 * @date ${.now?string('yyyy/MM/dd')}
	 * @return
	 */
	public String searchBill(){
		if (searchFields == null || searchFields.size() == 0) {
			return AJAX_RETURN_TYPE;
		}
		//生成或审核时间选项选中  不为空，判断时间是否大于31天
		if (StringUtils.isNotEmpty((searchFields.get("queryPar")))) {
		if(searchFields.get("queryPar").equals("0")){
			if(StringUtils.isNotBlank(searchFields.get("startDate")) && StringUtils.isNotBlank(searchFields.get("endDate"))){
				Date startDate = DateUtils.convert(StringUtils.trim(searchFields.get("startDate")));
				Date endDate = DateUtils.convert(StringUtils.trim(searchFields.get("endDate")));
				long days = DateUtil.DateSubtract(startDate, endDate);//获取时间天数
				if (days > 31) {
					addActionError("对不起，只能查询31天内的明细数据！");
					return ERROR;
				}
			}else{
				return AJAX_RETURN_TYPE;
			}
		  } 
		
		}else{
			return AJAX_RETURN_TYPE;
		}
		//业务处理
		Page<TStlEffectiveCheckBill> result = (Page<TStlEffectiveCheckBill>) i${entityName}BillAuditBiz.searchBill(queryPage, searchFields, getCurrentUser());
		setResult(result);
		return AJAX_RETURN_TYPE;
	}

	/**
	 * 
	 * @Desc 账单审核 Action
	 * @return String
	 * @author ${authorName}
	 * @date ${.now?string('yyyy/MM/dd')}
	 */
	public String auditStl${entityName}BillN() {
		message = "success";
		if (StringUtils.isNotEmpty(beginTime)&&StringUtils.isNotEmpty(overTime)) {
			searchFields.put("startTime", beginTime);
			searchFields.put("endTime", overTime);
			try{
				//账单审核业务处理
				i${entityName}BillAuditBiz.auditStl${entityName}Bill(searchFields, getCurrentUser(),orgCodes);
			}catch(BizException e){
				message = e.getMessage();//错误信息返回
			}   
		}else {
			if (StringUtils.isNotEmpty(beginTime)) {
				message = "false1";
			}else if (StringUtils.isNotEmpty(overTime)) {
				message = "false2";
			}
		}
		return AJAX_RETURN_TYPE;
	}

	/**
	 * 审核界面 ---账单导出
	 */
	public String export(){
		logger.trace("entering AutoCollectBillAudit export ...");
	    try {
	      StlExporterExecutor exporterExecutor = (StlExporterExecutor) BeanHolder.getBean("stlExporterExecutor");
	      exportSetting.setModule("STL");
	        exportSetting.setFileName("新绩效考核结算账单审核情况表");
	        exporterExecutor.exportAsync(iNewEffectiveCheckBillAuditBiz, new Object[] {exportSetting, searchFields, 
	                this.getCurrentUser()}, INewEffectiveCheckBillAuditBiz.class, "searchBill", 
	                new Class<?>[]{QueryPage.class, Map.class, IUser.class});
	    } catch (Exception e) {
	      logger.error("导出异常：", e);
	      return ERROR;
	    }
		return ASYNC_EXPORT;
	}
	
	
	public String getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	public String getOverTime() {
		return overTime;
	}

	public void setOverTime(String overTime) {
		this.overTime = overTime;
	}

	public I${entityName}BillAuditBiz geti${entityName}BillAuditBiz() {
		return i${entityName}BillAuditBiz;
	}

	public void seti${entityName}BillAuditBiz(
			I${entityName}BillAuditBiz i${entityName}BillAuditBiz) {
		this.i${entityName}BillAuditBiz = i${entityName}BillAuditBiz;
	}
}
```

## auditdao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;

/**
* 账单审核Dao
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public interface I${entityName}BillAuditDao {
	
	/**
	 * 审核页面 查询账单
	 * @param queryPage
	 * @param searchFields
	 * @param user
	 * @return
	 */
	 public IPage<TStlEffectiveCheckBill> searchBill(QueryPage queryPage, Map<String,String> searchFields, IUser user);
}

```

## auditjdbcdao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Date;



/**
* 账单审核JDBC
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public interface I${entityName}BillAuditJdbcDao {
	
	int get${entityName}Bill(Date startDate, Date endDate,String feeType);

}

```


## auditdaoimpl.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import cn.com.yto56.coresystem.module.commons.stl.constants.StlConst;
import cn.com.yto56.coresystem.module.commons.stl.dto.UserRoleHelper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.INewEffectiveCheckBillAuditDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;

import com.ibm.gbs.ai.portal.framework.server.dao.hibernate.BaseEntityDao;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnType;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.PageFooterColumn;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

/**
* 账单审核Dao实现类
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class ${entityName}BillAuditDaoImpl extends BaseEntityDao<TStlEffectiveCheckBill> implements I${entityName}BillAuditDao {

	/**
	 * 查询审核账单数据
	 */
	@Override
	public IPage<TStlEffectiveCheckBill> searchBill(QueryPage queryPage, Map<String, String> searchFields, IUser user) {
		StringBuffer sql = new StringBuffer();//sql
	    List<Object> args = new ArrayList<Object>();
	    List<ColumnType> scallarList = new ArrayList<ColumnType>();
	    sql.append(" SELECT "); 
	    sql.append(" T.ID as  id ,"); 
	    sql.append(" T.BILL_NO as billNo,  "); 
	    sql.append(" T.SETTLE_ORG_CODE as  settleOrgCode ,"); 
	    sql.append(" T.SETTLE_ORG_NAME as  settleOrgName ,"); 
	    sql.append(" T.BILL_AMOUNT as  billAmount ,"); 
	    sql.append(" T.BILL_START_TIME as  billStartTime ,"); 
	    sql.append(" T.BILL_END_TIME as billEndTime  ,"); 
	    sql.append(" T.BILL_CREATE_TIME as  billCreateTime ,"); 
	    sql.append(" T.BILL_CREATE_EMP_NO as billCreateEmpNo  ,"); 
	    sql.append(" T.BILL_CREATE_EMP_NAME as  billCreateEmpName ,"); 
	    sql.append(" T.BILL_CREATE_ORG_CODE as billCreateOrgCode  ,"); 
	    sql.append(" T.BILL_CREATE_ORG_NAME as billCreateOrgName  ,"); 
	    sql.append(" T.BILL_AUDIT_TIME as  billAuditTime ,"); 
	    sql.append(" T.BILL_AUDIT_EMP_NO as  billAuditEmpNo ,"); 
	    sql.append(" T.BILL_AUDIT_EMP_NAME as  billAuditEmpName ,"); 
	    sql.append(" T.BILL_AUDIT_ORG_CODE as billAuditOrgCode  ,"); 
	    sql.append(" T.BILL_AUDIT_ORG_NAME as billAuditOrgName  ,"); 
	    sql.append(" T.AUDIT_FLAG as auditFlg  ,"); 
	    sql.append(" T.SETTLE_ORG_TYPE as settleOrgType  ,"); 
	    sql.append("  T.RPT_DATE as  rptDate "); 
	    sql.append("   FROM YTSTL.T_STL_BILL_AGING_ASSESS T     ");                                       
		sql.append( " WHERE  1=1 " );
		
		  String temp = StringUtils.trim(searchFields.get("dateType"));
		  	//账单生成时间
		    if (temp.equals("1")) {
		    	if (StringUtils.isNotEmpty(searchFields.get("startDate"))) {
		    		Date startDate = DateUtils.convert(searchFields.get("startDate"));
		    		sql.append(" AND T.BILL_CREATE_TIME	 >= ? ");
		    		args.add(startDate);
				}
				if (StringUtils.isNotEmpty(searchFields.get("endDate"))) {
					Date endDate = DateUtils.getEndTimeAdd(DateUtils.convert(searchFields.get("endDate")));
					sql.append(" AND T.BILL_CREATE_TIME < ? ");
					args.add(endDate);
				}
				
			}
		    //账单审核时间
		    else {
				if (StringUtils.isNotEmpty(searchFields.get("startDate"))) {
		    		Date startDate = DateUtils.convert(searchFields.get("startDate"));
		    		sql.append(" AND T.BILL_AUDIT_TIME >= ?");
		    		args.add(startDate);
				}
				if (StringUtils.isNotEmpty(searchFields.get("endDate"))) {
					Date endDate = DateUtils.getEndTimeAdd(DateUtils.convert(searchFields.get("endDate")));
					sql.append(" AND T.BILL_AUDIT_TIME < ? ");
					args.add(endDate);
				}
			}
	    temp = StringUtils.trim(searchFields.get("auditStatus"));//账单状态(0:未审核；1已审核)
	    if (StringUtils.isNotEmpty(temp)) {
			sql.append(" AND T.AUDIT_FLAG = ? ");
			args.add(temp);
		}
	   // 数据权限
	    if (!UserRoleHelper.isHeadFinancial(user)) {
			sql.append(" and EXISTS (");
			sql.append(" select code from ytmdm.t_mdm_org m where m.whole_org_id like ");
			sql.append(" '%|' || (select id from ytmdm.t_mdm_org where code = '"
					+ user.getBelongToOrgCode() + "') || '|%' ");
			sql.append(" and T.SETTLE_ORG_CODE=m.code ) ");

		}
	    
	    scallarList = columnMapping();
	    
	    args.add(new PageFooterColumn("billNo", "'" + StlConst.TOTAL_WORD + "'", Hibernate.STRING));
		args.add(new PageFooterColumn("billAmount", "sum(billAmount)", Hibernate.DOUBLE));//金额总
		
		return super.findPageBySql(sql.toString(), 
				args, queryPage.getPageSize(), queryPage.getPageIndex(),
				queryPage.getSortMap(), scallarList, TStlEffectiveCheckBill.class);
	}

	
	private List<ColumnType> columnMapping() {
		List<ColumnType> scallarList = new ArrayList<ColumnType>();
		
		scallarList.add(new ColumnType("id", Hibernate.STRING));  
		scallarList.add(new ColumnType("billNo", Hibernate.STRING));   
		scallarList.add(new ColumnType("settleOrgCode", Hibernate.STRING));  
		scallarList.add(new ColumnType("settleOrgName", Hibernate.STRING));  
		scallarList.add(new ColumnType("billAmount", Hibernate.DOUBLE));  
		scallarList.add(new ColumnType("billStartTime", Hibernate.TIMESTAMP));  
		scallarList.add(new ColumnType("billEndTime", Hibernate.TIMESTAMP));   
		scallarList.add(new ColumnType("billCreateTime", Hibernate.TIMESTAMP));  
		scallarList.add(new ColumnType("billCreateEmpNo", Hibernate.STRING));   
		scallarList.add(new ColumnType("billCreateEmpName", Hibernate.STRING));  
		scallarList.add(new ColumnType("billCreateOrgCode", Hibernate.STRING));   
		scallarList.add(new ColumnType("billCreateOrgName", Hibernate.STRING));   
		scallarList.add(new ColumnType("billAuditTime", Hibernate.TIMESTAMP));  
		scallarList.add(new ColumnType("billAuditEmpNo", Hibernate.STRING));  
		scallarList.add(new ColumnType("billAuditEmpName", Hibernate.STRING));  
		scallarList.add(new ColumnType("billAuditOrgCode", Hibernate.STRING));   
		scallarList.add(new ColumnType("billAuditOrgName", Hibernate.STRING));   
		scallarList.add(new ColumnType("auditFlg", Hibernate.STRING));   
		scallarList.add(new ColumnType("settleOrgType", Hibernate.STRING));   
		scallarList.add(new ColumnType("rptDate", Hibernate.DATE)); 
		return scallarList;
	}
}
```


## auditjdbcdaoImpl.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.INewEffectiveCheckBillAuditJdbcDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;
import com.ibm.gbs.ai.portal.framework.server.dao.jdbc.BaseJdbcDao;
/**
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class ${entityName}BillAuditJdbcDaoImpl extends BaseJdbcDao  implements I${entityName}BillAuditJdbcDao {

	/**
	 * 是否存在审核数据
	 * 
	 */
	@Override
	public int get${entityName}Bill(Date startDate, Date endDate, String feeType) {

		StringBuffer sql = new StringBuffer();
		List<Object> args = new ArrayList<Object>();
	    sql.append("SELECT T.ID ");
	    if("0022".equals(feeType)){
	    	sql.append("FROM YTSTL.T_STL_BILL_AGING_ASSESS T WHERE ");
	    }
	    sql.append("  T.AUDIT_FLAG = '0' AND T.BILL_TYPE='0'");//0代表着应收
		sql.append(" AND T.BILL_CREATE_TIME >= ? ");
		sql.append(" AND T.BILL_CREATE_TIME < ? ");
		args.add(startDate);
		args.add(endDate);
		
		@SuppressWarnings("unchecked")
		List<TStlEffectiveCheckBill> list=this.getJdbcTemplate().query(sql.toString(), args.toArray(),new TStlBillCodRowMapper());
		return list.size() > 0 && list!= null ? list.size():0;
	}
	
	class TStlBillCodRowMapper implements RowMapper {
		@Override
		public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
			TStlEffectiveCheckBill item = new TStlEffectiveCheckBill();
			item.setId(rs.getString("ID"));
			return item;
		}
	}
}


```

## audit.ftl ##
```
function validator() {
        $("#startDate").rules("add",{
        	required : true
            });
        $("#endDate").rules("add",{
        	required : true
            });
};
function containerShowOrHide() {
	// 显示和隐藏查询条件框
	$(".legend_title a").toggle(function() {
		$(this).parent().next(".fieldset_container:first").hide();
		$(this).removeClass("container_show");
		$(this).addClass("container_hide");
	}, function() {
		$(this).parent().next(".fieldset_container:first").show();
		$(this).removeClass("container_hide");
		$(this).addClass("container_show");
	});
}
//最大日期日期验证
function checkDateIfValid() {
	return checkDateValid(31);
};



var colNames1=[
<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
	<#list classInfo.fieldList as fieldItem >
		"${fieldItem.fieldComment}"<#if fieldItem_has_next>,</#if>
	</#list>
</#if>
];





var colModel1=[
{name:"auditFlg",index:"auditFlg",width:60,formatter : 'select',editoptions : {value : "0:未审核;1:已审核"},align:'center'},//审核标示
<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
	<#list classInfo.fieldList as fieldItem >
		{name:"${fieldItem.fieldName}",index:"${fieldItem.fieldName}",width:120,align:'center'}<#if fieldItem_has_next>,</#if>//${fieldItem.fieldComment}
	</#list>
</#if>
			      ];

function inits(){
	$("#transferFirstAuditGrid").gridUtil().simpleGrid({
        url:"searchstlNewEffectiveCheckBill.action",
        caption : "",
        searchForm:"searchTransferFirstAuditForm",
        autowidth: false,
		width: 960,
		shrinkToFit: false,
		multiselect : false,
	    colNames:colNames1,
	    colModel:colModel1,
	    toolbar: [true,"top"],
	    pager: "#transferFirstAuditPager",
	    sortName : "createTime",
	    footerrow : true,
	    userDataOnFooter : true,
	    // validator:validator,
	    sortOrder : "desc"
	   },{lazyload:true});
	$("#transferFirstAudittoolBar").appendTo($("#t_transferFirstAuditGrid"));
	$("#transferFirstAuditGrid").gridUtil().customizeColumn();
};
//点击查询函数
function searchBill(){
	validator();
	var myStartDate = $("#startDate").val();//获取输入框开始时间
	var myEndDate = $("#endDate").val();//获取输入框结束时间
	var startTime = '';
	if (myStartDate != '') {
		var strArray=myStartDate.split(" ");   //年份和时间分割
    	var strDate=strArray[0].split("-");   //年月日分割
    	var strTime=strArray[1].split(":");   //时分秒分割
    	startTime = new Date(strDate[0],strDate[1]-1,strDate[2],strTime[0],strTime[1],strTime[2]);
	}
	var endDate = '';
	if (myEndDate != '') {
		var strrArray = myEndDate.split(" ");
    	var strEndDate = strrArray[0].split("-");
    	var strEndTime = strrArray[1].split(":");
    	endDate =  new Date(strEndDate[0],strEndDate[1]-1,strEndDate[2],strEndTime[0],strEndTime[1],strEndTime[2]);
	}
	var entTime = new Date("2014/08/02 00:00:00");
	if ($("#searchTransferFirstAuditForm").validate().form()) {
		if ((startTime - entTime) < 0 ) {
			$.boxUtil.alert("开始时间最早不得早于2014年8月2日00:00:00");
			return;
		}
		if ((endDate - entTime) < 0) {
			$.boxUtil.alert("开始时间最早不得早于2014年8月2日00:00:00");
			return;
		}
		if (!checkDateIfValid(31,"startTime","endTime")) {
			$.boxUtil.alert("对不起，只能查询31天之内的信息！");
			return;
		}else{
			$("#transferFirstAuditGrid").gridUtil().searchGrid($("#searchTransferFirstAuditForm"));
		}
	}
};


function billStatus(val){
	if('' ==val||""==val){
		$("#auditBill").hide();
	}
	else if (val==0) {
			$("#auditBill").show();
	}else{
		$("#auditBill").hide();
	}
};

function auditTerms(id){
	if (id == 1) {
		$("#billType option[value='1'] ").attr("selected",true);
	}else if (id == 2) {
		$("#billType option[value='2'] ").attr("selected",true);
	}else {
		$("#billType option[value=''] ").attr("selected",true);
	}
};

function auditBill(){
	var ids = jQuery("#transferFirstAuditGrid").getDataIDs();
	if (ids.length<1) {
		$.boxUtil.alert("审核数据不能为空！");
		return;
	}
	for ( var i = 0; i < ids.length; i++) {
		var rowData = $("#transferFirstAuditGrid").getRowData(ids[i]);
		var auditFlg = rowData.auditFlg;
		if (auditFlg == 1) {
			$.boxUtil.alert("对不起，请选择“未审核”数据进行审核！");
			return;
		}
	}
	$.blockUI( {
		message : $('#loading').html(),
		css : {
			padding : '10px'
		}
	});
	$.ajax({
		url : 'auditStlNewEffectiveCheckBillN.action?random=' + Math.random(),
		type : 'POST',
		dataType: "json",
		data : {beginTime : $("#startDate").val(),overTime : $("#endDate").val(),auditTerm : $("#auditTerm").val(),orgCodes : $("#settleOrgCode").val()},
		success : function(data) {
			if(data != null && data.message == "success"){
				setTimeout($.unblockUI,10000);
		    } else if(data.message == "false1"){
				$.boxUtil.error('结束时间不能为空！');
				setTimeout($.unblockUI);
 		 	} else if (data.message == "false2") {
 		 		$.boxUtil.error('开始时间不能为空！');
 		 		setTimeout($.unblockUI);
			}else {
				if (data == null || data.message == undefined || data.message == "") {
					$.boxUtil.error('账单生成出现异常，请联系系统维护人员！');
				} else {
					$.boxUtil.error(data.message);
				}
				setTimeout($.unblockUI);
			}
		},
		error : function(error) {
			setTimeout($.unblockUI);
			$.boxUtil.error('账单审核失败！');
		}
	});
};

function firstIns(){
	var genStatus = $("#auditStatus").val();
	if (genStatus == 0) {
		$("#auditBill").show();
	}else{
		$("#auditBill").hide();
	}
};


function exportExcel(){
	var rowData = $("#transferFirstAuditGrid").jqGrid("getRowData");
	if(rowData.length<1)
		$.boxUtil.alert("导出数据不能为空！");
	else
		$.boxUtil.confirm("确定要导出吗?", null, function() {
			$("#transferFirstAuditGrid").gridUtil().exportExcel( {
				url : "exportStlNewEffectiveCheckBillAudit.action",openWindow:true
			});
		});
};

$(function(){
	$("#tab-dataGridTabs").tabs();
	$("#searchConditionTabs").tabs();
	$("#queryPar").val("0");
	$("#auditStatus").val(0);
	$("#startDate").val(GetStartDate(0));//$("#startDate").val(GetStartDate(0));
	$("#endDate").val(GetEndDate(0));//$("#endDate").val(GetEndDate(0));
	$("#searchTransferFirstAuditForm").validate();
	inits();
	firstIns();
	getOrgName("orgSettleCode","orgType","settleOrgCode");
	containerShowOrHide();
	$("input[name='dateType']").click(function() {
    	var billNoType = $("input[name='dateType']:checked").val();
    	if(billNoType == 2)
    		$("#auditBill").hide(),
    		$("#auditStatus option[value='1'] ").attr("selected",true);
//    		$("#auditStatus").attr("disabled",true); 
    	else
    		$("#auditBill").show(),
    		$("#auditStatus option[value='0'] ").attr("selected",true);
    		$("#auditStatus").attr("disabled",false);
    });
});
```


## audit.ftl ##
```
<%@ page language="java" contentType="text/html; charset=utf-8"
pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<script type="text/javascript" src="<c:url value='/scripts/${audit}.js'/>">
</script>
<script type="text/javascript">
    var startTime = "2014-08-02 00:00:00";
    $(function() {
        //导出
        $("#export").click(exportExcel);
        //账单审核
        $("#auditBill").click(auditBill);
        //查询
        $("#search").click(searchBill);
    });
</script>
<s:form method="post" id="searchTransferFirstAuditForm"  name="searchTransferFirstAuditForm" >
    <input type="hidden" name="pageCache" id="pageCache" value="false">
    <input type="hidden" name="queryPar" id="queryPar" value="0" />
    <input type="hidden" name="payeeCode" id="payeeCode">
    <input id="settleOrgCode" name="settleOrg_Code" type="hidden"  />
    <s:hidden id="hidType" name="hidType"/>
    <div id="searchRegion" class="fieldset_border fieldset_bg m-b">
        <!-- 		<div class="warning" id="error" style="display: none;"></div> -->
        <div class="legend_title">

            <a href="#" class="container_show"> ${r"${app:i18n('stl.common.searchBtn')}"}</a>

        </div>
        <div class="fieldset_container">
            <div id="searchConditionTabs" class="tabs">
                <ul>
                    <li><a href="#tab-time">按账单时间查询</a></li>
                </ul>

                <div id="tab-time" style="height: 45px;" class="tabs">
                    <div style="float:left; width:304px; margin-top:-5px">
                        <table width="900" class="table_form">
                            <tr>
                                <td colspan="3">
                                    <input type="radio" id="dateType" name="dateType" value="1" checked="checked" ></input>按账单生成时间
                                    <input type="radio" id="dateType" name="dateType" value="2" ></input>按账单审核时间
                                </td>
                            </tr>
                            <tr>
                                <td align="left" width="50%" height="25">
                                    <label><em style="color:red">*</em>开始时间:</label>
                                    <input id="startDate" name="startDate" class="Wdate width_time2" onfocus="WdatePicker({ doubleCalendar:false,autoPickDate:true, dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:startTime,maxDate:$('#endDate').val() })"/>
                                </td>
                                <td align="left" width="50%" height="25">
                                    <label><em style="color:red">*</em>结束时间:</label>
                                    <input id="endDate" name="endDate" class="Wdate width_time2" onfocus="WdatePicker({ doubleCalendar:false,autoPickDate:true, dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:$('#startDate').val() })"/>
                                </td>

                            </tr>
                            <tr>

                                <td align="left" width="50%" height="25">
                                    <label>审核状态:</label>
                                    <select id="auditStatus" name="auditStatus" style="width:145px;" onchange="billStatus(this.value)">
                                        <option value="" selected="selected">全部</option>
                                        <option value="1">已审核</option>
                                        <option value="0">未审核</option>
                                        <option value="2">无效数据</option>
                                    </select>
                                </td>
                                <td></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="btn_layout">
                    <a class="easyui-linkbutton l-btn" id="search" name="search"> <span
                                class="l-btn-left"><span class="l-btn-text icon-search">查询</span></span></a>
                    <a class="easyui-linkbutton l-btn" id="auditBill"><span
                                class="l-btn-left"><span class="l-btn-text icon-audit">账单审核</span></span></a>
                </div>
                <br/>
            </div>
        </div>
    </div>

    <div id="tab-dataGridTabs" class="tabs">
        <ul>
            <li><a id="tab4" href="#tab-transferFirstAudit">账单</a></li>
        </ul>
        <div id="tab-transferFirstAudit" >
            <div id="transferFirstAudittoolBar">
                <a id="export" class="l-btn-plain l-btn">
                    <span class="l-btn-left"><span class="l-btn-text icon-excel">导出</span></span>
                </a>
            </div>
            <table id="transferFirstAuditGrid"></table>
            <div id="transferFirstAuditPager"></div>
        </div>
    </div>
    <div id="loading" style="display:none">
        <span class="loading_span">账单审核中，请稍候...</span> <br/>
        <img src="<c:url context='/common' value='/images/framework/ajax-loader.gif'/>"></img>
    </div>
</s:form>
```


## iaudit.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz;

import java.util.Map;



import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;

public interface I${entityName}AuditBiz {

	/**
	 * 审核页面 查询账单
	 * @param queryPage
	 * @param searchFields
	 * @param user
	 * @return
	 */
	 public IPage<TStlEffectiveCheckBill> searchBill(QueryPage queryPage, Map<String,String> searchFields, IUser user);
	 
	 /**
	  * 
	  * @Desc 账单审核
	  * @param searchFields
	  * @param user
	  * @param settleOrgCode void
	  * @author 01381726
	  */
	 void auditStl${entityName}Bill(Map<String, String> searchFields, IUser user,String settleOrgCode);
	
}

```


## auditimpl.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.INewEffectiveCheckBillAuditBiz;
import cn.com.yto56.coresystem.module.commons.mdm.constants.FeeType;
import cn.com.yto56.coresystem.module.commons.stl.domain.TStlAuditProcess;
import cn.com.yto56.coresystem.module.logic.stlcommon.service.IStlJobService;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.INewEffectiveCheckBillAuditDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.INewEffectiveCheckBillAuditJdbcDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnValue;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;

public class ${entityName}BillAuditBizImpl  implements I${entityName}AuditBiz {

	/**
	 * 账单审核Dao
	 */
	private I${entityName}BillAuditDao i${entityName}BillAuditDao;
	
	/**
	 * job接口
	 */
	private IStlJobService stlJobService;
	/**
	 * 账单审核Dao  ---JDBC  
	 */
	private I${entityName}BillAuditJdbcDao i${entityName}BillAuditJdbcDao;
	
	
	/**
	 * 审核界面 ----账单查询
	 */
	@Override
	public IPage<TStlEffectiveCheckBill> searchBill(QueryPage queryPage,Map<String, String> searchFields, IUser user) {
		
		IPage<TStlEffectiveCheckBill> sums = i${entityName}BillAuditDao.searchBill(queryPage, searchFields, user);
		return sums;
	}
	
	/**
	 * 审核界面---账单审核 
	 */
	@Override
	public void auditStl${entityName}Bill(Map<String, String> searchFields,
			IUser user, String settleOrgCode) {
		Date startDate=DateUtils.getStartDatetime(DateUtils.convert(searchFields.get("startTime")));//开始时间
		Date endDate=DateUtils.getEndTimeAdd(DateUtils.convert(searchFields.get("endTime")));//结束时间
		//NEW_EFFECTIVE_CHECK_FEE  新绩效考核 奖罚款，校验是否存在审核的账单，如果小于1则不存在
		int number=iNewEffectiveCheckBillAuditJdbcDao.getNewEffectiveCheckBill(startDate, endDate,FeeType.NEW_EFFECTIVE_CHECK_FEE.getCode());
		if(number<1){
			return;
		}
		TStlAuditProcess stlAuditDto=new TStlAuditProcess();
		stlAuditDto.setFeeType(FeeType.NEW_EFFECTIVE_CHECK_FEE.getCode());//费用类型--0022 新绩效考核 奖罚款
		stlAuditDto.setBusinessStartTime(startDate);//开始时间
		stlAuditDto.setBusinessEndTime(endDate);//结束时间 
		stlAuditDto.setOrgCode(user.getOrgCode());//当前登录网点
		stlAuditDto.setOrgName(user.getOrgName());//当前网点名称
		stlAuditDto.setUserCode(user.getUserCode());//登录人员代码
		stlAuditDto.setUserName(user.getDisplayName());//登录人员名称
		List<ColumnValue> columns = new ArrayList<ColumnValue>();
		columns.add(new ColumnValue("businessStartTime", stlAuditDto.getBusinessStartTime()));
		columns.add(new ColumnValue("businessEndTime", stlAuditDto.getBusinessEndTime()));
	    stlJobService.executeAuditJobs(stlAuditDto, columns);
		
	}
	

	public IStlJobService getStlJobService() {
		return stlJobService;
	}

	public void setStlJobService(IStlJobService stlJobService) {
		this.stlJobService = stlJobService;
	}

	public INew${entityName}BillAuditDao geti${entityName}BillAuditDao() {
		return iNewEffectiveCheckBillAuditDao;
	}

	public void seti${entityName}BillAuditDao(
			I${entityName}BillAuditDao i${entityName}BillAuditDao) {
		this.iNewEffectiveCheckBillAuditDao = iNewEffectiveCheckBillAuditDao;
	}

	public INew${entityName}BillAuditJdbcDao geti${entityName}BillAuditJdbcDao() {
		return i${entityName}BillAuditJdbcDao;
	}

	public void seti${entityName}BillAuditJdbcDao(
			I${entityName}BillAuditJdbcDao i${entityName}BillAuditJdbcDao) {
		this.i${entityName}AuditJdbcDao = i${entityName}BillAuditJdbcDao;
	}
}
```


