<?php

class sqlTool
{

    private $host = "localhost";

    private $user = "root";

    private $password = "";

    private $conn;

    private $db = "my";

    function sqlTool()
    {
        $this->conn = mysql_connect($this->host, $this->user, $this->password);
        if (! $this->conn) {
            die("链接数据库失败" . mysql_errno());
        }
        mysql_select_db($this->db, $this->conn);
        mysql_query("set names utf8");
    }

    function excute_dql($sql)
    {
        $res = mysql_query($sql,$this->conn);
        mysql_close($this->conn);
        return $res;
    }
}

?>