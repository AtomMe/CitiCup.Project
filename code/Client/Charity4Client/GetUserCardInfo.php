<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/8
 * Time: 下午3:56
 */

$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $userId = test_input($_GET['userId']);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if (!$link) {
        $output = array('data' => NULL, 'info' => 0, 'code' => -201);
        exit(json_encode($output));
    }

    $db = mysql_select_db("P2PCharity", $link);

    $sql = "SELECT SUM(donationMoney) AS totalMoney, COUNT(*) AS totalTimes FROM Donation WHERE userId = '$userId'";
    $result = mysql_query($sql, $link);
    if ($result) {
        if (mysql_num_rows($result) > 0) {

            $row = mysql_fetch_array($result);
            $output = array('data'=>$row, 'info'=> 1, 'code'=>200);
            exit(json_encode($output));

        } else {
            $output = array('data'=>NULL, 'info'=> 2, 'code'=>200);
            exit(json_encode($output));
        }
    } else {
        $output = array('data'=> NULL, 'info'=> 3, 'code'=>200);
        exit(json_encode($output));
    }

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}