<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>角色添加</title>
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
		<!-- 导入ztree类库 -->
		<link rel="stylesheet" href="../../js/ztree/zTreeStyle.css" type="text/css" />
		<script src="../../js/ztree/jquery.ztree.all-3.5.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(function(){
				// 授权树初始化
				var setting = {
					data : {
						simpleData : {
							enable : true
						}
					},
					check : {
						enable : true,
					}
				};
				
				$.ajax({
					//url : '../../data/menu.json',
					url: '../../menu_list.action',
					type : 'POST',
					dataType : 'json', // 数据类型，text、json
					success : function(data) {
						//alert(data);
						//var zNodes = eval("(" + data + ")"); // eval函数在js中将json形式的字符串转换成json数据
						//alert(zNodes);
						$.fn.zTree.init($("#menuTree"), setting, data);
					},
					error : function(msg) {
						alert('树加载异常!');
					}
				});
				
				
				
				// 点击保存
				$('#save').click(function(){
					// location.href='role.jsp';
					// 获取ztree勾选节点的集合
					var treeObj = $.fn.zTree.getZTreeObj("menuTree");
					var nodes = treeObj.getCheckedNodes(true);
					// 获取所有节点id
					var array = new Array();
					for(var i=0; i<nodes.length; i++){
						array.push(nodes[i].id);
					}
					var menuIds = array.join(",");
					$("input[name='menuIds']").val(menuIds);
					
					// 提交form
					if($("#roleForm").form('validate')){
						$("#roleForm").submit();
					}
				});
				
				/**
				 * 使用ajax查询所有的权限，遍历到页面的<td id="TdPermission">中
				 * 		<td id="TdPermission">
							<input type="checkbox" name="permissionIds" value="1" /> 添加快递员 
							<input type="checkbox" name="permissionIds" value="2" /> 快递员列表查询
							<input type="checkbox" name="permissionIds" value="3" /> 添加区域 
						</td>
				 */
				$.post("../../permission_list.action",{},function(data){
					$(data).each(function(){
						// alert(this.id+"    "+this.name);
						// 创建checkbox
						var checkbox = $("<input type='checkbox' name='permissionIds'/>");
						checkbox.val(this.id);
						// 将创建checkbox放置到<td id="TdPermission">中
						$("#TdPermission").append(checkbox);
						$("#TdPermission").append(this.name);
					})
				})
			});
		</script>
	</head>

	<body class="easyui-layout">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
			</div>
		</div>
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="roleForm" method="post" action="../../role_save.action">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">角色信息</td>
					</tr>
					<tr>
						<td>名称</td>
						<td>
							<input type="text" name="name" class="easyui-validatebox" data-options="required:true" />
						</td>
					</tr>
					<tr>
						<td>关键字</td>
						<td>
							<input type="text" name="keyword" class="easyui-validatebox" data-options="required:true" />
						</td>
					</tr>
					<tr>
						<td>描述</td>
						<td>
							<textarea name="description" rows="4" cols="60"></textarea>
						</td>
					</tr>
					<tr>
						<td>权限选择</td>
						<td id="TdPermission">
							
						</td>
					</tr>
					<tr>
						<td>菜单授权</td>
						<td>
							<input type="hidden" id="menuIds" name="menuIds"/>
							<ul id="menuTree" class="ztree"></ul>
						</td>
					</tr>
					
				</table>
			</form>
		</div>
	</body>

</html>