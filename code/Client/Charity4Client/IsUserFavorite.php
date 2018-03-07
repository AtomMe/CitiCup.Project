<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/7
 * Time: 下午11:00
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
    $sqlQuery = "SELECT * FROM Favorite WHERE userId = '$userId' AND projectId = '$projectId' ";
    $result = mysql_query($sqlQuery, $link);
    if ($result) {

        if (mysql_num_rows($result) > 0) {
            $output = array('data'=>NULL, 'userId' => $userId, 'projectId' => $projectId, 'info'=>1, 'code'=>200);
            exit(json_encode($output));
        } else {
            $output = array('data'=>NULL, 'userId' => $userId, 'projectId' => $projectId, 'info'=>3, 'code'=>200);
            exit(json_encode($output));
        }


    } else {
        $output = array('data'=>NULL, 'userId' => $userId, 'projectId' => $projectId, 'info'=>2, 'code'=>200);
        exit(json_encode($output));
    }

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}