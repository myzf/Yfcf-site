>抽象消费Mq消息

```

    /**
     * 抽象处理消息方法
     * @
     * @className StlAbstractConsumer
     * @author minyangzhuangfei
     * @date 2019/7/31 14:59
     * @since JDK 1.8
     * @see cn.com.yto56.frameworkJob.core.config.mq
     * @return
     * @throws
     */
    public DtoItems abstractMsgs(List<MessageExt> msgs){
        DtoItems dtoItems = new DtoItems();
        JobConfig jobConfig = ConfigRel.get("config");
        List list = Lists.newArrayList();
        for (MessageExt message : msgs) {
            try {
                String body = new String(message.getBody(), "UTF-8");
                Class clazz = Class.forName("cn.com.yto56.frameworkJob.common.domain."+jobConfig.getRedisEntryName());
                Object notice = JSON.parseObject(body, clazz);
                list.add(notice);
                if(list!=null && list.size()>0){
                    dtoItems.getDtoList().addAll(list);
                    return dtoItems;
                }
            } catch (Exception e) {
                logger.error("消息{}解析异常,异常信息{}" ,message,e.getMessage());
            }
        }
        return null;
    }

```





>分发Mq消息

```
  public ConsumeConcurrentlyStatus consumeMessage(final List<MessageExt> msgs, final ConsumeConcurrentlyContext context) {
            try {
                //抽象处理消息
                DtoItems dtoItems = abstractMsgs(msgs);
                FindPrice<DtoItems, LogItems> findPrice = SpringUtils.getBean(FindPrice.class);
                LogItems result = findPrice.execute(dtoItems);
                return result.getConsumeConcurrentlyStatus();
            }catch (Exception e){
                logger.info("计费异常",e.getMessage());
                context.setDelayLevelWhenNextConsume(delayLevelWhenNextConsume);
                return ConsumeConcurrentlyStatus.RECONSUME_LATER;
            }
        }

```


