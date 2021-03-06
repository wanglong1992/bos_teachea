<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>入库</title>
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
				
				// 定义入库交接单号列
				var instorageorder_columns = [
					[{
						field: 'id',
						title: '编号',
						width: 100,
						checkbox: true
					}, {
						field: 'wayBill.wayBillNum',
						title: '运单号',
						width: 100
					}, {
						field: 'wayBill.goodsType',
						title: '货物',
						width: 100
					}, {
						field: 'wayBill.sendAddress',
						title: '发货地址',
						width: 100
					}, {
						field: 'wayBill.recAddress',
						title: '收货地址',
						width: 100
					}, {
						field: 'inconnectOrder',
						title: '入库交接单号',
						width: 100
					},{
						field: 'inconnectOrderInfo',
						title: '入库信息',
						width: 100
					}, {
						field: 'receiver',
						title: '接货人',
						width: 100
					}, {
						field: 'receiveUnit',
						title: '接货单位',
						width: 100
					}, {
						field: 'inStorageTime',
						title: '入库时间',
						width: 100
					}]
				];
				
				// 入库信息表格
				$('#storageorder_grid').datagrid({
					iconCls: 'icon-forward',
					fit: true,
					border: false,
					rownumbers: true,
					striped: true,
					pageList: [20, 50, 100],
					pagination: true,
					idField: 'id',
					columns: instorageorder_columns
				});
			});
		</script>

	</head>

	<body class="easyui-layout">
		<div data-options="region:'center'" style="height:300px">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-add" href="#" class="easyui-linkbutton" plain="true">新增</a>
				<a id="edit" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				<a id="edit" icon="icon-cancel" href="#" class="easyui-linkbutton" plain="true">取消</a>
				<a id="edit" icon="icon-search" href="#" class="easyui-linkbutton" plain="true">查询</a>
				<a id="edit" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">确认</a>
				<a id="edit" icon="icon-edit" href="#" class="easyui-linkbutton" plain="true">列表显示</a>
			</div>
			<table id="storageorder_grid"></table>
		</div>
	</body>

</html>