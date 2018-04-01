<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

	<head>
		<meta content="application/xhtml+xml;charset=UTF-8" http-equiv="Content-Type">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
		<title>速运快递</title>

		<link rel="stylesheet" type="text/css" href="css/styleindex.css">
		<link rel="stylesheet" type="text/css" href="css/public.css">
		<link rel="stylesheet" type="text/css" href="css/bootstrap/bootstrap.css">
		<link rel="stylesheet" type="text/css" href="css/nav.css">

		<script src="js/jquery.min.js" type="text/javascript"></script>
		<script src="js/bootstrap.min.js" type="text/javascript"></script>
		<script src="js/self/effect.js" type="text/javascript"></script>
		<script type="text/javascript" src="js/angular.min.js"></script>
		<script type="text/javascript" src="js/angular-route.min.js"></script>
		<!--百度地图api-->
		<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=akR4c0vTf7DoSdtGTugRWYA0DRhzm99F"></script>
		<!--[if IE]>
    <script src="js/html5.js"  type="text/javascript"></script>
    <script src="js/respond.min.js"  type="text/javascript"></script>
    <![endif]-->
	</head>

	<body ng-app="bosfore_app">
		<div class="index">
			<!-- nav -->
			<div id="headnav">
				<div class="mainnav">
					<nav class="nav navbar-default navbar-fixed-top">
						<div class="container">
							<!-- Brand and toggle get grouped for better mobile display -->
							<div class="navbar-header">
								<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
			                    <span class="sr-only">折叠菜单</span>
			                    <span class="icon-bar"></span>
			                    <span class="icon-bar"></span>
			                    <span class="icon-bar"></span>
               				</button>
								<a class="navbar-brand" href="#/"><img src="images/icon/logo.png"></a>
							</div>
							<!-- Collect the nav links, forms, and other content for toggling -->
							<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
								<ul class="nav navbar-nav navbar-right">
									<li class="active">
										<a href="#/" data-toggle="tooltip" data-placement="bottom" title="首页">首页</a>
									</li>
									<li>
										<a href="#/order" data-toggle="tooltip" data-placement="bottom" title="在线下单" >在线下单</a>
									</li>
									<li>
										<a href="#/express_manage" data-toggle="tooltip" data-placement="bottom" title="快件管理">快件管理</a>
									</li>
									<li>
										<a href="#/userinfo" data-toggle="tooltip" data-placement="bottom" title="账户管理">账户管理</a>
									</li>
									<li>
										<a href="#/search" data-placement="bottom" title="查询服务">查询服务</a>
									</li>
									<li>
										<a href="#/myhome" data-placement="bottom" title="我的主页">我的主页</a>
									</li>
									<li>
										<c:if test="${empty customer }">
											<a href="login.jsp">登录</a>
										</c:if>
										<c:if test="${not empty customer }">
											<%-- 登录名:${customer.username } 注销 --%>
												 <a href="./customer_logout.action" 	title="注销">注销</a>
										</c:if>
									</li>
								</ul>
							</div>
						</div>
					</nav>
				</div>
			</div>
			<!-- banner area-->
			<div ng-view></div>
			<!-- footer -->
			<div id="footer">
				<footer>
					<section class="footnav">
						<div class="container">
							<div class="col-md-8">
								<ul class="list-unstyled list-inline">
									<li>寄件
										<ul class="list-unstyled inner">
											<li>我要寄件</li>
											<li>运单追踪</li>
											<li>运费时效查询</li>
											<li>收送范围查询</li>
											<li>收寄标准查询</li>
										</ul>
									</li>
								</ul>
								<ul class="list-unstyled list-inline">
									<li>服务
										<ul class="list-unstyled inner">
											<li>速运即日</li>
											<li>速运次晨</li>
											<li>速运次日</li>
											<li>速运隔日</li>
											<li>速运标快</li>

										</ul>
									</li>
								</ul>
								<ul class="list-unstyled list-inline ">
									<li>联系我们
										<ul class="list-unstyled inner">
											<li>客服热线</li>
											<li>我要合作</li>
											<li>采购信息</li>
											<li>开放平台</li>

										</ul>
									</li>
								</ul>
								<ul class="list-unstyled list-inline ">
									<li>企业
										<ul class="list-unstyled inner">
											<li>速运概况</li>
											<li>服务网络</li>
											<li>速运航空</li>

										</ul>
									</li>
								</ul>

							</div>
							<div class="col-md-4">
								<ul class="list-unstyled contact">
									<li>联系方式
										<ul class="list-unstyled inner">
											<li>客服热线</li>
											<li><span class="tel">400-618-4000</span></li>
											<li>在线客服</li>
											<li><span class="bigtel">进入在线客服</span></li>

										</ul>
									</li>
								</ul>
								<div class="saoma"><img src="images/icon/suyun/erweima.png"></div>
							</div>
						</div>
					</section>
					<section class="copyright">
						<div class="container">
							<p>地址：北京市昌平区建材城西路金燕龙办公楼一层 邮编：100096 电话：400-618-4000 传真：010-82935100</p>
							<p>京ICP备08001421号京公网安备110108007702</p>
						</div>
					</section>
				</footer>
			</div>
		</div>
		<a href="#0" class="cd-top">Top</a>
		<script type="text/javascript">
			var bosfore_app = angular.module("bosfore_app", ['ngRoute']);
			bosfore_app.config(["$routeProvider", function($routeProvider) {
				$routeProvider.when("/", {
					templateUrl: 'main.jsp'
				}).when("/order", {
					templateUrl: 'order.jsp'
				}).when("/express_manage", {
					templateUrl: 'express_manage.jsp'
				}).when("/userinfo", {
					templateUrl: 'userinfo.jsp'
				}).when("/search", {
					templateUrl: 'search.jsp'
				}).when("/myhome", {
					templateUrl: 'myhome.jsp'
				}).when("/promotion", {
					templateUrl: 'promotion.jsp'
				}).when("/promotion_detail/:id", {
					//templateUrl: 'promotion_detail.html'
					templateUrl: function($routeParams){
						return './promotion_detail.action?id='+$routeParams.id
					}
				}).otherwise({
					redirectTo: '/'
				})
			}]);
			
			// 账户管理 控制器 
			bosfore_app.controller("userInfoCtrl",["$scope",function($scope){
			}]);
			
			// 在线下单控制器
			bosfore_app.controller("orderCtrl",["$scope",function($scope){
			}]);
		</script>
	</body>
	<script src="js/self/page.js"></script>
</html>