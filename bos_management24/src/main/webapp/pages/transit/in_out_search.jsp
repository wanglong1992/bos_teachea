<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>出入库查询</title>
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
				// 出入库查询			
				$("#grid").datagrid({
					fit:true,
					columns: [
						[{
							field: 'id',
							title: '编号',
							width: 100,
							checkbox: true
						}, {
							field: 'connectOrder',
							title: '交接单号',
							width: 100
						}, {
							field: 'wayBillNum',
							title: '运单号',
							width: 100
						}, {
							field: 'receiver',
							title: '接货人',
							width: 100
						}, {
							field: 'inStorageTime',
							title: '入库时间',
							width: 100
						}, {
							field: 'operator',
							title: '操作人',
							width: 100
						}, {
							field: 'operatingType',
							title: '操作类型',
							width: 100
						}, {
							field: 'operatingTime',
							title: '操作时间',
							width: 100
						}, {
							field: 'operatingCompany',
							title: '操作单位',
							width: 200
						}]
					],
					pagination: true,
					toolbar: [{
							id: 'searchBtn',
							text: '查询',
							iconCls: 'icon-search'
						}, {
							id: 'printBtn',
							text: '打印',
							iconCls: 'icon-print',
							handler: function() {
								alert('要打印吗？');
							}
						}, {
							id: 'importBtn',
							text: '导出',
							iconCls: 'icon-import',
							handler: function() {
								alert('导出数据吗');
							}
						}
					]
				});
			});
		</script>
	</head>
	<body>
		<body class="easyui-layout">
		<div region="center">
			<table id="grid"></table>
		</div>
	</body>
	</body>
</html>
