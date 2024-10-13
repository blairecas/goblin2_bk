<?php
    // input file
    $fname = pathinfo(__FILE__, PATHINFO_DIRNAME)."/../original/GOBLIN.SAV";
    $f = fopen($fname, "r");
    $src = fread($f, filesize($fname));
    fclose($f);
    if ($src === false) { echo "ERROR: file $fname read failed\n"; exit(1); }

    $replarr = Array(' ' => 0, '!' => 5, '&' => 28, '(' => 8, '"' => 1, '#' => 3, '%' => 29, '$' => 6, '\'' => 7);

    // output file
    $g = fopen(pathinfo(__FILE__, PATHINFO_DIRNAME)."/maps.mac", "w");
    for ($map=2; $map<12; $map++)
    {
        $addr = 0x1FE6 + ($map*26*15);
        // fputs($g, "Lev$map:\n@packstart10\n");
        for ($y=0; $y<15; $y++)
        {
            fputs($g, "\t.byte\t");
            for ($x=0; $x<26; $x++)
            {
                $b = $replarr[$src[$addr++]];
                if (!isset($b)) { echo "ERROR: unknown character in map at addr 0x".dechex(--$addr); fclose($g); exit(1); }
                $s = str_pad(''.$b, 2, " ", STR_PAD_LEFT);
                fputs($g, $s);
                if ($x<25) fputs($g, ", "); else fputs($g, "\n");
            }
        }
        for ($y=15; $y<18; $y++)
        {
            fputs($g, "\t.byte\t");
            for ($x=0; $x<26; $x++)
            {
                $b = 0;
                $s = str_pad(''.$b, 2, " ", STR_PAD_LEFT);
                fputs($g, $s);
                if ($x<25) fputs($g, ", "); else fputs($g, "\n");
            }
        }
	fputs($g, "\n");
        //fputs($g, "@packend\n\n");
    }
    fclose($g);
