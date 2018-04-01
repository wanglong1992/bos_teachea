<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!--
	描述：运单查询
-->
<script src="js/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/stylesearch.css">

<script type="text/javascript">
	$(function() {
		$("#searchBtn").click(function() {
			$("#ordercontent").html("")
			$.get("waybill_findById.action?ids="+$("#exampleInputAmount").val(), function(data) {
				$(data.wayBillsData).each(function(index,value){
					var status;
					if(value.signStatus==1){
						status = " 待发货"
					}
					else if(value.signStatus==2){
						status =" 派送中"
					}else if(value.signStatus==3){
						status =" 已签收"
					}else{
						status ="异常"
						return;
					}
					var row = $("<tr><td><input type='checkbox'>"+value.recName+"</td><td>"+status+"</td><td class=''>操作</td></tr>")
					$("#ordercontent").append(row)
				})

			});
		})
	})
</script>

<section class="searchbox">
	<div class="container">
		<!-- nav -->

		<div class="searcharea">
			<div class="areatitle">
				<h4><span class="title">运单查询</span></h4>
			</div>
			<form class="form" id="ss" method="post">
				<div class="form-inline">
					<input type="text" class="form-control" id="exampleInputAmount" placeholder="输入查询的运单号码，多个运单号请以逗号隔开，最多输入20个运单号码查询">
					<button id="searchBtn" class="btn btn-danger">查询</button>
				</div>
			</form>
		</div>

		<div class="partline"></div>

		<div class="areatitle">
			<h4><span class="title">查询结果/查询历史</span></h4>
		</div>

		<div class="btnarea">
			<a href="##" class="btn btn-danger">订阅选中</a>
		</div>

	</div>
</section>

<section class="searchcontent container">
	<div class="ordertable">
		<table class="table table-striped" id="orderTable">
			<tr>
				<td><input type="checkbox" id="receiver">　收件人姓名</td>
				<td>运单最新状态</td>
				<td class="">操作</td>
			</tr>
		</table>
		<table class="table table-bordered table-striped" id="ordercontent">

		</table>
	</div>
</section>