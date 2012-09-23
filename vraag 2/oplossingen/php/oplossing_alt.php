<?php

for ($i = 1; $i <= 100; $i++)
{
	$s = "";
	if ($i % 3 == 0) $s .= "Fizz";
	if ($i % 5 == 0) $s .= "Buzz";
	echo (strlen($s) > 0 ? $s : $i) . PHP_EOL;
}