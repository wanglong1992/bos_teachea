<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>运单录入</title>
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
				$("body").css({
					visibility: "visible"
				});
				$("#no").click(function(){
					$("#waybillForm").form("reset");
					$("input[name='wayBillNum']").attr("readonly",false);
					$("input[name='order.orderNum']").attr("readonly",false);
				})

				// 对save按钮条件 点击事件
				$('#save').click(function() {
					// 对form 进行校验
//					if($('#waybillForm').form('validate')) {
//						$('#waybillForm').submit();
//					}
					// 使用ajax方式完成表单提交（保存）
					//alert($("#waybillForm").serialize());
					$.post("../../waybill_save.action",$("#waybillForm").serialize(),function(data){
						if(data.success){
							// 保存成功，提示：运单保存成功
							$.messager.show({
								title:'运单提示消息',
								msg:data.msg,
								timeout:5000,
								showType:'fade'
							});
							// 清空表单，解放只读
							$("#waybillForm").form("reset");
							$("input[name='wayBillNum']").attr("readonly",false);
							$("input[name='order.orderNum']").attr("readonly",false);
						}
						else{
							$.messager.alert("警告",data.msg,"wanring");
						}
					})
				});
				
				// 鼠标失去焦点事件，在点击订单输入框的时候
				$("input[name='order.orderNum']").blur(function(){
					// 如果订单号已经只读，不往下执行
					if($("input[name='order.orderNum']").attr("readonly")){
						return;
					}
					// alert(this.value);
					// 使用ajax技术，传递订单号，查询订单
					$.post("../../order_findByOrderNum.action",{"orderNum":this.value},function(data){
						if(data.success){
							// 查询到结果，将查询的结果，回显到表单中（按照订单回显）
							$("#waybillForm").form("load",data.orderData);
							// 将随机生成的运单号，回显到页面上的运单号的输入框中
							$("input[name='wayBillNum']").val(data.orderData.wayBill.wayBillNum);
							// 在页面上赋值，没有回显的数据
							// 设置订单id的隐藏域
							$("input[name='order.id']").val(data.orderData.id);
							
							// 清空运单ID的隐藏域，此时没有运单id，保存的时候，才是新增
							$("input[name='id']").val("");
							if(data.orderData.courier!=null){
								// 快递员的公司
								$("input[name='order.courier.company']").val(data.orderData.courier.company);
								// 快递员的姓名
								$("input[name='order.courier.name']").val(data.orderData.courier.name);
							}
							else{
								// 快递员的公司
								$("input[name='order.courier.company']").val("");
								// 快递员的姓名
								$("input[name='order.courier.name']").val("");
							}
							// 让运单号只读
							$("input[name='wayBillNum']").attr("readonly",true);
							// 让订单号只读
							$("input[name='order.orderNum']").attr("readonly",true);
						}
						else{
							// 没有查询到结果，清空表单
							$("#waybillForm").form("clear");
						}
					});
				});
				// 鼠标失去焦点事件，在点击运单输入框的时候
				$("input[name='wayBillNum']").blur(function(){
					// 使用ajax技术，传递运单号，查询运单
					$.post("../../waybill_findByWayBillNum.action",{"wayBillNum":this.value},function(data){
						if(data.success){
							// 查询到结果，将查询的结果，回显到表单中（按照运单回显）
							$("#waybillForm").form("load",data.wayBillData);
							if(data.wayBillData.order!=null){
								// 设置订单id（隐藏域）
								$("input[name='order.id']").val(data.wayBillData.order.id);
								// 设置订单号
								$("input[name='order.orderNum']").val(data.wayBillData.order.orderNum);
								if(data.wayBillData.order.courier!=null){
									// 快递员的公司
									$("input[name='order.courier.company']").val(data.wayBillData.order.courier.company);
									// 快递员的姓名
									$("input[name='order.courier.name']").val(data.wayBillData.order.courier.name);
								}
								else{
									// 快递员的公司
									$("input[name='order.courier.company']").val("");
									// 快递员的姓名
									$("input[name='order.courier.name']").val("");
								}
							}
							else{
								$("input[name='order.id']").val("");
								// 设置订单号
								$("input[name='order.orderNum']").val("");
							}
							// 设置订单号只读
							$("input[name='order.orderNum']").attr("readonly",true);
							// 让运单号只读
							$("input[name='wayBillNum']").attr("readonly",true);
						}
//						else{
//							// 没有查询到结果，清空表单
//							$("#waybillForm").form("clear");
//						}
					});
				})
			});
		</script>
	</head>

	<body>
		<div class="datagrid-toolbar">
			<a id="add" icon="icon-add" href="#" class="easyui-linkbutton" plain="true">新增</a>
			<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
			<a id="no" icon="icon-no" href="#" class="easyui-linkbutton" plain="true">取消</a>
		</div>
		<div style="width:95%;margin:10px auto">
			<form id="waybillForm" method="post" 
				action="../../waybill_save.action" >
			<div class="table-top">
				<table class="table-edit" width="95%">
					<tr class="title">
						<td colspan="6">单号信息</td>
					</tr>
					<tr>
						<td>订单号</td>
						<td>
							<input type="hidden" name="order.id" id="orderId" /><!--存放订单id-->
							<input type="hidden" name="id" id="id" /><!--存放运单id-->
							<input type="text" name="order.orderNum" id="orderNum" style="width:300px"/>
						</td>
						<td>运单号</td>
						<td>
							<input type="text" name="wayBillNum" id="wayBillNum" style="width:400px"/>
						</td>
					</tr>
					<tr>
						<td>到达地</td>
						<td><input type="text" name="arriveCity" required="true" /></td>
						<td>产品时限</td>
						<td>
							<select class="easyui-combobox" name="sendProNum">
									<option value="速运当日">速运当日</option>
									<option value="速运次日">速运次日</option>
									<option value="速运隔日">速运隔日</option>
								</select>
						</td>
						<td>配载要求</td>
						<td>
							<select class="easyui-combobox" name="floadreqr">
									<option value="无">无</option>
									<option value="禁航空">禁航空</option>
									<option value="禁铁路航空">禁铁路航空</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>受理单位</td>
						<td><input type="text" name="order.courier.company" required="true" /></td>
						<td>快递员</td>
						<td><input type="text" name="order.courier.name" required="true" /></td>
					</tr>
				</table>
			</div>
			<div class="table-center" style="margin-top:15px">
				<div class="col-md-5">
					<table class="table-edit send" width="95%">
						<tr class="title">
							<td colspan="4">寄件人信息</td>
						</tr>
						<tr>
							<td>寄件人</td>
							<td><input type="text" name="sendName" required="true" /></td>
							<td>地址</td>
							<td><input type="text" name="sendAddress" required="true" /></td>
						</tr>
						<tr>
							<td>公司</td>
							<td><input type="text" name="sendCompany" required="true" /></td>
							<td>电话</td>
							<td><input type="text" name="sendMobile" required="true" /></td>
						</tr>
					</table>

					<table class="table-edit receiver" width="95%">
						<tr class="title">
							<td colspan="4">收件人信息</td>
						</tr>
						<tr>
							<td>收件人</td>
							<td><input type="text" name="recName" required="true" /></td>
							<td>地址</td>
							<td><input type="text" name="recAddress" required="true" /></td>
						</tr>
						<tr>
							<td>公司</td>
							<td><input type="text" name="recCompany" required="true" /></td>
							<td>电话</td>
							<td><input type="text" name="recMobile" required="true" /></td>
						</tr>
					</table>
					<table class="table-edit number" width="95%">
						<tr class="title">
							<td colspan="4">货物信息</td>
						</tr>
						<tr>
							<td>原件数</td>
							<td><input type="text" name="num" required="true" /></td>
							<td>实际重量</td>
							<td><input type="text" name="actlweit" required="true" /></td>
						</tr>

						<tr>
							<td>货物</td>
							<td><input type="text" name="goodsType" required="true" /></td>
							<td>体积</td>
							<td><input type="text" name="vol" required="true" /></td>
						</tr>
					</table>
				</div>
				<div class="col-md-7">
					<table class="table-edit security" width="95%">
						<tr class="title">
							<td colspan="6">包装信息</td>
						</tr>
						<tr>
							<td>保险类型</td>
							<td>
								<select class="easyui-combobox">
									<option value="0">不保险</option>
									<option value="1">委托投保</option>
									<option value="2">自带投保</option>
									<option value="3">保价</option>
								</select>
							</td>
							<td>保险费</td>
							<td><input type="text" name="secuityprice" required="true" /></td>
							<td>声明价值</td>
							<td><input type="text" name="value" required="true" /></td>
						</tr>

						<tr>
							<td>原包装</td>
							<td>
								<select class="easyui-combobox">
									<option value="0">木箱</option>
									<option value="1">纸箱</option>
									<option value="2">快递袋</option>
									<option value="3">其他</option>
								</select>
							</td>
							<td>实际包装</td>
							<td>
								<select class="easyui-combobox">
									<option value="0">木箱</option>
									<option value="1">纸箱</option>
									<option value="2">快递袋</option>
									<option value="3">其他</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>包装费</td>
							<td><input type="text" name="packageprice" required="true" /></td>
							<td>包装要求</td>
							<td><input type="text" name="packageprice" required="true" /></td>
						</tr>
					</table>

					<table class="table-edit max" width="95%">
						<tr>
							<td>实际件数</td>
							<td><input type="text" name="realNum" required="true" /></td>
							<td>计费重量</td>
							<td><input type="text" name="priceWeight" required="true" /></td>
						</tr>
						<tr>
							<td>预收费</td>
							<td><input type="text" name="planprice" required="true" /></td>
							<td><button class="btn btn-default">计算</button></td>
						</tr>
					</table>

					<table class="table-edit money" width="95%">
						<tr class="title">
							<td colspan="6">计费信息</td>
						</tr>
						<tr>
							<td>结算方式</td>
							<td>
								<select class="easyui-combobox">
									<option value="0">现结</option>
									<option value="1">代付</option>
									<option value="2">网络</option>
									
								</select>
							</td>
							<td>代收款</td>
							<td><input type="text" name="priceWeight" required="true" /></td>
							<td>到付款</td>
							<td><input type="text" name="priceWeight" required="true" /></td>
						</tr>

					</table>
					<table class="table-edit feedback" width="95%">
						<tr class="title">
							<td colspan="4">配送信息</td>
						</tr>
						<tr>
							<td><input type="checkbox">反馈签收</td>
							<td><input type="checkbox">节假日可收货</td>
							<td>送达时限</td>
							<td><input type="text" class="easyui-datebox" data-options="editable:false" /></td>
						</tr>

						<tr>
							<td>处理方式</td>
							<td>
								<select class="easyui-combobox">
									<option value="0">无</option>
									<option value="1">不可开箱验货</option>
									<option value="2">开开箱单不可开内包</option>
									<option value="3">可开箱和内包</option>
								</select>
							</td>
							<td>签单返回</td>
							<td>
								<select class="easyui-combobox">
									<option value="0">箱单</option>
									<option value="1">原单</option>
									<option value="2">附原单</option>
									<option value="3">网络派送单</option>
								</select>
							</td>
						</tr>
					</table>
					<table class="table-edit tips" width="95%">
						<tr>
							<td>重要提示</td>
							<td><textarea style="width:250px;height: 80px;"></textarea></td>
						</tr>

					</table>
				</div>
			</div>
			<div class="clearfix"></div>
			</form>			
		</div>
	</body>

</html>