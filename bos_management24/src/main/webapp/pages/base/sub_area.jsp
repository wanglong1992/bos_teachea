<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>管理分区</title>
		<style type="text/css">
			.city-picker-dropdown{
				top:159px !important;
				left: 69px !important;
			}
			
		</style>
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
		
		<!--citypick-->
		<script type="text/javascript" src="../../js/citypick/js/city-picker.data.js" ></script>
		<script type="text/javascript" src="../../js/citypick/js/city-picker.js" ></script>
		<link rel="stylesheet" href="../../js/citypick/css/city-picker.css" />
		
		<script src="../../js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
		
		<!-- 导入一键上传 -->
		<!-- 导入ocupload -->
		<script type="text/javascript" src="../../js/ocupload/jquery.ocupload-1.1.2.js"></script>
		<!-- highcharts -->
		<script type="text/javascript" src="../../js/highcharts/highcharts.js"></script>
		<script type="text/javascript" src="../../js/highcharts/highcharts-3d.js"></script>
		<script type="text/ecmascript" src="../../js/highcharts/modules/exporting.js"></script>
		
		<script type="text/javascript">
			
			// 自定义jquery的方法，将Form表单中的内容转换成json（老师自定义的）
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
		        
			function doAdd(){
				// 清空重置表单数据
				$("#subArea").form("clear");
				$("#subArea").form("reset");
				$('#id').attr("readonly",false); 
				$("#area").citypicker("reset");
				
				$('#addWindow').window("open");
			}
			
			function doEdit(){
				//alert("修改...");
				// 清空表单数据
				$("#subArea").form("clear")
				
				var rows = $("#grid").datagrid("getSelections");
				if(rows.length != 1){
					// 没有选中一条记录
					$.messager.alert("警告","快递员的修改必须选中一条数据","warning");
				}else{
					var row = rows[0];
					// 表单回显收派标准
					// alert(row.standard.id);
					$('#id').attr("readonly","readonly");  
					// 重新修改citypick框中的内容
					$("#subArea").form("load",row);
					
						// 执行赋值之前，需要执行reset和destroy的操作
						$("#area").citypicker("reset");
						$("#area").citypicker("destroy");
						$('#area').citypicker({
						  province: row.area.province,
						  city: row.area.city,
						  district: row.area.district
						});
					// citypick框设置属性
					//$("span[data-count='district']").attr("data-code",row.area.id);
					// 设置定区编号(文本框值)？为什么没有自动设置上
					//$("#fixedArea").val(row.fixedArea.id);
					// 设置定区编号（改下拉框了）
					$('#fixedArea').combobox('setValue', row.fixedArea.id);
					$('#addWindow').window("open");
				}
			}
			
			function doDelete(){
				//alert("删除...");
				// 获取页面中所有勾选快递员 id 
				var rows = $("#grid").datagrid('getSelections');
				if(rows.length == 0){
					// 没有选中数据 
					$.messager.alert("警告","删除快递员必须选中一条以上数据","warning");
				}else{
					// 选中数据 
					// 获取选中所有id ，拼接字符串方法 
					var array = [];
					for(var i=0; i<rows.length; i++){
						array.push(rows[i].id);//添加到数组中
					}
					// 生成字符串，以逗号分隔
					var ids = array.join(",");
					// 将字符串发送服务器 
					window.location.href = "../../subArea_delete.action?ids=" + ids;						   }
			}
			
			function doSearch(){
				// 清空表单数据
				$("#searchSubArea").form("clear")
				// 显示弹框
				$('#searchWindow').window("open");
				
			}
			
			function doExport(){
				//alert("导出");
				window.location.href = "../../subArea_exportXls.action?";	
			}
			
			function doExportPdf(){
				//alert("导出PDF报表");
				// 导出 PDF 按钮 
				$("#button-exportPdf").click(function(){
					// 下载效果 
					$("#subArea").attr("action", "../../reportSubArea_exportPdf.action");
					$("#subArea").submit();
				});
			}
			
			function doExportSubAreaHighChart(){
				
					var jsonXData = [];
					var jsonYData = [];
					$.post("../../report_exportSubAreaHighcharts.action", {}, function(data) {
						if(data != null && data.length > 0) {
							for(var i = 0; i < data.length; i++) {
								// alert(data[i].data+"           "+data[i].name);
								jsonXData.push(data[i].name);
								jsonYData.push(data[i].data);
							}
						}
						// Set up the chart
						var chart = new Highcharts.Chart({
							chart: {
								renderTo: 'container',
								type: 'column',
								options3d: {
									enabled: true,
									alpha: 15,
									beta: 15,
									depth: 50,
									viewDistance: 25
								}
							},
							title: {
								text: '分区分布统计'
							},
							subtitle: {
								text: ''
							},
							plotOptions: {
								column: {
									depth: 25
								}
							},
							yAxis: {
								title: {
									text: '分区数量'
								}
							},
							xAxis: {
								categories: jsonXData
							},
							series: [{
								name: '分区',
								data: jsonYData
							}]
						});

						function showValues() {
							$('#alpha-value').html(chart.options.chart.options3d.alpha);
							$('#beta-value').html(chart.options.chart.options3d.beta);
							$('#depth-value').html(chart.options.chart.options3d.depth);
						}

						// Activate the sliders
						$('#sliders input').on('input change', function() {
							chart.options.chart.options3d[this.id] = parseFloat(this.value);
							showValues();
							chart.redraw(false);
						});

						showValues();
					})

					$("#subAreaWindow").window("open");
				
			}
//			function doImport(){
//				alert("导入");
//			}
			
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
				id : 'button-import',
				text : '导入',
				iconCls : 'icon-redo'
			},{
				id : 'button-export',
				text : '导出',
				iconCls : 'icon-undo',
				handler : doExport
			},{
				id : 'button-exportPdf',
				text : '导出PDF报表',
				iconCls : 'icon-print',
				handler : doExportPdf
			},{
				id : 'button-exportSubAreaHighChart',
				text : '分区分布统计',
				iconCls : 'icon-print',
				handler : doExportSubAreaHighChart
			}];
			// 定义列
			var columns = [ [ {
				field : 'id',
				checkbox : true,
			}, {
				field : 'showid',
				title : '分拣编号',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.id;
				}
			},{
				field : 'area.province',
				title : '省',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					if(row.area != null ){
						return row.area.province;
					}
					return "" ;
				}
			}, {
				field : 'area.city',
				title : '市',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					if(row.area != null ){
						return row.area.city;
					}
					return "" ;
				}
			}, {
				field : 'area.district',
				title : '区',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					if(row.area != null ){
						return row.area.district;
					}
					return "" ;
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
				field : 'fixedArea.id',
				title : '定区编号',
				width : 100,
				hidden:true,
				align : 'center',
				formatter : function(data,row ,index){
					if(row.fixedArea != null ){
						return row.fixedArea.id;
					}
					return "" ;
				}
			},{
				field : 'area.id',
				title : '区域编号',
				hidden:true,
				width : 100,
				align : 'center',
				formatter : function(data,row ,index){
					if(row.area != null ){
						return row.area.id;
					}
					return "" ;
				}
			} , {
				field : 'assistKeyWords',
				title : '辅助关键字',
				width : 100,
				align : 'center'
			} ] ];
			
			$(function(){
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 分区管理数据表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : true,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					// url : "../../data/sub_area.json",
					//url : "../../subArea_findAll.action",
					url : "../../subArea_pageQuery.action",
					idField : 'id',
					columns : columns,
					onDblClickRow : doDblClickRow
				});
				
				// 添加、修改分区
				$('#addWindow').window({
			        title: '添加修改分区',
			        width: 600,
			        modal: false,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				// 查询分区
				$('#searchWindow').window({
			        title: '查询分区',
			        width: 400,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
			    
			    
			    
			    
				$("#btn").click(function(){
					//alert("执行查询...");
					// 将form数据转化为json
					var queryParams = $("#searchSubArea").serializeJson()
					// 重新加载页面
					$("#grid").datagrid("load",queryParams);
					// 关闭查询窗口 
					$("#searchWindow").window("close");
				});
				
				
				// 为导入按钮，添加一键上传效果 
			    $("#button-import").upload({
			    	// 默认name=’file’ 
			    	action : '../../subArea_importSubArea.action',
                    // 默认enctype=’multipart/form-data’ 
			    	// 在选择文件的时候触发的事件
			    	onSelect :function(){
			    		// 选中文件后，关闭自动提交 
			    		this.autoSubmit = false ;
			    		// 判定文件格式 ，以.xls 或者 .xlsx 结尾 
			    		var filename = this.filename();
			    		var regex = /^.*\.(xls|xlsx)$/ ;
			    		if(regex.test(filename)){
			    			// 满足
			    			this.submit();
			    		}else{
			    			//不满足
			    			$.messager.alert("警告","只能上传.xls或.xlsx结尾的文件！","warning");
			    		}
			    	},
			    	onComplete : function(response){
			    		alert("文件上传成功！");
			    	}
			    });
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
		<!--<input type="" data-toggle="city-picker" name="" id="" value="" />-->
		<!-- 添加 修改分区 -->
		<div class="easyui-window"  title="分区添加修改" id="addWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="javascript:" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>

			<div style="overflow:auto;padding:5px;" border="false" >
				<form id="subArea" action="" method="post" >
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">分区信息</td>
						</tr>
						<tr>
							<td>分拣编码</td>
							<td>
								<!--<input type="hidden" name="id" id="edit_id" />-->
								<input type="text" name="id" id="id" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>选择区域</td>
							<td>
								<input class="easyui-validatebox" data-toggle="city-picker" id="area"  name="area.id" data-options="valueField:'id',textField:'name',url:'../../data/area.json'" />
							</td>
						</tr>
						<tr>
							<td>关键字</td>
							<td>
								<input type="text" name="keyWords" id="keyWords" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>辅助关键字</td>
							<td>
								<input type="text" name="assistKeyWords" id="assistKeyWords" class="easyui-validatebox"  />
							</td>
						</tr>
						<tr>
							<td>起始号</td>
							<td>
								<input type="text" name="startNum" id="startNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>终止号</td>
							<td>
								<input type="text" name="endNum" id="endNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>单双号</td>
							<td>
								<select class="easyui-combobox" name="single" id="single" style="width:165px;">
									<option value="0">单双号</option>
									<option value="1">单号</option>
									<option value="2">双号</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>定区编号</td>
							<td>
								<input type="text" id="fixedArea" name="fixedArea.id"    style="width:165px;" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<!-- 查询分区 -->
		<div class="easyui-window" title="查询分区窗口" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form id="searchSubArea" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">查询条件</td>
						</tr>
						<tr>
							<td>省</td>
							<td>
								<input type="text" name="area.province"   />
							</td>
						</tr>
						<tr>
							<td>市</td>
							<td>
								<input type="text" name="area.city"  />
							</td>
						</tr>
						<tr>
							<td>区（县）</td>
							<td>
								<input type="text" name="area.district"   />
							</td>
						</tr>
						<tr>
							<td>定区编码</td>
							<td>
								<input type="text" name="fixedArea.id"   />
							</td>
						</tr>
						<tr>
							<td>关键字</td>
							<td>
								<input type="text" name="keyWords"   />
							</td>
						</tr>
						<tr>
							<td colspan="2"><a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="easyui-window" title="分区分布统计" id="subAreaWindow" modal="true" closed="true" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:100px;width: 800px; height: 400px">
			<div id="container"></div>
		</div>
	</body>

</html>
<script type="text/javascript">
	//ajax 提交数据
	$(function(){
		var aaa = null;
		$("#fixedArea").combobox({
			url:"../../fixedArea_findAll.action",
		
			formatter:function (row){
				//console.log(row);
//				if(row != null){
//					return row.id;
//				}
//				return "";
				aaa = null;
				return row.id;

			},
			textField:"id",
			valueField:'id',
			required:"true"
			
		})
		
		$("#save").click(function(){
			// 分区id
			var temp_area = $("span[data-count='district']").attr("data-code");
			if(temp_area==null ||temp_area == ""){
				$.messager.alert("警告","区域选择必须精确到分区！","warning");
				return;
			}
			//console.log($("span[data-count='district']").attr("data-code"));
			$.post("../../subArea_add.action",{
					"id":$.trim($("#id").val()),
					"area.id":$.trim(temp_area),//data-count="district"
					"keyWords":$.trim($("#keyWords").val()),
					"assistKeyWords":$.trim($("#assistKeyWords").val()),
					"startNum":$.trim($("#startNum").val()),
					"endNum":$.trim($("#endNum").val()),
					//"single":$("#single").val(),
					"single":$.trim($("#single").combobox("getValue")),
					//"fixedArea.id":$("#fixedArea").val()
					"fixedArea.id":$.trim($("#fixedArea").combobox("getValue"))
					},function(result){
						console.log(result);
						if(result.success){
							// 保存成功，提示：运单保存成功
							$.messager.show({
								title:'分区提示消息',
								msg:result.msg,
								timeout:5000,
								showType:'fade'
							});
						}else{
							$.messager.alert("警告",result.msg,"wanring");
						}
						// 清空表单数据
						$("#subArea").form("clear");
						// 关闭添加窗口 
						$("#addWindow").window("close");
						// 重新加载页面
						$("#grid").datagrid("load");
					
			},"json");
		})
	})
	
</script>