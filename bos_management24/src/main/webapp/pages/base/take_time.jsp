<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>收派时间管理</title>
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
        $(function () {
            // 先将body隐藏，再显示，不会出现页面刷新效果
            $("body").css({visibility: "visible"});

            // 收派时间管理信息表格
            $('#grid').datagrid({
                iconCls: 'icon-forward',
                fit: true,
                border: false,
                rownumbers: true,
                striped: true,
                pageList: [30, 50, 100],
                pagination: true,
                toolbar: toolbar,
                url: "../../taketime_pageQuery.action",
                idField: 'id',
                columns: columns
            });
        });

        //工具栏
        var toolbar = [{
            id: 'button-add',
            text: '增加',
            iconCls: 'icon-add',
            handler: function () {
                $("#taketimeForm").form("clear");
                $('#taketimeWindow').window('open');

                $("input[name='name']").validatebox({
                    validType: "remote['../../taketime_validateName.action','name']'," // 设置校验
                });
                $("input[name='name']").attr("readonly",false);
            }
        }, {
            id: 'button-edit',
            text: '修改',
            iconCls: 'icon-edit',
            handler: function () {
                var rows = $("#grid").datagrid("getSelections");
                if (rows.length != 1) {
                    $.messager.alert("警告", "编辑的操作只能选择一条记录", "warning");
                    return;
                }

                $("#taketimeForm").form("load", rows[0]);
                $("input[name='name']").validatebox({
                    validType: ""
                });
                $("input[name='name']").attr("readonly", true);

                $('#taketimeWindow').window('open');
            }
        }, {
            id: 'button-delete',
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function () {
                var rows = $("#grid").datagrid("getSelections");
                if (rows == null || rows.length == 0) {
                    $.messager.alert("警告", "请选择要删除的记录", "warning");
                    return;
                } else {
                    $.messager.confirm('确认对话框', '您确实要删除这些记录吗？', function (r) {
                        if (r) {
                            var ids;
                            var array = new Array();
                            for (var i = 0; i < rows.length; i++) {
                                var row = rows[i];
                                array.push(row.id);
                            }
                            ids = array.join(",");

                            window.location.href = "../../taketime_delete.action?ids=" + ids;
                        }
                    });
                }
            }
        }];

        // 定义列
        var columns = [[{
            field: 'id',
            checkbox: true,
        }, {
            field: 'name',
            title: '时间名称',
            width: 120,
            align: 'center'
        }, {
            field: 'normalWorkTime',
            title: '平时上班时间',
            width: 120,
            align: 'center'
        }, {
            field: 'normalDutyTime',
            title: '平时休息时间',
            width: 120,
            align: 'center'
        }, {
            field: 'satWorkTime',
            title: '周六上班时间',
            width: 120,
            align: 'center'
        }, {
            field: 'satDutyTime',
            title: '周六休息时间',
            width: 120,
            align: 'center'
        }, {
            field: 'sunWorkTime',
            title: '周日上班时间',
            width: 120,
            align: 'center'
        }, {
            field: 'sunDutyTime',
            title: '周日休息时间',
            width: 120,
            align: 'center'
        }, {
            field: 'status',
            title: '状态',
            width: 120,
            align: 'center',
            formatter: function (data, row, index) {
                if (row.status != '1') {
                    return '正常使用';
                } else {
                    return '已作废';
                }
            }
        }, {
            field: 'company',
            title: '所属单位',
            width: 120,
            align: 'center'
        }, {
            field: 'operator',
            title: '操作人',
            width: 120,
            align: 'center'
        }, {
            field: 'operatingTime',
            title: '操作时间',
            width: 120,
            align: 'center',
            formatter: function (data, row, index) {
                if (row.operatingTime) {
                    return ('' + row.operatingTime).replace('T', ' ');
                } else {
                    return '';
                }
            }
        }, {
            field: 'operatingCompany',
            title: '操作单位',
            width: 120,
            align: 'center'
        }]];

        $(function () {

            // 点击保存按钮
            $("#save").click(function () {
                var flag = false;
                if ($("#taketimeForm").form("validate")) {
                    var f1 = $('input[name=normalWorkTime]').val() < $('input[name=normalDutyTime]').val();
                    var f2 = $('input[name=satWorkTime]').val() < $('input[name=satDutyTime]').val();
                    var f3 = $('input[name=sunWorkTime]').val() < $('input[name=sunDutyTime]').val();
                    if (f1 && f2 && f3) {
                        flag = true;
                    }
                }

                if (flag) {
                    $("#taketimeForm").submit();
                } else {
                    $.messager.alert("警告", "表单验证有误！", "warning");
                }
            });
        });


	</script>
</head>
<body class="easyui-layout" style="visibility:hidden;">
<div region="center" border="false">
	<table id="grid"></table>
</div>

<div class="easyui-window" title="对收派时间进行添加或者修改" id="taketimeWindow" collapsible="false" minimizable="false"
	 maximizable="false" modal="true" closed="true" style="width:700px;top:150px;left:500px">
	<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
		<div class="datagrid-toolbar">
			<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
		</div>
	</div>

	<div region="center" style="overflow:auto;padding:5px;" border="false">
		<form id="taketimeForm" action="../../taketime_save.action" method="post">
			<table class="table-edit" width="80%" align="center">
				<tr class="title">
					<td colspan="2">收派时间信息
						<!--提供隐藏域 装载id -->
						<input type="hidden" name="id"/>
					</td>
				</tr>
				<tr>
					<td>收派时间名称</td>
					<td>
						<input name="name" type="text" class="easyui-validatebox"
							   validtype="remote['../../taketime_validateName.action','name']" required="true"
							   invalidMessage="收派标准时间已存在"/>
					</td>
				</tr>
				<tr>
					<td>平时上班时间</td>
					<td>
						<input type="text" name="normalWorkTime"
							   class="easyui-datetimebox" required="true"/>
					</td>
					<td>平时休息时间</td>
					<td>
						<input type="text" name="normalDutyTime" class="easyui-datetimebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>周六上班时间</td>
					<td>
						<input type="text" name="satWorkTime"
							   class="easyui-datetimebox" required="true"/>
					</td>
					<td>周六休息时间</td>
					<td>
						<input type="text" name="satDutyTime" class="easyui-datetimebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>周日上班时间</td>
					<td>
						<input type="text" name="sunWorkTime"
							   class="easyui-datetimebox" required="true"/>
					</td>
					<td>周日休息时间</td>
					<td>
						<input type="text" name="sunDutyTime" class="easyui-datetimebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>所属公司</td>
					<td>
						<input type="text" name="company" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>操作单位</td>
					<td>
						<input type="text" name="operatingCompany" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
</body>
</html>
