<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>菜单列表页面</title>
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="../../js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/ext/portal.css">
		<link rel="stylesheet" type="text/css" href="../../css/default.css">
		<script type="text/javascript" src="../../js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="../../js/easyui/ext/jquery.portal.js"></script>
		<script type="text/javascript" src="../../js/easyui/ext/jquery.cookie.js"></script>
		<script src="../../js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(function(){
				$("#grid").datagrid({
					toolbar : [
						{
							id : 'add',
							text : '添加菜单',
							iconCls : 'icon-add',
							handler : function(){
								location.href='menu_add.jsp';
							}
						}           
					],
					url : '../../menu_list.action',
					columns : [[
					  {
						  field : 'id',
						  title : '编号',
						  width : 200
					  },
					  {
						  field : 'name',
						  title : '名称',
						  width : 200
					  },  
					  {
						  field : 'description',
						  title : '描述',
						  width : 200
					  },  
					  {
						  field : 'priority',
						  title : '优先级',
						  width : 200
					  },  
					  {
						  field : 'page',
						  title : '路径',
						  width : 200
					  }
					]]
				});
			});
		</script>
	</head>

	<body class="easyui-layout">
		<div data-options="region:'center'">
			<table id="grid"></table>
		</div>
	</body>

</html>