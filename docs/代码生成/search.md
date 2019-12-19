## searchAction.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.action;

import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.ibm.gbs.ai.portal.framework.server.context.BeanHolder;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;

import cn.com.yto56.coresystem.module.business.stlcommon.action.StlCommonAction;
import cn.com.yto56.coresystem.module.business.stlexporter.StlExporterExecutor;
import cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.INewEffectiveCheckBillSearchBiz;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBillNoDetail;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dto.TStlEffectiveCheckStatDto;
/**
* 账单查询
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class ${entityName}BillSearchAction extends StlCommonAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final String SEARCH_BY_TIME = "0";
	
	public static final String SEARCH_BY_BILLNO = "1";
	
	public static final String SEARCH_BY_DBCLICK = "2";
	
	public static final String SEARCH_BY_WAYBILLNO = "3";
	
	public static final String SEARCH_BY_CLICK = "4";
	
	public static final String SEARCH_BY_QTY = "5";
	
	public static final String WAYBILL_NO_LENGHT_ERROR = "最多输入20个运单号码,以 ENTER隔开！";
	public static final String BILL_NO_LENGHT_ERROR = "最多输入20个账单号码,以 ENTER隔开！";
	public static final String IS_NULL_ERROR = "最多输入20个号码,以 ENTER隔开";
	
	
	private I${entityName}BillSearchBiz ${entityName}BillSearchBiz;
	/**
	 * 初始化查询界面
	 * 
	 * @return
	 */
	public String init() {
		return SUCCESS;

	/**}
	 * 查询统计
	 * 
	 * @return
	 */
	public String searchStat() {
		String startDate = searchFields.get("startDate");
		String endDate = searchFields.get("endDate");
		if (!checkValidDate(startDate, endDate, 31)) {// 校验日期
			return ERROR;
		}
		Page<TStlEffectiveCheckStatDto> result = (Page<TStlEffectiveCheckStatDto>)newEffect iveCheckBillSearchBiz
				.searchEffectiveCheckStat(queryPage, searchFields, getCurrentUser());
		setResult(result);
		return AJAX_RETURN_TYPE;
	}
	/**
	 * 查询账单
	 * 
	 * @return
	 */
	public String searchBills() {
		String searchFlag = searchFields.get("searchFlag");
		String startDate = searchFields.get("startDate");
		String endDate = searchFields.get("endDate");
		if ((SEARCH_BY_TIME.equals(searchFlag) || SEARCH_BY_DBCLICK.equals(searchFlag))
				&& !checkValidDate(startDate, endDate, 31)) {
			return ERROR;
		}
		if (SEARCH_BY_BILLNO.equals(searchFlag)) {
			String billNo = searchFields.get("billNo");
			if(IS_NULL_ERROR.equals(billNo) || billNo == null){
				addActionError("账单号为必须字段");
				return ERROR;
			}
			if (StringUtils.isNotEmpty(billNo)) {
				String[] billNos = billNo.split("\n");
				if(billNos.length>20){
					addActionError(BILL_NO_LENGHT_ERROR);
					return ERROR;
				}
			}
		}
		Page<TStlEffectiveCheckBill> result = (Page<TStlEffectiveCheckBill>) newEffectiveCheckBillSearchBiz
				.searchEffectiveCheckBills(queryPage, searchFields, getCurrentUser());
		setResult(result);
		return AJAX_RETURN_TYPE;
	}
	/**
	 * 查询考核时间点数据
	 * 
	 * @return
	 */
	public String searchCheckDatas() {
			Page<TStlEffectiveCheckDetail> result = (Page<TStlEffectiveCheckDetail>) newEffectiveCheckBillSearchBiz
					.searchEffectiveCheckDetail(queryPage, searchFields, getCurrentUser());
			setResult(result);
		return AJAX_RETURN_TYPE;
	}
	/**
	 * 查询单号明细
	 * 
	 * @return
	 */
	public String searchDetails(){
		String searchFlag = searchFields.get("searchFlag");
		if(SEARCH_BY_WAYBILLNO.equals(searchFlag)){
			String waybillNo = searchFields.get("waybillNo");
			if(IS_NULL_ERROR.equals(waybillNo) || waybillNo == null){
				addActionError("运单号为必须字段");
				return ERROR;
			}
			if(StringUtils.isNotEmpty(waybillNo)){
				String[] waybillNos = waybillNo.split("\n");
				if(waybillNos.length>20){
					addActionError(WAYBILL_NO_LENGHT_ERROR);
					return ERROR;
				} 
			}
		}
		Page<TStlEffectiveCheckBillNoDetail> result = (Page<TStlEffectiveCheckBillNoDetail>) newEffectiveCheckBillSearchBiz
				.searchEffectiveCheckBillNoDetail(queryPage, searchFields, getCurrentUser());
		setResult(result);
		return AJAX_RETURN_TYPE;
	}
	/**
	 * 导出
	 * 
	 * @return
	 */
	public String export() {
		try {
			StlExporterExecutor exporterExecutor = (StlExporterExecutor) BeanHolder.getBean("stlExporterExecutor");
			exportSetting.setModule("STL");
			String gridFlag = searchFields.get("gridFlag");
			if ("0".equals(gridFlag)) {
				exportSetting.setFileName("总公司应收结算网点账单统计");
				exporterExecutor.exportAsync(newEffectiveCheckBillSearchBiz,
						new Object[] { exportSetting, searchFields, this.getCurrentUser() },
						INewEffectiveCheckBillSearchBiz.class, "searchEffectiveCheckStat",
						new Class<?>[] { QueryPage.class, Map.class, IUser.class });
			} else if ("1".equals(gridFlag)) {
				exportSetting.setFileName("总公司应收结算网点账单信息");
				exporterExecutor.exportAsync(newEffectiveCheckBillSearchBiz,
						new Object[] { exportSetting, searchFields, this.getCurrentUser() },
						INewEffectiveCheckBillSearchBiz.class, "searchEffectiveCheckBills",
						new Class<?>[] { QueryPage.class, Map.class, IUser.class });
			} else if ("2".equals(gridFlag)) {
				exportSetting.setFileName("考核时间点数据");
				exporterExecutor.exportAsync(newEffectiveCheckBillSearchBiz,
						new Object[] { exportSetting, searchFields, this.getCurrentUser() },
						INewEffectiveCheckBillSearchBiz.class, "searchEffectiveCheckDetail",
						new Class<?>[] { QueryPage.class, Map.class, IUser.class });
			} else if ("3".equals(gridFlag)){
				exportSetting.setFileName("单号明细");
				exporterExecutor.exportAsync(newEffectiveCheckBillSearchBiz,
						new Object[] { exportSetting, searchFields, this.getCurrentUser() },
						INewEffectiveCheckBillSearchBiz.class, "searchEffectiveCheckBillNoDetail",
						new Class<?>[] { QueryPage.class, Map.class, IUser.class });
			}
		} catch (Exception e) {
			logger.error("导出异常：", e);
			return ERROR;
		}
		return ASYNC_EXPORT;
	}

	public INewEffectiveCheckBillSearchBiz getNewEffectiveCheckBillSearchBiz() {
		return newEffectiveCheckBillSearchBiz;
	}

	public void setNewEffectiveCheckBillSearchBiz(
			INewEffectiveCheckBillSearchBiz newEffectiveCheckBillSearchBiz) {
		this.newEffectiveCheckBillSearchBiz = newEffectiveCheckBillSearchBiz;
	}
}
```



## billdao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;

/**
* 查账单信息
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public interface IStl${entityName}BillsDao {
//按时间
IPage<TStlEffectiveCheckBill> search${entityName}Bills(QueryPage queryPage, Map<String, String> searchFields, IUser user);
    //双击账单统计
    IPage<TStlEffectiveCheckBill> search${entityName}BillsDbClick(QueryPage queryPage, Map<String, String> searchFields, IUser user);
        //按账单号
        IPage<TStlEffectiveCheckBill> search${entityName}BillsByBillNo(QueryPage queryPage, String[] billNos, IUser user);
            }


```

## detaildao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;


/**
* 查考核时间点数据
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public interface IStl${entityName}DetailsDao {

        IPage<TStlEffectiveCheckDetail> search${entityName}Detail(QueryPage queryPage, Map<String, String> searchFields, IUser user);

    }
```


## nodetaildao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBillNoDetail;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;


/**
* 查单号明细
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public interface IStl${entityName}BillNoDetailDao {

//点击考核时间点数据查询

    IPage<TStlEffectiveCheckBillNoDetail> search${entityName}BillNoDetail(QueryPage queryPage, Map<String, String> searchFields, IUser user);
    //按运单号查询
    IPage<TStlEffectiveCheckBillNoDetail> search${entityName}BillNoDetailByWaybillNo(QueryPage queryPage, String[] waybillNos, IUser user);
        }
```


## statdao.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dto.TStlEffectiveCheckStatDto;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;


/**
* 查账单统计
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public interface IStl${entityName}StatDao {

        IPage<TStlEffectiveCheckStatDto> search${entityName}Stat(QueryPage queryPage, Map<String, String> searchFields, IUser user);
    }

```

## billdaoimpl.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;

import static cn.com.yto56.coresystem.module.commons.stl.constants.StlConst.DATE_FLG_AUDIT_TIME;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import com.ibm.gbs.ai.portal.framework.server.dao.hibernate.BaseEntityDao;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnType;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.PageFooterColumn;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

import cn.com.yto56.coresystem.module.commons.stl.constants.StlConst;
import cn.com.yto56.coresystem.module.commons.stl.dto.UserRoleHelper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckBillsDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;


/**
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class Stl${entityName}BillsDaoImpl extends BaseEntityDao<TStlEffectiveCheckBill>
    implements IStl${entityName}BillsDao{
    private static final String EFFECTIVE_CHECK_BILL_SQL = "SELECT T.BILL_NO AS billNo,"
    + " T.SETTLE_ORG_CODE			AS		settleOrgCode, "
    + " T.SETTLE_ORG_NAME 			AS		settleOrgName, "
    + "	T.BILL_AMOUNT				AS		billAmount,"
    + " CASE T.AUDIT_FLAG WHEN '0' THEN '未审核' WHEN '1' THEN '已审核' WHEN '2' THEN '无效账单' END AS auditFlg, "
    + " T.RPT_DATE AS rptDate, "
    + " T.BILL_START_TIME 			AS 		billStartTime, "
    + " T.BILL_END_TIME    			AS 		billEndTime  , "
    + " T.BILL_CREATE_TIME			AS 		billCreateTime,"
    + " T.BILL_CREATE_EMP_NAME		AS 		billCreateEmpName,"
    + " T.BILL_CREATE_ORG_NAME 		AS 		billCreateOrgName, "
    + " T.BILL_AUDIT_TIME			AS		billAuditTime,"
    + " T.BILL_AUDIT_EMP_NAME		AS 		billAuditEmpName,"
    + " T.BILL_AUDIT_ORG_NAME		AS 		billAuditOrgName "
    + " FROM YTSTL.T_STL_BILL_AGING_ASSESS T  WHERE 1=1 ";
    @Override
    public IPage<TStlEffectiveCheckBill> search${entityName}Bills(
        QueryPage queryPage, Map<String, String> searchFields, IUser user) {
        logger.trace(" enter dao ...");
        StringBuffer sql = new StringBuffer();
        List<Object> args = new ArrayList<Object>();
                List<ColumnType> scallarList = new ArrayList<ColumnType>();
                        sql.append(EFFECTIVE_CHECK_BILL_SQL);
                        if (StringUtils.isNotEmpty(searchFields.get("startDate"))) {
                        if(StringUtils.equals(searchFields.get("dateFlag"), DATE_FLG_AUDIT_TIME)){
                        sql.append(" AND T.BILL_AUDIT_TIME >= ? ");
                        }else{
                        sql.append(" AND T.BILL_CREATE_TIME >= ? ");
                        }
                        args.add(DateUtils.convert(StringUtils.trim(searchFields.get("startDate"))));
                        }
                        if (StringUtils.isNotEmpty(searchFields.get("endDate"))) {
                        if(StringUtils.equals(searchFields.get("dateFlag"), DATE_FLG_AUDIT_TIME)){
                        sql.append(" AND T.BILL_AUDIT_TIME < ? ");
                        }else{
                        sql.append(" AND T.BILL_CREATE_TIME < ? ");
                        }
                        args.add(DateUtils.getEndTimeAdd(DateUtils.convert(StringUtils.trim(searchFields.get("endDate")))));
                        }
                        if(StringUtils.isNotEmpty(searchFields.get("auditFlg"))){
                        sql.append(" AND T.AUDIT_FLAG = ? ");
                        args.add(StringUtils.trim(searchFields.get("auditFlg")));
                        }
                        if(StringUtils.isNotEmpty(searchFields.get("settleOrgCode"))){
                        sql.append(" AND T.SETTLE_ORG_CODE = ? ");
                        args.add(StringUtils.trim(searchFields.get("settleOrgCode")));
                        }
                        if (!UserRoleHelper.isHeadFinancial(user)) {
                        sql.append(" AND EXISTS (");
                        sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                        sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                        + "') || '|%' ");
                        sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                        }

                        addScallarList(scallarList);
                        addPageFooterColumn(args);
                        return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckBill.class);
                        }

                        @Override
                        public IPage<TStlEffectiveCheckBill> search${entityName}BillsDbClick(
                            QueryPage queryPage, Map<String, String> searchFields, IUser user) {
                            logger.trace(" enter dao ...");
                            StringBuffer sql = new StringBuffer();
                            List<Object> args = new ArrayList<Object>();
                                    List<ColumnType> scallarList = new ArrayList<ColumnType>();
                                            sql.append(EFFECTIVE_CHECK_BILL_SQL);
                                            if (StringUtils.isNotEmpty(searchFields.get("startDate"))) {
                                            if(StringUtils.equals(searchFields.get("dateFlag"), DATE_FLG_AUDIT_TIME)){
                                            sql.append(" AND T.BILL_AUDIT_TIME >= ? ");
                                            }else{
                                            sql.append(" AND T.BILL_CREATE_TIME >= ? ");
                                            }
                                            args.add(DateUtils.convert(StringUtils.trim(searchFields.get("startDate"))));
                                            }
                                            if (StringUtils.isNotEmpty(searchFields.get("endDate"))) {
                                            if(StringUtils.equals(searchFields.get("dateFlag"), DATE_FLG_AUDIT_TIME)){
                                            sql.append(" AND T.BILL_AUDIT_TIME < ? ");
                                            }else{
                                            sql.append(" AND T.BILL_CREATE_TIME < ? ");
                                            }
                                            args.add(DateUtils.getEndTimeAdd(DateUtils.convert(StringUtils.trim(searchFields.get("endDate")))));
                                            }
                                            if(StringUtils.isNotEmpty(searchFields.get("auditFlg"))){
                                            sql.append(" AND T.AUDIT_FLAG = ? ");
                                            args.add(StringUtils.trim(searchFields.get("auditFlg")));
                                            }
                                            if (StringUtils.isNotEmpty(searchFields.get("settleOrgCodeDb"))) {
                                            sql.append(" AND T.SETTLE_ORG_CODE = ? ");
                                            args.add(StringUtils.trim(searchFields.get("settleOrgCodeDb")));
                                            }
                                            if (!UserRoleHelper.isHeadFinancial(user)) {
                                            sql.append(" AND EXISTS (");
                                            sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                                            sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                                            + "') || '|%' ");
                                            sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                                            }
                                            addScallarList(scallarList);
                                            addPageFooterColumn(args);
                                            return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckBill.class);
                                            }

                                            @Override
                                            public IPage<TStlEffectiveCheckBill> search${entityName}BillsByBillNo(
                                                QueryPage queryPage, String[] billNos, IUser user) {
                                                logger.trace(" enter dao ...");
                                                if(billNos == null || billNos.length==0)
                                                return new Page<TStlEffectiveCheckBill>(null, 0, 0, 0);
                                                    StringBuffer sql = new StringBuffer();
                                                    List<Object> args = new ArrayList<Object>();
                                                            List<ColumnType> scallarList = new ArrayList<ColumnType>();
                                                                    sql.append(EFFECTIVE_CHECK_BILL_SQL);
                                                                    if (billNos.length == 1) {
                                                                    sql.append(" AND T.BILL_NO = ? ");
                                                                    args.add(StringUtils.trim(billNos[0]));
                                                                    } else {
                                                                    sql.append(" AND T.BILL_NO IN ( ");
                                                                    for (int i = 0; i < billNos.length; i++) {
                                                                    if (i == billNos.length - 1) {
                                                                    sql.append(" ? )");
                                                                    } else {
                                                                    sql.append(" ? , ");
                                                                    }
                                                                    args.add(StringUtils.trim(billNos[i]));
                                                                    }
                                                                    }
                                                                    if (!UserRoleHelper.isHeadFinancial(user)) {
                                                                    sql.append(" AND EXISTS (");
                                                                    sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                                                                    sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                                                                    + "') || '|%' ");
                                                                    sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                                                                    }
                                                                    addScallarList(scallarList);
                                                                    addPageFooterColumn(args);
                                                                    return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckBill.class);
                                                                    }
                                                                    private void addScallarList(List<ColumnType> scallarList) {
                                                                        scallarList.add(new ColumnType("billNo", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("settleOrgCode", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("settleOrgName", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("billAmount", Hibernate.DOUBLE));
                                                                        scallarList.add(new ColumnType("auditFlg", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("rptDate", Hibernate.DATE));
                                                                        scallarList.add(new ColumnType("billStartTime", Hibernate.TIMESTAMP));
                                                                        scallarList.add(new ColumnType("billEndTime", Hibernate.TIMESTAMP));
                                                                        scallarList.add(new ColumnType("billCreateTime", Hibernate.TIMESTAMP));
                                                                        scallarList.add(new ColumnType("billCreateEmpName", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("billCreateOrgName", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("billAuditTime", Hibernate.TIMESTAMP));
                                                                        scallarList.add(new ColumnType("billAuditEmpName", Hibernate.STRING));
                                                                        scallarList.add(new ColumnType("billAuditOrgName", Hibernate.STRING));
                                                                        }

                                                                        private void addPageFooterColumn(List<Object> args) {
                                                                            args.add(new PageFooterColumn("billNo", "'" + StlConst.TOTAL_WORD + "'", Hibernate.STRING));
                                                                            args.add(new PageFooterColumn("billAmount", "sum(billAmount)", Hibernate.DOUBLE));
                                                                            }

                                                                            }

```

## detaildaoimpl.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import com.ibm.gbs.ai.portal.framework.server.dao.hibernate.BaseEntityDao;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnType;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.PageFooterColumn;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

import cn.com.yto56.coresystem.module.commons.stl.constants.StlConst;
import cn.com.yto56.coresystem.module.commons.stl.dto.UserRoleHelper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckDetailsDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;


/**
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public class Stl${entityName}DetailsDaoImpl extends BaseEntityDao<TStlEffectiveCheckDetail> implements
    IStlNewEffectiveCheckDetailsDao {


    @Override
    public IPage<TStlEffectiveCheckDetail> search${entityName}Detail(
        QueryPage queryPage, Map<String, String> searchFields, IUser user) {
        logger.trace(" enter dao ...");
        StringBuffer sql = new StringBuffer();
        List<Object> args = new ArrayList<Object>();
                List<ColumnType> scallarList = new ArrayList<ColumnType>();
                        sql.append(" SELECT T.ASSESS_TIME_TYPE AS assessTimeType, ");
                        sql.append(" T.SETTLE_ORG_CODE AS settleOrgCode, ");
                        sql.append(" T.SETTLE_ORG_NAME AS settleOrgName, ");
                        sql.append(" T.SETTLE_ORG_TYPE AS settleOrgType, ");
                        sql.append(" T.CHARGE_AMOUNT AS billAmount, ");
                        sql.append(" T.TOTAL_CENTER_VOTES AS totalCenterVotes, ");
                        sql.append(" T.SIGNED_VOTES AS signedVotes, ");
                        sql.append(" T.UN_SIGNED_VOTES AS unSignedVotes, ");
                        sql.append(" to_char(T.ACTUAL_SIGN_RATE*100,'990.99') || '%'  as actualRateStr, ");
                        sql.append(" to_char(T.TARGET_SIGN_RATE*100,'990.99') || '%'  as targetRateStr, ");
                        sql.append(" T.RPT_DATE AS rptDate, ");
                        sql.append(" T.CHARGE_TIME AS chargeTime, ");
                        sql.append(" T.BILL_CREATE_TIME 	AS billCreateTime, ");
                        sql.append(" T.BILL_CREATE_EMP_NAME AS billCreateEmpName, ");
                        sql.append(" T.BILL_CREATE_ORG_NAME AS billCreateOrgName, ");
                        sql.append(" T.BILL_AUDIT_TIME 		AS billAuditTime, ");
                        sql.append(" T.BILL_AUDIT_EMP_NAME  AS billAuditEmpName, ");
                        sql.append(" T.BILL_AUDIT_ORG_NAME  AS billAuditOrgName ");
                        sql.append(" FROM YTSTL.T_STL_AGING_ASSESS_DETAIL T ");
                        sql.append(" WHERE 1=1 ");

                        //单机跳转，所选行条件（billNo）
                        if(StringUtils.isNotEmpty(searchFields.get("billNoDb"))){
                        sql.append(" AND T.BILL_NO = ? ");
                        args.add(StringUtils.trim(searchFields.get("billNoDb")));
                        }
                        if (!UserRoleHelper.isHeadFinancial(user)) {
                        sql.append(" AND EXISTS (");
                        sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                        sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                        + "') || '|%' ");
                        sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                        }
                        addScallarList(scallarList);
                        addPageFooterColumn(args);
                        return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckDetail.class);
                        }
                        private void addScallarList(List<ColumnType> scallarList) {
                            scallarList.add(new ColumnType("assessTimeType", Hibernate.STRING));
                            scallarList.add(new ColumnType("settleOrgCode", Hibernate.STRING));
                            scallarList.add(new ColumnType("settleOrgName", Hibernate.STRING));
                            scallarList.add(new ColumnType("settleOrgType", Hibernate.STRING));
                            scallarList.add(new ColumnType("billAmount", Hibernate.DOUBLE));
                            scallarList.add(new ColumnType("totalCenterVotes", Hibernate.INTEGER));
                            scallarList.add(new ColumnType("signedVotes", Hibernate.INTEGER));
                            scallarList.add(new ColumnType("unSignedVotes", Hibernate.INTEGER));
                            scallarList.add(new ColumnType("actualRateStr", Hibernate.STRING));
                            scallarList.add(new ColumnType("targetRateStr", Hibernate.STRING));
                            scallarList.add(new ColumnType("rptDate", Hibernate.DATE));
                            scallarList.add(new ColumnType("chargeTime", Hibernate.TIMESTAMP));
                            scallarList.add(new ColumnType("billCreateTime", Hibernate.TIMESTAMP));
                            scallarList.add(new ColumnType("billCreateEmpName", Hibernate.STRING));
                            scallarList.add(new ColumnType("billCreateOrgName", Hibernate.STRING));
                            scallarList.add(new ColumnType("billAuditTime", Hibernate.TIMESTAMP));
                            scallarList.add(new ColumnType("billAuditEmpName", Hibernate.STRING));
                            scallarList.add(new ColumnType("billAuditOrgName", Hibernate.STRING));
                            }

                            private void addPageFooterColumn(List<Object> args) {
                                args.add(new PageFooterColumn("billNo", "'" + StlConst.TOTAL_WORD + "'", Hibernate.STRING));
                                args.add(new PageFooterColumn("billAmount", "sum(billAmount)", Hibernate.DOUBLE));
                                }

                                }


```

## nodetaildaoimpl.ftl ##
```
package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import com.ibm.gbs.ai.portal.framework.server.dao.hibernate.BaseEntityDao;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnType;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

import cn.com.yto56.coresystem.module.commons.stl.dto.UserRoleHelper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckBillNoDetailDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBillNoDetail;


/**
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
public class Stl${entityName}BillNoDetailDaoImpl extends BaseEntityDao<TStlEffectiveCheckBillNoDetail> implements
    IStl${entityName}BillNoDetailDao {
    private static final String EFFECTIVE_CHECK_WAYBILL_NO_DETAIL_SQL = "SELECT T.WAYBILL_NO AS waybillNo,"
    + " T.SETTLE_ORG_CODE			 AS		settleOrgCode, "
    + " T.SETTLE_ORG_NAME 			 AS		settleOrgName, "
    + "	T.CENTER_ON_SCAN_TIME		 AS		centerOnScanTime, "
    + "	T.CENTER_ON_SCAN_UPLOAD_TIME AS		centerOnScanUploadTime, "
    + " T.SIGN_TIME 				 AS 	signTime, "
    + " T.SIGN_UPLOAD_TIME    		 AS 	signUploadTime, "
    + " T.IN_STORAGE_TIME			 AS 	inStorageTime, "
    + " T.IN_STORAGE_UPLOAD_TIME	 AS 	inStorageUploadTime, "
    + " T.SIGN_EMP_NAME				 AS		signEmpName, "
    + " T.SIGN_EMP_NO				 AS		signEmpNo, "
    + " T.EXPRESS_FREQUENCY			 AS 	expressFrequency ";

    private static final String ASSESS_TIME_TYPE_15 = "A";//考核时间点15点
    private static final String ASSESS_TIME_TYPE_20 = "B";//考核时间点20点
    private static final String ASSESS_TIME_TYPE_24 = "C";//考核时间点24点
    private static final String ASSESS_TIME_TYPE_24_II = "D";//三频24点

    @Override
    public IPage<TStlEffectiveCheckBillNoDetail> search${entityName}BillNoDetail(
        QueryPage queryPage, Map<String, String> searchFields, IUser user) {
        logger.trace(" enter dao ...");
        StringBuffer sql = new StringBuffer();
        List<Object> args = new ArrayList<Object>();
                List<ColumnType> scallarList = new ArrayList<ColumnType>();
                        sql.append(EFFECTIVE_CHECK_WAYBILL_NO_DETAIL_SQL);
                        String assessTimeTypeDb = searchFields.get("assessTimeTypeDb");//考核时间点为15点，20点，24点
                        Date date = DateUtils.convert(StringUtils.trim(searchFields.get("rptDateDb")));
                        //根据考核时间点不同，查不同的表
                        if(ASSESS_TIME_TYPE_15.equals(assessTimeTypeDb)){
                        sql.append(" FROM 	YTSTL.T_STL_EFFECTIVE_CHECK_DETAIL15 T	WHERE 1=1 ");
                        }
                        if(ASSESS_TIME_TYPE_20.equals(assessTimeTypeDb)){
                        sql.append(" FROM 	YTSTL.T_STL_EFFECTIVE_CHECK_DETAIL20 T	WHERE 1=1 ");
                        }
                        //三频24点和24点是一样的表
                        if(ASSESS_TIME_TYPE_24.equals(assessTimeTypeDb)||ASSESS_TIME_TYPE_24_II.equals(assessTimeTypeDb)){
                        sql.append(" FROM 	YTSTL.T_STL_EFFECTIVE_CHECK_DETAIL24 T  WHERE 1=1 ");
                        //如果是三频24点,查询结果集为快件频次是 三频 的数据
                        if(ASSESS_TIME_TYPE_24_II.equals(assessTimeTypeDb)){
                        sql.append(" AND T.EXPRESS_FREQUENCY = '3' ");
                        }else{
                        sql.append(" AND T.EXPRESS_FREQUENCY <> '3' ");
                        }
                        }
                        if(StringUtils.isNotEmpty(searchFields.get("rptDateDb"))){
                        sql.append(" AND T.RPT_DATE = ? ");
                        args.add(date);
                        }
                        if(StringUtils.isNotEmpty(searchFields.get("settleOrgCodeDb"))){
                        sql.append(" AND T.SETTLE_ORG_CODE = ?");
                        args.add(StringUtils.trim(searchFields.get("settleOrgCodeDb")));
                        }
                        //权限层级辐射
                        if (!UserRoleHelper.isHeadFinancial(user)) {
                        sql.append(" AND EXISTS (");
                        sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                        sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                        + "') || '|%' ");
                        sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                        }
                        addScallarList(scallarList);
                        return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckBillNoDetail.class);
                        }

                        @Override
                        public IPage<TStlEffectiveCheckBillNoDetail> searchEffectiveCheckBillNoDetailByWaybillNo(
                            QueryPage queryPage, String[] waybillNos, IUser user) {
                            logger.trace(" enter dao ...");
                            StringBuffer sql = new StringBuffer();
                            List<Object> args = new ArrayList<Object>();
                                    List<ColumnType> scallarList = new ArrayList<ColumnType>();
                                            //根据运单号查询明细时,可能有一个单号在四个时间点的单号明细中都存在的情况,需求要展示全部,采用union all
                                            sql.append(EFFECTIVE_CHECK_WAYBILL_NO_DETAIL_SQL);
                                            sql.append(" FROM YTSTL.T_STL_EFFECTIVE_CHECK_DETAIL15 T WHERE 1=1 ");
                                            condition(waybillNos,sql,args);
                                            sql.append(" UNION ALL ");
                                            sql.append(EFFECTIVE_CHECK_WAYBILL_NO_DETAIL_SQL);
                                            sql.append(" FROM YTSTL.T_STL_EFFECTIVE_CHECK_DETAIL20 T WHERE 1=1 ");
                                            condition(waybillNos,sql,args);
                                            sql.append(" UNION ALL ");
                                            sql.append(EFFECTIVE_CHECK_WAYBILL_NO_DETAIL_SQL);
                                            sql.append(" FROM YTSTL.T_STL_EFFECTIVE_CHECK_DETAIL24 T WHERE 1=1 ");
                                            condition(waybillNos,sql,args);
                                            //权限层级辐射
                                            if (!UserRoleHelper.isHeadFinancial(user)) {
                                            sql.append(" AND EXISTS (");
                                            sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                                            sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                                            + "') || '|%' ");
                                            sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                                            }
                                            addScallarList(scallarList);
                                            return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckBillNoDetail.class);
                                            }
                                            //是否多个运单号条件
                                            private void condition(String[] waybillNos, StringBuffer sql,
                                            List<Object> args) {
                                                if (waybillNos.length == 1) {
                                                sql.append(" AND T.WAYBILL_NO = ? ");
                                                args.add(StringUtils.trim(waybillNos[0]));
                                                } else {
                                                sql.append(" AND T.WAYBILL_NO IN ( ");
                                                for (int i = 0; i < waybillNos.length; i++) {
                                                if (i == waybillNos.length - 1) {
                                                sql.append(" ? )");
                                                } else {
                                                sql.append(" ? , ");
                                                }
                                                args.add(StringUtils.trim(waybillNos[i]));
                                                }
                                                }
                                                }
                                                //字段映射
                                                private void addScallarList(List<ColumnType> scallarList) {
                                                    scallarList.add(new ColumnType("waybillNo", Hibernate.STRING));
                                                    scallarList.add(new ColumnType("settleOrgCode", Hibernate.STRING));
                                                    scallarList.add(new ColumnType("settleOrgName", Hibernate.STRING));
                                                    scallarList.add(new ColumnType("centerOnScanTime", Hibernate.TIMESTAMP));
                                                    scallarList.add(new ColumnType("centerOnScanUploadTime", Hibernate.TIMESTAMP));
                                                    scallarList.add(new ColumnType("signTime", Hibernate.TIMESTAMP));
                                                    scallarList.add(new ColumnType("signUploadTime", Hibernate.TIMESTAMP));
                                                    scallarList.add(new ColumnType("inStorageTime", Hibernate.TIMESTAMP));
                                                    scallarList.add(new ColumnType("inStorageUploadTime", Hibernate.TIMESTAMP));
                                                    scallarList.add(new ColumnType("signEmpName", Hibernate.STRING));
                                                    scallarList.add(new ColumnType("signEmpNo", Hibernate.STRING));
                                                    scallarList.add(new ColumnType("expressFrequency", Hibernate.STRING));
                                                    }

                                                    }

```

## statdaoimpl.ftl ##
```


package cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;

import static cn.com.yto56.coresystem.module.commons.stl.constants.StlConst.DATE_FLG_AUDIT_TIME;

import com.ibm.gbs.ai.portal.framework.server.dao.hibernate.BaseEntityDao;
import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.ColumnType;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.PageFooterColumn;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.DateUtils;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

import cn.com.yto56.coresystem.module.commons.stl.constants.StlConst;
import cn.com.yto56.coresystem.module.commons.stl.dto.UserRoleHelper;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckStatDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dto.TStlEffectiveCheckStatDto;


/**
* @author  ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/

public class Stl${entityName}StatDaoImpl extends BaseEntityDao<TStlEffectiveCheckStatDto> implements
    IStl${entityName}StatDao {

    @Override
    public IPage<TStlEffectiveCheckStatDto> search${entityName}Stat(
        QueryPage queryPage, Map<String, String> searchFields, IUser user) {
        logger.trace(" enter dao ...");
        StringBuffer sql = new StringBuffer();
        List<Object> args = new ArrayList<Object>();
                List<ColumnType> scallarList = new ArrayList<ColumnType>();
                        sql.append(" SELECT T.SETTLE_ORG_CODE AS settleOrgCode, ");
                        sql.append(" T.SETTLE_ORG_NAME AS settleOrgName, ");
                        sql.append(" SUM(T.BILL_AMOUNT) AS billAmount ");
                        sql.append(" FROM YTSTL.T_STL_BILL_AGING_ASSESS T ");
                        sql.append(" WHERE 1=1 ");
                        if (StringUtils.isNotEmpty(searchFields.get("startDate"))) {
                        if(StringUtils.equals(searchFields.get("dateFlag"), DATE_FLG_AUDIT_TIME)){
                        sql.append(" AND T.BILL_AUDIT_TIME >= ? ");
                        }else{
                        sql.append(" AND T.BILL_CREATE_TIME >= ? ");
                        }
                        args.add(DateUtils.convert(StringUtils.trim(searchFields.get("startDate"))));
                        }
                        if (StringUtils.isNotEmpty(searchFields.get("endDate"))) {
                        if(StringUtils.equals(searchFields.get("dateFlag"), DATE_FLG_AUDIT_TIME)){
                        sql.append(" AND T.BILL_AUDIT_TIME < ? ");
                        }else{
                        sql.append(" AND T.BILL_CREATE_TIME < ? ");
                        }
                        args.add(DateUtils.getEndTimeAdd(DateUtils.convert(StringUtils.trim(searchFields.get("endDate")))));
                        }
                        if(StringUtils.isNotEmpty(searchFields.get("auditFlg"))){
                        sql.append(" AND T.AUDIT_FLG = ? ");
                        args.add(StringUtils.trim(searchFields.get("auditFlg")));
                        }
                        if(StringUtils.isNotEmpty(searchFields.get("settleOrgCode"))){
                        sql.append(" AND T.SETTLE_ORG_CODE = ? ");
                        args.add(StringUtils.trim(searchFields.get("settleOrgCode")));
                        }
                        if (!UserRoleHelper.isHeadFinancial(user)) {
                        sql.append(" AND EXISTS (");
                        sql.append("SELECT CODE FROM YTMDM.T_MDM_ORG M WHERE M.WHOLE_ORG_ID LIKE ");
                        sql.append(" '%|' || (SELECT ID FROM YTMDM.T_MDM_ORG WHERE CODE = '" + user.getBelongToOrgCode()
                        + "') || '|%' ");
                        sql.append(" AND T.SETTLE_ORG_CODE = M.CODE ) ");
                        }
                        sql.append(" GROUP BY T.SETTLE_ORG_CODE,T.SETTLE_ORG_NAME ");
                        addScallarList(scallarList);
                        addPageFooterColumn(args);
                        return findPageBySql(sql.toString(), args, queryPage.getPageSize(), queryPage.getPageIndex(), queryPage.getSortMap(), scallarList, TStlEffectiveCheckStatDto.class);
                        }
                        private void addScallarList(List<ColumnType> scallarList) {
                            scallarList.add(new ColumnType("settleOrgCode", Hibernate.STRING));
                            scallarList.add(new ColumnType("settleOrgName", Hibernate.STRING));
                            scallarList.add(new ColumnType("billAmount", Hibernate.DOUBLE));
                            }

                            private void addPageFooterColumn(List<Object> args) {
                                args.add(new PageFooterColumn("settleOrgCode", "'" + StlConst.TOTAL_WORD + "'", Hibernate.STRING));
                                args.add(new PageFooterColumn("billAmount", "sum(billAmount)", Hibernate.DOUBLE));
                                }
                                }
```


## search.ftl ##
```
$(function(){
	init();
	billStatGrid();
	billInfoGrid();
	checkDataGrid();
	billDetailsGrid();
	formValidate();
	searchTabsChange();
	resultTabsChange();
	$("#searchBtn").click(doSearch);
	$("#exportStatBtn").click(exportStats);
	$("#exportBillsBtn").click(exportBills);
	$("#exportDatasBtn").click(exportDatas);
	$("#exportDetailsBtn").click(exportDetails);
});
/**
 * 初始化基础查询条件参数
 */
function init(){
	$("#startDate").val(GetStartDate(0));
    $("#endDate").val(GetEndDate(0));
    $("#searchTabs").tabs();
    $("#resultTabs").tabs();
    $("#searchTabs").tabs('option','selected', 0);
    $("#resultTabs").tabs('option','selected', 0);
    $("#pageFlag").val(0);
    $("#gridFlag").val(0);
    $("#searchFlag").val(0);
    getOrgInfo("settleOrgCodeOrName","BRANCH","settleOrgCode",
			"../stlcommon/searchRestrictStlOrgNameControlCenter.action?random="+Math.random());
}

function searchTabsChange(){
    var searchTabs = "#searchTabs";
    var resultTabs = "#resultTabs";
    $(searchTabs).tabs({
        select: function(event, ui) {
            if(ui.index===0){
                $("#pageFlag").val(0);//按时间查询
                $("#startDate").rules("add",{
                    required : true
                });
                $("#endDate").rules("add",{
                    required : true
                });
                $("#waybillNo").rules("remove", "required");
                $("#billNo").rules("remove", "required");
                $(resultTabs).tabs('option','selected', 0);
            }else if(ui.index===1){
                $("#pageFlag").val(1);//按账单号查询
                $("#billNo").rules("add",{
                    required : true
                });
                $("#startDate").rules("remove", "required");
                $("#endDate").rules("remove", "required");
                $("#waybillNo").rules("remove", "required");
                $(resultTabs).tabs('option','selected', 1);
            }else if(ui.index===2){
            	 $("#pageFlag").val(2);//按运单号查询
                 $("#waybillNo").rules("add",{
                     required : true
                 });
                 $("#startDate").rules("remove", "required");
                 $("#endDate").rules("remove", "required");
                 $("#billNo").rules("remove", "required");
                 $(resultTabs).tabs('option','selected', 3);
            }
        }
    });
}

function resultTabsChange(){
    var resultTabs = "#resultTabs";
    $(resultTabs).tabs({
        select: function(event, ui) {
            if(ui.index===0){
                $("#gridFlag").val(0);
            }else if(ui.index===1){
                $("#gridFlag").val(1);
            }else if(ui.index === 2){
                $("#gridFlag").val(2);
            }else if(ui.index===3){
            	$("#gridFlag").val(3);
            }
        }
    });
}

function formValidate(){
    $("#searchForm").validate({
        rules:{
            "startDate": {required: true},
            "endDate": {required: true}
        },
        submitHandler:function(form){
            form.submit();
        }
    });
}
//账单统计
function billStatGrid(){
	var resultTabs = "#resultTabs";
	var billGrid = "#billInfoGrid";
	$("#billStatGrid").gridUtil().simpleGrid({
        url:"searchStats.action", //表格数据来源
        autowidth: false,    // 是否为可变大小
        width: 960,     //表格宽度960px
        shrinkToFit: false,  //此属性用来说明当初始化列宽度时候的计算类型，如果为ture，则按比例初始化列宽度。如果为false，则列宽度使用colModel指定的宽度
        multiselect : false, //是否可以选择多列
        colNames:["结算网点代码","结算网点名称","总公司应收金额"],
        colModel:[
            {name:"settleOrgCode",index:"settleOrgCode",width:"200px",align:"center",key:true},//结算网点代码
            {name:"settleOrgName",index:"settleOrgName",width:"200px",align:"center"},//结算网点名称
            {name:"billAmount",index:"billAmount",width:"170px",align:"center",formatter : 'number', formatoptions :
            		{ decimalSeparator : ".", thousandsSeparator : ",", decimalPlaces : 2, defaultValue : '' }},//总公司应收金额
        ],
        pager: "#billStatPage", //显示页数
        toolbar: [true,"top"], //工具栏显示及位置
        sortname: 'settleOrgCode', //排序列
        sortorder: 'ASC',		//排序规则
        caption: '结算网点账单统计',
        footerrow : true,  //当为true时，会在翻页栏之上增加一行
        userDataOnFooter : true,  
        ondblClickRow: function(id){
            $(resultTabs).tabs( 'option','selected', 1);
            $("#searchFlag").val('2');//双击查询
            var row = $("#billStatGrid").jqGrid('getRowData',id);
            $("#settleOrgCodeDb").val(row.settleOrgCode);
            $(billGrid).jqGrid("setGridParam",{datatype:"json"});
            $(billGrid).gridUtil().searchGrid($("#searchForm"));
            $(billGrid).jqGrid("setGridParam",{page:1});
        }
    } , {lazyload: true});
    $("#billStatToolbar").appendTo($("#t_billStatGrid"));
    $("#billStatGrid").gridUtil().customizeColumn();
}
//账单信息
function billInfoGrid(){
	$("#billInfoGrid").gridUtil().simpleGrid({
        url:"searchBills.action", //表格数据来源
        autowidth: false,    // 是否为可变大小
        width: 960,     //表格宽度960px
        shrinkToFit: false,  //此属性用来说明当初始化列宽度时候的计算类型，如果为ture，则按比例初始化列宽度。如果为false，则列宽度使用colModel指定的宽度
        multiselect : false, //是否可以选择多列
        colNames:["操作","审核状态","账单号码","结算网点代码","结算网点名称","总公司应收金额","业务所属日期",
                  "账单生成人","账单生成时间","账单开始时间","账单结束时间","账单生成网点名称","账单审核人","账单审核时间","账单审核网点名称"
        ],
        colModel:[
            {name:"operation",index:"operation",width:"120px",formatter:function(cellvalue, options, rowObject)
            	{return "<a id='searchCheckDatas'  onclick='searchCheckDatas(\""+rowObject.billNo+ "\")'><span class='l-btn-left'><span class='l-btn-text icon-find'>" + "查看考核时间点" + "</span></span></a>";}},//查看考核时间点
            {name:"auditFlg",index:"auditFlg",width:"120px",align:"center"},//审核状态
            {name:"billNo",index:"billNo",width:"170px",align:"center",key:true},//账单号码
            {name:"settleOrgCode",index:"settleOrgCode",width:"100px",align:"center"},//结算网点代码
            {name:"settleOrgName",index:"settleOrgName",width:"130px",align:"center"},//结算网点名称
            {name:"billAmount",index:"billAmount",width:"100px",align:"center",formatter : 'number', formatoptions :
            		{ decimalSeparator : ".", thousandsSeparator : ",", decimalPlaces : 2, defaultValue : '' }},//总公司应收金额
            {name:"rptDate",index:"rptDate",width:"130px",formatter:"date", formatoptions: {newformat:'Y-m-d'},align:"center"},//业务所属日期
            {name:"billCreateEmpName",index:"billCreateEmpName",width:"100px",align:"center"},//账单生成人
            {name:"billCreateTime",index:"billCreateTime",width:"130px",align:"center"},//账单生成时间
            {name:"billStartTime",index:"billStartTime",width:"130px",align:"center"},//账单开始时间
            {name:"billEndTime",index:"billEndTime",width:"130px",align:"center"},//账单结束时间
            {name:"billCreateOrgName",index:"billCreateOrgName",width:"130px",align:"center"},//账单生成网点名称
            {name:"billAuditEmpName",index:"billAuditEmpName",width:"100px",align:"center"},//账单审核人
            {name:"billAuditTime",index:"billAuditTime",width:"130px",align:"center"},//账单审核时间
            {name:"billAuditOrgName",index:"billAuditOrgName",width:"130px",align:"center"}//账单审核网点名称
        ],
        pager: "#billInfoPage", //显示页数
        toolbar: [true,"top"], //工具栏显示及位置
        sortname: '', //排序列
        sortorder: '',		//排序规则
        caption: '结算网点账单信息',
        footerrow : true,  //当为true时，会在翻页栏之上增加一行
        userDataOnFooter : true,  //
    },{lazyload: true});
    $("#billInfoToolbar").appendTo($("#t_billInfoGrid"));
    $("#billInfoGrid").gridUtil().customizeColumn();
}
//考核时间点数据
function checkDataGrid(){
	$("#checkDataGrid").gridUtil().simpleGrid({
        url:"searchCheckDatas.action", //表格数据来源
        autowidth: false,    // 是否为可变大小
        width: 960,     //表格宽度960px
        shrinkToFit: false,  //此属性用来说明当初始化列宽度时候的计算类型，如果为ture，则按比例初始化列宽度。如果为false，则列宽度使用colModel指定的宽度
        multiselect : false, //是否可以选择多列
        colNames:["考核时间点","结算网点代码","结算网点名称","结算网点类型","总公司应收金额","总票数","达成票数","未完成票数","实际签收率","指标签收率",
                  "业务所属日期","计费时间","账单生成人","账单生成时间","账单生成网点名称","账单审核人","账单审核时间","账单审核网点名称"
        ],
        colModel:[
            {name:"assessTimeType",index:"assessTimeType",width:"120px",align:"center",formatter : 'select',editoptions : {value : "A:15点;B:20点;C:24点;D:三频24点"}},//考核时间点
            {name:"settleOrgCode",index:"settleOrgCode",width:"100px",align:"center"},//结算网点代码
            {name:"settleOrgName",index:"settleOrgName",width:"130px",align:"center"},//结算网点名称
            {name:"settleOrgType",index:"settleOrgType",width:"110px",align:'center',hidden:true},//结算网点类型
            {name:"billAmount",index:"billAmount",width:"100px",align:"center",formatter : 'number', formatoptions :
    			{ decimalSeparator : ".", thousandsSeparator : ",", decimalPlaces : 2, defaultValue : '' }},//总公司应收金额
    		{name:"totalCenterVotes",index:"totalCenterVotes",width:"100px",align:"center"},//总票数
    		{name:"signedVotes",index:"signedVotes",width:"100px",align:"center"},//达成票数
//    		{name:"totalCenterVotes",index:"totalCenterVotes",width:"100px",align:"center",formatter:function(cellvalue, options, rowObject)
//                	{return "<a id='searchTotalCenterVotes'  onclick='searchTotalCenterVotes(\""+rowObject.assessTimeType+"\",\""+rowObject.rptDate+"\",\""+rowObject.settleOrgCode+"\")'><span><font color='#0000FF'>" + rowObject.totalCenterVotes + "</font></span></a>";}},//总票数
//            {name:"signedVotes",index:"signedVotes",width:"100px",align:"center",formatter:function(cellvalue, options, rowObject)
//                	{return "<a id='searchSignedVotes'  onclick='searchSignedVotes(\""+rowObject.assessTimeType+"\",\""+rowObject.rptDate+"\",\""+rowObject.settleOrgCode+"\")'><span><font color='#0000FF'>" + rowObject.signedVotes + "</font></span></a>";}},//达成票数
            {name:"unSignedVotes",index:"unSignedVotes",width:"100px",align:"center",formatter:function(cellvalue, options, rowObject)
                	{return "<a id='searchUnSignedVotes'  onclick='searchUnSignedVotes(\""+rowObject.assessTimeType+"\",\""+rowObject.rptDate+"\",\""+rowObject.settleOrgCode+"\")'><span><font color='#0000FF'>" + rowObject.unSignedVotes + "</font></span></a>";}},//未完成票数
            
            {name:"actualRateStr",index:"actualRateStr",width:"120px",align:"center"},//实际签收率
            {name:"targetRateStr",index:"targetRateStr",width:"120px",align:"center"},//指标签收率
            {name:"rptDate",index:"rptDate",width:"130px",formatter:"date", formatoptions: {newformat:'Y-m-d'},align:"center"},//业务所属日期
            {name:"chargeTime",index:"chargeTime",width:"130px",align:"center"},//计费时间
            {name:"billCreateEmpName",index:"billChargeEmpName",width:"100px",align:"center"},//账单生成人
            {name:"billCreateTime",index:"billCreateTime",width:"130px",align:"center"},//账单生成时间
            {name:"billCreateOrgName",index:"billChargeOrgName",width:"130px",align:"center"},//账单生成网点名称
            {name:"billAuditEmpName",index:"billAuditEmpName",width:"100px",align:"center"},//账单审核人
            {name:"billAuditTime",index:"billAuditTime",width:"130px",align:"center"},//账单审核时间
            {name:"billAuditOrgName",index:"billAuditOrgName",width:"130px",align:"center"}//账单审核网点名称
        ],
        pager: "#checkDataPage", //显示页数
        toolbar: [true,"top"], //工具栏显示及位置
        sortname: '', //排序列
        sortorder: '',		//排序规则
        caption: '考核时间点数据',
        footerrow : true,  //当为true时，会在翻页栏之上增加一行
        userDataOnFooter : true,  //
    } , {lazyload: true});
    $("#checkDataToolbar").appendTo($("#t_checkDataGrid"));
    $("#checkDataGrid").gridUtil().customizeColumn();
}
//单号明细
function billDetailsGrid(){
	$("#billDetailsGrid").gridUtil().simpleGrid({
        url:"searchDetails.action", //表格数据来源
        autowidth: false,    // 是否为可变大小
        width: 960,     //表格宽度960px
        shrinkToFit: false,  //此属性用来说明当初始化列宽度时候的计算类型，如果为ture，则按比例初始化列宽度。如果为false，则列宽度使用colModel指定的宽度
        multiselect : false, //是否可以选择多列
        colNames:["运单号码","结算网点代码","结算网点名称","中心上车扫描时间","中心上车扫描上传时间","签收时间","签收上传时间","入库时间",
                  "入库上传时间","签收业务员工号","签收业务员名称","快件频次"
        ],
        colModel:[
            {name:"waybillNo",index:"waybillNo",width:"120px",align:"center"},//运单号码
            {name:"settleOrgCode",index:"settleOrgCode",width:"100px",align:"center"},//结算网点代码
            {name:"settleOrgName",index:"settleOrgName",width:"130px",align:"center"},//结算网点名称
            {name:"centerOnScanTime",index:"centerOnScanTime",width:"150px",align:'center'},//中心上车扫描时间
            {name:"centerOnScanUploadTime",index:"centerOnScanUploadTime",width:"150px",align:'center'},//中心上车扫描上传时间
            {name:"signTime",index:"signTime",width:"150px",align:'center'},//签收时间
            {name:"signUploadTime",index:"signUploadTime",width:"150px",align:'center'},//签收上传时间
            {name:"inStorageTime",index:"inStorageTime",width:"150px",align:'center'},//入库时间
            {name:"inStorageUploadTime",index:"inStorageUploadTime",width:"150px",align:'center'},//入库上传时间
            {name:"signEmpNo",index:"signEmpNo",width:"110px",align:'center',formatter : 'select',editoptions : {value : "\N: "}},//签收业务员工号
            {name:"signEmpName",index:"signEmpName",width:"110px",align:'center',formatter : 'select',editoptions : {value : "\N: "}},//签收业务员名称
            {name:"expressFrequency",index:"expressFrequency",width:"110px",align:'center',
            	formatter : 'select',editoptions : {value : "1:一频;2:二频;3:三频"}}//快件频次（早班、中班、三频，早班改成一频，中班改成二频）
        ],
        pager: "#billDetailsPage", //显示页数
        toolbar: [true,"top"], //工具栏显示及位置
        sortname: '', //排序列
        sortorder: '',		//排序规则
        caption: '单号明细',
        footerrow : true,  //当为true时，会在翻页栏之上增加一行
        userDataOnFooter : true,  //
    } , {lazyload: true});
    $("#billDetailsToolbar").appendTo($("#t_billDetailsGrid"));
    $("#billDetailsGrid").gridUtil().customizeColumn();
}
//查询考核时间点tab页
function searchCheckDatas(billNo){
	$("#billNoDb").val(billNo);
	$("#resultTabs").tabs( 'enable', 2);
	$("#resultTabs").tabs( 'select', 2);
	$("#searchFlag").val(4);//单击查询flag  设置为4
	$("#checkDataGrid").gridUtil().searchGrid($("#searchForm"));
}
//点击总票数
function searchTotalCenterVotes(assessTimeType,rptDate,settleOrgCode){
	$("#assessTimeTypeDb").val(assessTimeType);
	$("#rptDateDb").val(rptDate);
	$("#settleOrgCodeDb").val(settleOrgCode);
	$("#resultTabs").tabs( 'enable', 3);
	$("#resultTabs").tabs( 'select', 3);
	$("#searchFlag").val(5);//单击票数查询flag  设置为5
	$("#colFlag").val(0);//选择的是总票数列
	$("#billDetailsGrid").gridUtil().searchGrid($("#searchForm"));
}
//点击达成票数
function searchSignedVotes(assessTimeType,rptDate,settleOrgCode){
	$("#assessTimeTypeDb").val(assessTimeType);
	$("#rptDateDb").val(rptDate);
	$("#settleOrgCodeDb").val(settleOrgCode);
	$("#resultTabs").tabs( 'enable', 3);
	$("#resultTabs").tabs( 'select', 3);
	$("#searchFlag").val(5);//单击票数查询flag  设置为5
	$("#colFlag").val(1);//选择的是达成票数列
	$("#billDetailsGrid").gridUtil().searchGrid($("#searchForm"));
}
//点击未达成票数
function searchUnSignedVotes(assessTimeType,rptDate,settleOrgCode){
	$("#assessTimeTypeDb").val(assessTimeType);
	$("#rptDateDb").val(rptDate);
	$("#settleOrgCodeDb").val(settleOrgCode);
	$("#resultTabs").tabs( 'enable', 3);
	$("#resultTabs").tabs( 'select', 3);
	$("#searchFlag").val(5);//单击票数查询flag  设置为5
	$("#colFlag").val(2);//选择的是未达成票数列
	$("#billDetailsGrid").gridUtil().searchGrid($("#searchForm"));
}
function doSearch(){
	var resultTabs = "#resultTabs";
    var girdFlag = "#gridFlag";
    var pageFlag = "#pageFlag";
    var statGird = "#billStatGrid";
    var billGrid = "#billInfoGrid";
    var detailGrid = "#billDetailsGrid";
    if($(pageFlag).val() === '0' && $(girdFlag).val() === '3'){//按时间  不能查明细！！！
        $(resultTabs).tabs( 'option','selected', 0);
        $(girdFlag).val(0);
        $.boxUtil.warn("按时间查询  不能查询明细 !");
    }
    if($(pageFlag).val() === '0' && $(gridFlag).val() === '0'){//按时间查账单统计
    	$(resultTabs).tabs( 'option','selected', 0);
    	$(girdFlag).val(0);
    }
    if($(pageFlag).val() === '0' && $(gridFlag).val() === '1'){//按时间查账单信息
    	$(resultTabs).tabs( 'option','selected', 1);
    	$(girdFlag).val(1);
    }
    if($(pageFlag).val() === '1' && $(girdFlag).val() !== '1'){//账单号查账单信息
        $(resultTabs).tabs( 'option','selected', 1);
        $(girdFlag).val(1);
    }
    if($(pageFlag).val() === '2' && $(girdFlag).val() !== '3'){//运单号查单号明细
        $(resultTabs).tabs( 'option','selected', 3);
        $(girdFlag).val(3);
    }
    if($("#settleOrgCodeOrName").val()===''){
        $("#settleOrgCode").val('');
    }
    if($(girdFlag).val()==='0'){
        $(statGird).gridUtil().searchGrid($("#searchForm"));//按时间查统计
    }else if($(girdFlag).val()==='1'){
    	if($(pageFlag).val()=='0'){
    		$("#searchFlag").val('0');//按照时间查账单信息
    	}if($(pageFlag).val()=='1'){
    		$("#searchFlag").val('1');//按照账单号查账单信息
    	}
        $(billGrid).gridUtil().searchGrid($("#searchForm"));
    }else if($(gridFlag).val()==='2'){
    	//按照时间是否能查询考核时间数据？？？
    	$(resultTabs).tabs( 'option','selected', 0);
        $(girdFlag).val(0);
    	$.boxUtil.warn("按时间查询  不能查询考核时间点数据 !");
    }else if($(gridFlag).val()==='3'){//按运单号查明细
    	$("#searchFlag").val('3');
    	$(detailGrid).gridUtil().searchGrid($("#searchForm"));
    }
}

function exportStats(){
	var records = $("#billStatGrid").getGridParam("records");
    if(records == 0){
        $.boxUtil.warn("结果集为空，不能导出！", {title: '提示'}, function(){});
        return false;
    } else {
        $.boxUtil.confirm("确定要导出吗?", {title:'确认' }, function(){
            $("#billStatGrid").gridUtil().exportGridExcel($("#searchForm"), {url:'exportSearchBills.action?exportFlg=1' });
        });
    }
}
function exportBills(){
	var records = $("#billInfoGrid").getGridParam("records");
    if(records == 0){
        $.boxUtil.warn("结果集为空，不能导出！", {title: '提示'}, function(){});
        return false;
    } else {
        $.boxUtil.confirm("确定要导出吗?", {title:'确认' }, function(){
            $("#billInfoGrid").gridUtil().exportGridExcel($("#searchForm"), {url:'exportSearchBills.action?exportFlg=2' });
        });
    }
}
function exportDatas(){
	var records = $("#checkDataGrid").getGridParam("records");
    if(records == 0){
        $.boxUtil.warn("结果集为空，不能导出！", {title: '提示'}, function(){});
        return false;
    } else {
        $.boxUtil.confirm("确定要导出吗?", {title:'确认' }, function(){
            $("#checkDataGrid").gridUtil().exportGridExcel($("#searchForm"), {url:'exportSearchBills.action?exportFlg=3' });
        });
    }
}
function exportDetails(){
	var records = $("#billDetailsGrid").getGridParam("records");
    if(records == 0){
        $.boxUtil.warn("结果集为空，不能导出！", {title: '提示'}, function(){});
        return false;
    } else {
        $.boxUtil.confirm("确定要导出吗?", {title:'确认' }, function(){
            $("#billDetailsGrid").gridUtil().exportGridExcel($("#searchForm"), {url:'exportSearchBills.action?exportFlg=4' });
        });
    }
}

/**
 * 根据网点代码以及类型查询网点信息
 */
var getOrgInfo = function(orgCodeOrName,orgType,orgCode,url) {
	if (orgCodeOrName == null || orgCode == null) {
		return;
	}
	$("#" + orgCodeOrName).autocomplete( {
		source : function(request, response) {
			$("#" + orgCode).val("");
			$.ajax( {
				url : url,
				dataType : "json",
				data : {
					orgCdOrNm : encodeURIComponent(request.term),
					orgType : orgType
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {
							label : item.code + " " + item.name,
							name : item.name,
							code : item.code
						};
					}));
				}
			});
		},
		minLength : 1,
		select : function(event, ui) {
			var code = ui.item.code;
			var name = ui.item.name;
			$("#" + orgCodeOrName).val(name);
			$("#" + orgCode).val(code);
			event.preventDefault();
		}
	});
};

```

## search.ftl ##
```
<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<script type="text/javascript"
	src="<c:url value='/scripts/${search}.js'/>"></script>
<div>
	<form id="searchForm" name="searchForm" method="post">
		<input type="hidden" id="billNoDb" name="billNoDb"> 
		<input type="hidden" id="billStartDate" name="billStartDate"> 
		<input type="hidden" id="billEndDate" name="billEndDate"> 
		<input type="hidden" id="statStartDate" name="statStartDate"> 
		<input type="hidden" id="statEndDate" name="statEndDate"> 
		<input type="hidden" id="searchFlag" name="searchFlag"> 
		<input type="hidden" id="detailSearchFlag" name="detailSearchFlag">
		<input type="hidden" id="assessTimeTypeDb" name="assessTimeTypeDb">
		<input type="hidden" id="rptDateDb" name="rptDateDb">
		<input type="hidden" id="settleOrgCodeDb" name="settleOrgCodeDb">
		<input type="hidden" id="colFlag" name="colFlag">
		<div class="fieldset_border">
			<div class="legend_title">
				<a href="#" class="container_show" id="rebateSearch">查询</a>
			</div>
			<div class="fieldset_container">
				<input id="pageFlag" name="pageFlag" type="hidden"> <input
					id="gridFlag" name="gridFlag" type="hidden">
				<div id="searchTabs" class="tabs">
					<ul>
						<li><a href="#tab-searchByTime">按账单时间查询</a></li>
						<li><a href="#tab-searchByBillNo">按账单号码查询</a></li>
						<li><a href="#tab-searchByWayBillNo">按运单号码查询</a></li>
					</ul>
					<div id="tab-searchByTime">
						<table border="0" cellspacing="1" cellpadding="0"
							class="table_form">
							<tr>
								<td colspan="8"><input type="radio" id="createTime"
									name="dateFlag" value="0" checked /><span>按账单生成时间</span> <input
									type="radio" id="auditTime" name="dateFlag" value="1" /><span>按账单审核时间</span>
								</td>
							</tr>
							<tr style="height: 40px">
								<th><em>*</em>开始时间:</th>
								<td style="width: 180px" colspan="2"><input id="startDate"
									name="startDate" class="Wdate width_time2"
									onfocus="WdatePicker({ doubleCalendar:false,autoPickDate:true, dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:$('#endDate').val() })" />
								</td>
								<th>结算网点</th>
								<td style="width: 180px"><input id="settleOrgCode"
									name="settleOrgCode" type="hidden"> <input
									id="settleOrgCodeOrName" type="text" name="settleOrgCodeOrName"
									class="width_b"></td>
							</tr>
							<tr style="height: 40px">
								<th><em>*</em>结束时间:</th>
								<td colspan="2"><input id="endDate" name="endDate"
									class="Wdate width_time2"
									onfocus="WdatePicker({ doubleCalendar:false,autoPickDate:true, dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:$('#startDate').val() })" />
								</td>
								<th>审核状态:</th>
								<td><select id="auditFlg" name="auditFlg" class="width_b">
										<option value="" selected="selected">全部</option>
										<option value="0">未审核</option>
										<option value="1">已审核</option>
										<option value="2">无效账单</option>
								</select></td>
							</tr>
						</table>
					</div>
					<div id="tab-searchByBillNo">
						<table class="table_form" style="height: 50px">
							<tr>
								<th><em>*</em>账单号：</th>
								<td><textarea id="billNo" name="billNo" cols="36px"
										rows="5"
										onfocus="if(this.value=='最多输入20个号码,以 ENTER隔开') {this.value='';}"
										onblur="if(this.value=='') {this.value='最多输入20个号码,以 ENTER隔开';}"
										style="resize: none">最多输入20个号码,以 ENTER隔开</textarea></td>
							</tr>
						</table>
					</div>
					<div id="tab-searchByWayBillNo">
						<table class="table_form" style="height: 50px">
							<tr>
								<th><em>*</em>运单号：</th>
								<td><textarea id="waybillNo" name="waybillNo" cols="36px"
										rows="5"
										onfocus="if(this.value=='最多输入20个号码,以 ENTER隔开') {this.value='';}"
										onblur="if(this.value=='') {this.value='最多输入20个号码,以 ENTER隔开';}"
										style="resize: none">最多输入20个号码,以 ENTER隔开</textarea></td>
							</tr>
						</table>
					</div>
					<div style="text-align: right; margin-right: 100px;">
						<a id="searchBtn" href="javascript:void(0)"
							class="easyui-linkbutton l-btn"> <span class="l-btn-left">查询</span>
						</a>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>
<div class="block">
	<div id="resultTabs" class="tabs">
		<ul>
			<li><a href="#tab-billStat">结算网点账单统计</a></li>
			<li><a href="#tab-billInfo">结算网点账单信息</a></li>
			<li><a href="#tab-checkData">考核时间点数据</a></li>
			<li><a href="#tab-billDetails">单号明细</a></li>
		</ul>
		<div id="tab-billStat" class="fieldset_container">
			<table id="billStatGrid"></table>
			<div id="billStatPage"></div>
			<div id="billStatToolbar">
				<a id="exportStatBtn" class="easyui-linkbutton l-btn"> <span
					class="l-btn-left"><span class="l-btn-text icon-excel">导出</span></span></a>
			</div>
		</div>
		<div id="tab-billInfo" class="fieldset_container">
			<table id="billInfoGrid"></table>
			<div id="billInfoPage"></div>
			<div id="billInfoToolbar">
				<a id="exportBillsBtn" class="easyui-linkbutton l-btn"> <span
					class="l-btn-left"><span class="l-btn-text icon-excel">导出</span></span></a>
			</div>
		</div>
		<div id="tab-checkData" class="fieldset_container">
			<table id="checkDataGrid"></table>
			<div id="checkDataPage"></div>
			<div id="checkDataToolbar">
				<a id="exportDatasBtn" class="easyui-linkbutton l-btn"> <span
					class="l-btn-left"><span class="l-btn-text icon-excel">导出</span></span></a>
			</div>
		</div>
		<div id="tab-billDetails" class="fieldset_container">
			<table id="billDetailsGrid"></table>
			<div id="billDetailsPage"></div>
			<div id="billDetailsToolbar">
				<a id="exportDetailsBtn" class="easyui-linkbutton l-btn"> <span
					class="l-btn-left"><span class="l-btn-text icon-excel">导出</span></span></a>
			</div>
		</div>
	</div>
</div>

```


## isearch.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz;

import java.util.Map;

import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBillNoDetail;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dto.TStlEffectiveCheckStatDto;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;

/**
 * @Description 
 * @author 
 * @date 2019年3月25日
 * @version 1.0
 */
public interface INewEffectiveCheckBillSearchBiz {
	
	IPage<TStlEffectiveCheckStatDto> searchEffectiveCheckStat(QueryPage queryPage, Map<String, String> searchFields, IUser user);

	IPage<TStlEffectiveCheckBill> searchEffectiveCheckBills(QueryPage queryPage, Map<String, String> searchFields, IUser user);
	
	IPage<TStlEffectiveCheckDetail> searchEffectiveCheckDetail(QueryPage queryPage, Map<String, String> searchFields, IUser user);
	
	IPage<TStlEffectiveCheckBillNoDetail> searchEffectiveCheckBillNoDetail(QueryPage queryPage, Map<String, String> searchFields, IUser user);
}


```

## searchimpl.ftl ##
```
package cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.impl;

import java.util.Map;

import com.ibm.gbs.ai.portal.framework.server.domain.IUser;
import com.ibm.gbs.ai.portal.framework.server.metadata.IPage;
import com.ibm.gbs.ai.portal.framework.server.metadata.Page;
import com.ibm.gbs.ai.portal.framework.server.metadata.QueryPage;
import com.ibm.gbs.ai.portal.framework.util.StringUtils;

import cn.com.yto56.coresystem.module.business.stlneweffectivecheck.biz.INewEffectiveCheckBillSearchBiz;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckBillNoDetailDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckBillsDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckDetailsDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dao.IStlNewEffectiveCheckStatDao;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBill;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckBillNoDetail;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.domain.TStlEffectiveCheckDetail;
import cn.com.yto56.coresystem.module.logic.stlneweffectivecheck.dto.TStlEffectiveCheckStatDto;

/**
 * @Description 
 * @author 
 * @date 2019年3月25日
 * @version 1.0
 */
public class NewEffectiveCheckBillSearchBizImpl implements
		INewEffectiveCheckBillSearchBiz {
	public static final String SEARCH_BY_TIME = "0";
	public static final String SEARCH_BY_BILLNO = "1";
	public static final String SEARCH_BY_DBCLICK = "2";
	public static final String SEARCH_BY_WAYBILLNO = "3";
	public static final String SEARCH_BY_CLICK = "4";
	public static final String SEARCH_BY_QTY = "5";
	
	private IStlNewEffectiveCheckStatDao stlNewEffectiveCheckStatDao;
	
	private IStlNewEffectiveCheckBillsDao stlNewEffectiveCheckBillsDao;
	
	private IStlNewEffectiveCheckDetailsDao stlNewEffectiveCheckDetailsDao;
	
	private IStlNewEffectiveCheckBillNoDetailDao stlNewEffectiveCheckBillNoDetailDao;

	@Override
	public IPage<TStlEffectiveCheckStatDto> searchEffectiveCheckStat(
			QueryPage queryPage, Map<String, String> searchFields, IUser user) {
		return stlNewEffectiveCheckStatDao.searchEffectiveCheckStat(queryPage, searchFields, user);
	}

	@Override
	public IPage<TStlEffectiveCheckBill> searchEffectiveCheckBills(
			QueryPage queryPage, Map<String, String> searchFields, IUser user) {
		String searchFlag = searchFields.get("searchFlag");
		if(SEARCH_BY_TIME.equals(searchFlag)){
			return stlNewEffectiveCheckBillsDao.searchEffectiveCheckBills(queryPage, searchFields, user);
		}
		if(SEARCH_BY_BILLNO.equals(searchFlag)){
			String billNo = searchFields.get("billNo");
			if(StringUtils.isNotEmpty(billNo)){
				String[] billNos = billNo.split("\n");
				return stlNewEffectiveCheckBillsDao.searchEffectiveCheckBillsByBillNo(queryPage, billNos, user);
			}
		}
		if(SEARCH_BY_DBCLICK.equals(searchFlag)){
			return stlNewEffectiveCheckBillsDao.searchEffectiveCheckBillsDbClick(queryPage, searchFields, user);
		}
		return new Page<TStlEffectiveCheckBill>(null,0,0,0);
	}

	@Override
	public IPage<TStlEffectiveCheckDetail> searchEffectiveCheckDetail(
			QueryPage queryPage, Map<String, String> searchFields, IUser user) {
		String searchFlag = searchFields.get("searchFlag");
		if(SEARCH_BY_CLICK.equals(searchFlag)){//单击查询考核时间点数据
			return stlNewEffectiveCheckDetailsDao.searchEffectiveCheckDetail(queryPage, searchFields, user);
		}
		return new Page<TStlEffectiveCheckDetail>(null,0,0,0);
	}

	@Override
	public IPage<TStlEffectiveCheckBillNoDetail> searchEffectiveCheckBillNoDetail(
			QueryPage queryPage, Map<String, String> searchFields, IUser user) {
		String searchFlag = searchFields.get("searchFlag");
		if(SEARCH_BY_WAYBILLNO.equals(searchFlag)){
			String waybillNo = searchFields.get("waybillNo");
			if(StringUtils.isNotEmpty(waybillNo)){
				String[] waybillNos = waybillNo.split("\n");
				return stlNewEffectiveCheckBillNoDetailDao.searchEffectiveCheckBillNoDetailByWaybillNo(queryPage, waybillNos, user);
			}
		}
		if(SEARCH_BY_QTY.equals(searchFlag)){
			return stlNewEffectiveCheckBillNoDetailDao.searchEffectiveCheckBillNoDetail(queryPage, searchFields, user);
		}
		return new Page<TStlEffectiveCheckBillNoDetail>(null,0,0,0);
	}

	public IStlNewEffectiveCheckStatDao getStlNewEffectiveCheckStatDao() {
		return stlNewEffectiveCheckStatDao;
	}

	public void setStlNewEffectiveCheckStatDao(
			IStlNewEffectiveCheckStatDao stlNewEffectiveCheckStatDao) {
		this.stlNewEffectiveCheckStatDao = stlNewEffectiveCheckStatDao;
	}

	public IStlNewEffectiveCheckBillsDao getStlNewEffectiveCheckBillsDao() {
		return stlNewEffectiveCheckBillsDao;
	}

	public void setStlNewEffectiveCheckBillsDao(
			IStlNewEffectiveCheckBillsDao stlNewEffectiveCheckBillsDao) {
		this.stlNewEffectiveCheckBillsDao = stlNewEffectiveCheckBillsDao;
	}

	public IStlNewEffectiveCheckDetailsDao getStlNewEffectiveCheckDetailsDao() {
		return stlNewEffectiveCheckDetailsDao;
	}

	public void setStlNewEffectiveCheckDetailsDao(
			IStlNewEffectiveCheckDetailsDao stlNewEffectiveCheckDetailsDao) {
		this.stlNewEffectiveCheckDetailsDao = stlNewEffectiveCheckDetailsDao;
	}

	public IStlNewEffectiveCheckBillNoDetailDao getStlNewEffectiveCheckBillNoDetailDao() {
		return stlNewEffectiveCheckBillNoDetailDao;
	}

	public void setStlNewEffectiveCheckBillNoDetailDao(
			IStlNewEffectiveCheckBillNoDetailDao stlNewEffectiveCheckBillNoDetailDao) {
		this.stlNewEffectiveCheckBillNoDetailDao = stlNewEffectiveCheckBillNoDetailDao;
	}
	
}


