<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/12
 * Time: 上午11:44
 */

// 0 数据库连接失败
// 1 用户不存在
// 2 登录成功
// 3 请求失败
// 4 密码错误

$username = $password = "";
$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // 验证数据
    $username = test_input($_GET["username"]);
    $password = test_input($_GET["password"]);


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

    if (mysql_num_rows($result) == 0) {
        $output = array('data'=>NULL, 'info'=>1, 'code'=>-201);
        exit(json_encode($output));
    } else {

        $row = mysql_fetch_array($result);
        if ($row['password'] == $password) {

            $userInfo = array('id' => $row['id'], 'username' => $username, 'password' => $password, 'nick' => $row['nick'],
                'realName' => $row['realName'], 'realID' => $row['realID'], 'phoneNum' => $row['phoneNum'],
                'authenticationRequest' => $row['authenticationRequest'], 'dateRequest' => $row['dateRequest'],
                'authenticationFail' => $row['authenticationFail'], 'authenticationFailMsg' => $row['authenticationFailMsg'],
                'avatar' => $row['avatar'],
                'isAuthentication' => $row['isAuthentication'], 'isActive' => $row['isActive']);

            $output = array('data'=>$userInfo, 'info'=>2, 'code'=>200);

            exit(json_encode($output));

        } else {
            $output = array('data'=>NULL, 'info'=>4, 'code'=>-201);
            exit(json_encode($output));
        }

    }

    mysql_close($link);

} else {
    $output = array('data'=>NULL, 'info'=>3, 'code'=>-201);
    exit(json_encode($output));
}


function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}