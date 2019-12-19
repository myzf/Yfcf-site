
## bootstrap-ui.ftl ##
```
<form action="/${classInfo.className?uncap_first}/save">

    <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
        <#list classInfo.fieldList as fieldItem >
            <div class="form-group">
                <label for="${fieldItem.fieldName}Label">${fieldItem.fieldComment}</label>
                <input type="input" class="form-control" id="${fieldItem.fieldName}" name="${fieldItem.fieldName}" placeholder="请输入${fieldItem.fieldComment}">
            </div>
        </#list>
    </#if>

    <button type="submit" class="btn btn-primary">保存</button>
</form>

```


## element-ui.ftl ##
```
<el-form :inline="true" :model="submitData" class="demo-form-inline" :rules="rules" ref="ruleForm">
    <el-card class="box-card">
        <div slot="header" class="header clearfix">
            <span>${classInfo.classComment}</span>
            <el-button v-if="!ischeck && !isFind" class="fr" type="primary" @click="validate('ruleForm')">提交</el-button>
            <el-button v-else class="fr" type="primary" @click="goBack">返回</el-button>
        </div>
        <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
            <#list classInfo.fieldList as fieldItem >
             <el-form-item label="${fieldItem.fieldComment}" prop="${fieldItem.fieldName}">
                 <el-input placeholder="${fieldItem.fieldComment}" v-model="submitData.${fieldItem.fieldName}"></el-input>
             </el-form-item>
            </#list>
        </#if>
    </el-card>
</el-form>

```


## swagger-ui.ftl ##
```
@ApiOperation(value = "${classInfo.classComment}", notes = "${classInfo.classComment}")
    @ApiImplicitParams({
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem >
                @ApiImplicitParam(name = "${fieldItem.fieldName}", value = "${fieldItem.fieldComment}", required = false, dataType = "${fieldItem.fieldClass}")<#if fieldItem_has_next>,</#if>
                </#list>
            </#if>
    }
    )


```
