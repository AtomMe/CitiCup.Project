<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/9
 * Time: 下午10:49
 */

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $userId = (int)test_input($_GET["userId"]);
    $avatar = test_input($_GET['avatar']);
    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if (!$link) {
        $output = array('data' => NULL, 'info' => 0, 'code' => -201);
        exit(json_encode($output));
    }

    $db = mysql_select_db("P2PCharity", $link);

    $sql = "UPDATE User SET avatar = '$avatar' WHERE id = '$userId'";

    if (mysql_query($sql, $link)) {
        $output = array('data' => NULL, 'info' => 1, 'code' => 200);
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