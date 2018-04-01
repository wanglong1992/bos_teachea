<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>取消签收申请</title>
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
			function addorderlist() {
				$('#addorder').window("open");
			}

			var toolbar = [{
					id: 'searchBtn',
					text: '查询',
					iconCls: 'icon-search'
				}, {
					id: 'addBtn',
					text: '新增',
					iconCls: 'icon-add',
					handler: addorderlist
				}, {
					id: 'deleteBtn',
					text: '作废',
					iconCls: 'icon-cancel',
					handler: function() {
						alert('作废');
					}
				}, {
					id: 'editBtn',
					text: '审批情况',
					iconCls: 'icon-edit',
					handler: function() {
						alert('审批情况');
					}
				}

			]
			var columns = [
				[{
					field: 'id',
					title: '编号',
					width: 100,
					checkbox: true
				}, {
					field: 'signBillNum',
					title: '申请单号',
					width: 100
				}, {
					field: 'wayBillNum',
					title: '工作单号',
					width: 100
				}, {
					field: 'sendCompany',
					title: '派送单位',
					width: 100
				}, {
					field: 'sendTime',
					title: '派送时间',
					width: 100
				}, {
					field: 'signStatus',
					title: '签收状态',
					width: 100
				}, {
					field: 'approveStatus',
					title: '审批状态',
					width: 100
				}, {
					field: 'applyreson',
					title: '申请原因',
					width: 100
				}, {
					field: 'applyer',
					title: '申请人',
					width: 100
				}, {
					field: 'applyUnit',
					title: '申请单位',
					width: 100
				}, {
					field: 'applyTime',
					title: '申请时间',
					width: 100
				}, {
					field: 'remark',
					title: '异常备注',
					width: 100
				}]
			]

			$(function() {
				// 取消签收申请			

				$("#grid").datagrid({
					iconCls: 'icon-forward',
					fit: true,
					border: true,
					rownumbers: true,
					striped: true,
					pageList: [30, 50, 100],
					pagination: true,
					toolbar: toolbar,
					url: "",
					idField: 'id',
					columns: columns,
				});

				// 新增分区
				$('#addorder').window({
					title: '新增卡片界面',
					
					modal: true,
					shadow: true,
					closed: true,
					height: 270,
					resizable: false
				});
			});
		</script>
	</head>

	<body class="easyui-layout">
		<div region="center">
			<table id="grid"></table>
		</div>
		<!-- 新增 -->
		<div class="easyui-window" title="新增取消签收" id="addorder" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form id="searchForm">
					<table class="table-edit" align="center">

						<tr>
							<td>申请单号</td>
							<td>
								<input type="text" required="true" name="approveorder" />
							</td>
							<td>运单号</td>
							<td>
								<input type="text" required="true" name="waybillnum" />
							</td>
							<td>异常单号</td>
							<td>
								<input type="text" required="true" name="errorbillnum" />
							</td>

						</tr>
						<tr>
							<td>派送时间</td>
							<td>
								<input type="text" required="true" name="giveTime" />
							</td>
							<td>签收状态</td>
							<td>
								<select class="easyui-combobox" style="width:150px">
									<option>正常</option>
									<option>返单</option>
									<option>转发签收</option>

								</select>
							</td>
							<td>派送单位</td>
							<td>
								<input type="text" required="true" name="sendUnit" />
							</td>
						</tr>

						<tr>
							<td>异常备注</td>
							<td><input type="text" required="true" name="errormark" style="width:200px"/></td>
						</tr>
						<tr>
							<td>申请原因</td>
							<td><input type="text" required="true" name="errormark" style="width:200px"/></td>
						</tr>
						<tr>
							<td>申请人</td>
							<td><input type="text" required="true" name="approver" /></td>
							<td>申请时间</td>
							<td><input type="text" required="true" name="approvetime" /></td>
							<td>申请单位</td>
							<td><input type="text" required="true" name="approveunit" /></td>
						</tr>
						<tr>
							<td colspan="1"><a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'">提交审批</a> </td>
							
							<td colspan="1"><a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">取消</a> </td>
							
						</tr>
						
						
					</table>
				</form>
			</div>
		</div>

	</body>

</html>