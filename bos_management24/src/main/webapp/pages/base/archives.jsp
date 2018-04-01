<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>基本档案信息管理</title>
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
				
				// 基础档案信息表格
				$('#archives_grid').datagrid({
					iconCls: 'icon-forward',
					fit: true,
					border: false,
					rownumbers: true,
					striped: true,
					pageList: [3, 5, 10],
					pagination: true,
					toolbar: toolbar,
					url: "../../archive_pageQuery.action",
					idField: 'id',
					columns: columns
				});

				// 基础档案信息表格
				$('#archives_grid').datagrid({
					//双击事件  
      				onDblClickRow: function (index, row) {  
                 		var id = row.id;
                 		// 子档案信息表格
						$('#sub_archives_grid').datagrid({
							iconCls: 'icon-forward',
							fit: true,
							border: false,
							rownumbers: true,
							striped: true,
							//pageList: [3, 5, 10],
							//pagination: true,
							toolbar: toolbar2,
							url: "../../subArchive_pageQuery.action?archiveId="+id,
							idField: 'id',
							columns: child_columns
						});
       				 } 
       			});
       			
				
		        
		        $("#save").click(function() {
					if($("#archiveForm").form("validate")) {
						$("#archiveForm").submit();
					} else {
						$.messager.alert("警告", "基础资料表单校验有误,请检查后重新提交!", "warning")
					}
				})
		        
		        $("#subSave").click(function() {
		       		if($("#subArchiveForm").form("validate")) {
		       			$("#subArchiveForm").submit();
		       			$("input[name='archive.id']").val("");
		       		} else {
						$.messager.alert("警告", "子档案表单数据校验有误,请检查后重新提交!", "warning")
					}
		        })
		        
			});
			//工具栏
			var toolbar = [{
				id: 'button-add',
				text: '增加',
				iconCls: 'icon-add',
				handler: function() {
					$("#archiveForm").form("reset");
					$("input[name='archiveNum']").attr("readonly",false);
					$("#parentId").val("");
					$("#archiveWindow").window("open");
				}
			}, {
				id: 'button-edit',
				text: '修改',
				iconCls: 'icon-edit',
				handler: function() {
					var rows = $('#archives_grid').datagrid('getSelections');
					if (rows.length==1) {
						$("#archiveForm").form("load",rows[0]);
						$("#archiveWindow").window("open");
						$("#parentId").val(rows[0].id);
						$("input[name='archiveNum']").attr("readonly",true);
					} else {
						$.messager.alert("警告", "修改基础档案,必须选中一行基础档案数据!", "warning")
					}
				}
			}, {
				id: 'button-remove',
				text: '删除',
				iconCls: 'icon-remove',
				handler: function() {
					var rows = $('#archives_grid').datagrid('getSelections');
					if (rows.length > 0) {
						var array = [];
						for(var i=0; i<rows.length; i++){
							array.push(rows[i].id);
						}
						var ids = array.join(",");
						alert(ids);
						window.location.href="../../archive_delete.action?ids="+ids;
					} else {
						$.messager.alert("警告", "删除基础档案,必须选中至少一行基础档案数据!", "warning")
					}

				}
			}];
			
			//工具栏
			var toolbar2 = [{
				id: 'button-add',
				text: '增加',
				iconCls: 'icon-add',
				handler: function() {
					var rows = $('#archives_grid').datagrid('getSelections');
					if (rows.length==1) {
							if(rows[0].hasChild==1){
								$("#subArchiveForm").form("reset");
								$("#subId").val("");
								$("input[name='archive.id']").val(rows[0].id);
								$("input[name='archive.id']").attr("readonly",true);
								$("#subArchiveWindow").window("open");
							} else {
								$.messager.alert("警告", "此基础档案为不分级,请选择正确的基础档案数据!", "warning")
							}
							
					} else {
						$.messager.alert("警告", "增加子档案,必须选中一行基础档案数据!", "warning")
					}
					
				}
			}, {
				id: 'button-edit',
				text: '修改',
				iconCls: 'icon-edit',
				handler: function() {
					var rows = $('#sub_archives_grid').datagrid('getSelections');
					if (rows.length==1) {
						$("#subArchiveForm").form("load",rows[0]);
						$("#subArchiveWindow").window("open");
						$("input[name='archive.id']").val(rows[0].archive.id);
						$("input[name='archive.id']").attr("readonly",true);
						$("#subId").val(rows[0].id);
					} else {
						$.messager.alert("警告", "修改子档案,必须选中一行子档案数据!", "warning")
					}
				}
			}, {
				id: 'button-remove',
				text: '删除',
				iconCls: 'icon-remove',
				handler: function() {
					var rows = $('#sub_archives_grid').datagrid('getSelections');
					if (rows.length > 0) {
						var array = [];
						for(var i=0; i<rows.length; i++){
							array.push(rows[i].id);
						}
						var ids = array.join(",");
						window.location.href="../../subArchive_delete.action?ids="+ids;
					} else {
						$.messager.alert("警告", "删除子档案,必须选中至少一行子档案数据!", "warning")
					}
				}
			}];

			// 定义列
			var columns = [
				[{
					field: 'id',
					title: '基础档案编号',
					width: 120,
					align: 'center'
				}, {
					field: 'archiveName',
					title: '基础档案名称',
					width: 120,
					align: 'center'
				}, {
					field: 'hasChild',
					title: '是否分级',
					width: 120,
					align: 'center'
				}, {
					field: 'remark',
					title: '备注',
					width: 300,
					align: 'center'
				}]
			];

			var child_columns = [
				[{
					field: 'id',
					title: '档案编码',
					width: 120,
					align: 'center'
				}, {
					field: 'subArchiveName',
					title: '档案名称',
					width: 120,
					align: 'center'
				}, {
					field: 'archive.id',
					title: '上级编码',
					width: 120,
					align: 'center'
				}, {
					field: 'mnemonicCode',
					title: '助记码',
					width: 120,
					align: 'center'
				}, {
					field: 'mothballed',
					title: '封存',
					width: 120,
					align: 'center'
				}, {
					field: 'remark',
					title: '备注',
					width: 300,
					align: 'center'
				}]
			];
		function doDblClickRow(rowIndex, rowData){
			alert("双击表格数据..." +  rowData.id);
		}        
			
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center">
			<table id="archives_grid"></table>
		</div>
		<div region="south" style="height: 250px;">
			<table id="sub_archives_grid"></table>
		</div>

		<div class="easyui-window" title="基础档案信息进行添加或者修改" id="archiveWindow" collapsible="false" minimizable="false" maximizable="false" modal="true" closed="true" style="width:600px;top:150px;left:500px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>
			<form id="archiveForm" action="../../archive_save.action" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">基础档案信息
							<input type="hidden" id="parentId"  name="id" />
						</td>
					</tr>
					<tr>
						<td>档案编号</td>
						<td>
							<input type="text" name="archiveNum" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>档案名称</td>
						<td>
							<input type="text" name="archiveName" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>备注</td>
						<td>
							<textarea name="remark" id="" cols="50" rows="5"></textarea>
						</td>
					</tr>
					<tr>
						<td>是否分级</td>
						<td>
							<select id="hasChild" class="easyui-combobox" name="hasChild" style="width:200px;">
								<option value="">---------------请选择---------------</option>
								<option value="0">不分级</option>
								<option value="1">分级</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>

		<div class="easyui-window" title="子档案信息添加或者修改" id="subArchiveWindow" collapsible="false" minimizable="false" maximizable="false" modal="true" closed="true" style="width:600px;top:150px;left:500px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="subSave" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>
			<form id="subArchiveForm" action="../../subArchive_save.action" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">子档案信息
							<input type="hidden" id="subId" name="id" />
						</td>
					</tr>
					<tr>
						<td>上级编码</td>
						<td>
							<input type="text" name="archive.id" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>子档名称</td>
						<td>
							<input type="text" name="subArchiveName" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>助记码</td>
						<td>
							<input type="text" name="mnemonicCode" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>备注</td>
						<td>
							<textarea name="remark" id="" cols="50" rows="5"></textarea>
						</td>
					</tr>
					<tr>
						<td>封存标志</td>
						<td>
							<select clnass="easyui-combobox" name="mothballed" style="width:200px;">
								<option value="是">是</option>
								<option value="否">否</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>

</html>