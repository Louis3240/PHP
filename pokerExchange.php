<?php
    $temp = range(0,51);   //還沒洗過的撲克牌。共52張，次序僅代表對應牌，不需必要1~52
    $poker = [];    //洗好的牌放這
    $randNum = 0;   //存放每次隨機的值
    $point = 0;     //占存點數，顯示用

    for($i=0;$i<52;$i++){   //做52次
        $randNum = rand(0,51-$i);   //每次都從還沒交換的牌裡面跑隨機   
        $poker[$i+1]=$temp[$randNum];   //跑到某個值就丟給poker，我後面想映出第X張牌，不想有0，所以平移1
        $temp[$randNum] = $temp[51-$i]; //並將該值跟從後面數過來還沒被交換的值交換，如此一來便不會被重複選取
    }

    foreach($poker as $index => $p){     //好了就映出來吧
        $point = ($p%13)+1;
        switch (floor($p / 13)){
            case 0:
                if($point==11) echo "第{$index}張牌是梅花J<br>";
                else if($point==12) echo "第{$index}張牌是梅花Q<br>";
                else if($point==13) echo "第{$index}張牌是梅花K<br>";
                else
                echo "第{$index}張牌是梅花{$point}<br>";
                break;
            case 1:
                if($point==11) echo "第{$index}張牌是方塊J<br>";
                else if($point==12) echo "第{$index}張牌是方塊Q<br>";
                else if($point==13) echo "第{$index}張牌是方塊K<br>";
                else
                echo "第{$index}張牌是方塊{$point}<br>";
                break;
            case 2:
                if($point==11) echo "第{$index}張牌是愛心J<br>";
                else if($point==12) echo "第{$index}張牌是愛心Q<br>";
                else if($point==13) echo "第{$index}張牌是愛心K<br>";
                else
                echo "第{$index}張牌是愛心{$point}<br>";
                break;
            case 3:
                if($point==11) echo "第{$index}張牌是黑桃J<br>";
                else if($point==12) echo "第{$index}張牌是黑桃Q<br>";
                else if($point==13) echo "第{$index}張牌是黑桃K<br>";
                else
                echo "第{$index}張牌是黑桃{$point}<br>";
                break;
            
        }
        
    }    
?>