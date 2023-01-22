# sql training
## テーブルを作る：学生、先生、課程、点数

create table Student(
	`SID` int not null auto_increment comment '学生番号',
	`SName` varchar(16) not null comment '学生名前',
	`SAge` date comment '生年月日',
	`SSex` char(2) comment '性別',
    constraint `PK_SID` primary key (`SID`),
	constraint `SSex_CHK` check (`SSex` in('男', '女'))
);


create table Teacher(
	`TID` int not null auto_increment comment '教師番号',
	`TName` varchar(16) not null comment '教師名前',
    constraint `PK_TID` primary key (`TId`)
);


create table Course(
	`CID` int not null auto_increment comment '課程番号',
	`CName` varchar(16) not null comment '課程',
	`TID` int comment '教師名前',
	constraint `PK_CID` primary key (`CID`),
	constraint `FK_Teacher` foreign key (`TID`) references Teacher(`TID`)
);


create table SC(
	`SID` int not null comment '学生番号',
	`CID` int not null comment '課程番号',
	`Score` int comment '点数',
	constraint `S_C_ID` primary key (`SID`, `CID`)
);

データー内容、参照：DDL.sql
## 問題集
1. 国語コースは数学コースより高い点数の学生情報
- 国語と数学両方ともに点数が存在する学生の情報
- 国語点数が存在するすべての学生の情報
- 数学点数だけ存在する学生情報
2 すべて課程の点数の平均値は60以上の学生情報と点数の平均値
- 平均点数が60以上且つすべての課程受験が受けた学生情報
3. いずれ点数がある学生の情報
4. すべて学生の基本情報と受験した課程数と総点数
5. 「李」先生が授かった学生の情報
6. 「张三」先生の授業を受けた学生情報
7. 課程の受験が漏れた学生情報
8. 少なくとも一つ受験した課程が01学生の受験した課程と同じ学生の情報
9. 01の学生勉強した課程のすべてが同じように勉強した学生の情報
10. 张三先生の授業が受けたことがない学生情報
11. 少なくとも二つ課程が落ちた学生情報と平均点数
12. 国語課程の点数が60以下の学生は降順で情報を並べる
13. 平均点数高い方が優先して学生の情報、課程と各課程の点数
14. 各課程の最高点、最低点と平均点数
15. 課程を分けて学生の点数を降順で並べる
16. 学生の総点数を計算して学生情報を並べる
18. 各課程のトップの三位学生の情報を降順で並べる
20. 二つだけ受験が受けた学生の情報
21. 男の子と女の子の人数を絞る
22. 名前が「风」が含んだ学生の情報
23. 同じ名前の学生人数
24. 1990年出身の学生情報
26. 平均点数が85超過の学生情報と平均点数
27. 数学の点数が60未満の学生情報と点数
29. いずれ課程の点数が70点以上の学生を並べて点数を計算する
30. 受験が落ちた学生の点数情報
31. 課程番号は01の点数８０以上の学生情報
33. 「张三」先生の授業下学生の中に成績が優勝した学生情報と点数
35. 同じ課程の点数が同じ学生情報と点数
38. 少なくともalter二つ課程を授業した学生情報
40. 学生の年齢を示す
41. 今週は誕生日ある学生
42. 来週は誕生日である学生
43. 今月誕生日の学生
44. 来月誕生日の学生

## 答案
参照：Answer.sql

