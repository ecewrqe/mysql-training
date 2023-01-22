select * from Student;
select * from Teacher;
select * from Course;
select * from SC;
-- 学生：1赵雷、2钱电、3孙风、4李云、5周梅、6吴兰、7郑竹、8王菊
-- 先生：1张三、2李四、3王五
-- 課程：1国語、2数学、3英語
-- 問１：国語コースは数学コースより高い点数の学生情報
-- キーは(課程、学生)、国語は01, 数学は02、以下の通り
select * from SC where CID="01";
select * from SC where CID="02";
-- 人ごとに国語点数と数学点数並立して組み合わせする
select
		a.SID as SID,
		a.CID as Course1,
		a.Score as Course1_Score,
		b.CID as Course2,
		b.Score as Course2_Score
	from
		(select * from SC where CID="01") a
	inner join
		(select * from SC where CID="02") b
		on a.SID = b.SID;

-- 学生表(Student)を上の結果(Score)と並立して結果を出す
select
	student.SID as SID, 
	student.SName as SName,
	DATE_FORMAT(student.SAge, "%Y-%m-%d") as SAge,
	Score.Course1 as CID1,
	Score.Course1_score as Score1,
	Score.Course2 as CID2,
	Score.Course2_score as Score2
from
	student
inner join
	(select
		a.SId as SId,
		a.CId as Course1,
		a.score as Course1_score,
		b.CId as Course2,
		b.score as Course2_score
	from
		(select * from SC where CID="01") a
	inner join
		(select * from SC where CID="02") b
		on a.SID = b.SID) Score
	on student.SID = Score.SID
where
	Score.Course1_score > Score.Course2_score;

-- 問1.1 国語と数学両方ともに点数が存在する学生の情報
-- 問1.2 国語点数が存在するすべての学生の情報
select
		a.SID as SID,
		a.CID as Course1,
		a.Score as Course1_Score,
		b.CID as Course2,
		b.Score as Course2_Score
	from
		(select * from SC where CID="01") a
	left join
		(select * from SC where CID="02") b
		on a.SID = b.SID;
-- 結果
select
	student.SID as SID, 
	student.SName as SName,
	DATE_FORMAT(student.SAge, "%Y-%m-%d") as SAge,
	Score.Course1 as CID1,
	Score.Course1_score as Score1,
	Score.Course2 as CID2,
	Score.Course2_score as Score2
from
	student
inner join
	(select
		a.SID as SID,
		a.CID as Course1,
		a.Score as Course1_Score,
		b.CID as Course2,
		b.Score as Course2_Score
	from
		(select * from SC where CID="01") a
	left join
		(select * from SC where CID="02") b
		on a.SID = b.SID) Score
	on student.SID = Score.SID;
    
-- 数学点数だけ存在する学生情報
select
		b.SID as SID,
		a.CID as Course1,
		a.Score as Course1_Score,
		b.CID as Course2,
		b.Score as Course2_Score
	from
		(select * from SC where CID="01") a
	right join
		(select * from SC where CID="02") b
		on a.SID = b.SID;

-- 結果
select
	student.SID as SID, 
	student.SName as SName,
	DATE_FORMAT(student.SAge, "%Y-%m-%d") as SAge,
	Score.Course1 as CID1,
	Score.Course1_score as Score1,
	Score.Course2 as CID2,
	Score.Course2_score as Score2
from
	student
inner join
	(select
		b.SID as SID,
		a.CID as Course1,
		a.Score as Course1_Score,
		b.CID as Course2,
		b.Score as Course2_Score
	from
		(select * from SC where CID="01") a
	right join
		(select * from SC where CID="02") b
		on a.SID = b.SID) Score
	on student.SID = Score.SID;

-- 2. すべて課程の点数の平均値は60以上の学生情報と点数の平均値

select 
	SID, SName,
	round(avg(Score), 2) as avg_score,
    count(SName) as course_account
from
	(select
		Student.SID as SID,
		Student.SName as SName,
		SC.Score as Score
	from 
		Student 
	inner join 
		SC 
		on student.SID = SC.SID) student
group by SID
having avg_score > 60;
-- 平均点数が60以上且つすべての課程受験が受けた学生情報

select 
	SID, SName,
	round(avg(Score), 2) as avg_score,
    count(SName) as course_account
from
	(select
		Student.SID as SID,
		Student.SName as SName,
		SC.Score as Score
	from 
		Student 
	inner join 
		SC 
		on student.SID = SC.SID) student
group by SID
having avg_score > 60 and course_account = (
	select count(CID) from Course
);

-- 3. いずれ点数がある学生の情報
-- すべて学生の点数状況を絞りだす
select
		Student.SID as SID,
		Student.SName as SName,
		SC.Score as score
	from 
		Student 
		left join 
		SC 
			on student.SID = SC.SID;

-- 合併して点数のまとまりがある学生を絞りだす
select 
	SID, SName,
	round(avg(Score), 2) as avg_score,
    count(SName) as course_account
from
	(select
		Student.SID as SID,
		Student.SName as SName,
		SC.Score as Score
	from 
		Student 
	left join 
		SC 
		on student.SID = SC.SID) student
group by SID
having avg_score is not null;
-- 

-- 4. すべて学生の基本情報と受験した課程数と総点数
select
	Student.SID as SID,
	Student.SName as SName,
	(
	case
		when SC.Score is null then 0
		else
			count(Student.SID)
		end
	) as score_count,
	(
	case
		when SC.Score is null then 0
		else
			sum(SC.Score)
		end
	) as score_sum
from
	student
left join
	SC
	on student.SID = SC.SID
group by Student.SID;

-- 5 「李」先生が授かった学生の情報
select
	teacher.TName as Teacher,
    course.Cname as Course,
    student.SName as Student
from teacher
left join
	course
    on Course.TID = Teacher.TID
left join
	SC
    on SC.CID = Course.CID
left join
	Student
    on student.SID = SC.SID
where teacher.TName like '李%';

-- 6 「张三」先生の授業を受けた学生情報
select
	teacher.TName as Teacher,
    course.CName as Course,
    student.SName as Student
from
	teacher
left join
	course
	on Course.TID = Teacher.TID
left join
	SC
	on SC.CID = Course.CID
left join
	Student
	on student.SID = SC.SID
where
	teacher.Tname = '张三';
    
-- 7 課程の受験が漏れた学生情報
select
	student.SId as SId,
	student.Sname as Sname,
	(
	case
		when SC.CId is null then 0
	else 
		count(SC.SId)
	end
	) as course_count
from
	student
left join
	SC
	on SC.SId = student.SId
group by student.SId
having course_count < (select count(*) from course);

-- 8.少なくとも一つ受験した課程が01学生の受験した課程と同じ学生の情報
select
	student.SId as SId,
	student.Sname as Sname,
    student_1.CID as CID,
	date_format(student.Sage, "%Y-%m-%d") as Sage,
	SSex
from
	(select
		*
	from
		SC
	where
		SId = "01") student_1
inner join
	(select
		*
	from
		SC
	where
		SId <> "01") student_other
	on student_1.CId = student_other.CId
left join
	student
	on student_other.SId = student.SId
group by student.SId;

-- 9. 01の学生勉強した課程のすべてが同じように勉強した学生の情報
select
	student.SId as SId,
	student.Sname as Sname,
	date_format(student.Sage, "%Y-%m-%d") as Sage,
	SSex,
	count(student.SId) as score_count
from
	(select
		*
	from
		SC
	where
		SId = "01") student_1
left join
	(select
		*
	from
		SC
	where
		SId <> "01") student_other
	on student_1.CId = student_other.CId
left join
	student
	on student_other.SId = student.SId
group by student.SId
having score_count = (select count(*) from SC where SId = "01");

-- 10. 张三先生の授業が受けたことがない学生情報
-- 勉強した学生
drop view zhangsan_course_student;
create view zhangsan_course_student as select
	student.Sid as Sid,
	student.Sname as Sname
from
	student
left join
	SC
	on student.SId = SC.SId
left join
	Course
	on SC.CId = Course.CId
left join
	teacher
	on teacher.TId = Course.TId
where
	teacher.Tname = "张三";

select * from zhangsan_course_student;
-- 以外の学生
select
	sname
from
	student
where
	student.SId not in (select Sid from zhangsan_course_student);
    
-- 11. 少なくとも二つ課程が落ちた学生情報と平均点数
-- 合否判断を一列増えて0は合格、1は不合格とします
select
	student.Sid as SId,
	student.Sname as Sname,
	SC.CId as CId,
	SC.score as score,
	(
	case
		when SC.score < 60 then 1
	else
		0
	end
	) as isnot_passed
from 
	student
inner join
	SC
	on student.SId = SC.SId;
-- isnot_passedは1がある学生の平均点数を計算してから絞りだす
select
	*,
	count(
		case 
			when isnot_passed = '1' then 1 else null end
	) as not_passed_count,
	round(avg(score), 2) as score_avg
from
	(
	select
		student.Sid as SId,
		student.Sname as Sname,
		SC.CId as CId,
		SC.score as score,
		(
		case
			when SC.score < 60 then 1
		else
			0
		end
		) as isnot_passed
	from 
		student
	inner join
		SC
		on student.SId = SC.SId) student
group by SId
having isnot_passed='1';

-- 12. 国語課程の点数が60以下の学生は降順で情報を並べる
select
	*
from
	SC
left join
	student
	on SC.SId = student.SId
where
	SC.score < 60
order by score desc;


-- 13. 平均点数高い方が優先して学生の情報、課程と各課程の点数
-- すべて学生の平均点数を出しとく
select
	student.SId as SId,
    student.SName as SName,
    
	round(avg(SC.Score), 2) as score_avg
from
	student
left join
	SC
	on SC.SId = student.SId
left join
	Course
    on SC.CID = Course.CID
group by student.SId
order by score_avg desc;

-- 結果
select
	*
from
	student
left join
	SC
	on SC.SId = student.SId
left join
	Course
	on SC.CID = Course.CID
left join
	(select
		student.SId as SId,
		round(avg(SC.Score), 2)as score_avg
	from
		student
	left join
		SC
		on SC.SId = student.SId

	group by student.SId
    order by score_avg desc) average
	on student.SId = average.SId;

-- 14. 各課程の最高点、最低点と平均点数
select
	Course.CId as 'course id',
	count(SC.SId) as 'proceeded count',
	max(SC.score) as 'the best score',
	min(SC.score) as 'the worst score',
	round(avg(SC.score), 2) as 'the average score',
	round(count(
	case
		when SC.score >= 60 then 1 else NUll end
	)/count(SC.SId), 2) as 'the passed rate',
	round(count(
	case
		when SC.score >= 70 and SC.score < 80 then 1 else NUll end
	)/count(SC.SId), 2) as 'the middle rate',
	round(count(case
		when SC.score >= 80 and SC.score < 90 then 1 else NUll end
	)/count(SC.SId), 2) as 'the good rate',
	round(count(case
		when SC.score >= 90 then 1 else NUll end
	)/count(SC.SId), 2) as 'the excellent rate'
	
from
	Course
left join
	SC
	on SC.CId = Course.CId
group by Course.CId
order by count(SC.SId) desc, Course.CId asc;

-- 15. 課程を分けて学生の点数を降順で並べる
select
	*,
	rank() over(PARTITION BY SC.CId ORDER BY SC.score DESC) as score_rank
from
	course
left join
	SC
	on Course.CId=SC.CId
left join
	student
	on SC.SId = student.SId
order by SC.CId asc, SC.score desc;

-- 16. 学生の総点数を計算して学生情報を並べる
select
	*,
	rank() over(PARTITION BY SC.CId ORDER BY SC.score DESC) as score_rank
from
	course
left join
	SC
	on Course.CId=SC.CId
left join
	student
	on SC.SId = student.SId
order by SC.CId asc, SC.score desc;

-- すべて課程の点数の各段階の比率を計算する
select
	*,
	count(SC.SId) as 'persons',
	round(count(
	case
		when SC.score < 60 then 1 else null end
	)/count(SC.SId), 2) as 'lost rate',
	
	round(count(
	case
		when SC.score >= 60 and SC.score < 70 then 1 else null end
	)/count(SC.SId), 2) as 'middle rate',
	
	round(count(
	case
		when SC.score >= 70 and SC.score < 85 then 1 else null end
	)/count(SC.SId), 2) as 'good rate',
	round(count(
	case
		when SC.score >= 85 then 1 else null end
	)/count(SC.SId), 2) as 'excellent rate'
from
	course
left join
	SC
	on course.CId = SC.CId
group by course.CId;

-- 18. 各課程のトップの三位学生の情報を降順で並べる
select
	*
from 
(
select 
	Course.CId as CId,
	Course.Cname as Cname,
	SC.SId as SId,
	SC.score as score,
	student.Sname as Sname,
	row_number()over(partition by SC.CId order by SC.score desc) student_rank
from
	SC
left join
	Course
	on SC.CId=Course.CId
left join
	student
	on SC.SId=student.SId
order by SC.CId asc, SC.score desc) student
where student_rank <= 3;

-- 20.二つだけ受験が受けた学生の情報
select
	student.*,
	count(student.SId) as scount
from
	student
left join
	SC
	on student.SId = SC.SId
group by student.SId
having scount = 2;

-- 21. 男の子と女の子の人数を絞る
select 
	Ssex,
	count(Ssex) as Ssex_count,
    round(count(Ssex) / (select count(*) from student), 2)as rate
from
	student
group by Ssex;

-- 22. 名前が「风」が含んだ学生の情報
select
	*
from 
	student
where
	Sname like '%风%';
    
    
-- 23.同じ名前の学生人数
select
	SId, Sname, count(SId) as SId_count
from
	student
group by sname;

-- 24.1990年出身の学生情報
select
	*
from
	student
where
	Sage between '1990-01-01' and '1991-01-01';
    
-- 26.平均点数が85超過の学生情報と平均点数
select
	*,
	round(avg(SC.score), 2) as score_avg
from 
	student
left join 
	SC
	on SC.SId=student.SId
group by student.SId
having avg(SC.score)>85;
-- 2７. 数学の点数が60未満の学生情報と点数
select 
	*
from
	student
left join
	SC
	on SC.SId=student.SId
left join
	Course
	on Course.CId=SC.CId
where
	Course.Cname = 'math' and SC.score < 60;

-- 29. いずれ課程の点数が70点以上の学生を並べて点数を計算する
select 
	*,
	count(if(SC.score>70, 1, null)) as score_gt_70
from
	student
left join
	SC
	on SC.SId=student.SId
group by student.SId
having count(if(SC.score>70, 1, null)) > 0;

-- 30.受験が落ちた学生の点数情報
select
	*
from
	student
left join
	SC
	on SC.SId=student.SId
where
	SC.score < 60;

-- 31. 課程番号は01の点数８０以上の学生情報
select
	*
from
	student
left join
	SC
	on SC.SId=student.SId
where
	SC.score >= 80;

-- 33. 「张三」先生の授業下学生の中に成績が優勝した学生情報と点数
select
	*,
	rank()over(order by SC.score desc) as score_rank
from
	student
left join
	SC
	on SC.SId=student.SId
left join
	Course
	on Course.CId = SC.CId
left join
	Teacher
	on Teacher.TId = Course.TId
where
	Teacher.Tname = '张三'
order by SC.score desc
limit 1;

-- 35. 同じ課程の点数が同じ学生情報と点数

select *
from
	(select
		Course.CName as Course,
        SC.CID as CID, -- Course id
		SC.Score as Score,
		count(SC.Score) as score_count
	from
		student
	inner join
		SC
		on SC.SId=student.SId
	inner join
		Course
		on Course.CId = SC.CId
	group by Course.CId, SC.Score
	having score_count >= 2) Course_Score
left join
	SC
    on SC.CID = Course_Score.CID and SC.Score = Course_Score.Score
left join
	student
    on SC.SID = student.SID
;

-- 38. 少なくともalter二つ課程を授業した学生情報
select
	student.SId as SId,
	student.Sname as Sname
from
	student
inner join
	SC
	on SC.SId=student.SId
group by student.SId
having count(student.SId) >= 2;

-- 40. 学生の年齢を示す
select
	*,
	round(datediff(curdate(), Sage) / 365.0, 2) as age
from
	student;
    
-- 41. 今週は誕生日ある学生
select
	*
from 
	student
where 
	(str_to_date(
		concat_ws('-', year(curdate()), month(sage), day(sage)),
		'%Y-%m-%d'
	)) between 
		(subdate(curdate(), dayofweek(curdate()))) 
		and 
			(adddate(curdate(), 7-dayofweek(curdate())));

-- 42. 来週は誕生日である学生
-- 43. 今月誕生日の学生
select
	*
from 
	student
where 
	(str_to_date(
		concat_ws('-', year(curdate()), month(sage), day(sage)),
		'%Y-%m-%d'
	)) between 
		(subdate(curdate(), dayofmonth(curdate())-1))
		and
		(last_day(curdate()));
-- 44. 来月誕生日の学生

