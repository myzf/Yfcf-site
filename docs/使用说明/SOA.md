> SOA目前只适合老项目的走件查询


 # 引入依赖 #
 
 
 ```
        <dependency>
            <groupId>com.caucho</groupId>
            <artifactId>hessian</artifactId>
            <version>4.0.33</version>
        </dependency>
```


 # 使用说明 #

```
   @Autowired
   @Qualifier("expTrackSoa")
   private IHessianSoa hessianSoa;
   
   //调用
   String lstTrace = hessianSoa.track(0, waybillNo);//waybillNo是List
```


