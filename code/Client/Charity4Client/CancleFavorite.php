<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/8
 * Time: 上午12:01
 */

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // 验证数据
    $userId = test_input($_GET["userId"]);
    $projectId = test_input($_GET['projectId']);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if (!$link) {
        $output = array('data' => NULL, 'info' => 0, 'code' => -201);
        exit(json_encode($output));
    }

    $db = mysql_select_db("P2PCharity", $link);
    $sql = "DELETE FROM Favorite WHERE userId = '$userId' AND projectId = '$projectId'";

    if (mysql_query($sql, $link)) {
        $output = array('data'=>NULL, 'info'=>1, 'code'=>200);
        exit(json_encode($output));
    } else {
        $output = array('data'=>NULL, 'info'=>2, 'code'=>200);
        exit(json_encode($output));
    }

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}