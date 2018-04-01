<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
    <meta charset="UTF-8">
    <title>客户信息</title>
    <!--<link rel="stylesheet" href="css/bootstrap/bootstrap.css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/angular.min.js"></script>
-->
    <link rel="stylesheet" type="text/css" href="css/styleindex.css">
    <link rel="stylesheet" type="text/css" href="css/public.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="css/nav.css">

    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/self/effect.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/angular.min.js"></script>
    <!--[if IE]>
    <script src="js/html5.js" type="text/javascript"></script>
    <script src="js/respond.min.js" type="text/javascript"></script>
    <![endif]-->
    <style type="text/css">
        nav {
            position: relative;
            width: 100%;
            height: 50px;
        }

        .pagination {
            right: 0px;
            position: absolute;
            top: -30px;
        }

        table, th, td {
            border: 1px solid grey;
            border-collapse: collapse;
            padding: 5px;
        }

        table tr:nth-child(odd) {
            background-color: #f1f1f1;
        }

        table tr:nth-child(even) {
            background-color: #ffffff;
        }
    </style>
</head>


<body>
<div class="page-header col-md-offset-1 col-md-10">
    <h1 class="col-md-11">客户信息表 <!--<small>Subtext for header</small>--></h1>
</div>
<li role="separator" class="divider col-md-offset-1 col-md-10 "></li>
<div class="col-md-10 col-md-offset-1 table-responsive" id="divMain" ng-app="myApp" ng-controller="myCtrl">
    <table class="table table-bordered table-hover">
        <thead>
        <tr>
            <th>序号</th>
            <th>客户编号</th>
            <th>用户名</th>
            <th>性别</th>
            <th>手机号</th>
            <th>公司</th>
            <th>邮箱</th>
            <th>定区编码</th>
            <th>客户类型</th>
        </tr>
        </thead>
        <tbody>
        <tr ng-repeat="x in products">
            <td>{{$index + 1}}</td>
            <td ng-bind="x.id"></td>
            <td ng-bind="x.username"></td>
            <td>{{x.sex==1?'男':'女'}}</td>
            <td ng-bind="x.telephone"></td>
            <td ng-bind="x.company"></td>
            <td ng-bind="x.email"></td>
            <td ng-bind="x.fixedAreaId"></td>
            <td>{{x.type==1?'vip':'普通客户'}}</td>
        </tr>
        </tbody>
    </table>
    <nav>
        <ul class="pagination">
            <li>
                <a ng-click="prev()">
                    <span>上一页</span>
                </a>
            </li>
            <li ng-repeat="page in pageList" ng-class="{active: isActivePage(page)}">
                <a ng-click="selectPage(page)">{{ page }}</a>
            </li>
            <li>
                <a ng-click="next()">
                    <span>下一页</span>
                </a>
            </li>
        </ul>
    </nav>
</div>
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
                    <div class="saoma"><img src="image/erweima.png"></div>
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
<script type="text/javascript">
    var myapp = angular.module('myApp', []);
    myapp.controller('myCtrl', ["$scope", "$http", function ($scope, $http) {

        $scope.currentPage = 1;
        $scope.pageSize = 5;
        $scope.totalCount = 0;
        $scope.totalPages = 0;

        $scope.prev = function () {
            if ($scope.currentPage > 1) {
                $scope.selectPage($scope.currentPage - 1);
            }
        }

        $scope.next = function () {
            if ($scope.currentPage < $scope.totalPages) {
                $scope.selectPage($scope.currentPage + 1);
            }
        }

        $scope.selectPage = function (page) {
            $http({
                method: 'GET',
                url: './customer_page_query.action',
                params: {
                    "page": page,
                    "rows": $scope.pageSize
                }
            }).success(function (data, status, headers, config) {
                console.log(data);
                $scope.products = data.rows;
                $scope.totalCount = data.total;
                $scope.totalPages = Math.ceil($scope.totalCount / $scope.pageSize);

                // 第1,2 页
                if (page <= 2) {
                    $scope.pageList = [];
                    $scope.newPages = $scope.totalPages > 5 ? 5 : $scope.totalPages;
                    for (var i = 0; i < $scope.newPages; i++) {
                        $scope.pageList.push(i + 1);
                    }
                }
            }).error(function (data, status, headers, config) {
                // 当响应以错误状态返回时调用
            });

            //不能小于1大于最大
            if (page < 1 || page > $scope.totalPages) return;

            //最多显示分页数5
            if (page > 2) {
                //因为只显示5个页数，大于2页开始分页转换
                var newpageList = [];
                for (var i = (page - 3); i < ((page + 2) > $scope.totalPages ? $scope.totalPages : (page + 2)); i++) {
                    newpageList.push(i + 1);
                }
                $scope.pageList = newpageList;
            }
            $scope.currentPage = page;
            $scope.isActivePage(page);
        }

        $scope.isActivePage = function (page) {
            return page == $scope.currentPage;
        }

        // 发起请求 显示第一页数据
        $scope.selectPage($scope.currentPage);
    }]);
</script>
</body>

</html>