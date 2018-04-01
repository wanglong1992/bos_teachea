<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>取派标准</title>
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
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 收派标准信息表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					pageList: [3,50,100],
					pagination : true,
					toolbar : toolbar,
					// url : "../../data/standard.json",
					url : "../../standard_pageQuery.action",
					idField : 'id',
					columns : columns
				});
				
				// 点击保存按钮
				$("#save").click(function(){
					if($("#standardForm").form("validate")){
						$("#standardForm").submit();
					}
					else{
						$.messager.alert("警告","表单验证有误！","warning");
					}
				})
			});	
			
			//工具栏
			var toolbar = [ {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : function(){
					// alert('增加');
					// 清空表单
					$("#standardForm").form("clear");
					// 收派标准名称添加校验，同时可写
					$("input[name='name']").validatebox({
					    validType: "remote['../../standard_validateName.action','name']"   
					});  
					$("input[name='name']").attr("readonly",false);
					$("#standardWindow").window('open');
				}
			}, {
				id : 'button-edit',
				text : '修改',
				iconCls : 'icon-edit',
				handler : function(){
					// alert('修改');
					// 获取选中的行对象
					var rows = $("#grid").datagrid("getSelections");
					if(rows.length!=1){
						$.messager.alert("警告","编辑的操作只能选择一条记录","warning");
						return;
					}
					// 将数据表格中的json数据，回显到standardForm表单中。
					$("#standardForm").form("load",rows[0]);
					// 收派标准名称去掉校验，同时只读
					$("input[name='name']").validatebox({
					    validType: ""   
					});  
					$("input[name='name']").attr("readonly",true);
					// alert(rows[0].id+"    "+rows[0].name);
					// 传统方法：使用ajax，根据传递的id查询，返回对应id的数据，回显到输入框中。
					$("#standardWindow").window('open');
				}
			},{
				id : 'button-delete',
				text : '作废',
				iconCls : 'icon-cancel',
				handler : function(){
					// alert('作废');
					var rows = $("#grid").datagrid("getSelections");
					if(rows.length==0){
						$.messager.alert("警告","删除的操作至少选择一条记录","warning");
						return;
					}
					// 组织ids
					var ids;
					var array = new Array();
					for(var i=0;i<rows.length;i++){
						var row = rows[i];
						array.push(row.id);
					}
					// ids封装的是一个id字符串，id之间使用逗号分开
					ids = array.join(",");
					// alert(ids);
					// url
					window.location.href = "../../standard_delete.action?ids="+ids;
				}
			}];
			
			// 定义列
			var columns = [ [ {
				field : 'id',
				checkbox : true
			},{
				field : 'name',
				title : '标准名称',
				width : 120,
				align : 'center'
			}, {
				field : 'minWeight',
				title : '最小重量',
				width : 120,
				align : 'center'
			}, {
				field : 'maxWeight',
				title : '最大重量',
				width : 120,
				align : 'center'
			}, {
				field : 'minLength',
				title : '最小长度',
				width : 120,
				align : 'center'
			}, {
				field : 'maxLength',
				title : '最大长度',
				width : 120,
				align : 'center'
			}, {
				field : 'operator',
				title : '操作人',
				width : 120,
				align : 'center'
			}, {
				field : 'operatingTime',
				title : '操作时间',
				width : 120,
				align : 'center'
			}, {
				field : 'company',
				title : '操作单位',
				width : 120,
				align : 'center'
			} ] ];
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		
		<div class="easyui-window" title="对收派标准进行添加或者修改" id="standardWindow" collapsible="false" minimizable="false" maximizable="false" modal="true" closed="true" style="width:600px;top:50px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				
				<form id="standardForm" action="../../standard_save.action" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">收派标准信息
								<!--提供隐藏域 装载id -->
								<input type="hidden" name="id" />
							</td>
						</tr>
						<tr>
							<td>收派标准名称</td>
							<td>
								<!--<input type="text" name="name" 
									class="easyui-validatebox" data-options="required:true" />-->
								<input name="name" type="text" class="easyui-validatebox" validtype="remote['../../standard_validateName.action','name']" required="true" missingMessage="收派标准名称不能为空" invalidMessage="收派标准名称已存在"/>
							</td>
						</tr>
						<tr>
							<td>最小重量</td>
							<td>
								<input type="text" name="minWeight" 
										class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最大重量</td>
							<td>
								<input type="text" name="maxWeight" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最小长度</td>
							<td>
								<input type="text" name="minLength" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最大长度</td>
							<td>
								<input type="text" name="maxLength" class="easyui-numberbox" required="true" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>

</html>