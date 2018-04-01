<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://shiro.apache.org/tags" prefix="shiro" %>
<script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery-1.8.3.js"></script>
<link id="easyuiTheme" rel="stylesheet" href="${pageContext.request.contextPath }/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/js/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/css/default.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/js/easyui/jquery.easyui.min.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<shiro:hasPermission name="courier:add">
	<a href="#" class="easyui-linkbutton">添加</a>
</shiro:hasPermission>
<shiro:hasPermission name="courier:update">
	<a href="#" class="easyui-linkbutton">修改</a>
</shiro:hasPermission>
<shiro:hasPermission name="courier:delete">
	<a href="#" class="easyui-linkbutton">删除</a>
</shiro:hasPermission>
<shiro:hasPermission name="courier:list">
	<a href="#" class="easyui-linkbutton">查询</a>
</shiro:hasPermission>

用户名：<shiro:principal property="username"></shiro:principal>
</body>
</html>