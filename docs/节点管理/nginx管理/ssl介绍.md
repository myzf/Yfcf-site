## Jpom 中对ssl证书 管理

> 为了方便运维人员对nginx的管理，Jpom可以对ssl证书进行快捷管理。

#### 管理规则如下

1. 上传ssl证书zip压缩包，证书文件必须包含pem、crt、cer中的一个。
2. 证书上传成功后可点击模板按钮查看nginx证书配置模板信息（包含证书绑定域名，和证书所在路径）。
3. 如证书过期可点击编辑按钮重新上传证书，自动替换原有证书。

###   为了系统安全只有系统管理员可以配置ssl证书静态资源路径和删除证书文件