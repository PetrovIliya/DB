USE lw7;

-- 1. Добавить внешние ключи.

ALTER TABLE student
ADD CONSTRAINT student_group_fk
FOREIGN KEY (group_id) REFERENCES `group`(group_id);

ALTER TABLE lesson
ADD CONSTRAINT lesson_teacher_fk
FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id);

ALTER TABLE lesson
ADD CONSTRAINT lesson_subject_fk
FOREIGN KEY (subject_id) REFERENCES subject(subject_id);

ALTER TABLE lesson
ADD CONSTRAINT lesson_group_fk
FOREIGN KEY (group_id) REFERENCES `group`(group_id);

ALTER TABLE mark
ADD CONSTRAINT mark_lesson_fk
FOREIGN KEY (lesson_id) REFERENCES lesson(lesson_id);

ALTER TABLE mark
ADD CONSTRAINT mark_student_fk
FOREIGN KEY (student_id) REFERENCES student(student_id);

-- 2. Выдать оценки студентов по информатике если они обучаются данному
-- предмету. Оформить выдачу данных с использованием view.

DROP VIEW IF EXISTS lw7.informatics_students_marks;

CREATE VIEW informatics_students_marks AS
SELECT
  st.name,
  GROUP_CONCAT(m.mark SEPARATOR ', ') 'marks'
FROM
  lesson l
  INNER JOIN subject s ON s.subject_id = l.subject_id
  INNER JOIN mark m ON m.lesson_id = l.lesson_id
  INNER JOIN student st ON st.student_id = m.student_id
WHERE
  s.name = 'Информатика'
GROUP BY
  st.student_id,
  st.name
;

-- 3. Дать информацию о должниках с указанием фамилии студента и названия
-- предмета. Должниками считаются студенты, не имеющие оценки по предмету,
-- который ведется в группе. Оформить в виде процедуры, на входе
-- идентификатор группы.

DROP PROCEDURE IF EXISTS getStudentsWithoutMarksByGroupId;
DELIMITER //
CREATE PROCEDURE getStudentsWithoutMarksByGroupId(IN groupId INT)
BEGIN
  SELECT
	(SELECT SUBSTRING_INDEX(t.name, ' ', -1) FROM student t WHERE t.student_id = st.student_id) 'student',
	(SELECT t.name FROM `subject` t WHERE t.subject_id = s.subject_id) 'subject'
  FROM 
	`group` g
	INNER JOIN lesson l ON l.group_id = g.group_id
	INNER JOIN student st ON st.group_id = g.group_id
	LEFT JOIN mark m ON m.student_id = st.student_id AND m.lesson_id = l.lesson_id
	LEFT JOIN subject AS s ON s.subject_id = l.subject_id
  WHERE
	g.group_id = groupId
  GROUP BY
   g.group_id,
   st.student_id,
   s.subject_id
  HAVING
    COUNT(m.mark_id) = 0
  ORDER BY 2
;
END //
DELIMITER ;

CALL getStudentsWithoutMarksByGroupId(1);

-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по
-- которым занимается не менее 35 студентов.

SELECT
  s.name,
  SUM(m.mark) / COUNT(m.mark) avg_mark
FROM
  lesson l
  INNER JOIN subject s ON s.subject_id = l.subject_id
  INNER JOIN `group` g ON g.group_id = l.group_id
  INNER JOIN student st ON st.group_id = g.group_id
  LEFT JOIN mark m ON m.student_id = st.student_id
GROUP BY
  s.subject_id,
  s.name
HAVING
  COUNT(DISTINCT st.student_id) >= 35
;

-- 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с
-- указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
-- значениями NULL поля оценки.

SELECT
  st.name, g.name , s.name, l.date, m.mark
FROM
  student st
  INNER JOIN `group` g ON g.group_id = st.group_id
  INNER JOIN lesson l ON l.group_id = g.group_id
  INNER JOIN `subject` s ON s.subject_id = l.subject_id
  LEFT JOIN mark m ON m.student_id = st.student_id AND m.lesson_id = l.lesson_id
WHERE
  g.name = 'ВМ'
;

-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету
-- БД до 12.05, повысить эти оценки на 1 балл.

BEGIN;

UPDATE
  mark
  INNER JOIN `group` g ON g.group_id = st.group_id
  INNER JOIN lesson l ON l.group_id = g.group_id
  INNER JOIN subject s ON s.subject_id = l.subject_id
  INNER JOIN mark m ON m.student_id = st.student_id AND m.lesson_id = l.lesson_id
SET
  mark = mark + 1  
WHERE
  s.name = 'БД'
  AND g.name = 'ПС'
  AND m.mark < 5
  AND l.date < '2019-05-12';

ROLLBACK;

-- 7. Добавить необходимые индексы.

CREATE INDEX lesson_date_ix ON lesson(date);
CREATE INDEX subject_name_ix ON subject(name);
CREATE INDEX group_name_ix ON `group`(name);

