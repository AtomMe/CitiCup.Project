<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/23
 * Time: 下午11:04
 */

$username = "";

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // 验证数据
    $username = test_input($_GET["username"]);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if (!$link) {
        $output = array('data' => NULL, 'info' => 0, 'code' => -201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);
    $sql = "SELECT * FROM User WHERE username = '$username'";
    $result = mysql_query($sql, $link);

    if (mysql_num_rows($result) > 0) {

        $raw = mysql_fetch_array($result);
    }

} else {

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}