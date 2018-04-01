<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>班车管理</title>
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

            // 班车信息表格
            $('#grid').datagrid({
                iconCls: 'icon-forward',
                fit: true,
                border: false,
                rownumbers: true,
                striped: true,
                pageList: [30, 50, 100],
                pagination: true,
                toolbar: toolbar,
                url: "../../vehicle_pageQuery.action",
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
                $("#vehicleForm").form("clear");
                $('#vehicleWindow').window('open');
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
                // 将数据表格中的json数据，回显到standardForm表单中。
                $("#vehicleForm").form("load", rows[0]);

                $('#vehicleWindow').window('open');
            }
        }, {
            id: 'button-delete',
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function () {
                var rows = $("#grid").datagrid("getSelections");
                if (rows == null || rows.length==0) {
                    $.messager.alert("警告", "请选择要删除的记录", "warning");
                    return;
                }else {
                    $.messager.confirm('确认对话框', '您确实要删除这些记录吗？', function(r){
                        if (r){
                            var ids;
                            var array = new Array();
                            for(var i=0;i<rows.length;i++){
                                var row = rows[i];
                                array.push(row.id);
                            }
                            ids = array.join(",");

                            window.location.href = "../../vehicle_delete.action?ids="+ids;
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
            field: 'routeType',
            title: '线路类型',
            width: 120,
            align: 'center'
        }, {
            field: 'routeName',
            title: '线路名称',
            width: 120,
            align: 'center'
        }, {
            field: 'vehicleNum',
            title: '车牌号',
            width: 120,
            align: 'center'
        }, {
            field: 'shipper',
            title: '承运商',
            width: 120,
            align: 'center'
        }, {
            field: 'driver',
            title: '司机',
            width: 120,
            align: 'center'
        }, {
            field: 'telephone',
            title: '电话',
            width: 120,
            align: 'center'
        }, {
            field: 'vehicleType',
            title: '车型',
            width: 120,
            align: 'center'
        }, {
            field: 'ton',
            title: '吨控',
            width: 120,
            align: 'center'
        }, {
            field: 'remark',
            title: '备注',
            width: 120,
            align: 'center'
        }]];

        $(function () {
            // 点击保存按钮
            $("#save").click(function () {
                var flag = false;
                if ($("#vehicleForm").form("validate")) {
                    flag = true;
                }

                if (flag) {
                    $("#vehicleForm").submit();
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

<div class="easyui-window" title="对班车信息进行添加或者修改" id="vehicleWindow" collapsible="false" minimizable="false"
	 maximizable="false" modal="true" closed="true" style="width:600px;top:150px;left:500px">
	<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
		<div class="datagrid-toolbar">
			<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
		</div>
	</div>

	<div region="center" style="overflow:auto;padding:5px;" border="false">

		<form id="vehicleForm" action="../../vehicle_save.action" method="post">
			<table class="table-edit" width="80%" align="center">
				<tr class="title">
					<td colspan="2">班车信息
						<input type="hidden" name="id"/>
					</td>
				</tr>
				<tr>
					<td>线路类型</td>
					<td>
						<input type="text" name="routeType" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>线路名称</td>
					<td>
						<input type="text" name="routeName" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>承运商</td>
					<td>
						<input type="text" name="shipper" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>司机</td>
					<td>
						<input type="text" name="driver" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>车牌号</td>
					<td>
						<input type="text" name="vehicleNum" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>电话</td>
					<td>
						<input type="text" name="telephone" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>车型</td>
					<td>
						<input type="text" name="vehicleType" class="easyui-validatebox" required="true"/>
					</td>
				</tr>
				<tr>
					<td>吨控</td>
					<td>
						<input type="text" name="ton" class="easyui-numberbox" required="true"/>吨
					</td>
				</tr>
				<tr>
					<td>备注</td>
					<td>
						<textarea name="remark" id="" cols="50" rows="5"></textarea>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>

</body>
</html>
