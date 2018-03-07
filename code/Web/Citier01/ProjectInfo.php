<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>资料展示页面</title>
<link rel="stylesheet" href="css/style.default.css" type="text/css" />
<script type="text/javascript" src="js/plugins/jquery-1.7.min.js"></script>
<script type="text/javascript"
	src="js/plugins/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="js/plugins/jquery.cookie.js"></script>
<script type="text/javascript" src="js/plugins/jquery.bxSlider.min.js"></script>
<script type="text/javascript" src="js/custom/general.js"></script>
<script type="text/javascript" src="js/custom/profile.js"></script>
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
		<?php
                           if (isset($_GET['id'])) {
                                $projectid = $_GET['id'];
                                $userid = $_GET['userid'];
                            }              
                            require_once "sqlTool.php";
                            $sqltool = new sqlTool();
                            $sql = "UPDATE project set ProjectRequest = 0 where ProjectID = '$projectid'";
                            $result = $sqltool->excute_dql($sql);
                            
                            $sqltool = new sqlTool();
                            $sql = "SELECT * FROM user WHERE UserID = '$userid'";
                            $result = $sqltool->excute_dql($sql);
                            $row = mysql_fetch_array($result);
                            ?>

		<div class="centercontent">
			<div class="pageheader">
				<div class="profiletitle"></div>
				<!--pageheader-->
				<div id="contentwrapper" class="contentwrapper">
					<div class="two_third last profile_wrapper">
						<div id="profile" class="subcontent">

							<div class="contenttitle2">
								<h3>项目发起人基本信息</h3>
							</div>
							<!--contenttitle-->
							<div class="profile_about">
								<p>用户账号： <?php echo $row['UserName'];?></p>
								<p>真实姓名： <?php echo $row['RealName'];?></p>
								<p>身份证号码：<?php echo $row['ID'];?></p>
								<p>电话号码：  <?php echo $row['PhoneNum'];?></p>

							</div>
							<!--recentblog-->
							<br clear="all" />
							<div class="contenttitle2">
								<h3>身份证照片</h3>
							</div>
							<!--contenttitle-->
							<ul class="recentshots">
								<li><a href="" class="th"><img
										width = "400px" height = "300px" src="<?php echo $row['IDphotoFrontFar']?>" alt="" /></a></li>
								<li><a href="" class="th"><img
										width = "400px" height = "300px" src="<?php echo $row['IDphotoReverseFar']?>" alt="" /></a></li>
							</ul>
							<br clear="all" />

						<?php             
                            require_once "sqlTool.php";                                    
                            $sqltool = new sqlTool();
                            $sql = "SELECT * FROM project WHERE ProjectID = '$projectid'";
                            $result = $sqltool->excute_dql($sql);
                            $row = mysql_fetch_array($result);
                            ?>
							<div class="contenttitle2">
								<h3>受助人基本信息</h3>
							</div>
							<!--contenttitle-->
							<div class="profile_about">
								<p>真实姓名： <?php echo $row['AppealName'];?></p>
								<p>身份证号码：<?php echo $row['AppealID'];?></p>
								<p>电话号码： <?php echo $row['AppealPhone'];?></p>
								<p>籍贯：<?php echo $row['AppealAddress'];?></p>
								<p>性别：男</p>
								<p>收入：<?php echo $row['AppealIncome'];?>元/月</p>
							</div>

							<div class="contenttitle2">
								<h3>项目基本信息</h3>
							</div>
							<!--contenttitle-->
							<div class="profile_about">
								<p>项目编号： <?php echo $row['ProjectID'];?></p>
								<p>项目名称： <?php echo $row['ProjectTitle'];?></p>
								<p>项目类型： 其他</p>
								<p>求助金额： <?php echo $row['ProjectMoney'];?></p>
								<p>项目地址：<?php echo $row['ProjectAddress'];?></p>
								<p>发起人与受助人关系：朋友</p>
								<p>申请时间： <?php echo $row['ProjectDateRequest'];?></p>
							</div>
							<!--recentblog-->
							<br clear="all" />

							<div class="contenttitle2">
								<h3>项目详情</h3>
							</div>
							<div class="profile_about">
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $row['ProjectReason'];?></p>
							</div>
							<!--contenttitle-->
							<div class="profile_about">
								<p></p>
							</div>
							<br clear="all" />
							<div class="contenttitle2">
								<h3>项目相关照片</h3>
							</div>
							<!--contenttitle-->
							<ul class="recentshots">
								<li><a href="" class="th"><img
										width = "400px" height = "300px" src="<?php echo $row['ProveMaterial']?>" alt="" /></a>
								</li>
							</ul>
							<br clear="all" /> <br /> <br />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;
							 <a href="ExamineHelpProject.php">
							 <button class="button">通过</button></a>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp; 
							<a href="ProjectReply.php?id=<?php echo $projectid;?>">
							<button class="button">不通过</button></a> <br /> <br />
						</div>
					</div>
				</div>
			</div>
			<!-- centercontent -->
		</div>
		<!--bodywrapper-->

</body>
</html>
