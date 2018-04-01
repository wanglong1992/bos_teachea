<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>管理定区/调度排班</title>
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
				$("#fixedAreaForm").form("reset");
				$('input[name="id"]').attr("readonly",false);
				$('#addWindow').window("open");
			}
			
			function doEdit(){
				//alert("修改...");
				var rows = $('#grid').datagrid('getSelections');
				if(rows.length==1){
					$('input[name="id"]').attr("readonly",true);
					var row = rows[0];
					$("#fixedAreaForm").form("load",row);
					$('#addWindow').window("open");

				} else {
					$.messager.alert("警告","【管理定区/调度排班】修改数据,请您必须选中一行!","warning");
				}
			}
			
			function doDelete(){
				//alert("删除...");
				var rows = $('#grid').datagrid('getSelections');
				if(rows.length==0){
					$.messager.alert("警告","【管理定区/调度排班】删除数据,请您至少选中一行!","warning");
				} else {
					var array = [];
					for(var i=0; i<rows.length; i++){
						array.push(rows[i].id);
					}
					var ids = array.join(",");
					window.location.href="../../fixedArea_delete.action?ids=" + ids;
				}
			}
			
			function doSearch(){
				$('#searchWindow').window("open");
			}
			
			function doAssociations(){
				var rows = $("#grid").datagrid("getSelections");
				if(rows.length==1){
					// alert(rows[0].id);
					$("#customerFixedAreaId").val(rows[0].id); // 后续做定区关联客户，使用隐藏域存放定区id
					$('#customerWindow').window('open');
					/**开启进度条*/
					$.messager.progress({
						title:"正在数据加载",
						msg:"数据加载中...",
						text:"请等等",
						interval:1000
					});
					/*
					 * 使用ajax查询没有关联定区的客户列表
					 * <select id="noassociationSelect" multiple="multiple" size="10" style="width: 300px;"></select>
					 */
					$.post("../../fixedArea_noassociationSelect.action",{},function(data){
						// 清空select
						$("#noassociationSelect").empty();
						$(data).each(function(){
							// alert(this.id+"     "+this.username);
							// 创建option
							var $option = $("<option value='"+this.id+"'>"+this.username+"("+this.address+")</option>");
							$("#noassociationSelect").append($option);
						})
						/**关闭进度条*/
						$.messager.progress('close');
					})
					/*
					 * 使用ajax查询已经关联当前定区的客户列表
					 * <select id="associationSelect" name="customerIds" multiple="multiple" size="10" style="width: 300px;"></select>
					 */
					$.post("../../fixedArea_associationSelect.action",{id:rows[0].id},function(data){
						// 清空select
						$("#associationSelect").empty();
						$(data).each(function(){
							// alert(this.id+"     "+this.username);
							// 创建option
							var $option = $("<option value='"+this.id+"'>"+this.username+"("+this.address+")</option>");
							$("#associationSelect").append($option);
						})
					})
				}
				else{
					$.messager.alert("警告","只能选择一个定区","warning");
				}
				
			}
			
			//工具栏
			var toolbar = [ {
				id : 'button-search',	
				text : '查询',
				iconCls : 'icon-search',
				handler : doSearch
			}, {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : doAdd
			}, {
				id : 'button-edit',	
				text : '修改',
				iconCls : 'icon-edit',
				handler : doEdit
			},{
				id : 'button-delete',
				text : '删除',
				iconCls : 'icon-cancel',
				handler : doDelete
			},{
				id : 'button-association',
				text : '关联客户',
				iconCls : 'icon-sum',
				handler : doAssociations
			},{
				id : 'button-association-courier',
				text : '关联快递员',
				iconCls : 'icon-sum',
				handler : function(){
					// 判断是否已经选中了一个定区，弹出关联快递员窗口 
					var rows = $("#grid").datagrid('getSelections');
					if(rows.length==1){
						// 只选择了一个定区
						// 将定区id，存放到窗口的隐藏域中
						$("#courierFixedAreaId").val(rows[0].id);
						// 弹出定区关联快递员 窗口 
						$("#courierWindow").window('open');
					}else{
						// 没有选中定区，或者选择 了多个定区
						$.messager.alert("警告","关联快递员,只能（必须）选择一个定区","warning");
					}
				}
			}];
			// 定义列
			var columns = [ [ {
				field : 'id',
				title : '编号',
				width : 80,
				align : 'center',
				checkbox:true
			},{
				field : 'fixedAreaNum',
				title : '定区编号',
				width : 120,
				align : 'center',
				formatter : function(value,row,index){
					return row.id ;
				}
			},{
				field : 'fixedAreaName',
				title : '定区名称',
				width : 120,
				align : 'center'
			}, {
				field : 'fixedAreaLeader',
				title : '负责人',
				width : 120,
				align : 'center'
			}, {
				field : 'telephone',
				title : '联系电话',
				width : 120,
				align : 'center'
			}, {
				field : 'company',
				title : '所属公司',
				width : 120,
				align : 'center'
			} ] ];
			
			$(function(){
				//将Form表单中的元素转换成json数组。
				$.fn.serializeJson=function(){  
		            var serializeObj={};  
		            var array=this.serializeArray();  
		            var str=this.serialize();  
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
				
				// 向右移动按钮 
				$("#toRight").click(function(){
					$("#associationSelect").append($("#noassociationSelect option:selected"));
				});
				// 向左移动按钮
				$("#toLeft").click(function(){
					$("#noassociationSelect").append($("#associationSelect option:selected"));
				});
				
				// 定区数据表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : true,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					// url : "../../data/fixed_area.json",
					url : "../../fixedArea_pageQuery.action",
					idField : 'id',
					columns : columns,
					onDblClickRow : doDblClickRow
				});
				
				// 添加、修改定区
				$('#addWindow').window({
			        title: '添加修改定区',
			        width: 600,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				// 查询定区
				$('#searchWindow').window({
			        title: '查询定区',
			        width: 400,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				$("#btn").click(function(){
					// alert("执行查询...");
					var params = $("#searchForm").serializeJson();
					//查询条件绑定在datagrid中
					$("#grid").datagrid("load",params);
					//关闭查询窗口
					$("#searchWindow").window("close");
				});
				
				// 点击【保存】按钮
				// 点击 添加定区的保存按钮，实现添加定区
				$("#save").click(function(){
					// 先校验表单 
					if($("#fixedAreaForm").form('validate')){
						$("#fixedAreaForm").submit();
					}else{
						// 提示用户
						$.messager.alert("警告","表单存在非法数据项！","warning");
					}
				});
				
				// 点击关联客户的按钮
				$("#associationBtn").click(function(){
					if($("#customerForm").form("validate")){
						// 让关联客户的下拉列表associationSelect中的option被选中
						$("#associationSelect option").attr("selected","selected");
						$("#customerForm").submit();
					}
				})
				
				// 点击关联快递员的按钮
				$("#associationCourierBtn").click(function(){
					if($("#courierForm").form("validate")){
						$("#courierForm").submit();
					}
					else{
						$.messager.alert("警告","表单校验有误！","warning");
					}
				})
			});
		
			function doDblClickRow(rowIndex, rowData){
				// alert("双击表格数据...：定区id："+rowData.id);
				var id = rowData.id;
				// 关联分区
				$('#association_subarea').datagrid( {
					fit : true,
					border : true,
					rownumbers : true,
					striped : true,
					//url : "../../data/association_subarea.json",
					url : "../../subArea_findSubAreaByFixedAreaId.action?FixedAreaId="+id,
					columns : [ [{
						field : 'id',
						title : '分拣编号',
						width : 120,
						align : 'center'
					},{
						field : 'province',
						title : '省',
						width : 120,
						align : 'center',
						formatter : function(data,row ,index){
							if(row.area!=null){
								return row.area.province;
							}
							return "";
						}
					}, {
						field : 'city',
						title : '市',
						width : 120,
						align : 'center',
						formatter : function(data,row ,index){
							if(row.area!=null){
								return row.area.city;
							}
							return "";
						}
					}, {
						field : 'district',
						title : '区',
						width : 120,
						align : 'center',
						formatter : function(data,row ,index){
							if(row.area!=null){
								return row.area.district;
							}
							return "";
						}
					}, {
						field : 'keyWords',
						title : '关键字',
						width : 120,
						align : 'center'
					}, {
						field : 'startNum',
						title : '起始号',
						width : 100,
						align : 'center'
					}, {
						field : 'endNum',
						title : '终止号',
						width : 100,
						align : 'center'
					} , {
						field : 'single',
						title : '单双号',
						width : 100,
						align : 'center'
					} , {
						field : 'assistKeyWords',
						title : '辅助关键字',
						width : 100,
						align : 'center'
					} ] ]
				});
				// 关联客户
				$('#association_customer').datagrid( {
					fit : true,
					border : true,
					rownumbers : true,
					striped : true,
					url : "../../fixedArea_associationSelect.action?id="+id,
					columns : [[{
						field : 'id',
						title : '客户编号',
						width : 120,
						align : 'center'
					},{
						field : 'username',
						title : '客户名称',
						width : 120,
						align : 'center'
					}, {
						field : 'company',
						title : '所属单位',
						width : 120,
						align : 'center'
					}]]
				});
				// 关联快递员
				$('#association_courier').datagrid({
					fit : true,
					border : true,
					rownumbers : true,
					striped : true,
					// url : "../../data/courier.json",
					url : "../../courier_findCourierByFixedAreaId.action?fixedAreaId="+id,
					columns : [[{
						field : 'id',
						title : '编号',
						width : 120,
						align : 'center'
					},{
						field : 'courierNum',
						title : '快递员工号',
						width : 120,
						align : 'center'
					},{
						field : 'name',
						title : '快递员姓名',
						width : 120,
						align : 'center'
					}, {
						field : 'standard.name',
						title : '收派标准',
						width : 120,
						align : 'center',
						formatter : function(value,row,index){
							if(row.standard != null){
								return row.standard.name;
							}
							return null ; 
						}
					}, {
						field : 'taketime.name',
						title : '收派时间',
						width : 120,
						align : 'center',
						formatter : function(value,row,index){
							if(row.takeTime != null){
								return row.takeTime.name;
							}
							return null ; 
						}
					}, {
						field : 'company',
						title : '所属单位',
						width : 120,
						align : 'center'
					}]]
				});
			}
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center">
			<table id="grid"></table>
		</div>
		<div region="south" style="height:150px">
			<div id="tabs" fit="true" class="easyui-tabs">
				<div title="关联快递员" id="courier" style="width:100%;height:100%;overflow:hidden">
					<table id="association_courier"></table>
				</div>
				<div title="关联分区" id="subArea" style="width:100%;height:100%;overflow:hidden">
					<table id="association_subarea"></table>
				</div>
				<div title="关联客户" id="customers" style="width:100%;height:100%;overflow:hidden">
					<table id="association_customer"></table>
				</div>
			</div>
		</div>

		<!-- 添加 修改定区 -->
		<div class="easyui-window" title="定区添加修改" id="addWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="height:31px;overflow:hidden;" split="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>

			<div style="overflow:auto;padding:5px;">
				<form id="fixedAreaForm" 
					action="../../fixedArea_save.action" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">定区信息</td>
						</tr>
						<tr>
							<td>定区编码</td>
							<td>
								<input type="text" name="id" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>定区名称</td>
							<td>
								<input type="text" name="fixedAreaName" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>负责人</td>
							<td>
								<input name="fixedAreaLeader" class="easyui-validatebox" required="true"/>
							</td>
						</tr>
						<tr>
							<td>联系电话</td>
							<td>
								<input name="telephone" class="easyui-validatebox" required="true"/>
							</td>
						</tr>
						<tr>
							<td>所属公司</td>
							<td>
								<input name="company" class="easyui-validatebox" required="true"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<!-- 查询定区 -->
		<div class="easyui-window" title="查询定区窗口" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="overflow:auto;padding:5px;">
				<form id="searchForm">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">查询条件</td>
						</tr>
						<tr>
							<td>定区编码</td>
							<td>
								<input type="text" name="id" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>所属单位</td>
							<td>
								<input type="text" name="company" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td colspan="2"><a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>

		<!-- 关联客户窗口 -->
		<div class="easyui-window" title="关联客户窗口" id="customerWindow" modal="true"
			collapsible="false" closed="true" minimizable="false" maximizable="false" style="top:20px;left:200px;width: 700px;height: 300px;">
			<div style="overflow:auto;padding:5px;">
				<form id="customerForm" 
					action="../../fixedArea_associationCustomersToFixedArea.action" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="3">关联客户</td>
						</tr> 
						<tr>
							<td>
								<!-- 存放定区编号 -->
								<input type="hidden" name="id" id="customerFixedAreaId" />
								<select id="noassociationSelect" multiple="multiple" size="10" style="width: 300px;"></select>
							</td>
							<td>
								<input type="button" value="》》" id="toRight">
								<br/>
								<input type="button" value="《《" id="toLeft">
							</td>
							<td>
								<select id="associationSelect" name="customerIds" multiple="multiple" size="10" style="width: 300px;"></select>
							</td>
						</tr>
						<tr>
							<td colspan="3"><a id="associationBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'">关联客户</a> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		
		<!-- 关联快递员窗口 -->
		<div class="easyui-window" title="关联快递员窗口" id="courierWindow" modal="true"
			collapsible="false" closed="true" minimizable="false" maximizable="false" style="top:20px;left:200px;width: 700px;height: 300px;">
			<div style="overflow:auto;padding:5px;">
				<form id="courierForm" 
					action="../../fixedArea_associationCourierToFixedArea.action" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">关联快递员</td>
						</tr> 
						<tr>
							<td>选择快递员</td>
							<td>
								<!-- 存放定区编号 -->
								<input type="hidden" name="id" id="courierFixedAreaId" />
								<input type="text" name="courierId" class="easyui-combobox" required="true" 
									data-options="url:'../../courier_findnoassociation.action',
										valueField:'id',textField:'info'"/>
							</td>
						</tr>
						<tr>
							<td>选择收派时间</td>
							<td>
								<input type="text" name="takeTimeId" class="easyui-combobox" required="true"
									data-options="url:'../../taketime_findAll.action', 
									valueField:'id',textField:'name'" />
							</td>
						</tr>
						<tr>
							<td colspan="3"><a id="associationCourierBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'">关联快递员</a> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>

</html>