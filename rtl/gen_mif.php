<?php
//include_once('view.php');

function show_bit($ch)
{
	//for($i=128;$i>1;$i=$i/2)
	for($i=1;$i<256;$i=$i*2)
	{
		echo ($ch&$i)?"#":".";
	}
}

$bin_name  = strval($argv[1]);
$file_name  = strval($argv[2]);

// 读文件
$buf = file_get_contents($bin_name);
if($buf===FALSE) exit;

$l = strlen($buf);

echo "in : $bin_name\n";
echo "out : $file_name\n";

/*
for($i=0;$i<$l;$i++) {
	$ch = ord($buf{$i});
	show_bit($ch);
	printf("  %04X %02X\n", $i, $ch);
}
*/

$s = "";
$s .= "DEPTH = $l;\n";
$s .= "WIDTH = 8;\n";
$s .= "ADDRESS_RADIX = HEX;\n";
$s .= "DATA_RADIX = HEX;\n";
$s .= "CONTENT\n";

$s .= "BEGIN\n";
for($i=0;$i<$l;$i++) {
	$ch = ord($buf{$i});
	$s .= sprintf("%04X:%02X;\n", $i, $ch);
}
$s .= "END;\n";
//echo $s;
file_put_contents($file_name,$s);
