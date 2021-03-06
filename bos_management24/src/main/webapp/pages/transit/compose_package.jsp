<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>合包管理</title>
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
			$(function() {
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({
					visibility: "visible"
				});

				// 合包信息表格
				$('#compose_grid').datagrid({
					iconCls: 'icon-forward',
					fit: true,
					border: false,
					rownumbers: true,
					striped: true,
					pageList: [30, 50, 100],
					pagination: true,
					toolbar: toolbar,
					idField: 'id',
					columns: columns
				});

				// 条形码信息表格
				$('#detail_compose_grid').datagrid({
					iconCls: 'icon-forward',
					fit: true,
					border: false,
					rownumbers: true,
					striped: true,
					pageList: [30, 50, 100],
					pagination: true,

					idField: 'id',
					columns: child_columns
				});
			});

			//工具栏
			var toolbar = [{

				id: 'button-receive',
				text: '接收数据',
				iconCls: 'icon-undo',
				handler: function() {
					alert('接收数据');
				}

			},{

				id: 'button-import',
				text: '导入数据',
				iconCls: 'icon-redo',
				handler: function() {
					alert('导入');
				}

			}, {
				id: 'button-moreimport',
				text: '追加导入数据',
				iconCls: 'icon-redo',
				handler: function() {
					alert('追加导入数据');
				}
			},
			
			{
				id: 'button-delete',
				text: '删除合包',
				iconCls: 'icon-cut',
				handler: function() {
					alert('删除');
				}
			}, {
				id: 'button-add',
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					alert('增加');
				}
			}, {
				id: 'button-edit',
				text: '修改',
				iconCls: 'icon-edit',
				handler: function() {
					alert('修改');
				}
			}];

			// 定义列
			var columns = [
				[{
					field: 'id',
					title: '合包编号',
					width: 100,
					checkbox:true

				}, {
					field: 'composeNum',
					title: '合包号',
					width: 100,

				}, {
					field: 'composer',
					title: '合包人',
					width: 100,

				}, {
					field: 'equipementNum',
					title: '设备号',
					width: 100,

				}]
			];

			var child_columns = [
				[{
					field: 'id',
					title: '条形码编号',
					width: 100,
					checkbox:true
					

				}, {
					field: 'shapecode',
					title: '条码号',
					width: 100
				}]
			];
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center">
			<table id="compose_grid"></table>
		</div>
		<div region="south" style="height: 250px;">
			<table id="detail_compose_grid"></table>
		</div>
	</body>

</html>