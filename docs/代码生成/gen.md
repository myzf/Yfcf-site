

## genAction.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.action;

import java.util.Map;
import com.ibm.gbs.ai.portal.framework.server.context.BeanHolder;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;
import cn.com.yto56.coresystem.module.business.stlcommon.action.StlCommonAction;
import cn.com.yto56.coresystem.module.business.stlexporter.StlExporterExecutor;
import cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.INewEffectiveCheckBillGenBiz;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;

/**
* 账单生成
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class ${entityName}GenAction extends StlCommonAction{

private static final long serialVersionUID = 1L;
//账单没有生成标识
private static final String NO_GEN_FLG = "0";
//开始时间
private String beginTime;
//结束时间
private String overTime;
//账单标识 0：未生成  1：已生成
private String billFlag;

//业务层biz
private I${entityName}BillGenBiz i${entityName}BillGenBiz;

public String init(){
return SUCCESS;
}

/**
* 查询账单明细action
*/
public String search(){
String startDate = searchFields.get("startDate");
String endDate = searchFields.get("endDate");
//一次只能查询一天的数据
if (!checkValidDate(startDate, endDate, 1)) {
return ERROR;
}
Page<TStlEffectiveCheckDetail> result = i${entityName}BillGenBiz.search${entityName}BillDetails(queryPage, searchFields ,getCurrentUser());
    setResult(result);
    return AJAX_RETURN_TYPE;
    }

    /**
    * 账单生成action
    * @return
    */
    public String gen(){
    if (!NO_GEN_FLG.equals(billFlag)) {
    addActionError("账单状态必须为未生成账单");
    return ERROR;
    }
    //校验时间不能大于1天
    if (!checkValidDate(beginTime, overTime, 1)) {
    return ERROR;
    }
    searchFields.put("startTime", beginTime);
    searchFields.put("endTime", overTime);
    try{
    //账单生成业务处理
    i${entityName}BillGenBiz.gen(searchFields, getCurrentUser());
    message = SUCCESS;
    return AJAX_RETURN_TYPE;
    }catch(Exception e){
    logger.error("新时效考核结算账单生成失败"+e.getMessage(), e);
    addActionError(StringUtils.isEmpty(e.getMessage())?"系统异常":e.getMessage());
    return ERROR;
    }
    }
    /**
    * 导出账单数据
    */
    public String export() {
    try {
    StlExporterExecutor exporterExecutor = (StlExporterExecutor) BeanHolder.getBean("stlExporterExecutor");
    exportSetting.setModule("STL");
    exportSetting.setFileName("新绩效考核结算账单生成数据明细表");
    exporterExecutor.exportAsync(i${entityName}BillGenBiz,
    new Object[] { exportSetting, searchFields, this.getCurrentUser() },
    I${entityName}BillGenBiz.class, "search${entityName}BillDetails",
    new Class<?>[] { QueryPage.class, Map.class ,IUser.class });
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
    public String getBillFlag() {
    return billFlag;
    }
    public void setBillFlag(String billFlag) {
    this.billFlag = billFlag;
    }

    public I${entityName}BillGenBiz geti${entityName}BillGenBiz() {
    return i${entityName}BillGenBiz;
    }

    public void seti${entityName}BillGenBiz(
    I${entityName}BillGenBiz i${entityName}BillGenBiz) {
    this.i${entityName}BillGenBiz = i${entityName}BillGenBiz;
    }
    }

```


## gendao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;


/**
* 账单查询Dao
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public interface I${entityName}BillGenDao {
	

	/**
	 * 查询账单明细（生成）
	 * @param querypage
	 * @param user
	 * @param searchFields
	 * @return
	 */
	public Page<TStlEffectiveCheckDetail> search${entityName}BillGen(QueryPage querypage,IUser user, Map<String, String> searchFields);
	
}



```



## gendaoimpl.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import com.ibm.gbs.ai.portal.framework.server.dao.hibernate.BaseEntityDao;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnType;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.PageFooterColumn;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;
import cn.com.yto56.coresystem.module.commons.stl.constants.StlConst;
import cn.com.yto56.coresystem.module.commons.stl.dto.UserRoleHelper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.INewEffectiveCheckBillGenDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;

/**
* 账单生成数据查询dao接口实现类
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class ${entityName}BillGenDaoImpl extends BaseEntityDao<TStlEffectiveCheckDetail> implements INewEffectiveCheckBillGenDao {

	/**
	 * 账单生成数据明细查询
	 */
	@Override
	public Page<TStlEffectiveCheckDetail> search${entityName}BillGen(
			QueryPage querypage, IUser user, Map<String, String> searchFields) {
		
		StringBuffer sql = new StringBuffer();
		List<Object> args = new ArrayList<Object>();
		List<ColumnType> scallarList = new ArrayList<ColumnType>();

		sql.append(" SELECT   ");
		sql.append(" ID as id,  ");
		sql.append(" T.SETTLE_ORG_CODE as settleOrgCode,  ");
		sql.append(" T.SETTLE_ORG_NAME as settleOrgName,  ");
		sql.append(" T.SETTLE_ORG_TYPE as settleOrgType,  ");
		sql.append(" T.ASSESS_TIME_TYPE as assessTimeType,  ");
		sql.append(" T.CHARGE_AMOUNT as billAmount,  ");
		sql.append(" T.RPT_DATE as rptDate,  ");
		sql.append(" T.CHARGE_TIME as chargeTime,  ");
		sql.append(" T.BILL_NO as billNo,  ");
		sql.append(" T.BILL_CREATE_TIME as billCreateTime,  ");
		sql.append(" T.BILL_CREATE_EMP_NO as billCreateEmpNo,  ");
		sql.append(" T.BILL_CREATE_EMP_NAME as billCreateEmpName,  ");
		sql.append(" T.BILL_CREATE_ORG_CODE as billCreateOrgCode,  ");
		sql.append(" T.BILL_CREATE_ORG_NAME as billCreateOrgName,  ");
		sql.append(" T.BILL_AUDIT_TIME as billAuditTime,  ");
		sql.append(" T.BILL_AUDIT_EMP_NO as billAuditEmpNo,  ");
		sql.append(" T.BILL_AUDIT_EMP_NAME as billAuditEmpName,  ");
		sql.append(" T.BILL_AUDIT_ORG_CODE as billAuditOrgCode,  ");
		sql.append(" T.BILL_AUDIT_ORG_NAME as billAuditOrgName,  ");
		sql.append(" T.TOTAL_CENTER_VOTES as totalCenterVotes,  ");
		sql.append(" T.SIGNED_VOTES as signedVotes,  ");
		sql.append(" T.UN_SIGNED_VOTES as unSignedVotes,  ");
		sql.append(" T.ACTUAL_SIGN_RATE as actualSignRate,  ");
		sql.append(" T.TARGET_SIGN_RATE as targetSignRate  ");
		sql.append(" FROM YTSTL.T_STL_AGING_ASSESS_DETAIL T  ");
		sql.append("               where 1 = 1         ");
		
		//计费时间CHARGE_TIME
		if (StringUtils.isNotEmpty(searchFields.get("startDate"))) {
			sql.append(" AND T.CHARGE_TIME >= ? ");
			args.add(DateUtils.convert(searchFields.get("startDate")));
		}
		if (StringUtils.isNotEmpty(searchFields.get("endDate"))) {
			sql.append(" AND T.CHARGE_TIME < ? ");
			args.add(DateUtils.getEndTimeAdd(DateUtils.convert(searchFields.get("endDate"))));
		}
		//数据生成状态 0：未生成账单  1：已生成账单
		String flag = searchFields.get("genFlg");
		if (StringUtils.isNotEmpty(flag)) {
			if(flag.equals("0")){
				sql.append(" AND T.BILL_NO = 'N/A' ");
			}else if(flag.equals("1")){
				sql.append(" AND T.BILL_NO <> 'N/A' ");
			}
		}
		//按层级控制角色权限
		if (!UserRoleHelper.isHeadFinancial(user)) {
			sql.append(" AND EXISTS (");
			sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
			sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
					+ "') || '|%' ");
			sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
		}
		scallarList = columnMappingBillDetail();
		//页面合计
		args.add(new PageFooterColumn("billNo", "'" + StlConst.TOTAL_WORD + "'", Hibernate.STRING));
		args.add(new PageFooterColumn("billAmount", "sum(billAmount)", Hibernate.DOUBLE));
		return (Page<TStlEffectiveCheckDetail>) super.findPageBySql(
						sql.toString(), args, querypage.getPageSize(),
						querypage.getPageIndex(), querypage.getSortMap(), scallarList,
						TStlEffectiveCheckDetail.class);
		
	}
	
	
	/**
	 * @Description: 账单明细映射
	 * @param:@return
	 * @return: List<ColumnType> 返回类型
	 * @throws
	 */
	private List<ColumnType> columnMappingBillDetail(){
		List<ColumnType> scallarList = new ArrayList<ColumnType>();
		
		scallarList.add(new ColumnType("id", Hibernate.STRING));
		scallarList.add(new ColumnType("billNo", Hibernate.STRING));
		scallarList.add(new ColumnType("settleOrgCode", Hibernate.STRING));
		scallarList.add(new ColumnType("settleOrgName", Hibernate.STRING));
		scallarList.add(new ColumnType("settleOrgType", Hibernate.STRING));
		scallarList.add(new ColumnType("assessTimeType", Hibernate.STRING));
		scallarList.add(new ColumnType("billAmount", Hibernate.DOUBLE));
		scallarList.add(new ColumnType("rptDate", Hibernate.DATE));
		scallarList.add(new ColumnType("chargeTime", Hibernate.TIMESTAMP));
		scallarList.add(new ColumnType("totalCenterVotes", Hibernate.INTEGER));
		scallarList.add(new ColumnType("signedVotes", Hibernate.INTEGER));
		scallarList.add(new ColumnType("unSignedVotes", Hibernate.INTEGER));
		scallarList.add(new ColumnType("actualSignRate", Hibernate.DOUBLE));
		scallarList.add(new ColumnType("targetSignRate", Hibernate.DOUBLE));
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
		  
		return scallarList;
	}
	

}
```



## gen.ftl ##
```
$(function(){
	init();
	containerShowOrHide();
	billDetailsGrid();
	$("#genFlg").change(function(){
		genFlgChanged(this);
	});
	//查询
	$("#searchBtn").click(searchBillDetail);
	//账单生成
	$("#genBtn").click(genBill);
	//导出
	$("#exportBtn").click(exportDetails);
});

//初始化基础查询条件参数
function init(){
	$("#startDate").val(GetStartDate(-1));
    $("#endDate").val(GetEndDate(-1));
    $("#searchTabs").tabs();
    $("#resultTabs").tabs();
    $("#genFlg").val(0);
}
/**
 * 绑定账单状态Change事件
 * @param obj
 */
function genFlgChanged(obj){
    var genFlg = $(obj).val();
    if(genFlg === '0'){
        $("#genBtn").show();
    }else{
        $("#genBtn").hide();
    }
}

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
var colNames=[
<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
	<#list classInfo.fieldList as fieldItem >
		"${fieldItem.fieldComment}"<#if fieldItem_has_next>,</#if>
	</#list>
</#if>
	              ];
var colModel=[
<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
	<#list classInfo.fieldList as fieldItem >
		{name:"${fieldItem.fieldName}",index:"${fieldItem.fieldName}",width:120,align:'center'}<#if fieldItem_has_next>,</#if>//${fieldItem.fieldComment}
	</#list>
</#if>
           ];

function billDetailsGrid(){
	$("#billDetailsGrid").gridUtil().simpleGrid({
        url:"searchBillDetailGen.action",
        caption : "",
        searchForm:"searchForm",
        autowidth: false,
		width: 960,
		shrinkToFit: false,
		multiselect : false,
	    colNames:colNames,
	    colModel:colModel,
	    toolbar: [true,"top"],
	    pager: "#billDetailsPage",
	    sortName : "billCreateTime",
	    footerrow : true,
	    userDataOnFooter : true,
	    // validator:validator,
	    sortOrder : "desc",
	    loadComplete:function(){
	    	   var rowData = $("#billDetailsGrid").jqGrid("getRowData");//取得现在表格中显示的数据条数
	    	   var id = jQuery("#billDetailsGrid").getDataIDs();//取得显示数据中的id
	 		   for ( var i = 0; i < rowData.length; i++) {
	 				 var row = rowData[i];  //jqgrid的行数是从1开始算起
	 			     if(row.dataBusinessType == "R"){
	 			         //给该行所对应的tr改变背景色，tr的ID是行数。
	 			         document.getElementById(id[i]).style.color="red";   
	 			     }
	 		   }
	 	}
	   },{lazyload:true});
	$("#billDetailsToolbar").appendTo($("#t_billDetailsGrid"));
	$("#billDetailsGrid").gridUtil().customizeColumn();
	
};
//最大日期日期验证
function checkDateValid(maxDay) {
	return checkDateWithField(maxDay, "startDate", "endDate");
}
//查询
function searchBillDetail(){
	if (!checkDateValid(1)) {
		$.boxUtil.alert("对不起，只能查询1天之内的信息！");
		return;
	}else{
		$("#billDetailsGrid").gridUtil().searchGrid($("#searchForm"));
	}
};
//生成
function genBill(){
    if (!$("#searchForm").validate().form()) {
        return;
    }
    var startDate = $("#startDate").val();
    var endDate = $("#endDate").val();
    var billFlag = $("#genFlg").val();
    var params = {
        beginTime : startDate,
        overTime : endDate,
        billFlag : billFlag
    };
    $.ajax({
        url : "genBillDetail.action?random="+Math.random(),
        type: "POST",
        dataType: "json",
        data: params,
        error: function(request) {
            alert("异常，请联系数据管理员！！");
        },
        success : function(data) {
            dbOnclick = false;
            if(data != null && data.message != "success"){
                $.boxUtil.alert(data.text);
            } else{
                setTimeout(function(){
                    $.growlUI("成功信息！", "账单生成成功！");
                }, 10);
                searchBillDetail();
            }
        }
    });
}
//导出
function exportDetails(){
    var records = $("#billDetailsGrid").getGridParam("records");
    if(records == 0){
        $.boxUtil.warn("结果集为空，不能导出！", {title: '提示'}, function(){});
        return false;
    } else {
        $.boxUtil.confirm("确定要导出吗?", {title:'确认' }, function(){
            $("#billDetailsGrid").gridUtil().exportGridExcel($("#searchForm"), {url:'exportBillDetailGen.action' });
        });
    }
}
```



## gen.ftl ##
```
<%@ page language="java" contentType="text/html; charset=utf-8"
pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<script type="text/javascript"
        src="<c:url value='/scripts/neweffectivecheck/${gen}.js'/>">
</script>
<div>
    <form id="searchForm" name="searchForm" method="post">
        <div class="fieldset_border">
            <div class="legend_title">
                <a href="#" class="container_show">查询</a>
            </div>
            <div class="fieldset_container">
                <div id="searchTabs" class="tabs">
                    <ul>
                        <li><a href="#tab-BillSearchByTime">按计费时间查询</a></li>
                    </ul>
                    <div id="tab-BillSearchByTime">
                        <div id="detail">
                            <table border="0" cellspacing="1" cellpadding="0"
                                   class="table_form">
                                <tr>
                                    <th><em>*</em>计费开始时间:</th>
                                    <td align="right" width="300px" colspan="2"><input
                                                id="startDate" name="startDate" class="Wdate width_time2"
                                                onfocus="WdatePicker({ doubleCalendar:false,autoPickDate:true, dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:$('#endDate').val() })" />
                                    </td>
                                    <th>账单状态:</th>
                                    <td><select id="genFlg" name="genFlg" class="width_b">
                                            <option value="" selected="selected">全部</option>
                                            <option value="0">未生成账单</option>
                                            <option value="1">已生成账单</option>
                                        </select></td>
                                </tr>
                                <tr>
                                    <th><em>*</em>计费结束时间:</th>
                                    <td colspan="2" width="300px"><input id="endDate"
                                                                         name="endDate" class="Wdate width_time2"
                                                                         onfocus="WdatePicker({ doubleCalendar:false,autoPickDate:true, dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:$('#startDate').val() })" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="text-align: right; margin-right: 100px;">
                            <a class="easyui-linkbutton l-btn" id="searchBtn"
                               name="searchBtn"> <span class="l-btn-left"><span
                                            class="l-btn-text icon-search">查询</span></span>
                            </a> <a class="easyui-linkbutton l-btn" id="genBtn"><span
                                        class="l-btn-left"><span class="l-btn-text icon-audit">生成账单</span></span></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<div id="resultTabs" class="tabs">
    <ul>
        <li><a id="tab" href="#tab-billDetails">账单明细</a></li>
    </ul>
    <div id="tab-billDetails">
        <div id="billDetailsToolbar">
            <a id="exportBtn" class="l-btn-plain l-btn"> <span
                        class="l-btn-left"><span class="l-btn-text icon-excel">导出</span></span>
            </a>
        </div>
        <table id="billDetailsGrid"></table>
        <div id="billDetailsPage"></div>
    </div>
</div>
<div id="loading" style="display: none">
    <span class="loading_span">账单生成中，请稍候...</span> <br /> <img
            src="<c:url context='/common' value='/images/framework/ajax-loader.gif'/>"></img>
</div>
```



## igen.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;

public interface ITestGen {

	public Page<TStlEffectiveCheckDetail> searchNewEffectiveCheckBillDetails(QueryPage querypage, Map<String, String> searchFields,IUser user);
	
	void gen(Map<String, String> searchFields, IUser user);

}



```


## genimpl.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.INewEffectiveCheckBillGenBiz;
import cn.com.yto56.coresystem.module.commons.mdm.constants.FeeType;
import cn.com.yto56.coresystem.module.commons.stl.constants.StlJobEnum;
import cn.com.yto56.coresystem.module.commons.stl.dto.StlJobDto;
import cn.com.yto56.coresystem.module.logic.stlcommon.service.IStlJobService;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.INewEffectiveCheckBillGenDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;

import com.ibm.gbs.ai.portal.framework.server.biz.BaseBiz;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnValue;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;

public class NewEffectiveCheckBillGenBizImpl extends BaseBiz implements INewEffectiveCheckBillGenBiz{
	
	private INewEffectiveCheckBillGenDao iNewEffectiveCheckBillGenDao;
	
	private IStlJobService stlJobService;
	
	/**
	 * 账单生成页面查询 明细表信息
	 */
	@Override
	public Page<TStlEffectiveCheckDetail> searchNewEffectiveCheckBillDetails(
			QueryPage querypage,  Map<String, String> searchFields,IUser user) {
		
		return iNewEffectiveCheckBillGenDao.searchNewEffectiveCheckBillGen(querypage, user, searchFields);
	}
	
	/**
	 * 手动点击账单生成biz
	 */
	@Override
	public void gen(Map<String, String> searchFields, IUser user) {
		Date startDate = DateUtils.convert(searchFields.get("startTime"), DateUtils.DATE_TIME_FORMAT);//开始时间
        Date endDate = DateUtils.getEndTimeAdd(DateUtils.convert(searchFields.get("endTime")));//结束时间
        StlJobDto stlJobDto = new StlJobDto();
        stlJobDto.setJobCode(StlJobEnum.NEW_EFFECTIVE_CHECK_BILL_GEN.getCode());//新时效考核结算账单生成
        stlJobDto.setFeeType(FeeType.NEW_EFFECTIVE_CHECK_FEE.getCode());// 新时效考核 奖罚款
        stlJobDto.setBusinessStartTime(startDate);//开始时间
        stlJobDto.setBusinessEndTime(endDate);//结束时间
        stlJobDto.setOrgCode(user.getOrgCode());//当前登录网点
        stlJobDto.setOrgName(user.getOrgName());//当前网点名称
        stlJobDto.setUserCode(user.getUserCode());//登录人员代码
        stlJobDto.setUserName(user.getDisplayName());//登录人员名称
        List<ColumnValue> columns = new ArrayList<ColumnValue>();
        columns.add(new ColumnValue("code", stlJobDto.getJobCode()));
        columns.add(new ColumnValue("businessStartTime", stlJobDto.getBusinessStartTime()));
        columns.add(new ColumnValue("businessEndTime", stlJobDto.getBusinessEndTime()));
        stlJobService.executeStlJob(stlJobDto, columns);
	}


	public IStlJobService getStlJobService() {
		return stlJobService;
	}

	public void setStlJobService(IStlJobService stlJobService) {
		this.stlJobService = stlJobService;
	}

	public INewEffectiveCheckBillGenDao getiNewEffectiveCheckBillGenDao() {
		return iNewEffectiveCheckBillGenDao;
	}

	public void setiNewEffectiveCheckBillGenDao(
			INewEffectiveCheckBillGenDao iNewEffectiveCheckBillGenDao) {
		this.iNewEffectiveCheckBillGenDao = iNewEffectiveCheckBillGenDao;
	}
	
}



```




