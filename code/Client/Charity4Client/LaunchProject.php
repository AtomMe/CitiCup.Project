<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/27
 * Time: 下午2:16
 */

// projectStatus
// 0 申请中
// 1 申请失败
// 2 申请成功
// 3 期限已到

// 0 数据库连接失败
// 1 新建成功
// 2 失败
// 3 失败

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // 验证数据
    $sponsorId = test_input($_GET["sponsorId"]);
    $projectType = test_input($_GET["projectType"]);
    $projectMoney = test_input($_GET["projectMoney"]);
    $projectReason = test_input($_GET["projectReason"]);
    $projectTitle = test_input($_GET["projectTitle"]);
    $projectAddress = test_input($_GET["projectAddress"]);
    $projectStatus = 2;
    $projectRequestDate = date('YmdHis');
    $projectLeftMoney = 0.0;
    $projectWithdrawMoney = 0.0;
    $projectDonationTime = date("YmdHis", strtotime("+30 days"));
    $appealName = test_input($_GET["appealName"]);
    $appealID = test_input($_GET["appealID"]);
    $appealPhone = test_input($_GET["appealPhone"]);
    $appealAddress = test_input($_GET["appealAddress"]);
    $appealEnmergencyName = test_input($_GET["appealEnmergencyName"]);
    $appealEnmergencyPhone = test_input($_GET["appealEnmergencyPhone"]);
    $appealSex = test_input($_GET["appealSex"]) == "0"? true : false;
    $appealIncome = test_input($_GET["appealIncome"]);
    $proveMaterial = test_input($_GET["proveMaterial"]);
    $priority = 0.7;
    $spendDay = 0;

    $imageWidth = floatval(test_input($_GET['imageWidth']));
    $imageHeight = floatval(test_input($_GET['imageHeight']));

    // 连接数据库并保存到数据库

    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=>0, 'code'=>-201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);

    $sql = "INSERT INTO Project(sponsorId, projectType, projectMoney, projectReason, projectTitle, projectAddress,
            projectStatus, projectRequestDate, projectLeftMoney, projectWithdrawMoney, projectDonationTime, appealName,
            appealID, appealPhone, appealAddress, appealEnmergencyName, appealEnmergencyPhone, appealSex, appealIncome, proveMaterial, priority, spendDay, imageWidth, imageHeight)
            VALUES('$sponsorId', '$projectType', '$projectMoney', '$projectReason', '$projectTitle', '$projectAddress',
             '$projectStatus', '$projectRequestDate', '$projectLeftMoney', '$projectWithdrawMoney', '$projectDonationTime',
              '$appealName', '$appealID', '$appealPhone', '$appealAddress', '$appealEnmergencyName', '$appealEnmergencyPhone',
               '$appealSex', '$appealIncome', '$proveMaterial', '$priority', '$spendDay', '$imageWidth', '$imageHeight')";

    if (mysql_query($sql, $link)) {

        $output = array('data' => NULL, 'info' => 1, 'code' => 200);
        mysql_close($link);
        exit(json_encode($output));

    } else {
        $output = array('data' => NULL, 'imageWidth' => $imageWidth, 'imageHeight' => $imageHeight, 'info' => 2, 'code' => -201);
        exit(json_encode($output));
    }

} else {
    $output = array('data' => NULL, 'info' => 3, 'code' => -201);
    exit(json_encode($output));
}


function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}