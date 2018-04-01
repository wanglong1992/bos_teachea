<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>宣传任务</title>
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
		
		<!--添加kindEditor文本编辑器-->
		<script type="text/javascript" src="../../editor/kindeditor.js" ></script>
		<script type="text/javascript" src="../../editor/lang/zh_CN.js" ></script>
		<link rel="stylesheet" href="../../editor/themes/default/default.css" />
		<script type="text/javascript">
			//将Form表单中的元素转换成json数组。
			$.fn.serializeJson = function() {
				var serializeObj = {};
				var array = this.serializeArray();
				var str = this.serialize();
				$(array).each(function() {
					if(serializeObj[this.name]) {
						if($.isArray(serializeObj[this.name])) {
							serializeObj[this.name].push(this.value);
						} else {
							serializeObj[this.name] = [serializeObj[this.name], this.value];
						}
					} else {
						serializeObj[this.name] = this.value;
					}
				});
				return serializeObj;
			};
			$(function() {
				$("body").css({visibility:"visible"});
				// 条件查询
				$('#searchWindow').window({
					title: '查询定区',
					width: 400,
					modal: true,
					shadow: true,
					closed: true,
					height: 400,
					resizable: false
				});
				$('#updateWindow').window({
					title: '修改',
					width: 400,
					modal: true,
					shadow: true,
					closed: true,
					height: 400,
					resizable: false
				});
				$("#btn").click(function() {
					// alert("执行查询...");
					var params = $("#searchForm").serializeJson();
					//查询条件绑定在datagrid中
					$("#grid").datagrid("load", params);
					//关闭查询窗口
					$('#status').combobox('clear');
					$("#searchWindow").window("close");
				});
				// 点击保存按钮
				$("#update").click(function(){
						$("#updateForm").submit();
				})
				// 添加文本编辑器
				KindEditor.ready(function(K) {
		            window.editor = K.create('#description',{
		            	items:[
						        'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'template', 'code', 'cut', 'copy', 'paste',
						        'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
						        'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
						        'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
						        'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
						        'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
						        'flash', 'media', 'insertfile', 'table', 'hr', 'emoticons', 'baidumap', 'pagebreak',
						        'anchor', 'link', 'unlink', '|'
						],
						uploadJson:"../upload_json.jsp",   // 文件上传
						fileManagerJson:"../file_manager_json.jsp",   // 文件管理
						//uploadJson:"../../image_upload.action",   // 文件上传
						//fileManagerJson:"../../image_fileManager.action",   // 文件管理
						allowFileManager:true
		            });
		        });

				// 宣传任务表格			
				$("#grid").datagrid({
					columns: [
						[{
							field: 'id',
							title: '编号',
							width: 100,
							checkbox: true
						}, {
							field: 'title',
							title: '宣传概要（标题）',
							width: 200
						}, {
							field: 'titleImg',
							title: '宣传图片',
							width: 200,
							formatter: function(value, row, index) {
								return "<img src='" + value + "' width='100' height='100' />";
							}
						}, {
							field: 'startDate',
							title: '发布时间',
							width: 100,
							formatter: function(value, row, index) {
								if(value != null) {
									return value.replace("T", " ");
								}
							}
						}, {
							field: 'endDate',
							title: '失效时间',
							width: 100,
							formatter: function(value, row, index) {
								if(value != null) {
									return value.replace("T", " ");
								}
							}
						}, {
							field: 'updateTime',
							title: '更新时间',
							width: 100
						}, {
							field: 'updateUnit',
							title: '更新单位',
							width: 100
						}, {
							field: 'updateUser',
							title: '更新人',
							width: 100
						}, {
							field: 'status',
							title: '状态',
							width: 100,
							formatter: function(value, row, index) {
								if(value == 1) {
									return "进行中"
								} else {
									return "已结束"
								}
							}
						}]
					],
					url: "../../promotion_pageQuery.action",
					pagination: true,
					toolbar: [{
							id: 'searchBtn',
							text: '查询',
							iconCls: 'icon-search',
							handler: function() {
								$('#searchWindow').window("open");
							}
						}, {
							id: 'addBtn',
							text: '增加',
							iconCls: 'icon-add',
							handler: function() {
								location.href = "promotion_add.jsp";
							}
						}, {
							id: 'editBtn',
							text: '修改',
							iconCls: 'icon-edit',
							handler: function() {
								var rows = $("#grid").datagrid("getSelections");
								if(rows.length != 1) {
									$.messager.alert("警告", "编辑的操作只能选择一条记录", "warning");
									return;
								}
								// 将数据表格中的json数据，回显到standardForm表单中。
								$("#updateForm").form("load",rows[0]);
								$("#updateWindow").window("open");
							}
						}, {
							id: 'deleteBtn',
							text: '作废',
							iconCls: 'icon-cancel',
							handler: function() {
								var rows = $("#grid").datagrid("getSelections");
								if(rows.length == 0) {
									$.messager.alert("警告", "作废的操作至少选择一条记录", "warning");
									return;
								}
								// 组织ids
								var ids;
								var array = new Array();
								for(var i = 0; i < rows.length; i++) {
									var row = rows[i];
									array.push(row.id);
								}
								// ids封装的是一个id字符串，id之间使用逗号分开
								ids = array.join(",");
								// alert(ids);
								// url
								window.location.href = "../../promotion_zuofei.action?ids=" + ids;
							}
						},
						{
							id: 'saveBtn',
							text: '保存',
							iconCls: 'icon-save',
							handler: function() {
								alert('保存成功');
							}
						},
						{
							id: 'cancelBtn',
							text: '取消',
							iconCls: 'icon-no',
							handler: function() {
								alert('取消宣传任务');
							}
						}

					]
				});
			});
		</script>
	</head>

	<body class="easyui-layout">
		<div region="center" style="overflow:auto;padding:5px;">
			<table id="grid"></table>
		</div>
	</body>

	<div class="easyui-window" title="查询定区窗口" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="overflow:auto;padding:5px;">
			<form id="searchForm">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">查询条件</td>
					</tr>
					<tr>
						<td>宣传概要(标题):</td>
						<td>
							<input type="text" name="title" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>状态:</td>
						<td>
							<select id="status" class="easyui-combobox" name="status" style="width:140px;">
								<option value="1">进行中</option>
								<option value="2">已结束</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>发布时间: </td>
						<td>
							<input type="text" name="startDate" id="startDate" class="easyui-datebox" />
						</td>
					</tr>
					<tr>
						<td>失效时间: </td>
						<td>
							<input type="text" name="endDate" id="endDate" class="easyui-datebox" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<div class="easyui-window" title="修改窗口" id="updateWindow" collapsible="false" style="width:600px;height:400px">
		<div style="overflow:auto;padding:5px;">
			<form id="updateForm" action="../../promotion_update.action" method="post">
				
				<table class="table-edit" width="100%" align="center">
					<tr>
						<td>宣传概要(标题):
							<input type="hidden" name="id" />
							<input type="hidden" name="activeScope"/>
						</td>
						<td>
							<input type="text" name="title" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>状态:</td>
						<td>
							<select id="status" class="easyui-combobox" name="status" style="width:140px;">
								<option value="1">进行中</option>
								<option value="2">已结束</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>发布时间: </td>
						<td>
							<input type="text" name="startDate" id="startDate" class="easyui-datebox" />
						</td>
					</tr>
					<tr>
						<td>失效时间: </td>
						<td>
							<input type="text" name="endDate" id="endDate" class="easyui-datebox" />
						</td>
					</tr>
					<tr>
						<td>宣传内容(活动描述信息):</td>
						<td>
							<textarea id="description" name="description" style="width:90%" rows="20"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<a id="update" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">保存</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</html>