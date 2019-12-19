# JdbcWapper

```功能
常用的数据库操作crud.
支持mysql.
依赖spring-jdbc.
使用JdbcWapper后只需配置好实体和数据库表的关系,即可完成不写sql操作表
```



### 常用方法
1. 批量插入
2. 单条插入
3. 批量更新
4. 单条更新
5. 多条件查询

#### 使用前提
>在class上添加和表对照的@Table和@Column

```
@Table(name="T_STL_FIXEDPRICE_NOCHARGE")
public class StlFixedPriceNoCharge implements Serializable{

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	
	@Column(name="ID")
	private String id; 
	@Column(name="WAYBILL_NO")
	private String waybillNo; 
	@Column(name="DATA_TYPE")
	private String dataType; 
	@Column(name="NOCHARGE_TYPE")
	private String nochargeType; 
	@Column(name="CREATE_TIME")
	private Date createTime;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getWaybillNo() {
		return waybillNo;
	}
	public void setWaybillNo(String waybillNo) {
		this.waybillNo = waybillNo;
	}
	 
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public String getNochargeType() {
		return nochargeType;
	}
	public void setNochargeType(String nochargeType) {
		this.nochargeType = nochargeType;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
}
```

>传入参数 jdbcTemplate、实体类的list,实体类的class

```java
@Autowired
	private JdbcWrapper jdbcWrapper;
	@Override
	public void batchSaveBillOperDetails(List<TStlDetailOper> waybillList) {
		try {
			jdbcWrapper.batchSave(jdbcTemplate, waybillList, TStlDetailOper.class);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
```



## 复杂查询 ##

```
  TStlFixedPriceEndDetail tStlFixedPriceEndDetail = new TStlFixedPriceEndDetail();
        tStlFixedPriceEndDetail.setChargeDesCode("1");
        tStlFixedPriceEndDetail.setBackup1("3");
        //生成自定义where条件
        Criteria criteria = new Criteria();
        criteria.and("department","财务开发组");//列字段+列值
        List<A> list = Lists.newArrayList();
        A a = new A();
        a.setName("1");
        a.setDepartment("1");
        A b = new A();
        b.setName("2");
        b.setDepartment("2");
        list.add(a);
        list.add(b);
        jdbcWrapper.batchUpdate(jdbcTemplate,A.class,criteria,list);
```

>**其他插入、查询、删除、分页等复杂sql等高级操作可参看EntityDao接口**



```
/**
	 * 插入指定的持久化对象
	 * @throws Exception sql错误抛出异常
	 * @param t 实体对象
	 */
	void save(T t) throws Exception ;

	/**
	 * 修改指定的持久化对象
	 * @throws Exception sql错误抛出异常
	 * @param t 实体对象
	 */
	void update(T t) throws Exception ;

	/**
	 * 批量保存指定的持久化对象
	 * @throws Exception sql错误抛出异常
	 * @param list 实体对象集合
	 */
	void batchSave(List<T> list) throws Exception ;

	/**
	 * 批量更新指定的持久化对象
	 * @throws Exception sql错误抛出异常
	 * @param list 实体对象集合
	 */
	void batchUpdate(List<T> list) throws Exception ;

	/**
	 * 根据主键删除
	 * @throws Exception sql错误抛出异常
	 * @param id 实体主键
	 */
	void delete(Id id) throws Exception ;

	/**
	 * 根据where条件删除
	 * @param criteria 条件参数
	 * @throws Exception sql错误抛出异常
	 */
	void deleteWithCriteria(Criteria criteria) throws Exception;

	/**
	 * 根据主键批量删除
	 * @throws Exception sql错误抛出异常
	 * @param ids 主键集合
	 */
	void batchDelete(List<Id> ids) throws Exception ;

	/**
	 * 根据ID检索持久化对象
	 * @param id 主键
	 * @return T 实体对象
	 * @throws Exception sql错误抛出异常
	 */
	T queryOne(Id id) throws Exception ;

	/**
	 * 检索所有持久化对象
	 * @return List 实体对象列表
	 * @throws Exception sql错误抛出异常
	 */
	List<T> queryAll() throws Exception ;

	/**
	 * 分页查询
	 * @param page 分页条件
	 * @return PageResult 分页查询结果
	 * @throws Exception sql错误抛出异常
	 */
	PageResult<T> pageQuery(Page page) throws Exception;

	/**
	 * 分页条件查询
	 * @param page 分页条件
	 * @param criteria 查询条件
	 * @return PageResult 分页查询结果
	 * @throws Exception sql错误抛出异常
	 */
	PageResult<T> pageQueryWithCriteria(Page page, Criteria criteria) throws Exception;

	/**
	 * 条件查询
	 * @param criteria 查询条件
	 * @return List 结果集
	 * @throws Exception sql错误抛出异常
	 */
	List<T> queryWithCriteria(Criteria criteria) throws Exception;

	/**
	 * 根据条件查询
	 * @param criteria 查询条件
	 * @return T 实体对象
	 * @throws Exception sql错误抛出异常
	 */
	T queryOne(Criteria criteria)throws Exception;

	/**
	 * 根据sql查询
	 * @param sql sql拼接器
	 * @param <E> 查询结果类型
	 * @throws Exception
	 */
	<E> Result<E> queryWithSql(Class<E> clss, SQL sql)throws Exception;

	/**
	 * 根据sql更新
	 * @param sql sql拼接器
	 * @return int 更新条目数量
	 * @throws Exception
	 */
	int updateWithSql(SQL sql)throws Exception;
	/**
	 * 键值对查询
	 * @param sql sql拼接器
	 * @param resultSetExtractor 结果抽取器
	 * @param <K> 键类型
	 * @param <V> 值类型
	 * @return Map 返回类型Map
	 * @throws Exception
	 */
	<K,V> Map<K,V> queryMapWithSql(SQL sql, ResultSetExtractor<Map<K, V>> resultSetExtractor)throws Exception;

	/**
	 * 根据条件查询Map集合
	 * @param sql sql拼接器
	 * @return List 结果集
	 * @throws Exception sql错误抛出异常
	 */
	List<Map<String,Object>> queryMapsWithSql(SQL sql)throws Exception;

	/**
	 * 根据sql查询一个int值
	 * @param sql sql拼接器
	 * @return Integer 结果类型，一般为查询数量
	 * @throws Exception
	 */
	Integer queryIntegerWithSql(SQL sql)throws Exception;

	/**
	 * 根据sql插入数据
	 * @param sql sql拼接器
	 * @return int 更新条目数量
	 * @throws Exception
	 */
	int insertWithSql(SQL sql)throws Exception;


```




