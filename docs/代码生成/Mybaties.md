


## mapper.ftl ##
```
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
* ${classInfo.classComment}
* @author ${authorName}
* @date ${.now?string('yyyy/MM/dd')}
*/
@Mapper
@Repository
public interface ${classInfo.className}Mapper {

    /**
    * [新增]
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int insert(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * [刪除]
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int delete(int id);

    /**
    * [更新]
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int update(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * [查詢] 根據主鍵 id 查詢
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    ${classInfo.className} load(int id);

    /**
    * [查詢] 分頁查詢
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    List<${classInfo.className}> pageList(int offset,int pagesize);

    /**
    * [查詢] 分頁查詢 count
    * @author ${authorName}
    * @date ${.now?string('yyyy/MM/dd')}
    **/
    int pageListCount(int offset,int pagesize);

}
```


## mybatis.xml ##
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${packageName}.dao.${classInfo.className}Dao">

    <resultMap id="BaseResultMap" type="${packageName}.entity.${classInfo.className}Entity" >
        <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
            <#list classInfo.fieldList as fieldItem >
                <result column="${fieldItem.columnName}" property="${fieldItem.fieldName}" />
            </#list>
        </#if>
    </resultMap>

    <sql id="Base_Column_List">
        <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
            <#list classInfo.fieldList as fieldItem >
                ${fieldItem.columnName}<#if fieldItem_has_next>,</#if>
            </#list>
        </#if>
    </sql>

    <insert id="insert" useGeneratedKeys="true" keyColumn="id" parameterType="${packageName}.entity.${classInfo.className}Entity">
        INSERT INTO ${classInfo.tableName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem >
                    <#if fieldItem.columnName != "id" >
                        ${r"<if test ='null != "}${fieldItem.fieldName}${r"'>"}
                        ${fieldItem.columnName}<#if fieldItem_has_next>,</#if>
                        ${r"</if>"}
                    </#if>
                </#list>
            </#if>
        </trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem >
                    <#if fieldItem.columnName != "id" >
                    <#--<#if fieldItem.columnName="addtime" || fieldItem.columnName="updatetime" >
                    ${r"<if test ='null != "}${fieldItem.fieldName}${r"'>"}
                        NOW()<#if fieldItem_has_next>,</#if>
                    ${r"</if>"}
                    <#else>-->
                        ${r"<if test ='null != "}${fieldItem.fieldName}${r"'>"}
                        ${r"#{"}${fieldItem.fieldName}${r"}"}<#if fieldItem_has_next>,</#if>
                        ${r"</if>"}
                    <#--</#if>-->
                    </#if>
                </#list>
            </#if>
        </trim>
    </insert>

    <delete id="delete" >
        DELETE FROM ${classInfo.tableName}
        WHERE id = ${r"#{id}"}
    </delete>

    <update id="update" parameterType="${packageName}.entity.${classInfo.className}Entity">
        UPDATE ${classInfo.tableName}
        <set>
            <#list classInfo.fieldList as fieldItem >
                <#if fieldItem.columnName != "id" && fieldItem.columnName != "AddTime" && fieldItem.columnName != "UpdateTime" >
                    ${r"<if test ='null != "}${fieldItem.fieldName}${r"'>"}${fieldItem.columnName} = ${r"#{"}${fieldItem.fieldName}${r"}"}<#if fieldItem_has_next>,</#if>${r"</if>"}
                </#if>
            </#list>
        </set>
        WHERE id = ${r"#{"}id${r"}"}
    </update>


    <select id="load" resultMap="BaseResultMap">
        SELECT <include refid="Base_Column_List" />
        FROM ${classInfo.tableName}
        WHERE id = ${r"#{id}"}
    </select>

    <select id="pageList" resultMap="BaseResultMap">
        SELECT <include refid="Base_Column_List" />
        FROM ${classInfo.tableName}
        LIMIT ${r"#{offset}"}, ${r"#{pageSize}"}
    </select>

    <select id="pageListCount" resultType="java.lang.Integer">
        SELECT count(1)
        FROM ${classInfo.tableName}
    </select>

</mapper>
```

## plusmapper.ftl ##
```
package ${packageName}.mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.springframework.stereotype.Repository;

/**
*  ${classInfo.classComment}
* @author ${authorName} ${.now?string('yyyy-MM-dd')}
*/
@Repository
public interface ${classInfo.className}Mapper extends BaseMapper<${classInfo.className}> {
}
```


## pluscontroller.ftl ##
```
package ${packageName}.controller;

import ${packageName}.entity.${classInfo.className};
import ${packageName}.mapper.${classInfo.className}Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import java.util.List;
import java.util.Map;

/**
* ${classInfo.classComment}
* @author ${authorName} ${.now?string('yyyy-MM-dd')}
*/
@RestController
@RequestMapping("/${classInfo.className?uncap_first}")
public class ${classInfo.className}Controller {

    @Autowired
    private ${classInfo.className}Mapper ${classInfo.className?uncap_first}Mapper;

    /**
    * 新增或编辑
    */
    @PostMapping("/save")
    public Object save(${classInfo.className} ${classInfo.className?uncap_first}){
        ${classInfo.className} ${classInfo.className?uncap_first} = ${classInfo.className?uncap_first}Mapper.selectOne(new QueryWrapper<${classInfo.className}>().eq("id",id))
        if(${classInfo.className?uncap_first}!=null){
            ${classInfo.className?uncap_first}Mapper.updateById(${classInfo.className?uncap_first});
        }else{
            ${classInfo.className?uncap_first}Mapper.insert(${classInfo.className?uncap_first});
        }
        return ${returnUtil}.success(${classInfo.className?uncap_first});
    }

    /**
    * 删除
    */
    @PostMapping("/delete")
    public Object delete(int id){
        ${classInfo.className} ${classInfo.className?uncap_first} = ${classInfo.className?uncap_first}Mapper.selectOne(new QueryWrapper<${classInfo.className}>().eq("id",id))
        if(${classInfo.className?uncap_first}!=null){
            return ${returnUtil}.success(${classInfo.className?uncap_first});
        }else{
            return ${returnUtil}.error("没有找到该对象");
        }
    }

    /**
    * 查询
    */
    @PostMapping("/find")
    public Object find(int id){
        ${classInfo.className} ${classInfo.className?uncap_first} = ${classInfo.className?uncap_first}Mapper.selectOne(new QueryWrapper<${classInfo.className}>().eq("id",id))
        if(${classInfo.className?uncap_first}!=null){
            return ${returnUtil}.success(${classInfo.className?uncap_first});
        }else{
            return ${returnUtil}.error("没有找到该对象");
        }
    }

    /**
    * 分页查询
    */
    @PostMapping("/list")
    public Object list(${classInfo.className} ${classInfo.className?uncap_first},
                        @RequestParam(required = false, defaultValue = "0") int pageNumber,
                        @RequestParam(required = false, defaultValue = "10") int pageSize) {
        //分页构造器
        Page<${classInfo.className}> page = new Page<${classInfo.className}>(pageNumber,pageSize);
        //条件构造器
        QueryWrapper<${classInfo.className}> queryWrapperw = new QueryWrapper<${classInfo.className}>(${classInfo.className?uncap_first});
        //执行分页
        IPage<${classInfo.className}> pageList = certPersonMapper.selectPage(page, queryWrapperw);
        //返回结果
        return ${returnUtil}.success(pageList);
    }

}
```