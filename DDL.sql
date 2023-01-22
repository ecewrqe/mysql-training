use SqlTraining;
drop table if exists Student;
drop table if exists Course;
drop table if exists Teacher;
drop table if exists SC;

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

-- DML
-- 学生データ
insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into Student values('08' , '王菊' , '1990-01-20' , '女');
-- 教師データ
insert into Teacher values('01' , '张三');  
insert into Teacher values('02' , '李四');  
insert into Teacher values('03' , '王五');
-- 課程データ
insert into Course values('01' , '国語' , '02');  
insert into Course values('02' , '数学' , '01');  
insert into Course values('03' , '英語' , '03');  
-- 点数データ
insert into SC values('01' , '01' , 80);  
insert into SC values('01' , '02' , 90);  
insert into SC values('01' , '03' , 99);  
insert into SC values('02' , '01' , 70);  
insert into SC values('02' , '02' , 60);  
insert into SC values('02' , '03' , 80);  
insert into SC values('03' , '01' , 80);  
insert into SC values('03' , '02' , 80);  
insert into SC values('03' , '03' , 80);  
insert into SC values('04' , '01' , 50);  
insert into SC values('04' , '02' , 30);  
insert into SC values('04' , '03' , 20);  
insert into SC values('05' , '01' , 76);  
insert into SC values('05' , '02' , 87);  
insert into SC values('06' , '01' , 31);  
insert into SC values('06' , '03' , 34);  
insert into SC values('07' , '02' , 89);  
insert into SC values('07' , '03' , 98);