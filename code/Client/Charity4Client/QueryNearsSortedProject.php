<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/31
 * Time: 下午10:27
 */

// 0 请求失败
// 1 数据库连接失败
// 2 没有数据
// 3 没有更多的数据用于刷新
// 4 下拉刷新，重新加载数据
// 5 上拉加载更多数据返回

$output = array();

$data = array();

$avatar = array();

if ($_SERVER["REQUEST_METHOD"] == "GET") {

    $times = (int)test_input($_GET["times"]);
    $queryType = (int)test_input($_GET["queryType"]);
    $longitude = test_input($_GET["longitude"]);
    $latitude = test_input($_GET["latitude"]);

    // 连接数据库
    $link = mysql_connect("localhost", "root", "");

    if(!$link)
    {
        $output = array('data'=>NULL, 'info'=> 1, 'code'=>-201);
        exit(json_encode($output));
    }


    $db = mysql_select_db("P2PCharity", $link);

    $sql = "SELECT * from Project WHERE projectStatus = 2 AND spendDay < 30 ORDER BY priority DESC";

    $result = mysql_query($sql, $link);

    if (mysql_num_rows($result) == 0) {

        // 没有数据
        $output = array('data'=>NULL, 'info'=> 2, 'code'=>-201);
        exit(json_encode($output));

    } else {

        // 下拉刷新，重新加载数据
        if ($queryType == 0) {

            $i = 0;
            while ($row = mysql_fetch_array($result)) {

                $longLat = $row['projectAddress'];
                if ($longLat != null) {

                    $arr = explode(";", $longLat);
                    $rowLongitude = $arr[0];
                    $rowLatitude = $arr[1];

                    // 10Km之内
                    if (distanceBetween($latitude, $longitude, $rowLatitude, $rowLongitude) < 10000) {

                        $sponsorId = $row['sponsorId'];
                        $sqlForAvatar = "SELECT avatar FROM User WHERE id = '$sponsorId'";
                        $avatarResult = mysql_query($sqlForAvatar, $link);
                        if (mysql_num_rows($avatarResult) == 0) {
                            continue;
                        } else {
                            $avatarRow = mysql_fetch_array($avatarResult);
                            $avatar[] = $avatarRow;
                        }

                        $data[] = $row;
                        $i++;
                    }
                }

                if ($i >= 10) {
                    break;
                }

            }

            $output = array('data'=>$data, 'avatar' => $avatar, 'info'=> 4, 'code'=>200);
            exit(json_encode($output));

        } elseif($queryType == 1) { // 上拉加载更多数据

            // 没有更多的数据用于刷新
            if (mysql_num_rows($result) < (int)$times * 10) {
                $output = array('data'=>NULL, 'info'=> 3, 'code'=>-201);
                exit(json_encode($output));
            } else {
                // 查询更多的数据并返回
                // 首先跳过指定的行数
                // 再加载10个或不够时少于10个数据
                $i = 0;
                while ($row = mysql_fetch_array($result)) {

                    $longLat = $row['projectAddress'];
                    if ($longitude != null) {

                        $arr = explode(";", $longitude);
                        $rowLongitude = $arr[0];
                        $rowLatitude = $arr[1];

                        // 10Km之内
                        if (distanceBetween($latitude, $longitude, $rowLatitude, $rowLongitude) < 10000) {

                            $i++;

                            if ($i >= (((int)$times + 1) * 10)) {
                                break;
                            }

                            if ($i >= ((int)$times * 10)) {

                                $sponsorId = $row['sponsorId'];
                                $sqlForAvatar = "SELECT avatar FROM User WHERE id = '$sponsorId'";
                                $avatarResult = mysql_query($sqlForAvatar, $link);
                                if (mysql_num_rows($avatarResult) == 0) {
                                    continue;
                                } else {
                                    $avatarRow = mysql_fetch_array($avatarResult);
                                    $avatar[] = $avatarRow;
                                }

                                $data[] = $row;
                            }
                        }
                    }



                }

                $output = array('data'=>$data, 'avatar' => $avatar, 'info'=> 5, 'code'=>200);
                exit(json_encode($output));

            }

        }

    }


} else {
    $output = array('data'=>NULL, 'info'=> 0, 'code'=>-201);
    exit(json_encode($output));
}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}


/**
 * 计算两个坐标之间的距离(米)
 * @param float $fP1Lat 起点(纬度)
 * @param float $fP1Lon 起点(经度)
 * @param float $fP2Lat 终点(纬度)
 * @param float $fP2Lon 终点(经度)
 * @return int
 */
function distanceBetween($fP1Lat, $fP1Lon, $fP2Lat, $fP2Lon){
    $fEARTH_RADIUS = 6378137;
    //角度换算成弧度
    $fRadLon1 = deg2rad($fP1Lon);
    $fRadLon2 = deg2rad($fP2Lon);
    $fRadLat1 = deg2rad($fP1Lat);
    $fRadLat2 = deg2rad($fP2Lat);
    //计算经纬度的差值
    $fD1 = abs($fRadLat1 - $fRadLat2);
    $fD2 = abs($fRadLon1 - $fRadLon2);
    //距离计算
    $fP = pow(sin($fD1/2), 2) +
        cos($fRadLat1) * cos($fRadLat2) * pow(sin($fD2/2), 2);
    return intval($fEARTH_RADIUS * 2 * asin(sqrt($fP)) + 0.5);
}