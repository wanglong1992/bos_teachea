<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>用户列表页面</title>
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
			// 工具栏
			var toolbar = [ {
				id : 'button-view',	
				text : '查看',
				iconCls : 'icon-search',
				handler : doView
			}, {
				id : 'button-add',
				text : '新增',
				iconCls : 'icon-add',
				handler : doAdd
			}, {
				id : 'button-delete',
				text : '删除',
				iconCls : 'icon-cancel',
				handler : doDelete
			}];
		
		
			// 定义标题栏
			var columns = [ [ {
				field : 'id',
				checkbox : true,
				rowspan : 2
			}, {
				field : 'username',
				title : '名称',
				width : 80,
				rowspan : 2
			}, {
				field : 'gender',
				title : '性别',
				width : 60,
				rowspan : 2,
				align : 'center'
			}, {
				field : 'birthday',
				title : '生日',
				width : 120,
				rowspan : 2,
				align : 'center'
			}, {
				title : '其他信息',
				colspan : 2
			}, {
				field : 'telephone',
				title : '电话',
				width : 800,
				rowspan : 2
			} ], [ {
				field : 'station',
				title : '单位',
				width : 80,
				align : 'center'
			}, {
				field : 'salary',
				title : '工资',
				width : 80,
				align : 'right'
			} ] ];
			$(function(){
				// 初始化 datagrid
				// 创建grid
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					toolbar : toolbar,
					// url : "../../data/users.json",
					url:'../../user_list.action',
					idField : 'id', 
					columns : columns,
					onClickRow : onClickRow,
					onDblClickRow : doDblClickRow
				});
				
				$("body").css({visibility:"visible"});
				
			});
			// 双击
			function doDblClickRow(rowIndex, rowData) {
				var items = $('#grid').datagrid('selectRow',rowIndex);
				doView();
			}
			// 单击
			function onClickRow(rowIndex){
		
			}
			
			function doAdd() {
				location.href="../../pages/system/userinfo.jsp";
			}
		
			function doView() {
				var item = $('#grid').datagrid('getSelected');
				console.info(item);
				//window.location.href = "edit.jsp";
			}
		
			function doDelete() {
				var ids = [];
				var items = $('#grid').datagrid('getSelections');
				for(var i=0; i<items.length; i++){
				    ids.push(items[i].id);	    
				}
					
				console.info(ids.join(","));
				
				$('#grid').datagrid('reload');
				$('#grid').datagrid('uncheckAll');
			}
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center">
			<table id="grid"></table>
		</div>
	</body>

</html>