<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>儿童成长项目页面</title>
<link rel="stylesheet" href="css/style.default.css" type="text/css" />
<script type="text/javascript" src="js/plugins/jquery-1.7.min.js"></script>
<script type="text/javascript"
	src="js/plugins/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="js/plugins/jquery.cookie.js"></script>
<script type="text/javascript" src="js/plugins/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="js/plugins/jquery.uniform.min.js"></script>
<script type="text/javascript" src="js/custom/general.js"></script>
<script type="text/javascript" src="js/custom/tables.js"></script>
<!--[if IE 9]>
    <link rel="stylesheet" media="screen" href="css/style.ie9.css"/>
<![endif]-->
<!--[if IE 8]>
    <link rel="stylesheet" media="screen" href="css/style.ie8.css"/>
<![endif]-->
<!--[if lt IE 9]>
	<script src="js/plugins/css3-mediaqueries.js"></script>
<![endif]-->
</head>

<body class="withvernav">
	<div class="bodywrapper">
		<div class="topheader">
			<div class="left">
				<h1 class="logo">
					益帮人.<span>Admin</span>
				</h1>
				<span class="slogan">后台管理系统</span>

				<div class="search">
					<form action="" method="post">
						<input type="text" name="keyword" id="keyword" value="请输入" />
						<button class="submitbutton"></button>
					</form>
				</div>
				<!--search-->
				<br clear="all" />
			</div>
			<!--left-->

			<div class="right">
				<!--<div class="notification">
                <a class="count" href="ajax/notifications.html"><span>9</span></a>
        	</div>-->
				<div class="userinfo">
					<img src="images/thumbs/logo.png" style="width: 30px; heith: 23px;"
						alt="" /> <span>管理员</span>
				</div>
				<!--userinfo-->

				<div class="userinfodrop">
					<div class="avatar">
						<img height=110px width=100px src="images/thumbs/logo.png" alt="" />
						<div class="changetheme">
							切换主题: <br /> <a class="default"></a> <a class="blueline"></a> <a
								class="greenline"></a> <a class="contrast"></a> <a
								class="custombg"></a>
						</div>
					</div>
					<!--avatar-->
					<div class="userdata">
						<h4>Citier</h4>
						<span class="email">420625682@qq.com</span>
						<ul>
							<li><a href="EditProfile.php">编辑资料</a></li>
							<li><a href="SetAccount.php">账号设置</a></li>
							<li><a href="HelpPage.php">帮助</a></li>
							<li><a href="index.php">退出</a></li>
						</ul>
					</div>
					<!--userdata-->
				</div>
				<!--userinfodrop-->
			</div>
			<!--right-->
		</div>
		<!--topheader-->

		<div class="header">
			<ul class="headermenu">
				<li class="current"><a href="dashboard.php"><span
						class="icon icon-flatscreen"></span>首页</a></li>
			</ul>
		</div>
		<!--header-->

		<div class="vernav2 iconmenu">
			<ul>
				<li><a href="#formsub" class="editor">审核管理</a> <span class="arrow"></span>
					<ul id="formsub">
					     <?php
                         require_once "sqlTool.php";
                         $sqltool = new sqlTool();
                         $sql = "SELECT * FROM user where AuthenticationRequest = 1";
                         $result = $sqltool->excute_dql($sql);
                         $num = mysql_num_rows($result);                        
                        ?>                        
						<li><a href="ExamineAccount.php">认证用户(<?php echo $num;?>)</a></li>
						
						<?php
                         require_once "sqlTool.php";
                         $sqltool = new sqlTool();
                         $sql = "SELECT * FROM project where ProjectRequest = 1";
                         $result = $sqltool->excute_dql($sql);
                         $num = mysql_num_rows($result);                         
                        ?>                       
						<li><a href="ExamineHelpProject.php">项目求助(<?php echo $num;?>)</a></li>
						
						<?php
                         require_once "sqlTool.php";
                         $sqltool = new sqlTool();
                         $sql = "SELECT * FROM withdraw where WithdrawRequest = 1";
                         $result = $sqltool->excute_dql($sql);
                         $num = mysql_num_rows($result);                         
                        ?>
						<li><a href="ExamineWithdraw.php">申请提款(<?php echo $num;?>)</a></li>
					</ul></li>
				<li><a href="VerifyProject.php" class="elements">投诉管理</a></li>
				<li><a href="#error" class="error">用户管理</a> <span class="arrow"></span>
					<ul id="error">
						<li><a href="CheckNormalAccount.php">普通注册用户</a></li>
						<li><a href="CheckVerifiedAccount.php">认证用户</a></li>
						<li><a href="CheckInactiveAccount.php">冻结用户</a></li>
					</ul></li>
				<li><a href="#addons" class="addons">项目管理</a> <span class="arrow"></span>
					<ul id="addons">
						<li><a href="CheckStudyProject.php">支教助学</a></li>
						<li><a href="CheckChildProject.php">儿童成长</a></li>
						<li><a href="CheckMedicalProject.php">医疗救助</a></li>
						<li><a href="CheckAnimalProject.php">动物保护</a></li>
						<li><a href="CheckEnvironmentProject.php">环境保护</a></li>
						<li><a href="CheckOtherProject.php">其他</a></li>
					</ul></li>
			</ul>
			<a class="togglemenu"></a> <br /> <br />
		</div>
		<!--leftmenu-->

		<div class="centercontent tables">

			<div class="pageheader notab">
				<h1 class="pagetitle">儿童成长类型</h1>
			</div>
			<!--pageheader-->

			<div id="contentwrapper" class="contentwrapper">
				<!--contenttitle-->
				<table cellpadding="0" cellspacing="0" border="0" class="stdtable"
					id="dyntable2">
					<colgroup>
						<col class="con0" style="width: 4%" />
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
					</colgroup>
					<thead>
						<tr>
							<th class="head0 nosort"><input type="checkbox" /></th>
							<th class="head0">项目名称</th>
							<th class="head1">求助人账号</th>
							<th class="head0">求助金额</th>
							<th class="head1">已捐金额</th>
							<th class="head0">截止日期</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th class="head0"><span class="center"> <input
									type="checkbox" />
							</span></th>
							<th class="head0">项目名称</th>
							<th class="head1">求助人账号</th>
							<th class="head0">求助金额</th>
							<th class="head1">已捐金额</th>
							<th class="head0">截止日期</th>
						</tr>
					</tfoot>
					<tbody>
						<tr class="gradeX">
							<td align="center"><span class="center"> <input
									type="checkbox" />
							</span></td>
							<td>单亲留守少年</td>
							<td>420516528@qq.com</td>
							<td>1000</td>
							<td class="center">100</td>
							<td class="center">2015-8-1</td>
						</tr>
						<tr class="gradeX">
							<td align="center"><span class="center"> <input
									type="checkbox" />
							</span></td>
							<td>乡村儿童的音乐梦</td>
							<td>51462515124@qq.com</td>
							<td>1000</td>
							<td class="center">100</td>
							<td class="center">2015-8-1</td>
						</tr>
						<tr class="gradeX">
							<td align="center"><span class="center"> <input
									type="checkbox" />
							</span></td>
							<td>乡村儿童的求学梦</td>
							<td>251485415@qq.com</td>
							<td>13000</td>
							<td class="center">1300</td>
							<td class="center">2015-8-1</td>
						</tr>
						<tr class="gradeX">
							<td align="center"><span class="center"> <input
									type="checkbox" />
							</span></td>
							<td>白血病男孩的求学梦</td>
							<td>251456201@qq.com</td>
							<td>1000</td>
							<td class="center">100</td>
							<td class="center">2015-8-3</td>
						</tr>
						<tr class="gradeX">
							<td align="center"><span class="center"> <input
									type="checkbox" />
							</span></td>
							<td>大山留守儿童</td>
							<td>5481420215@qq.com</td>
							<td>1000</td>
							<td class="center">100</td>
							<td class="center">2015-8-4</td>
						</tr>
						
					</tbody>
				</table>
			</div>
			<!--contentwrapper-->
		</div>
		<!-- centercontent -->
	</div>
	<!--bodywrapper-->
</body>
</html>
