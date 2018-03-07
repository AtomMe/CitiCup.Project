<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/12
 * Time: 上午12:14
 */

// 0 数据库连接失败
// 1 用户名已存在
// 2 注册成功
// 3 注册失败
// 4 请求失败

$username = $password = "";
$output = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    // echo "当前为GET请求";

    // 验证数据
    $username = test_input($_GET["username"]);
    $password = test_input($_GET["password"]);

    // 连接数据库并保存到数据库

    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=>0, 'code'=>-201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);
    $sql = "SELECT * FROM User WHERE username = '$username'";
    $result = mysql_query($sql, $link);

    if (mysql_num_rows($result) > 0) {
        $output = array('data'=>NULL, 'info'=>1, 'code'=>-201);
        exit(json_encode($output));
    } else {

        // 向数据库中插入数据

        $avatar = "http://123.56.91.235/Charity4Client/Avatar/icon-default-avatar.png";

        $sqlQueryAll = "SELECT * FROM User";

        $resultAll = mysql_query($sqlQueryAll, $link);

        $num = mysql_num_rows($resultAll);

        $nick = "Charity" . $num;

        $sqlInsert = "INSERT INTO User(username, password, nick, isAuthentication, isActive, authenticationFail, authenticationRequest,
                      authenticationFailMsg, avatar)
                      VALUES ('$username', '$password', '$nick', FALSE, TRUE, TRUE, FALSE, '$nick', '$avatar')";

        if (mysql_query($sqlInsert, $link)) {

            $userInfo = array('id' => $num + 1, 'username' => $username, 'password' => $password, 'nick' => $nick, 'isAuthentication' => false, 'isActive' => true );

            $output = array('data' => $userInfo, 'info' => 2, 'code' => 200);
            mysql_close($link);
            exit(json_encode($output));
        } else {
            $output = array('data' => NULL, 'info' => 3, 'code' => -201);
            exit(json_encode($output));
        }

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