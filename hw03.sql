--建資料庫(先檢查有沒有這個庫，暴力刪除)
drop database if exists iii;

create database iii;

--用iii
use iii;

---建客戶表 
create table customers (id int primary key auto_increment, name varchar(20), phone varchar(20) unique, email varchar(100), address varchar(100));

---建供應商表 
create table suppliers (id int primary key auto_increment, name varchar(20), phone varchar(20) unique,address varchar(100) );

---建商品表 
create table products (id int primary key auto_increment, serials varchar(20) unique,name varchar(20),spec text,basePrice int,sid int,foreign key (sid) references suppliers(id));

---建訂單
create table orders (id int primary key auto_increment, serials varchar(20) unique,cid int,foreign key(cid) references customers(id));

---建訂單細項 
create table orderDetails (id int primary key auto_increment, serials varchar(20),pid int,price int,quantity int,foreign key (serials) references orders(serials),foreign key (pid) references products(id));

--加客戶
\d #
create procedure addCus(in na varchar(20),ph varchar(20),em varchar(100),addr varchar(20)) 
begin
   insert into customers (name,phone,email,address) values (na,ph,em,addr);
end #
\d ;

--刪客戶
\d #
create procedure delCus(in cid int) 
begin
   delete from customers where id=cid;
end #
\d ;

--修客戶
\d #
create procedure altCus(in cid varchar(20),na2 varchar(20),ph2 varchar(20),em2 varchar(100),addr2 varchar(100)) 
begin
   update customers set name=na2,phone=ph2,email=em2,address=addr2 where id=cid;
end #
\d ;

--查客戶
\d #
create procedure inquireCus(in na varchar(20),ph varchar(20)) 
begin
   IF na="" THEN select * from customers where phone like concat('%',ph,'%');
   ELSEIF ph="" THEN select * from customers where name like concat('%',na,'%');
   ELSE select * from customers where name like concat('%',na,'%') and phone like concat('%',ph,'%');
   END IF;
end #
\d ;

--加供應商
\d #
create procedure addSup(in na varchar(20),ph varchar(20),addr varchar(100)) 
begin
   insert into suppliers (name,phone,address) values (na,ph,addr);
end #
\d ;

--刪供應商
\d #
create procedure delSup(in sid int) 
begin
   delete from suppliers where id =sid;
end #
\d ;

--修供應商
\d #
create procedure altSup(in sid varchar(20),na2 varchar(20),ph2 varchar(20),addr2 varchar(100)) 
begin
   update suppliers set name=na2,phone=ph2,address=addr2 where id=sid;
end #
\d ;

--查供應商
\d #
create procedure inquireSup(in na varchar(20),ph varchar(20)) 
begin
   IF na="" THEN select * from suppliers where phone like concat('%',ph,'%');
   ELSEIF ph="" THEN select * from suppliers where name like concat('%',na,'%');
   ELSE select * from suppliers where name like concat('%',na,'%') and phone like concat('%',ph,'%');
   END IF;
end #
\d ;

--加商品
\d #
create procedure addPro(in se varchar(20),na varchar(20),sp text,baseP int,id int) 
begin
   insert into products (serials,name,spec,basePrice,sid) values (se,na,sp,baseP,id);
end #
\d ;

--刪商品
\d #
create procedure delPro(in se varchar(20)) 
begin
   delete from products where serials =se;
end #
\d ;

--修商品
\d #
create procedure altPro(in se varchar(20),se2 varchar(20),na2 varchar(20),sp2 text,baseP int,id int) 
begin
   update products set serials=se2,name=na2,spec=sp2, basePrice=baseP,sid=id where serials=se;
end #
\d ;

--查商品
\d #
create procedure inquirePro(in se varchar(20),na varchar(20)) 
begin
   IF na="" THEN select * from products where serials like concat('%',se,'%');
   ELSEIF se="" THEN select * from products where name like concat('%',na,'%');
   ELSE select * from products where serials like concat('%',se,'%') and name like concat('%',na,'%');
   END IF;
end #
\d ;

--加訂單
\d #
create procedure addOrders(in se varchar(20),id int) 
begin
   insert into orders (serials,cid) values (se,id);
end #
\d ;

--刪訂單
\d #
create procedure delOrders(in se varchar(20)) 
begin
   delete from orders where serials =se;
end #
\d ;

--加訂單細項
\d #
create procedure addOD(in se varchar(20),id int,pr int,qu int) 
begin
   insert into orderDetails (serials,pid,price,quantity) values (se,id,pr,qu);
end #
\d ;

--刪訂單
\d #
create procedure delOD(in odid int) 
begin
   delete from orderDetails where id =odid;
end #
\d ;

--修訂單細項
\d #
create procedure altOD(in odid int,pr2 int,qu2 int) 
begin
   update orderDetails set price=pr2, quantity=qu2 where id=odid;
end #
\d ;

----綜合查詢
--指定客戶查訂單含名細 <由於客戶名稱可重複所以用ID查詢>
\d #
create procedure useCusFindOrders(in id int) 
begin
   select o.serials,o.cid,od.pid,od.price,od.quantity from orders as o join orderDetails as od on o.serials = od.serials where o.cid = id;
end #
\d ;

--指定客戶查訂單總金額 <同上個查詢用ID查>
\d #
create procedure useCusFindOrdersTotal(in id int) 
begin
   select o.serials,o.cid,sum(od.price * od.quantity) as TotalMoney from orders as o join orderDetails as od on o.serials = od.serials where o.cid = id group by o.cid;
end #
\d ;

--指定商品查訂單中客戶 <由於orderdetail裡面沒有客戶ID，所以要有4張表互相JOIN>
\d #
create procedure useProFindCusInOrders(in serials varchar(20)) 
begin
   select c.id as customerID, c.name,p.serials as proSerials,od.price,od.quantity from orderDetails as od join orders as o on od.serials = o.serials 
   join customers as c on o.cid = c.id join products as p on od.pid=p.id where p.serials = serials; 
end #
\d ;

--指定供應商查詢訂單中的商品清單 <同客戶，用ID查詢>
\d #
create procedure useSupFindProInOrders(in id int) 
begin
   select s.id,s.name,od.serials as orderSerials,p.serials as proSerials,p.name from products as p join suppliers as s on p.sid = s.id join orderDetails as od on p.id = od.pid where s.id = id;
end #
\d ;


--基本資料匯入
insert into customers (name,phone,email,address) values 
("Alan","0938471823","ji3@yahoo.com.tw","Taipei"),
("Brian","0986730917","g4@yahoo.com.tw","Taoyuan"),
("Clerk","0933857111","go6@yahoo.com.tw","Hsinchu"),
("David","0965888472","wu0@yahoo.com.tw","Taipei"),
("Evan","0977341246","g3@yahoo.com.tw","Taichung"),
("Famila","0987654321","m3@yahoo.com.tw","Tainan"),
("Gorilla","0922314987","ai6@yahoo.com.tw","Taitung"),
("Hermes","0934861222","ejo3@yahoo.com.tw","Hualien"),
("Ivy","0975817244","fortune@yahoo.com.tw","Kaoshiung"),
("Jungle","0973291738","farm@yahoo.com.tw","Taoyuan");

insert into suppliers (name,phone,address) values
("Kami","0927391822","Taipei"),
("Lawson","0911249501","Taichung"),
("Mcdownload","0987987987","Kaoshiung"),
("Mac","0935412342","Tainan"),
("Noch","0975618374","Taitung");

insert into products (serials, name, spec, basePrice, sid) values
("P001","sign","god", 50, 1),
("P002","microfood","notGood", 80, 2),
("P003","frenchFries","delicious", 52, 3),
("P004","chicken","fourlegs", 80, 3),
("P005","cleanser","cleanBody", 100, 4),
("P006","lotion","smoother", 120, 4),
("P007","masque","beautifyFace", 200, 4),
("P008","chop","chineseUtility", 30, 5),
("P009","mop","cleanFloor", 25, 5),
("P010","slippers","useItWalk", 40, 5);

insert into orders (serials, cid) values
("O001",9),
("O002",2),
("O003",8),
("O004",10),
("O005",4),
("O006",5),
("O007",3),
("O008",1),
("O009",7),
("O010",6);

insert into orderDetails (serials,pid,price,quantity) values 
("O002",10,37,9),
("O007",1,44,7),
("O002",9,15,16),
("O005",8,34,6),
("O005",5,107,4),
("O004",2,75,16),
("O002",4,70,10),
("O003",8,28,11),
("O008",2,74,1),
("O007",5,104,6),
("O010",2,79,19),
("O003",6,96,9),
("O010",10,32,3),
("O008",6,102,18),
("O003",9,25,14),
("O003",3,60,9),
("O006",5,97,5),
("O010",2,86,19),
("O009",6,119,12),
("O007",4,88,1),
("O001",1,45,13),
("O002",1,59,4),
("O007",6,108,15),
("O006",1,50,15),
("O010",10,45,10),
("O009",4,87,1),
("O006",7,192,12),
("O010",10,46,11),
("O003",5,94,7),
("O006",6,98,15),
("O003",1,41,2),
("O009",1,50,8),
("O006",6,101,9),
("O009",2,81,1),
("O005",5,91,9),
("O010",8,32,4),
("O005",1,48,8),
("O003",5,110,20),
("O002",2,71,13);
