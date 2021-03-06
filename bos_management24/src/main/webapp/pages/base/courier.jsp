<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>管理取派员</title>
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
			function doAdd(){
				$('#addWindow').window("open");
			}
			
			function doEdit(){
				//alert("修改...");
				var rows = $("#grid").datagrid("getSelections");
				if(rows.length!=1){
					//没有选择数据
					$.messager.alert("警告","修改只能选择一行数据","warning");
				}else{
					var row = rows[0];
					//数据回显
					$("#standardId").combobox("setValue",row.standard.id);
					$("#courierForm").form("load",row);
					//打开编辑窗口,将回显的数据展示出来
					$('#addWindow').window("open");
				}
			}
			
			function doDelete(){
				// alert("删除...");
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
				window.location.href = "../../courier_delete.action?ids="+ids;
			}
			
			function doRestore(){
				//alert("将取派员还原...");
				var rows = $("#grid").datagrid("getSelections");
				if(rows.length==0){
					//没有选择数据
					$.messager.alert("警告","还原请至少选择一行数据","warning");
				}else{
					var array= new Array();
					for(var i=0;i<rows.length;i++){
						array.push(rows[i].id);
					}
					var ids=array.join(",");
					window.location.href ="../../courier_restoreCourier.action?ids="+ids;
				}
			}
			//工具栏
			var toolbar = [ {
				id : 'button-add',	
				text : '增加',
				iconCls : 'icon-add',
				handler : doAdd
			}, {
				id : 'button-edit',
				text : '修改',
				iconCls : 'icon-edit',
				handler : doEdit
			}, {
				id : 'button-delete',
				text : '作废',
				iconCls : 'icon-cancel',
				handler : doDelete
			},{
				id : 'button-restore',
				text : '还原',
				iconCls : 'icon-save',
				handler : doRestore
			},{
				id : 'button-search',
				text : '查询',
				iconCls : 'icon-search',
				handler : function(){
					$("#searchWindow").window("open");
				}
			}];
			// 定义列
			var columns = [ [ {
				field : 'id',
				checkbox : true,
			},{
				field : 'courierNum',
				title : '工号',
				width : 80,
				align : 'center'
			},{
				field : 'name',
				title : '姓名',
				width : 80,
				align : 'center'
			}, {
				field : 'telephone',
				title : '手机号',
				width : 120,
				align : 'center'
			}, {
				field : 'checkPwd',
				title : '查台密码',
				width : 120,
				align : 'center'
			}, {
				field : 'pda',
				title : 'PDA号',
				width : 120,
				align : 'center'
			}, {
				field : 'standard.name',
				title : '取派标准',
				width : 120,
				align : 'center',
				formatter : function(data,row, index){
					if(row.standard != null){
						return row.standard.name;
					}
					return "";
				}
			}, {
				field : 'type',
				title : '取派员类型',
				width : 120,
				align : 'center'
			}, {
				field : 'company',
				title : '所属单位',
				width : 200,
				align : 'center'
			}, {
				field : 'deltag',
				title : '是否作废',
				width : 80,
				align : 'center',
				formatter : function(data,row, index){
					if(data==null){
						return "正常使用"
					}else{
						return "已删除";
					}
				}
			}, {
				field : 'vehicleType',
				title : '车型',
				width : 100,
				align : 'center'
			}, {
				field : 'vehicleNum',
				title : '车牌号',
				width : 120,
				align : 'center'
			} ] ];
			
			$(function(){
				// 自定义jquery的方法，将Form表单中的内容转换成json
				$.fn.serializeJson=function(){  
		            var serializeObj={};  
		            var array=this.serializeArray();  
		            $(array).each(function(){  
		                if(serializeObj[this.name]){  
		                    if($.isArray(serializeObj[this.name])){  
		                        serializeObj[this.name].push(this.value);  
		                    }else{  
		                        serializeObj[this.name]=[serializeObj[this.name],this.value];  
		                    }  
		                }else{  
		                    serializeObj[this.name]=this.value;   
		                }  
		            });  
		            return serializeObj;  
		        }; 
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 取派员信息表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					// url : "../../data/courier.json",
					url : "../../courier_pageQuery.action",
					idField : 'id',
					columns : columns,
					onDblClickRow : doDblClickRow
				});
				
				// 添加取派员窗口
				$('#addWindow').window({
			        title: '添加取派员',
			        width: 800,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				// 点击保存
				$("#save").click(function(){
					if($("#courierForm").form("validate")){
						$("#courierForm").submit();
					}
					else{
						$.messager.alert("警告","表单校验有误","warning");
					}
				})
				
				// 点击查询
				$("#searchBtn").click(function(){
					// var courierNum = $("input[name='courierNum']").val();
					// 不是json，格式：courierNum=gh001&standard.id=4&company=&type=
					//var params = $("#searchForm").serialize(); 
					//alert(params);
					
					// 是json，[object Object],[object Object],[object Object],[object Object]
					/*
					 * [{"name":"courierNum","value":"gh001"},{"name":"standard.id","value":"1"},{"name":"company","value":""},{"name":"type","value":""}]
					 */
					//var params = $("#searchForm").serializeArray(); 
					//alert(JSON.stringify(params));
					
					var params = $("#searchForm").serializeJson();
					// alert(JSON.stringify(params));
					
					$('#grid').datagrid('load',params);
					// 关闭查询窗口
					$("#searchWindow").window("close");
				})
			});
		
			function doDblClickRow(){
				alert("双击表格数据...");
			}
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		<div class="easyui-window" title="对收派员进行添加或者修改" id="addWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				<form id="courierForm" action="../../courier_save.action" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="4">收派员信息</td>
						</tr>
						<tr>
							<td>快递员工号</td>
							<td>
								<input type="hidden" name="id" id = "id" />
								<input type="text" name="courierNum" class="easyui-validatebox" required="true" />
							</td>
							<td>姓名</td>
							<td>
								<input type="text" name="name" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>手机</td>
							<td>
								<input type="text" name="telephone" class="easyui-validatebox" required="true" />
							</td>
							<td>所属单位</td>
							<td>
								<input type="text" name="company" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>查台密码</td>
							<td>
								<input type="text" name="checkPwd" class="easyui-validatebox" required="true" />
							</td>
							<td>PDA号码</td>
							<td>
								<input type="text" name="pda" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>快递员类型</td>
							<td>
								<input type="text" name="type" class="easyui-validatebox" required="true" />
							</td>
							<td>收派标准</td>
							<td>
								<input type="text" name="standard.id" id="standardId"
										class="easyui-combobox" 
										data-options="required:true,valueField:'id',textField:'name',
											url:'../../standard_findAll.action'"/>
							</td>
						</tr>
						<tr>
							<td>车型</td>
							<td>
								<input type="text" name="vehicleType" class="easyui-validatebox" required="true" />
							</td>
							<td>车牌号</td>
							<td>
								<input type="text" name="vehicleNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		
		<!-- 查询快递员-->
		<div class="easyui-window" title="查询快递员窗口" closed="true" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="width: 400px; top:40px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form id="searchForm">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">查询条件</td>
						</tr>
						<tr>
							<td>工号</td>
							<td>
								<input type="text" name="courierNum" />
							</td>
						</tr>
						<tr>
							<td>收派标准</td>
							<td>
								<input type="text" name="standard.id" 
										class="easyui-combobox" 
										data-options="valueField:'id',textField:'name',
											url:'../../standard_findAll.action'"/>
							</td>
						</tr>
						<tr>
							<td>所属单位</td>
							<td>
								<input type="text" name="company" />
							</td>
						</tr>
						<tr>
							<td>取派员类型</td>
							<td>
								<input type="text" name="type" />
							</td>
						</tr>
						<tr>
							<td colspan="2"><a id="searchBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>

</html>