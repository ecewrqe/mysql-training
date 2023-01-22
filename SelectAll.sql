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
