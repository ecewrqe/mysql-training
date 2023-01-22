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
１ 国語コースは数学コースより高い点数の学生情報
1.1 国語と数学両方ともに点数が存在する学生の情報
1.2 国語点数が存在するすべての学生の情報
1.3 数学点数だけ存在する学生情報
2 すべて課程の点数の平均値は60以上の学生情報と点数の平均値
2.1 平均点数が60以上且つすべての課程受験が受けた学生情報
3. いずれ点数がある学生の情報
4. すべて学生の基本情報と受験した課程数と総点数
5 「李」先生が授かった学生の情報
6 「张三」先生の授業を受けた学生情報
7 課程の受験が漏れた学生情報
8.少なくとも一つ受験した課程が01学生の受験した課程と同じ学生の情報

## 答案
参照：Answer.sql

