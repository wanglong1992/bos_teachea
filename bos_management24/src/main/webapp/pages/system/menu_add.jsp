<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>菜单添加</title>
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
				// 点击保存
				$('#save').click(function(){
					//location.href='menu.jsp';
					if($("#menuForm").form("validate")){
						$("#menuForm").submit();
					}
				});
			});
		</script>
	</head>

	<body class="easyui-layout">
		<div data-options="region:'north'">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
			</div>
		</div>
		<div data-options="region:'center'">
			<form id="menuForm" method="post" action="../../menu_save.action">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">菜单项信息</td>
					</tr>
					<tr>
						<td>名称</td>
						<td>
							<input type="text" name="name" class="easyui-validatebox" data-options="required:true" />
						</td>
					</tr>
					<tr>
						<td>访问路径</td>
						<td>
							<input type="text" name="page" />
						</td>
					</tr>
					<tr>
						<td>优先级</td>
						<td>
							<input type="text" name="priority" class="easyui-numberbox" data-options="required:true" />
						</td>
					</tr>
					<tr>
						<td>父菜单项</td>
						<td>
							<input name="parentMenu.id" class="easyui-combobox" data-options="valueField:'id',textField:'name',url:'../../menu_list.action'" />
						</td>
					</tr>
					<tr>
						<td>描述</td>
						<td>
							<textarea name="description" rows="4" cols="60"></textarea>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>

</html>