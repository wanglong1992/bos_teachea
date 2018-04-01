<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>签收录入</title>
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
			function approveorderlist() {
				$('#approveorder').window("open");
			}
			var columns = [
				[{
					field: 'id',
					title: '录入编号',
					width: 100,
					checkbox: true
				}, {
					field: 'wayBill.wayBillNum',
					title: '工作单号',
					width: 100
				}, {
					field: 'returnMark',
					title: '返单标志',
					width: 100
				}, {
					field: 'courierNum',
					title: '派送员工号',
					width: 100
				}, {
					field: 'courierName',
					title: '派送人姓名',
					width: 100
				}, {
					field: 'courierCompany',
					title: '派送单位',
					width: 100
				}, {
					field: 'signName',
					title: '签收人',
					width: 100
				}, {
					field: 'signTime',
					title: '签收时间',
					width: 100
				}, {
					field: 'signType',
					title: '签收类型',
					width: 100
				}, {
					field: 'errorRemark',
					title: '异常备注',
					width: 200
				}]
			];

			$(function() {
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({
					visibility: "visible"
				});

				// 信息表格
				$('#grid').datagrid({
					iconCls: 'icon-forward',
					fit: true,
					border: false,
					rownumbers: true,
					striped: true,
					idField: 'id',
					columns: columns,
					toolbar: '#tb',
					pagination: true
				});

				// 签收单
				$('#approveorder').window({
					title: '申请单',
					modal: true,
					shadow: true,
					closed: true,
					height: 370,
					resizable: false
				});
			});
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div id="tb">
			<a id="save" icon="icon-add" href="#" class="easyui-linkbutton" plain="true" onclick="approveorderlist()">增加</a>
			<a id="edit" icon="icon-cut" href="#" class="easyui-linkbutton" plain="true">删除</a>
			<a id="edit" icon="icon-help" href="#" class="easyui-linkbutton" plain="true">帮助</a>
			<br />
			<form>
				<table class="table-edit">
					<tr>
						<td>录入人姓名</td>
						<td><input type="text" name="operator"></td>
						<td>签收日期</td>
						<td>
							<input type="text" class="easyui-datebox" name="pickdate" data-options="required:true, editable:false" />
						</td>
						<td>至</td>
						<td>
							<input type="text" class="easyui-datebox" name="pickdate" data-options="required:true, editable:false" />
						</td>
					</tr>
					<tr>
						<td>工作单号</td>
						<td><input type="text" name="waybill.id"></td>
						<td>签收类型</td>
						<td>
							<select class="easyui-combobox" name="signType" style="width: 175px;">
								<option value="正常签收">正常签收</option>
								<option value="部分签收">部分签收</option>
								<option value="返货">返货</option>
							</select>
						</td>
						<td>派送人单位</td>
						<td>
							<input type="text" name="courier.courierNum">
						</td>
					</tr>
					<tr>
						<td>派送人单位</td>
						<td colspan="3"><input type="text" name="courier.company" style="width:410px;"></td>
						<td><button class="btn btn-default">查询</button></td>
					</tr>
				</table>
			</form>
		</div>

		<div region="center" border="false">
			<table id="grid"></table>
		</div>

		<!-- 新增签收单-->
		<div class="easyui-window" title="签收单" id="approveorder" collapsible="false" minimizable="false" maximizable="false" style="width:600px ;top:20px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				<form id="signForm" action="" method="post">
					<table class="table-edit" align="center">
						<tr>
							<td>工作单号</td>
							<td>
								<input type="text" required="true" name="waybill.id" />
							</td>
							<td>派送单位</td>
							<td>
								<input type="text" required="true" name="courierCompany" />
							</td>
						</tr>
						<tr>
							<td>快递员工号</td>
							<td>
								<input type="text" required="true" name="courierNum" />
							</td>
							<td>快递员姓名</td>
							<td>
								<input type="text" required="true" name="courierName" />
							</td>
						</tr>
						<tr>
							<td>签收人</td>
							<td>
								<input type="text" required="true" name="signName" />
							</td>
							<td>签收日期</td>
							<td>
								<input type="text" class="easyui-datebox" required="true" name="signTime" />
							</td>
						</tr>
						<tr>
							<td>签收状态</td>
							<td colspan="3">
								<select class="easyui-combobox" style="width:150px" name="signType">
									<option>正常</option>
									<option>返单</option>
									<option>转发签收</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>异常备注</td>
							<td colspan="3">
								<textarea name="errorRemark" rows="4" cols="60"></textarea>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>
</html>