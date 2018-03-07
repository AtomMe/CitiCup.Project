<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/22
 * Time: 下午12:36
 */

// 0 上传文件出错
// 1 上传成功

$output = array();

$filename = date('YmdHis') . '.jpg';

$result = file_put_contents( 'Authentication/IDPhoto/'.$filename, file_get_contents('php://input') );

if (!$result) {
    $output = array('data'=>NULL, 'info'=> 0, 'code'=>-201);
    exit(json_encode($output));
} else {
    $output = array('data'=>'Authentication/IDPhoto/'.$filename, 'info'=> 1, 'code'=>200);
    exit(json_encode($output));
}
