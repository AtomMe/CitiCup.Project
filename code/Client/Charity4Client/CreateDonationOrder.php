<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/3
 * Time: 下午7:45
 */

// status
// 0 支付成功，但未使用
// 1 捐款已经使用

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $projectId = test_input($_GET['projectId']);
    $userId = test_input($_GET['userId']);
    $name = test_input($_GET['name']);
    $phoneNum = test_input($_GET['phoneNum']);
    $donationMoney = test_input($_GET['donationMoney']);
    $tradeNo = test_input($_GET['tradeNo']);
    $status = 0;
    $dateDonation = date('YmdHis');
    $applicationOfMoney = "暂未使用";

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=> 0, 'code'=>-201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);
    $sql = "INSERT INTO Donation(projectId, userId, name, phoneNum, donationMoney, status, dateDonation, applicationOfMoney, tradeNo)
            VALUES('$projectId', '$userId', '$name', '$phoneNum', '$donationMoney', '$status', '$dateDonation', '$applicationOfMoney', '$tradeNo')";

    if ($result = mysql_query($sql, $link)) {
        // 插入成功
        // 需要更新相应Project的记录
        $projectUpdateSql = "UPDATE Project SET projectLeftMoney = projectLeftMoney + '$donationMoney', priority = (spendDay / 30) * 0.3 +
                            ((projectMoney -projectLeftMoney - projectWithdrawMoney) / projectMoney) * 0.7 WHERE id = '$projectId'";
        if(mysql_query($projectUpdateSql, $link)) {
            // 更新成功
            $output = array('data'=>NULL, 'donationMoney' => $donationMoney, 'tradeNo' => $tradeNo, 'info'=> 1, 'code'=>200);
            exit(json_encode($output));
        } else {
            $output = array('data'=>NULL, 'info'=> 3, 'code'=>-201);
            exit(json_encode($output));
        }

    } else {
        // 插入失败
        $output = array('data'=>NULL, 'info'=> 2, 'code'=>-201);
        exit(json_encode($output));
    }

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}