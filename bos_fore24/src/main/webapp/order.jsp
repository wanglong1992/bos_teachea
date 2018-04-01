<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!--
描述：用户下单页面
-->
<link href="css/city-picker.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="css/styleorder.css">

<div class="order" id="ng-app" ng-app="app">
    <!-- orderall -->
    <section>
        <div class="tab-title ">
            <ul class="nav nav-tabs container" role="tablist">
                <li role="presentation" class="active">
                    <a data-target="#home" aria-controls="home" role="tab" data-toggle="tab">单件下单</a>
                </li>
                <li role="presentation">
                    <a data-target="#profile" aria-controls="profile" role="tab" data-toggle="tab">批量下单</a>
                </li>

            </ul>

            </ul>
        </div>
        <div class="tab-content container">
            <div class="jiangli">
                <div class="col-md-4 xiaojf">
                    <h5>消费积分奖励</h5>
                    <p class="grey">消费1元积1分，累计积分兑好礼</p>
                </div>
                <div class="col-md-4 tenjf">
                    <h5>消费积分奖励</h5>
                    <p class="grey">消费1元积1分，累计积分兑好礼</p>
                </div>
                <div class="col-md-4 qianjf">
                    <h5>消费积分奖励</h5>
                    <p class="grey">消费1元积1分，累计积分兑好礼</p>
                </div>
            </div>
            <div role="tabpanel" class="tab-pane fade in active" id="home">

                <ul class="nav nav-tabs">
                    <li role="presentation" class="active">
                        <a data-target="#one" aria-controls="home" role="tab" data-toggle="tab">国内</a>
                    </li>
                    <li role="presentation">
                        <a data-target="#two" aria-controls="profile" role="tab" data-toggle="tab">港澳台</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane fade in active" id="one">
                        <form id="orderForm" class="form-horizontal" method="post" action="./order_save.action">
                            <!--寄件人信息 -->
                            <div class="model">
                                <div class="areatitle">
                                    <h4><span class="zhezhao">寄件人信息</span></h4>
                                </div>
                                <div class="col-md-5">
                                    <div class="orderinfo">
                                        <div class="form-group " id="sender-group">
                                            <label class="col-sm-3 control-label"><b>*</b>姓名：</label>

                                            <div class="col-sm-8 input-group" style="padding:0 15px;">
                                                <input name="sendName" type="text" class="form-control"
                                                       placeholder="请输入发件人姓名" required="required">
                                                <div class="input-group-addon">
                                                    <button type="button" data-toggle="modal" data-target="#myModal"
                                                            id="dao"><img src="images/icon/suyun/contact.png"></button>
                                                </div>

                                                <!-- Modal -->
                                                <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                                                     aria-labelledby="myModalLabel" aria-hidden="true">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <button type="button" class="close"
                                                                        data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                                                                        class="sr-only">关闭</span></button>
                                                                <h4 class="modal-title" id="myModalLabel">
                                                                    <strong>从地址薄导入</strong></h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <!-- Nav tabs -->
                                                                <ul class="nav nav-tabs" role="tablist">
                                                                    <li role="presentation" class="active">
                                                                        <a data-target="#person" role="tab"
                                                                           data-toggle="tab">个人地址</a>
                                                                    </li>
                                                                    <li role="presentation">
                                                                        <a data-target="#all" role="tab"
                                                                           data-toggle="tab">常用地址</a>
                                                                    </li>

                                                                </ul>

                                                                <!-- Tab panes -->
                                                                <div class="tab-content">
                                                                    <div class="form-group col-md-5">
                                                                        <input type="text" class="form-control"
                                                                               id="inputPassword"
                                                                               placeholder="输入姓名/手机号/地址查询">
                                                                    </div>
                                                                    <button type="submit" class="btn btn-danger new">
                                                                        搜索
                                                                    </button>
                                                                    <%--  <table class="table table-striped table-bordered">
                                                                          <thead>
                                                                          <tr>
                                                                              <th><input type="checkbox"/>　姓名</th>
                                                                              <th>联系方式</th>
                                                                              <th>公司名</th>
                                                                              <th>详细地址</th>
                                                                          </tr>
                                                                          </thead>--%>
                                                                    <%--<tbody>
                                                                    </tbody>--%>
                                                                    <%--   </table>--%>

                                                                    <div role="tabpanel"
                                                                         class="tab-pane active clearfix" id="person">
                                                                        <table class="table table-striped table-bordered">
                                                                            <thead>
                                                                            <tr>
                                                                                <th><input type="checkbox"/></th>
                                                                                <th>姓名</th>
                                                                                <th>联系方式</th>
                                                                                <th>公司名</th>
                                                                                <th>详细地址</th>
                                                                            </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                            <tr><td><input type="checkbox"/></td>
                                                                                <td><%--<input type="checkbox">--%>  1</td>
                                                                                <td>2</td>
                                                                                <td>3</td>
                                                                                <td>4</td>
                                                                            </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <div role="tabpanel" class="tab-pane" id="all">
                                                                        <table class="table table-striped table-bordered">
                                                                            <thead>
                                                                            <tr><th><input type="checkbox"/></th>
                                                                                <th>姓名</th>
                                                                                <th>联系方式</th>
                                                                                <th>公司名</th>
                                                                                <th>详细地址</th>
                                                                            </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                            <tr>
                                                                                <td><input type="checkbox"> </td><td> 11</td>
                                                                                <td>12</td>
                                                                                <td>13</td>
                                                                                <td>14</td>
                                                                            </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>

                                                                </div>

                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-default"
                                                                        data-dismiss="modal">取消
                                                                </button>
                                                                <button type="button" class="btn btn-primary">确定
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Modal end -->

                                            </div>
                                        </div>

                                        <div class="form-group" id="mobile-group">
                                            <label class="col-sm-3 control-label"><b>*</b>联系方式：</label>

                                            <div class="col-sm-8">
                                                <input name="sendMobile" type="text" class="form-control"
                                                       placeholder="请输入联系电话" required="required">

                                            </div>
                                        </div>
                                        <div class="form-group" id="sendcompany-group">
                                            <label class="col-sm-3 control-label">寄件公司：</label>

                                            <div class="col-sm-8">
                                                <input name="sendCompany" type="text" class="form-control"
                                                       placeholder="请输入寄件公司">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">省市区：</label>

                                            <div class="col-sm-8 province">
                                                <div class="docs-methods">
                                                    <div id="distpicker">
                                                        <div class="form-group">
                                                            <div class="innercity">
                                                                <input id="sendAreaInfo" name="sendAreaInfo"
                                                                       class="form-control" readonly type="text"
                                                                       data-toggle="city-picker">
                                                            </div>
                                                            <button class="btn btn-warning" id="reset" type="button"
                                                                    style="float: right;padding: 8px;">重置
                                                            </button>
                                                        </div>

                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="sendAddress"
                                                   class="col-sm-3 control-label"><b>*</b>详细地址：</label>

                                            <div class="col-sm-8">
                                                <input id="sendAddress" name="sendAddress" type="text"
                                                       class="form-control" placeholder="街道详细（精确到门牌号） "
                                                       required="required">
                                                <div id="searchResultPanel"
                                                     style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
                                                <p class="error">
                                                    请填写正确的信息
                                                </p>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-md-7"></div>
                            </div>
                            <!--收件人信息 -->
                            <div class="model clearfix">
                                <div class="areatitle">
                                    <h4><span class="zhezhao">收件人信息</span></h4>

                                </div>
                                <div class="col-md-5">
                                    <div class="orderinfo">
                                        <div class="form-group" id="sender-group">
                                            <label class="col-sm-3 control-label"><b>*</b>姓名：</label>

                                            <div class="col-sm-8 input-group" style="padding:0 15px;">
                                                <input name="recName" type="text" class="form-control"
                                                       style="z-index: 0;" placeholder="请输入收件人姓名" required="required">
                                                <div class="input-group-addon">
                                                    <button type="button" data-toggle="modal" data-target="#myModal"
                                                            id="dao"><img src="images/icon/suyun/contact.png"></button>
                                                </div>

                                                <!-- Modal -->
                                                <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                                                     aria-labelledby="myModalLabel" aria-hidden="true">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <button type="button" class="close"
                                                                        data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                                                                        class="sr-only">关闭</span></button>
                                                                <h4 class="modal-title" id="myModalLabel">
                                                                    <strong>从地址薄导入</strong></h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <!-- Nav tabs -->
                                                                <ul class="nav nav-tabs" role="tablist">
                                                                    <li role="presentation" class="active">
                                                                        <a data-target="#person" role="tab"
                                                                           data-toggle="tab">个人地址</a>
                                                                    </li>
                                                                    <li role="presentation">
                                                                        <a data-target="#all" role="tab"
                                                                           data-toggle="tab">常用地址</a>
                                                                    </li>

                                                                </ul>

                                                                <!-- Tab panes -->
                                                                <div class="tab-content">
                                                                    <div class="form-group col-md-5">
                                                                        <input type="text" class="form-control"
                                                                               id="inputPassword"
                                                                               placeholder="输入姓名/手机号/地址查询">
                                                                    </div>
                                                                    <button type="submit" class="btn btn-danger new">
                                                                        搜索
                                                                    </button>
                                                                    <table class="table table-striped">
                                                                        <thead>
                                                                        <tr>
                                                                            <th>姓名</th>
                                                                            <th>联系方式</th>
                                                                            <th>公司名</th>
                                                                            <th>详细地址</th>
                                                                        </tr>
                                                                        </thead>
                                                                        <tbody>

                                                                        </tbody>

                                                                    </table>

                                                                    <div role="tabpanel"
                                                                         class="tab-pane active clearfix" id="person">
                                                                        个人地址
                                                                    </div>
                                                                    <div role="tabpanel" class="tab-pane" id="all">
                                                                        常用地址
                                                                    </div>

                                                                </div>

                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-default"
                                                                        data-dismiss="modal">取消
                                                                </button>
                                                                <button type="button" class="btn btn-primary">确定
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Modal end -->
                                            </div>
                                        </div>
                                        <div class="form-group" id="mobile-group">
                                            <label class="col-sm-3 control-label"><b>*</b>联系方式：</label>

                                            <div class="col-sm-8">
                                                <input name="recMobile" type="text" class="form-control"
                                                       placeholder="请输入收件人电话" required="required">

                                            </div>
                                        </div>
                                        <div class="form-group" id="sendcompany-group">
                                            <label class="col-sm-3 control-label">收件公司：</label>

                                            <div class="col-sm-8">
                                                <input name="recCompany" type="text" class="form-control"
                                                       placeholder="请输入收件公司">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">省市区：</label>

                                            <div class="col-sm-8 province">
                                                <div class="docs-methods">
                                                    <div id="distpicker">
                                                        <div class="form-group">
                                                            <div class="innercity">
                                                                <input name="recAreaInfo" id="recAreaInfo"
                                                                       class="form-control" readonly type="text"
                                                                       data-toggle="city-picker">
                                                            </div>
                                                            <button class="btn btn-warning" id="reset2" type="button"
                                                                    style="float: right;padding: 8px;">重置
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="inputPassword"
                                                   class="col-sm-3 control-label"><b>*</b>详细地址：</label>

                                            <div class="col-sm-8">
                                                <input id="recAddress" name="recAddress" type="text"
                                                       class="form-control" placeholder="街道详细（精确到门牌号） "
                                                       required="required">
                                                <div id="searchResultPanel1"
                                                     style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-7"></div>

                            </div>

                            <div class="partline"></div>

                            <!--快件信息 -->
                            <div class="model clearfix">
                                <div class="areatitle">
                                    <h4><span class="zhezhao">快件信息</span></h4>

                                </div>
                                <div class="col-md-5">
                                    <div class="orderinfo">
                                        <div class="form-group" id="sender-group">
                                            <label class="col-sm-3 control-label"><b>*</b>拖寄物：</label>

                                            <div class="col-sm-8">
                                                <select class="form-control" name="goodsType">
                                                    <option>文件</option>
                                                    <option>衣服</option>
                                                    <option>食品</option>
                                                    <option>电子产品</option>
                                                </select>

                                            </div>
                                        </div>
                                        <div class="form-group" id="mobile-group">
                                            <label class="col-sm-3 control-label">重量：</label>

                                            <div class="col-sm-8">
                                                <input name="weight" type="text" class="form-control"
                                                       placeholder="请输入重量" required="required">

                                            </div>
                                        </div>
                                        <div class="form-group" id="sendcompany-group">
                                            <label class="col-sm-3 control-label">备注：</label>

                                            <div class="col-sm-8">
                                                <input name="remark" type="text" class="form-control"
                                                       placeholder="备注不超过20个字">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">快递产品：</label>

                                            <div class="col-sm-8">
                                                <select class="form-control" name="sendProNum">
                                                    <option>速运当日</option>
                                                    <option>速运次日</option>
                                                    <option>速运隔日</option>

                                                </select>

                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="inputPassword" class="col-sm-3 control-label">付款方式：</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" name="payTypeNum">
                                                    <option>寄付日结</option>
                                                    <option>寄付月结</option>
                                                    <option>到付</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-7"></div>
                            </div>

                            <div class="partline"></div>

                            <!--预约-->
                            <div class="model clearfix">
                                <div class="col-md-5">
                                    <div class="orderinfo">
                                        <div class="form-group" id="mobile-group">
                                            <label class="col-sm-3 control-label">给小哥捎话：</label>

                                            <div class="col-sm-8">
                                                <input name="sendMobileMsg" type="text" class="form-control"
                                                       placeholder="有什么要提醒快递员的吗？" required="required">

                                            </div>
                                        </div>
                                    </div>
                        </form>
                    </div>
                    <div class="col-md-7"></div>
                </div>
                </form>
            </div>

            <div role="tabpanel" class="tab-pane fade" id="two">港澳台待定</div>

        </div>

</div>
<div role="tabpanel" class="tab-pane fade" id="profile">

    <div class="model">
        <div class="areatitle">
            <h4><span class="zhezhao">寄件人信息</span></h4>

        </div>
        <div class="col-md-5">
            <form class="form-horizontal" name="OrderForm" ng-submit="submitForm()">
                <div class="orderinfo">
                    <div class="form-group" id="sender-group">
                        <label class="col-sm-3 control-label"><b>*</b>姓名：</label>

                        <div class="col-sm-8">
                            <input name="sendName" type="text" class="form-control" placeholder="请输入发件人姓名"
                                   ng-model="orderdata.sendName" required="required">

                        </div>
                    </div>
                    <div class="form-group" id="mobile-group">
                        <label class="col-sm-3 control-label"><b>*</b>联系方式：</label>

                        <div class="col-sm-8">
                            <input name="sendMobile" type="text" class="form-control" placeholder="请输入联系电话"
                                   ng-model="orderdata.sendMobile" required="required">

                        </div>
                    </div>
                    <div class="form-group" id="sendcompany-group">
                        <label class="col-sm-3 control-label">寄件公司：</label>

                        <div class="col-sm-8">
                            <input name="sendCompany" type="text" class="form-control" placeholder="请输入寄件公司"
                                   ng-model="orderdata.sendCompany">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">省市区：</label>

                        <div class="col-sm-8">
                            <input name="sendArea" type="text" class="form-control" placeholder="请填写正确的省市区"
                                   ng-model="orderdata.sendArea">

                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword" class="col-sm-3 control-label"><b>*</b>详细地址：</label>

                        <div class="col-sm-8">
                            <input name="sendAddress" type="text" class="form-control" placeholder="街道详细（精确到门牌号） "
                                   ng-model="orderdata.sendAddress" required="required">

                        </div>
                    </div>

                </div>

            </form>
        </div>
        <div class="col-md-7"></div>
    </div>

    <div class="partline clearfix"></div>

    <div class="daoru">
        <p>
            <a data-target="#" class="btn btn-default" data-toggle="modal" data-target="#ExcelModal">导入Excel</a>
            <a data-target="#" class="btn btn-default">从地址薄导入</a>
            <input type="button" onclick="Click()" value="下载Excel" class="btn btn-danger">
        </p>

    </div>
    <!--导入excel-->

    <div class="modal fade" id="ExcelModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span
                            aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title" id="myModalLabel"><strong>导入Excel模板</strong></h4>
                </div>
                <div class="modal-body" ng-controller="orderCtrl" nv-file-drop="" uploader="uploader"
                     filters="queueLimit, customFilter">
                    <center><img src="images/icon/xlsLogo.png" class="img-responsive"></center>
                    <div class="row excel">

                        <div class="col-md-6">
                            <input type="file" nv-file-select="" uploader="uploader"/>
                        </div>

                        <div class="col-md-6">

                            <div>
                                <span style="float:left">上传进度:</span>
                                <div class="progress" style="">
                                    <div class="progress-bar" role="progressbar"
                                         ng-style="{ 'width': uploader.progress + '%' }"></div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success btn-s" ng-click="uploader.uploadAll()"
                                ng-disabled="!uploader.getNotUploadedItems().length">
                            <span class="glyphicon glyphicon-upload"></span> 上传
                        </button>

                        <button type="button" class="btn btn-danger btn-s" ng-click="uploader.clearQueue()"
                                ng-disabled="!uploader.queue.length">
                            <span class="glyphicon glyphicon-trash"></span> 删除
                        </button>

                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary">确定</button>
                </div>
            </div>
        </div>
    </div>

    <div class="searchset">
        <form class="form-inline">
            <div class="form-group">

                <div class="input-group">

                    <input type="text" class="form-control" id="exampleInputAmount" placeholder="请输入姓名/电话/地址">
                    <div class="input-group-addon btn btn-danger">搜索</div>
                </div>
            </div>
            <input type="checkbox"/><span class="typetext">只显示错误信息</span>
        </form>
        <div class="setbtn">
            <a href="#" class="btn btn-danger">批量设置</a>
            <a href="#" class="btn btn-default">删除</a>
        </div>

    </div>

    <!--piliang-->
    <table class="table table-striped clearfix">

        <tr>
            <td><input type="checkbox"/>　收件人姓名</td>
            <td>收件人联系电话</td>
            <td>收件人公司</td>
            <td>省</td>
            <td>市</td>
            <td>区</td>
            <td>详细地址</td>
        </tr>
    </table>

</div>

<div class="col-md-11 submit">
    <div class="xieyi"><input type="checkbox" checked="checked"/>我已阅读并同意《快件运单契约条款》</div>
    <div class="tijiao">
        <div class="tjtext">
            <p class="red">1、如果您在周六、日等法定节假日期间寄件，将会做相应加时。（以上“预计时效”已做相应加时）</p>
            <p class="red">2、如果您收方地址属于偏远地区，在“预计时效”基础上需增加0.5天.</p>
        </div>

    </div>

</div>
<div class="col-md-1 ordertj">
    <a href="javascript:$('#orderForm').submit();" class="btn btn-danger">提交</a>
</div>
</div>
</section>
</div>
<script src="js/self/city-picker.data.js"></script>
<script src="js/self/city-picker.js"></script>
<script src="js/angular-file-upload.min.js"></script>
<script src="js/console-sham.min.js"></script>
<script src="js/self/controllers.js"></script>
<script src="js/self/main.js"></script>
<script src="js/self/effect.js"></script>
<script>
    function Click() {
        $('a[rel*=downloadr]').downloadr()
    }

    $().ready(function () {
        $("#reset").click(function () {
            $("#sendAreaInfo").citypicker('reset');
        });
        $("#reset2").click(function () {
            $("#recAreaInfo").citypicker('reset');
        })
    })

    // 百度地图API功能
    function G(id) {
        return document.getElementById(id);
    }

    /**寄件人*/
    var ac = new BMap.Autocomplete( //建立一个自动完成的对象
        {
            "input": "sendAddress"
        });

    ac.addEventListener("onhighlight", function (e) { //鼠标放在下拉列表上的事件
        var str = "";
        var _value = e.fromitem.value;
        var value = "";
        if (e.fromitem.index > -1) {
            value = _value.province + _value.city + _value.district + _value.street + _value.business;
        }
        str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;

        value = "";
        if (e.toitem.index > -1) {
            _value = e.toitem.value;
            value = _value.province + _value.city + _value.district + _value.street + _value.business;
        }
        str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
        G("searchResultPanel").innerHTML = str;
    });

    var myValue;
    ac.addEventListener("onconfirm", function (e) { //鼠标点击下拉列表后的事件
        var _value = e.item.value;
        myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
        G("searchResultPanel").innerHTML = "onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
        // 使用地址，查询省市区的信息
        myValue = encodeURIComponent(myValue, "UTF-8");
        $.getJSON("http://api.map.baidu.com/cloudgc/v1?address=" + myValue + "&ak=rQdNKQPGtCNWSc92KGRjlsjX6ZjdM4PA&callback=?", {}, function (data) {
            // alert(data.result[0].address_components.province+"     "+data.result[0].address_components.city+"    "+data.result[0].address_components.district);
            $("#sendAreaInfo").citypicker("reset");
            $("#sendAreaInfo").citypicker("destroy");
            $("#sendAreaInfo").citypicker({
                province: data.result[0].address_components.province,
                city: data.result[0].address_components.city,
                district: data.result[0].address_components.district
            });
        })
    });

    /**收件人*/
    var ac = new BMap.Autocomplete( //建立一个自动完成的对象
        {
            "input": "recAddress"
        });

    ac.addEventListener("onhighlight", function (e) { //鼠标放在下拉列表上的事件
        var str = "";
        var _value = e.fromitem.value;
        var value = "";
        if (e.fromitem.index > -1) {
            value = _value.province + _value.city + _value.district + _value.street + _value.business;
        }
        str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;

        value = "";
        if (e.toitem.index > -1) {
            _value = e.toitem.value;
            value = _value.province + _value.city + _value.district + _value.street + _value.business;
        }
        str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
        G("searchResultPanel1").innerHTML = str;
    });

    var myValue;
    ac.addEventListener("onconfirm", function (e) { //鼠标点击下拉列表后的事件
        var _value = e.item.value;
        myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
        // alert(myValue);
        G("searchResultPanel1").innerHTML = "onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
        // 使用地址，查询省市区的信息
        myValue = encodeURIComponent(myValue, "UTF-8");
        $.getJSON("http://api.map.baidu.com/cloudgc/v1?address=" + myValue + "&ak=rQdNKQPGtCNWSc92KGRjlsjX6ZjdM4PA&callback=?", {}, function (data) {
            // alert(data.result[0].address_components.province+"     "+data.result[0].address_components.city+"    "+data.result[0].address_components.district);
            $("#recAreaInfo").citypicker("reset");
            $("#recAreaInfo").citypicker("destroy");
            $("#recAreaInfo").citypicker({
                province: data.result[0].address_components.province,
                city: data.result[0].address_components.city,
                district: data.result[0].address_components.district
            });
        })
    });
</script>