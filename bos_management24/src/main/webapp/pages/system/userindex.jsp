<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>用户详情页面</title>
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
				$("body").css({visibility:"visible"});
				// 注册按钮事件
				$('#reset').click(function() {
					$('#form').form("clear");
				});
				// 注册所有下拉控件
				$("select").combobox( {
					width : 155,
					listWidth : 180,
					editable : true
				});
				// 注册ajax查询
				$('#ajax').click(function() {
					var elWin = $("#list").get(0).contentWindow;
					elWin.$('#grid').datagrid( {
						pagination : true,
						url : "../../data/users.json"
					});
				});
			});
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="east" title="查询条件" icon="icon-forward" style="width:180px;overflow:auto;" split="false">
			<div class="datagrid-toolbar">
				<a id="reset" href="#" class="easyui-linkbutton" plain="true" icon="icon-reload">重置</a>
			</div>

			<form id="form" method="post">
				<table class="table-edit" width="100%">
					<tr>
						<td>
							<b>用户名</b><span class="operator"><a name="username-opt" opt="all"></a></span>
							<input type="text" id="username" name="username" />
						</td>
					</tr>
					<tr>
						<td>
							<b>性别</b><span class="operator"><a name="gender-opt" opt="all"></a></span>
							<select id="gender" name="gender">
								<option value=""></option>
								<option value="0">女</option>
								<option value="1">男</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<b>生日</b><span class="operator"><a name="birthday-opt" opt="date"></a></span>
							<input type="text" id="birthday" name="birthday" value="1977-11-11" class="easyui-datebox" />
							<br/>
							<input type="text" id="_birthday2" name="_birthday2" value="1988-11-11" class="easyui-datebox" />
						</td>
					</tr>

				</table>
			</form>

			<div class="datagrid-toolbar">
				<a id="ajax" href="#" class="easyui-linkbutton" plain="true" icon="icon-search">查询</a>
			</div>
		</div>
		<div region="center" style="overflow:hidden;">
			<iframe id="list" src="./userlist.jsp" scrolling="no" style="width:100%;height:100%;border:0;"></iframe>
		</div>
	</body>

</html>