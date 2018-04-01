<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>添加宣传任务</title>
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="../../js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="../../css/default.css">
		<script type="text/javascript" src="../../js/easyui/jquery.easyui.min.js"></script>
		<script src="../../js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
	
		<!--添加kindEditor文本编辑器-->
		<script type="text/javascript" src="../../editor/kindeditor.js" ></script>
		<script type="text/javascript" src="../../editor/lang/zh_CN.js" ></script>
		<link rel="stylesheet" href="../../editor/themes/default/default.css" />
		<script type="text/javascript">
			$(function(){
				$("body").css({visibility:"visible"});
				$("#back").click(function(){
					location.href = "promotion.jsp";
				});
				// 点击保存
				$("#save").click(function(){
					if($("#promotionForm").form("validate")){
						editor.sync();
						$("#promotionForm").submit();
					}
					else{
						$.messager.alert("警告","表单校验有误！","warning");
					}
				})
				// 添加文本编辑器
				KindEditor.ready(function(K) {
		            window.editor = K.create('#description',{
		            	items:[
						        'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'template', 'code', 'cut', 'copy', 'paste',
						        'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
						        'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
						        'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
						        'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
						        'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
						        'flash', 'media', 'insertfile', 'table', 'hr', 'emoticons', 'baidumap', 'pagebreak',
						        'anchor', 'link', 'unlink', '|'
						],
						uploadJson:"../upload_json.jsp",   // 文件上传
						fileManagerJson:"../file_manager_json.jsp",   // 文件管理
						//uploadJson:"../../image_upload.action",   // 文件上传
						//fileManagerJson:"../../image_fileManager.action",   // 文件管理
						allowFileManager:true
		            });
		        });
			});
		</script>
	</head>
	<body class="easyui-layout" style="visibility:hidden;">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				<a id="back" icon="icon-back" href="#" class="easyui-linkbutton" plain="true">返回列表</a>
			</div>
		</div>
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="promotionForm" enctype="multipart/form-data" method="post" action="../../promotion_save.action">
				<table class="table-edit" width="95%" align="center">
					<tr class="title">
						<td colspan="4">宣传任务</td>
					</tr>
					<tr>
						<td>宣传概要(标题):</td>
						<td colspan="3">
							<input type="text" name="title" id="title" class="easyui-validatebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>活动范围:</td>
						<td>
							<input type="text" name="activeScope" id="activeScope" class="easyui-validatebox" />
						</td>
						<td>宣传图片:</td>
						<td>
							<input type="file" name="titleImgFile" id="titleImg" class="easyui-validatebox" required="true"/>
						</td>
					</tr>
					<tr>
						<td>发布时间: </td>
						<td>
							<input type="text" name="startDate" id="startDate" class="easyui-datebox" required="true" />
						</td>
						<td>失效时间: </td>
						<td>
							<input type="text" name="endDate" id="endDate" class="easyui-datebox" required="true" />
						</td>
					</tr>
					<tr>
						<td>宣传内容(活动描述信息):</td>
						<td colspan="3">
							<textarea id="description" name="description" style="width:80%" rows="20"></textarea>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>
