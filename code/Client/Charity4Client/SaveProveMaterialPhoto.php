<?php
/**
 * Created by PhpStorm.
 * User: Deep
 * Date: 15/8/28
 * Time: 下午4:01
 */

// 0 上传文件出错
// 1 上传成功



$output = array();

$fileAddressAll = "";

$test = 0;

for($i = 0; $i < 9; $i++) {
    if (isset($_FILES["proveMaterials$i"]) && !empty($_FILES["proveMaterials$i"]['name'])) {

        move_uploaded_file($_FILES["proveMaterials$i"]["tmp_name"], "Project/ProveMaterial/" . $_FILES["proveMaterials$i"]['name']);
        $fileAddressAll .= "http://123.56.91.235/Charity4Client/Project/ProveMaterial/" . $_FILES["proveMaterials$i"]['name'] . ";";
        $test++;

    }
}

$output = array('data'=> $fileAddressAll, 'info'=> 0, 'code'=>-201);
exit(json_encode($output));
