<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>查台转单</title>
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
				// 查台转单			
				$("#grid").datagrid({
					columns: [
						[{
							field: 'id',
							title: '编号',
							width: 100,
							checkbox: true
						},
						{
							field: 'workBill.id',
							title: '工单编号',
							width: 100
						},
						{
							field: 'smsNumber',
							title: '短信序号',
							width: 100
						}, {
							field: 'type',
							title: '工单类型',
							width: 100
						}, {
							field: 'buildtime',
							title: '工单生成时间',
							width: 130
						}, {
							field: 'order.sendAddress',
							title: '地址',
							width: 100
						}, {
							field: 'courier.name',
							title: '快递员',
							width: 100
						}, {
							field: 'courier.telephone',
							title: '快递员电话',
							width: 100
						}, {
							field: 'customer_id',
							title: '客户编号',
							width: 100
						}, {
							field: 'order.sendName',
							title: '联系人',
							width: 100
						}, {
							field: 'order.sendMobile',
							title: '联系电话',
							width: 100
						}]
					],
					pagination: true,
					toolbar: [{
							id: 'searchBtn',
							text: '查询',
							iconCls: 'icon-search'
						}, {
							id: 'changeBtn',
							text: '转单',
							iconCls: 'icon-redo',
							handler: function() {
								alert('转单');
							}
						}, {
							id: 'resetBtn',
							text: '重发',
							iconCls: 'icon-reload',
							handler: function() {
								alert('重新发送');
							}
						}
					]
				});
			});
		</script>
	</head>
	<body>
		<div region="center">
			<table id="grid"></table>
		</div>
	</body>
</html>
