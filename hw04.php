<?php
    $img = rand(1,5);       //隨機選五張圖
    $img = imagecreatefromjpeg("flower{$img}".".jpg");     //將照片引入
    // $color = imagecolorallocate($img,rand(0,255),rand(0,255),rand(0,255));
    $color = [imagecolorallocate($img,0,0,0),imagecolorallocate($img,255,0,0),imagecolorallocate($img,255,255,255)];    //字有三種隨機顏色白紅黑
    $color = $color[rand(0,2)];     //隨機選顏色
    $angle = rand(-15,15);          //字的角度落在-15~15度不會偏太大
    $text = ['您好','早安','一切順利','感謝','美好的一天']; //有五句話隨機產生
    $positionX = rand(100,800);     //字的X座標落在100~800之間(因為圖都為1280的寬所以可以)
    $positionY = array(150,250,350,450,550);    //不同句話要有不同的Y座標以免重疊，從這些數字中選取，間距夠大，不至於重疊
    

    for($i=0;$i<5;$i++){        //總共五句話分別製作
        if(rand(0,1)){      //不一定每句話都要顯示
            $rand1 = rand(0,count($positionY)-1);       //決定Y軸位置
            $rand2 = rand(0,count($text)-1);        //決定哪句話
                                                                                //!!!FONT的路徑非常重要，一定要是對的不然顯示不了!!!
            imagettftext($img, 72, $angle, $positionX, $positionY[$rand1],$color,'C:\xampp\htdocs\Louis\myfont.ttf', $text[$rand2]);    //將字印上
            $positionY[$rand1]=$positionY[count($positionY)-1];     //交換被選取的Y軸位置
            array_pop($positionY);         //去掉被選過的Y軸位置
            $text[$rand2]=$text[count($text)-1];        //交換被選取的字
            array_pop($text);       //去掉被選取的字
        }
    }

    // 3. Output => 1. file; 2. Browser
    header('Content-Type: image/jpeg');
    imagejpeg($img);

    // imagejpeg($img, "newflower.jpg");
    // 4. release
    imagedestroy($img);
?>