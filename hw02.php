<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>1到100的質數</title>
    <!-- 引用bootstrap -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    
    <style>
        /* CSS調整文字跟寬度格式 */
        table{
            text-align:center;
            border-spacing:0;
            font-size: 32px;
            width:100%;
        }
        /* 指示使用者滑到哪個數字了 */
        td:hover{
            background-color:white;
        }

    </style>
</head>
<body>
    <!-- 訓練PHP，質數的尋找都用PHP，TABLE也一起用PHP畫了 -->
    <?php
        $temp = range(2,100);       //從2開始找質數
        $primeFactorization = [1=>[1]];     //由於index要對應數字，所以從1開始
        $factor = [];       //暫存因數的地方
        $notPrime = true;       //檢測是否沒有因數了

        foreach($temp as $number){
            $numForFactor = $number;        //當該數非質數時需要重複檢查，因此額外存一個變數
            $notPrime = true;               //先假設不是質數，如果是質數就跳出迴圈
            $count = 1;                     //防止無限迴圈
            while($notPrime ||$count >100){
                $count = $count+1;          //防止無限迴圈
                for($i=1 ; $i<=floor(sqrt($numForFactor)) ; $i++){
                    if($numForFactor % $i == 0 && $i!=1){
                        $factor[] = $i;     //找到因數且非1就丟進去
                        $numForFactor = $numForFactor / $i;     //找到因數就將正在檢查的數字除以該數
                        $notPrime = true;                       //由於找到因數整除，所以還沒質數
                        break;                                  //找到了因數就跳出去
                    }
                    $notPrime = false;                          //都沒遇到跳出的程序，代表是質數
                }
            }

            $factor[]=$numForFactor;                            //沒有數可以整除了，只剩自己丟進因數裡
            $primeFactorization[]=$factor;                      //將因數陣列存到對應的index
            $factor=[];                                         //清空因數暫存陣列
        }

        $index = 0;     //由於畫table我是用兩個迴圈，所以要一個變數代表正確的數字
        echo"<table class='table table-info table-bordered .table-responsive'>";        //套用bootstrap的table格式
        for($i=0 ; $i<10 ; $i++){
            echo"<tr>";     //一列表格
            for($j=1 ; $j<=10 ; $j++){      //每10個一列
                $index = 10*$i+$j;      //到哪個數字

                if(count($primeFactorization[$index])==1)       //因數裡面只有1個，代表是質數
                echo"<td class='table-warning' onclick='isPrime(".$index.")'>$index</td>";      //質數在點擊時回應是質數
                else
                echo"<td onclick='isFactor(".$index.")'>$index</td>";       //合數在點擊時回應是合數
            }
            echo"</tr>";
        }
        echo"</table>";

      
        // ----------------分隔----------------
        // 如果只是要得到質數下面這一段就行了
        // 但我想讓合數顯示質因數分解、質數則為1和其相乘
        // 為了這個結果要將所有乘積存在陣列裡
        //$temp = range(2,100);     //做一陣列為2到100的數
        //$prime = [];              //存放篩選出質數的陣列
        //$isPrime = true;          //檢測是否為質數的flag
        // foreach($temp as $number){       //針對陣列裡每個數都做for迴圈檢查
        //     $isPrime = true;             //先預設是質數
        //     for($i=1 ; $i<=floor(sqrt($number)) ; $i++){     //每個數僅須檢測小於開根號的值是否可整除
        //         if($number % $i==0 && $i!=1){                //只要有除了1以外的值可以整除就將flag改成false
        //             $isPrime = false;
        //         }
        //     }
        //     if($isPrime)         //如果flag為true即為質數加入陣列裡
        //     $prime[] = $number;
        // }
        // ----------------分隔---------------- 
    ?>

<script>
    // 點擊函數我在這邊完成
    function isPrime(index){
        if(index==1)
        alert("不是質數也不是合數");
        else
        alert("質數");
    }

    function isFactor(index){
        var primeFactorization = <?php echo json_encode($primeFactorization) ?>;
        alert("合數\n"+primeFactorization[index].join("×"));
    }
</script>

</body>
</html>