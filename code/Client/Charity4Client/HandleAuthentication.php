<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/22
 * Time: 下午12:47
 */

// 0 数据库连接失败
// 1 插入成功
// 2 插入失败
// 3 请求失败

// $username = $realName = $realID = $phoneNum = $idPhoto1 = $idPhoto2 = "";

$output = array();

if ($_SERVER["REQUEST_METHOD"] == 'GET') {

    // 验证数据
    $username = test_input($_GET['username']);
    $realName = test_input($_GET['realName']);
    $realID = test_input($_GET['realID']);
    $phoneNum = test_input($_GET['phoneNum']);
    $idPhoto1 = test_input($_GET['idPhoto1']);
    $idPhoto2 = test_input($_GET['idPhoto2']);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=> 0, 'code'=>-201);
        exit(json_encode($output));
    }

    $db = mysql_select_db("P2PCharity", $link);

    $sql = "INSERT INTO Authentication(username, realName, realID, phoneNum, IDphoto1, IDphoto2, status)
            VALUES ('$username', '$realName', '$realID', '$phoneNum', '$idPhoto1', '$idPhoto2', FALSE )";

    if (mysql_query($sql, $link)) {
        $output = array('data' => NULL, 'info' => 1, 'code' => 200);
        mysql_close($link);
        exit(json_encode($output));
    } else {
        $output = array('data' => NULL, 'info' => 2, 'code' => -201);
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

