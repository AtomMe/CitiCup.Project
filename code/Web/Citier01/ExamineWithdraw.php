<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>审核提款页面</title>
<link rel="stylesheet" href="css/style.default.css" type="text/css" />
<script type="text/javascript" src="js/plugins/jquery-1.7.min.js"></script>
<script type="text/javascript"
	src="js/plugins/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="js/plugins/jquery.cookie.js"></script>
<script type="text/javascript" src="js/plugins/jquery.uniform.min.js"></script>
<script type="text/javascript" src="js/plugins/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/plugins/jquery.tagsinput.min.js"></script>
<script type="text/javascript" src="js/plugins/charCount.js"></script>
<script type="text/javascript" src="js/plugins/ui.spinner.min.js"></script>
<script type="text/javascript" src="js/plugins/chosen.jquery.min.js"></script>
<script type="text/javascript" src="js/custom/general.js"></script>
<script type="text/javascript" src="js/custom/forms.js"></script>

<!--[if IE 9]>
    <link rel="stylesheet" media="screen" href="css/style.ie9.css"/>
<![endif]-->
<!--[if IE 8]>
    <link rel="stylesheet" media="screen" href="css/style.ie8.css"/>
<![endif]-->
<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
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

		<div class="centercontent">

			<div class="pageheader">
				<h1 class="pagetitle">提款申请审核</h1>
				<!-- <span class="pagedesc">The content below are loaded using ajax</span> -->

				<ul class="hornav">
					<!-- <li class="current"><a href="#inbox">Inbox</a></li> -->
					<!-- <li><a href="#compose">Compose New</a></li> -->
				</ul>
			</div>
			<!--pageheader-->

			<div id="contentwrapper" class="contentwrapper">

				<div id="inbox" class="subcontent">

					<div class="msghead">
						<ul class="msghead_menu">
							<li><a class="reportspam">Report Spam</a></li>
							<li class="marginleft5 dropdown" id="actions"><a
								class="dropdown_label" href="#actions"> Actions <span
									class="arrow"></span>
							</a>
								<ul>
									<li><a href="">Mark as Read</a></li>
									<li><a href="">Mark as Unread</a></li>
									<li><a href="">Move to Folder</a></li>
									<li><a href="">Add Star</a></li>
								</ul></li>
							<li class="marginleft5"><a class="msgtrash" title="Trash"></a></li>
							<li class="right"><a class="next"></a></li>
							<li class="right"><a class="prev prev_disabled"></a></li>
							<li class="right"><span class="pageinfo">1-10 of 20</span></li>
						</ul>
						<span class="clearall"></span>
					</div>
					<!--msghead-->

					<table cellpadding="0" cellspacing="0" border="0"
						class="stdtable mailinbox">
						<colgroup>
							<col class="con1" width="4%" />
							<col class="con0" width="4%" />
							<col class="con1" width="15%" />
							<col class="con0" width="63%" />
							<col class="con1" width="4%" />
							<col class="con1" width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th width="20" class="head1 aligncenter"><input
									type="checkbox" name="checkall" class="checkall" /></th>
								<th class="head0">&nbsp;</th>
								<th class="head1">项目名称</th>
								<th class="head0">提款编号(点击链接，查看具体内容，并进行审核)</th>
								<th class="head1 attachement">&nbsp;</th>
								<th class="head0">日期</th>
							</tr>
						</thead>
						<?php
                         require_once "sqlTool.php";
                         $sqltool = new sqlTool();
                         $sql = "SELECT * FROM withdraw where WithdrawRequest = 1";
                         $result = $sqltool->excute_dql($sql);
                         ?>
                          <?php
                         while ($row = mysql_fetch_array($result)) // 通过循环读取数据内容
                         {
                         ?>
						<tbody>
							<tr class="unread">
								<td class="aligncenter"><input type="checkbox" name="" /></td>
								<td class="star"><a class="msgstar"></a></td>
								<td><?php echo $row['Name'] ?></td>
								<td><a href="WithdrawInfo.php?id=<?php echo $row['WithdrawID'];?>&userid=<?php echo $row['UserID'];?>" class="title"><?php echo $row['WithdrawID'];?></a></td>
								<td class="attachment"></td>
								<td class="date"><?php echo $row['DateRequest'];?></td>
							</tr>
					       <?php }?>
                         </tbody>
					</table>
				</div>
				<div id="compose" class="subcontent" style="display: none">&nbsp;</div>
			</div>
			<!--contentwrapper-->
		</div>
		<!--centercontent-->
	</div>
	<!--bodywrapper-->
</body>
</html>