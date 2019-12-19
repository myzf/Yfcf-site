> 注入redisClient

```
@Autowired
private IRedisService iRedisService;
....


```



_调用n种方法_

```
/** 
	 * @Description: 获取list数据并删除
	 * @author: GuanXianmin 
	 * @date: 2018年11月13日 下午1:58:35
	 * @param:@param shardedJedisPool
	 * @param:@param nitoceName
	 * @param:@param count
	 * @param:@return
	 * @return: List<String> 返回类型
	 */
	List<String> getMessageFromProducer(ShardedJedisPool shardedJedisPool, String nitoceName, Integer count);

	/**
	 * @Description: 批量删除key
	 * @author: GuanXianmin
	 * @date: 2018年11月13日 下午1:58:53
	 * @param:@param shardedJedisPool
	 * @param:@param keys
	 * @param:@return
	 * @return: Long 返回类型
	 */
	Long delKeys(ShardedJedisPool shardedJedisPool, String[] keys);

	/**
	 * @Description: 保存 key-value
	 * @author: GuanXianmin
	 * @date: 2018年11月13日 下午1:59:04
	 * @param:@param shardedJedisPool
	 * @param:@param key
	 * @param:@param value
	 * @param:@param timeOut
	 * @param:@return
	 * @return: String 返回类型
	 */
	String setSingleString(ShardedJedisPool shardedJedisPool, String key, String value, int timeOut);

	/**
	 * @Description: 批量获取Bykeys
	 * @author: GuanXianmin
	 * @date: 2018年11月13日 下午2:13:31
	 * @param:@param shardedJedisPool
	 * @param:@param keys
	 * @param:@return
	 * @return: List<String> 返回类型
	 */
	List<String> getListByKeys(ShardedJedisPool shardedJedisPool, String[] keys);

	/**
	 * @Description: 获取key-value
	 * @author: GuanXianmin
	 * @date: 2018年11月13日 下午2:13:31
	 * @param:@param shardedJedisPool
	 * @param:@param keys
	 * @param:@return
	 * @return: List<String> 返回类型
	 */
	String getStringByKey(ShardedJedisPool shardedJedisPool, String key);

	boolean saveToListAndString(ShardedJedisPool shardedJedisPool, String string, String jsonString, String string2);

	public Set<String> getSetValues(ShardedJedisPool shardedJedisPool, String key);
	
	
	/**
    	 * 保存字符串到list  通用
    	 * @description 
    	 * @created  by huagnjianhua@2015-7-23
    	 * @param redisType
    	 * @param value
    	 * @return
    	 */
    	public Long saveToList(String redisType, List<String> value);
    	
    	/**
    	 * 保存字符串到list和散key  通用
    	 * @description 
    	 * @created  by huagnjianhua@2015-7-23
    	 * @param redisType
    	 * @param value
    	 * @return
    	 */
    	public boolean saveToListAndString(String redisType, String producerKey, String value);
    	
    	/**
    	 * 批量保存字符串到list和散key  通用
    	 * @description 
    	 * @created  by huagnjianhua@2016-1-4
    	 * @param redisType
    	 * @param value
    	 * @return
    	 */
    	public List<String>  saveToListAndStringBatch(String redisType, Map<String, String> value);
    	
    	/**
    	 * 从redis生产者获得数据  通用 ,获得数据同时在生存者中删除次数据,可多线程使用
    	 * @description 
    	 * @created  by huagnjianhua@2015-8-19
    	 * @param redisType
    	 * @param size
    	 * @return
    	 */
    	public List<String>  getMessageFromProducer(String redisType, int size);
    	
    	/**
    	 * 从list获得数据 查询用，不删数据  通用 
    	 * @description 
    	 * @created  by huagnjianhua@2015-8-19
    	 * @param redisType
    	 * @param size
    	 * @return
    	 */
    	public List<String>  getMessageFromList(String redisType, int size);
    	
    	/**
    	 * 通过散key批量获得消息
    	 * @description 
    	 * @created  by huangjianhua@2015-9-6
    	 * @param redisType
    	 * @param keys
    	 * @return
    	 */
    	public List<String>	 getMessageByKeys(String redisType, List<String> keys);
    	
    	/**
    	 * 通过散key删除消息
    	 * @description 
    	 * @created  by huangjianhua@2015-9-7
    	 * @param redisType
    	 * @param keys
    	 * @return
    	 */
    	public Long	 delMessageByKeys(String redisType, List<String> keys);
    	
    	
    	/**
    	 * @declare delMessageByKey: 通过散key删除消息
    	 * @author weiBingjie 
    	 * @date 2016年1月27日 上午10:29:25
    	 * @param redisType
    	 * @param keys
    	 * @return Long
    	 */
    	public Long	 delMessageByKey(String redisType, String key);
    	
    	/**
    	 * 通过模糊查询获得keys
    	 * @description 
    	 * @created  by huangjianhua@2015-9-7
    	 * @param redisType
    	 * @param likeString
    	 * @return
    	 */
    	public List<String> getKeysByFuzzySearch(String redisType, String likeString);
    	
    	/**
    	 * 获取每个redisdbsize大小
    	 * @description 
    	 * @created  by yanwangen@2016-11-17
    	 * @param redisType
    	 * @param 
    	 * @return
    	 */
    	public Long getRedisDbsize(String redisType);
    	
    	/**
    	 * 批量保存字符串\散key  通用
    	 * @description 
    	 * @created  by yanwangen@2017-08-31
    	 * @param redisType
    	 * @param value
    	 * @return
    	 */
    	public String  saveKeyListBatch(String redisType, Map<String, String> value);
    	
    	/**
    	 * 从redis生产者通过指定key获得数据  ,获得数据同时在生存者中删除次数据
    	 * @param redisType 用于获取redis实例
    	 * @param listKey redis 队列key
    	 * @param size 获取长度
    	 * @return
    	 */
    	public List<String>  getMessageFromProducer(String redisType, String listKey, int size);
	
	
```	