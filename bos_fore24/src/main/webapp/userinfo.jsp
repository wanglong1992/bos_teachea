<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!--
描述：账户管理
-->
<link rel="stylesheet" type="text/css" href="css/styleuserinfo.css">
<script src="js/self/addressadd.js"></script>
<script src="js/jquery.min.js"></script>
<script>
    $(function () {
        //alert("嘿");
        //查询客户详细信息
        $.post("./customer_findById.action",
            {"id":${customer.id}},
            function (data) {
                //隐藏域赋值
                $('#id').val(data.id);
                $('#username').val(data.username).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#company').val(data.company).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#birthday').val(data.birthday).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#department').val(data.department).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#sex').val(data.sex).attr("disabled", "disabled").css("background-color", "#EEEEEE");
                $('#position').val(data.position).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#mobilePhone').val(data.mobilePhone).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#telephone').val(data.telephone).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#email').val(data.email).attr("readonly", true).css("background-color", "#EEEEEE");
                $('#address').val(data.address).attr("readonly", true).css("background-color", "#EEEEEE");
                //显示图片
                $('img').attr("src", data.headImg);
                //background-color: #EEEEEE;" disabled="disabled"
            })

        $('#edit').click(function () {
            $('#username').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#company').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#birthday').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#department').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#sex').attr("disabled", false).css("background-color", "#FFFFFF");
            $('#position').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#mobilePhone').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#telephone').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#email').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#address').attr("readonly", false).css("background-color", "#FFFFFF");
            $('#uploadimg').css("display", "");
            $('#schema').css("display", "");
            $('#edit').css("display", "none");
            $('#save').css("display", "");
        })

        $('#save').click(function () {
            $('#updateForm').submit();
            $.messager.alert("messager", ${msg})

        })
    })
</script>
<div class="userinfo" ng-app="userInfoModule">
    <div class="container">
        <div class="col-md-2 tab-title ">
            <h4 class="accounttitle">账号管理</h4>
            <ul class="nav nav-tab vertical-tab" role="tablist" id="vtab">
                <li role="presentation" class="pieceorder  active">
                    <a data-target="#aa" aria-controls="aa" role="tab" data-toggle="tab">个人信息</a>
                </li>

                <li role="presentation" class="pieceorder">
                    <a data-target="#bb" aria-controls="bb" role="tab" data-toggle="tab">地址薄</a>
                </li>
                <li role="presentation" class="pieceorder">
                    <a data-target="#cc" aria-controls="cc" role="tab" data-toggle="tab">账号绑定</a>
                </li>
                <li role="presentation" class="pieceorder">
                    <a data-target="#dd" aria-controls="dd" role="tab" data-toggle="tab">我的积分</a>
                </li>
                <li role="presentation" class="pieceorder">
                    <a data-target="#ee" aria-controls="ee" role="tab" data-toggle="tab">我的优惠券</a>
                </li>

                <li role="presentation" class="pieceorder">
                    <a data-target="#ff" aria-controls="ff" role="tab" data-toggle="tab">打印设置</a>
                </li>
                <li role="presentation" class="pieceorder">
                    <a data-target="#gg" aria-controls="gg" role="tab" data-toggle="tab">我的月结卡</a>
                </li>
            </ul>
        </div>
        <!-- Tab panes -->
        <div class="col-md-10 tabcontent">
            <div class="tab-content vertical-tab-content">
                <!--个人信息-->
                <div role="tabpanel" class="tab-pane active" id="aa">
                    <div class="areatitle">
                        <h4><span class="title">基本资料</span></h4>
                    </div>
                    <div class="info">
                        <form id="updateForm" enctype="multipart/form-data" action="./customer_update.action"
                              method="post">
                            <div class="col-md-8">
                                <table class="table ">
                                    <tr>
                                        <input type="hidden" name="id" id="id"/>
                                        <td>姓名：<input type="text" name="username" id="username" required="true"
                                                      style="width:200px"/></td>
                                        <td>公司：<input type="text" name="company" id="company" required="true"
                                                      style="width:200px"/></td>
                                    </tr>
                                    <tr>
                                        <td>生日：<input type="text" name="birthday" id="birthday" required="true"
                                                      style="width:200px"/></td>
                                        <td>部门：<input type="text" name="department" id="department" required="true"
                                                      style="width:200px"/></td>
                                    </tr>
                                    <tr>
                                        <td>性别：<select class="easyui-combobox" name="sex" id="sex" style="width:200px">
                                            <option value="1">男</option>
                                            <option value="0">女</option>
                                            <option value="2">娚</option>
                                        </select>
                                        </td>
                                        <td>职位：<input type="text" name="position" id="position" required="true"
                                                      style="width:200px"/></td>
                                    </tr>
                                    <tr>
                                        <td>座机：<input type="text" name="mobilePhone" id="mobilePhone" required="true"
                                                      style="width:200px"/></td>
                                        <td>手机：<input type="text" name="telephone" id="telephone" required="true"
                                                      style="width:200px"/></td>
                                    </tr>
                                    <tr>
                                        <td>Emial：<input type="text" name="email" id="email" required="true"
                                                         style="width:200px"/></td>
                                        <td>地址：<input type="text" name="address" id="address" required="true"
                                                      style="width:200px"/></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-4">
                                <p>个人头像：<span class="right"><a href="javascript:;" id="edit">编辑</a><a
                                        href="javascript:;" style="display:none" id="save">保存</a></span>

                                </p>

                                <div class="text-center">
                                    <img src="" class="img-responsive" align="我的头像"/>
                                    <input type="file" name="titleImgFile" id="titleImg" class="easyui-validatebox"
                                           required="true" style="display:none"/>
                                    <input type='button' id="uploadimg" style="display:none" value='上传图片'
                                           onClick='javascript:$("#titleImg").click();'/>
                                    <p class="text-center" id="schema" style="display:none">您需要上传200x200以上且小于1M的
                                        JPG格式的图片
                                    </p>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="areatitle clearfix">
                        <h4><span class="title">验证信息</span></h4>
                    </div>
                    <div class="col-md-8">
                        <div class="info">
                            <p>手机号码 15210740955<span class="right"><a href="#">修改</a></span></p>
                            <p>邮箱地址 您尚未绑定油箱<span class="right"><a href="#">立即绑定</a></span></p>

                        </div>
                    </div>

                    <div class="areatitle clearfix">
                        <h4><span class="title">密码设置</span></h4>
                    </div>
                    <div class="info">
                        <p>
                            <a href="#">修改密码</a>
                        </p>
                        <p>登录后修改您的速运账号密码</p>
                        <p>
                            <a href="#">找回密码</a>
                        </p>
                        <p>如果您忘记了密码，可以通过密保邮箱找回密码。</p>
                    </div>

                </div>

                <!--地址薄-->
                <div role="tabpanel" class="tab-pane" id="bb">
                    <!-- 页面tab -->
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active">
                            <a data-target="#home" role="tab" data-toggle="tab">我的地址</a>
                        </li>
                        <li role="presentation">
                            <a data-target="#profile" role="tab" data-toggle="tab">常用地址</a>
                        </li>

                    </ul>
                    <!-- Tab panes -->
                    <div class="tab-content" ng-controller="userInfoCtrl">
                        <div class="fixedbtn">
                            <div class="col-md-4 btnaddress">
                                <button class="btn btn-default">删除</button>
                                <button class="btn btn-default">导出</button>
                                <button type="button" class="btn btn-default " data-toggle="modal"
                                        data-target="#myModal">添加
                                </button>

                                <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                                     aria-labelledby="myModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <button type="button" class="close" data-dismiss="modal"><span
                                                        aria-hidden="true">&times;</span><span
                                                        class="sr-only">Close</span></button>
                                                <h4 class="modal-title" id="myModalLabel">添加地址薄</h4>
                                            </div>
                                            <div class="modal-body">
                                                <form class="form-horizontal" role="form">

                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label"><b>*</b>　姓名：</label>
                                                        <div class="col-sm-8">
                                                            <input name="username" type="text" class="form-control"
                                                                   placeholder="请输入发件人姓名" ng-model="userInfo.username"
                                                                   required="required">
                                                        </div>
                                                    </div>
                                                    <div class="form-group" id="mobile-group">
                                                        <label class="col-sm-3 control-label"><b>*</b> 联系方式：</label>
                                                        <div class="col-sm-8">
                                                            <input name="mobile" type="text" class="form-control"
                                                                   placeholder="请输入联系电话" ng-model="userInfo.mobile"
                                                                   required="required">
                                                        </div>
                                                    </div>
                                                    <div class="form-group" id="sendcompany-group">
                                                        <label class="col-sm-3 control-label"> 寄件公司：</label>
                                                        <div class="col-sm-8">
                                                            <input name="company" type="text" class="form-control"
                                                                   placeholder="请输入寄件公司" ng-model="userInfo.company">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label"><b>*</b> 省市区：</label>
                                                        <div class="col-sm-8">
                                                            <input name="province" type="text" class="form-control"
                                                                   placeholder="请填写正确的省市区" ng-model="userInfo.province">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="inputPassword"
                                                               class="col-sm-3 control-label"><b>*</b> 详细地址：</label>
                                                        <div class="col-sm-8">
                                                            <input name="address" type="text" class="form-control"
                                                                   placeholder="街道详细（精确到门牌号） "
                                                                   ng-model="userInfo.address" required="required">
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <div class="form-group">
                                                    <div class="col-md-offset-2 col-md-10">
                                                        <button type="button" class="btn btn-default"
                                                                data-dismiss="modal" ng-click="getFormData()">确定
                                                        </button>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!--查询-->
                            <div class="col-md-8">
                                <form class=" form-inline">
                                    <div class="form-group">
                                        <label class="sr-only" for="exampleInputAmount">Amount (in dollars)</label>
                                        <div class="input-group">

                                            <input type="text" class="form-control" id="exampleInputAmount"
                                                   placeholder="姓名/电话/地址">
                                            <div class="input-group-addon">查询</div>
                                        </div>
                                    </div>

                                </form>
                            </div>
                            <div class="clearfix"></div>

                        </div>

                        <div role="tabpanel" class="tab-pane fade in active" id="home">
                            <div class="addresstable">
                                <table class="table table-striped table-bordered">
                                    <thead>
                                    <th><input type="checkbox"/>　姓名</th>
                                    <th>联系方式</th>
                                    <th>公司</th>
                                    <th>地址</th>
                                    <th class="">操作</th>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><input type="checkbox">　<input type="hidden" name="id" value="">小王</td>
                                        <td>13112589764</td>
                                        <td>北京市传智播客</td>
                                        <td>中关村软件园</td>
                                        <td>
                                            <a href="#">设为默认</a>
                                        </td>
                                    </tr>
                                    </tbody>

                                </table>

                            </div>

                        </div>
                        <div role="tabpanel" class="tab-pane fade" id="profile">

                            <div class="addresstable">
                                <table class="table table-striped">
                                    <tr>
                                        <td><input type="checkbox"/>　姓名</td>
                                        <td>联系方式</td>
                                        <td>公司</td>
                                        <td>地址</td>

                                        <td class="">操作</td>
                                    </tr>
                                </table>
                                <table class="table table-bordered table-striped" id="expresscontent">

                                </table>

                            </div>

                        </div>

                    </div>

                </div>

                <!--账号绑定-->
                <div role="tabpanel" class="tab-pane" id="cc">账号绑定</div>
                <!--我的积分-->
                <div role="tabpanel" class="tab-pane" id="dd">我的积分</div>
                <!--我的优惠券-->
                <div role="tabpanel" class="tab-pane" id="ee">我的优惠券</div>
                <!--打印设置-->
                <div role="tabpanel" class="tab-pane" id="ff">打印设置</div>
                <!--我的月结卡-->
                <div role="tabpanel" class="tab-pane" id="gg">我的月结卡</div>
            </div>
        </div>
    </div>
</div>