<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="promotion" >
	<!-- banner-->
	<section class="bannerarea">
		<div class="bannerimg"><img src="images/show/suyun/banner.png" class="img-responsive" alt="Responsive image"></div>
	</section>
	<!-- maincontent-->
	<section class="container">
		<div ng-controller="ctrlRead">
			<table class="table table-striped table-condensed table-hover">
				<tbody>
					<div class="activitybox row">
						<div class="areatitle">
							<h2 class="text-left"><span class="title">活动促销</span></h2>
							<p class="english"><span class="subtitle">ACTIVITY PROMOTION</span></p>
							<ul class="list-inline">
								<li class="active">全国</li>
								<li>华中</li>
								<li>华南</li>
								<li>华北</li>
							</ul>
						</div>
						<div class="col-sm-6 col-md-3" ng-repeat="item in pageItems">
							<div class="thumbnail">
								<img ng-src="{{item.titleImg}}" alt="活动一">

								<div class="caption">
									<p><a href="#/promotion_detail/{{item.id}}">{{item.title}}</a></p>
									<p class="text-right status">
										<span ng-show="item.status==1">进行中</span>
										<span ng-show="item.status==2">已结束</span>
									</p>
									<p class="text-right grey">{{item.startDate.replace("T"," ")}}—{{item.endDate.replace("T"," ")}}</p>
									<p class="text-right grey">{{item.activeScope}}</p>
								</div>
							</div>
						</div>
					</div>
				</tbody>
			</table>
			<!--  分页按钮 -->
			<div>
				<ul class="pagination pull-right">
					<li>
						<a href ng-click="prev()">上一页</a>
					</li>
					<li ng-repeat="page in pageList" ng-class="{active: isActivePage(page)}">
						<a ng-click="selectPage(page)">{{ page }}</a>
					</li>
					<li>
						<a href ng-click="next()">下一页</a>
					</li>
				</ul>
			</div>
		</div>
	</section>
</div>
