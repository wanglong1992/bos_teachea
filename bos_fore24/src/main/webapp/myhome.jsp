<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="css/stylemyhome.css">
<div class="myhome">
	<section class="bannerarea">
		<div class="bannerimg"><img src="images/show/suyun/homebanner.png" class="img-responsive" alt="Responsive image"></div>
	</section>
	<div class="container">
		<section class="huiyuan">
			<div class="info">
				<div class="col-md-3 activity">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h4 class="panel-title">会员动态<span>更多</span></h4>
						</div>
						<div class="panel-body">
							<ul class="list-group">
								<li>关于20xx年杭州G20峰会期间</li>
								<li>电子账户余额已转至顺手付</li>
								<li>会员福利来袭，带你玩"赚"积分</li>
								<li>电子账户升级为顺手付通知</li>
								<li>“20xx瞄准幸福”电话回访中</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="personinfo">
					<div class="col-md-3  text-center model">
						<img src="images/icon/suyun/photo.png" alt="我的头像" />
						<p>13812345678</p>
						<p>
							<a href="" class="btn btn-warning">VIP俱乐部</a>
						</p>
						<p>账号安全：******</p>
						<p>我的勋章：8888</p>
					</div>
					<div class="col-md-3  text-center model">
						<p>
							<a href="" class="btn btn-inverse">我的本年度成长值</a>
						</p>
						<h1>2</h1>
						<p>
							<c:if test="${customer.hasSignInToday==1}">
								<a href="" class="btn btn-danger" id = "signInBtn2">已签到</a>
							</c:if>
							<c:if test="${customer.hasSignInToday!=1}">
								<a href="" class="btn btn-danger" id = "signInBtn">签到</a>
							</c:if>
							<a href="index.jsp#/order" class="btn btn-danger">寄件</a>
						</p>
						<p>
							<a href="">速运快递会员成长值介绍</a>
						</p>

					</div>
					<div class="col-md-3 jifen model">

						<p class="text-left">我的账号</p>
						<table class="table">
							<tr>
								<td>
									<p class="grey" >可用积分</p>
									<p class="num" id="customerCredits">${customer.credits}</p>
								</td>
								<td>
									<p class="grey">优惠券</p>
									<p class="num">2</p>
								</td>
							</tr>
							<tr>
								<td>
									<p class="grey">个人会员积分</p>

									<p class="num">2</p>
									<p>
										<a href="">积分兑换</a>
									</p>

								</td>
								<td>
									<p class="grey">月结会员积分</p>
									<p class="num">2</p>
									<p>
										<a href="">兑换细则</a>
									</p>
								</td>
							</tr>
						</table>

					</div>
					<div class="col-md-3 homeshow">
						<img src="images/show/suyun/homeshow.png" alt="我的头像" />
					</div>
				</div>

				<div class="tequan">
					<b>*</b>　亲爱的会员您拥有单子运单专享特权哦！　详情
				</div>
				<div class="seek">
					<form class="form">
						<div class="form-inline">
							<input type="text" class="form-control" id="orderseek" placeholder="输入查询的运单号码，多个运单号请以逗号（，）隔开，最多输入20个运单号码查询">
							<button type="submit" class="btn btn-danger">查询</button>
						</div>
					</form>
				</div>
				<div class="order">
					<div class="col-md-3 left">
						<a href="#/order" class="btn btn-danger">我要下单</a>
					</div>
					<div class="col-md-9 right">
						<h4 class="bigtitle"><span class="title">使用模板寄件</span></h4>
						<p class="text-right">
							<a href="">管理</a>
							<a href="">全部</a>
						</p>
						<table class="table">
							<tr>
								<td>
									<h4><span class="plus">新添加模板</span></h4>
									<p class="grey">自定义专属</p>
								</td>
								<td>
									<h4><span class="plus">新添加模板</span></h4>
									<p class="grey">自定义专属</p>
								</td>
								<td style="border-right:none">
									<h4><span class="plus">新添加模板</span></h4>
									<p class="grey">自定义专属</p>
								</td>

							</tr>

						</table>

					</div>
				</div>

		</section>
		</div>
	</div>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript">
	
	$("#signInBtn").click(function(){
		$.post("./customer_signIn.action",function(data){
			console.log(data);
			if(data.success){
				//如果签到成功,修改按钮为已经签到
				alert("签到成功,你已经成功签到"+data.customer.hasSignIsDay+"天");
				//更新客户积分显示
				$("#customerCredits").html(data.customer.credits);
				//修改按钮
				$("#signInBtn").html("已签到");
			}
		})
	})
</script>