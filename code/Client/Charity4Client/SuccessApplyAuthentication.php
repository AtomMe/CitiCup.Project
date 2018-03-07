<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/23
 * Time: 下午10:04
 */

// 0 数据库连接失败
// 1 更新成功
// 2、3、4 更新失败

$username = "";

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // 验证数据
    $username = test_input($_GET["username"]);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=> 0, 'code'=>-201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);
    $sql = "SELECT * FROM User WHERE username = '$username'";
    $result = mysql_query($sql, $link);

    if (mysql_num_rows($result) > 0) {

        $raw = mysql_fetch_array($result);

        $time = date('YmdHis');
        $sqlUpdate = "UPDATE User SET authenticationRequest = TRUE, dateRequest = '$time' WHERE username = '$username'";
        if (mysql_query($sqlUpdate, $link)) {
            $output = array('data'=>$time, 'info'=>1, 'code'=>200);
            exit(json_encode($output));
        } else {
            $output = array('data'=>NULL, 'info'=>2, 'code'=>-201);
            exit(json_encode($output));
        }

    } else {
        $output = array('data'=>NULL, 'info'=>3, 'code'=>-201);
        exit(json_encode($output));
    }

} else {
    $output = array('data'=>NULL, 'info'=>4, 'code'=>-201);
    exit(json_encode($output));
}


function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}