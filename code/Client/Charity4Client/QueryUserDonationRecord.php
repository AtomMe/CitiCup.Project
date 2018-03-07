<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/9/4
 * Time: 上午10:39
 */

$output = array();

$data = array();

$projectTitle = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $userId = test_input($_GET["userId"]);
    $times = (int)test_input($_GET["times"]);
    $queryType = (int)test_input($_GET["queryType"]);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if (!$link) {
        $output = array('data' => NULL, 'info' => 0, 'code' => -201);
        exit(json_encode($output));
    }

    $db = mysql_select_db("P2PCharity", $link);

    $sql = "SELECT * FROM Donation WHERE userId = '$userId' ORDER BY dateDonation DESC";

    $result = mysql_query($sql, $link);

    if (mysql_num_rows($result) == 0) {

        // 没有数据
        $output = array('data'=>NULL, 'info'=> 1, 'code'=>-201);
        exit(json_encode($output));

    } else {

        // 下拉刷新或者首次刷新
        if ($queryType == 0) {
            for ($i = 0; $i < 10; $i++) {
                if ($row = mysql_fetch_array($result)) {

                    $projectId = $row['projectId'];
                    $sqlForTitle = "SELECT projectTitle FROM Project WHERE id = '$projectId'";
                    $titleResult = mysql_query($sqlForTitle, $link);
                    if (mysql_num_rows($titleResult) == 0) {
                        continue;
                    } else {
                        $titleRow = mysql_fetch_array($titleResult);
                        $projectTitle[] = $titleRow;
                    }

                    $data[] = $row;

                } else {
                    break;
                }
            }

            $output = array('data'=>$data, 'title' => $projectTitle, 'info'=> 2, 'code'=>200);
            exit(json_encode($output));
        } elseif ($queryType == 1) {  // 上拉刷新

            // 没有更多的数据用于刷新
            if (mysql_num_rows($result) < $times * 10) {
                $output = array('data'=>NULL, 'info'=> 3, 'code'=>-201);
                exit(json_encode($output));
            } else {
                // 查询更多的数据并返回
                // 首先跳过指定的行数
                // 再加载10个或不够时少于10个数据
                for($i = 0; $i < (($times + 1) * 10); $i++) {
                    if ($row = mysql_fetch_array($result)) {
                        if ($i >= ($times * 10)) {

                            $projectId = $row['projectId'];
                            $sqlForTitle = "SELECT projectTitle FROM Project WHERE id = '$projectId'";
                            $titleResult = mysql_query($sqlForTitle, $link);
                            if (mysql_num_rows($titleResult) == 0) {
                                continue;
                            } else {
                                $titleRow = mysql_fetch_array($titleResult);
                                $projectTitle[] = $titleRow;
                            }

                            $data[] = $row;

                        }
                    } else {
                        break;
                    }
                }

                $output = array('data'=>$data, 'title' => $projectTitle, 'info'=> 4, 'code'=>200);
                exit(json_encode($output));
            }

        }
    }

}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}