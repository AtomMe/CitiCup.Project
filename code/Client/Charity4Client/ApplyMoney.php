<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/4
 * Time: 下午10:52
 */

// status
// 0 正在申请中
// 1 申请成功，已转账
// 2 申请失败

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    $projectId = test_input($_GET['projectId']);
    $userId = test_input($_GET['userId']);
    $applyMoney = test_input($_GET['applyMoney']);
    $purpose = test_input($_GET['purpose']);
    $alipayAccount = test_input($_GET['alipayAccount']);
    $phoneNum = test_input($_GET['phoneNum']);
    $proveMaterial = test_input($_GET['proveMaterial']);
    $status = 0;
    $dateRequest = date('YmdHis');

    // 连接数据库并保存到数据库
    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=>0, 'code'=>-201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);

    $sql = "INSERT INTO Withdraw(projectId, userId, applyMoney, purpose, alipayAccount, phoneNum, proveMaterial, status, dateRequest)
            VALUES('$projectId', '$userId', '$applyMoney', '$purpose', '$alipayAccount', '$phoneNum', '$proveMaterial', '$status', '$dateRequest')";

    if (mysql_query($sql, $link)) {

        $output = array('data' => NULL, 'info' => 1, 'code' => 200);
        mysql_close($link);
        exit(json_encode($output));

    } else {
        $output = array('data' => NULL, 'info' => 2, 'code' => -201);
        exit(json_encode($output));
    }

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}