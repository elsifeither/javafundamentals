#create database
CREATE DATABASE kursova;
USE kursova;

#create table exams_info
CREATE TABLE exams_info (
id_exam INT PRIMARY KEY AUTO_INCREMENT,
name_exam VARCHAR(55),
date_start DATE,
session ENUM('winter session','summer session'),
average_mark DECIMAL (9,2)
);


#create table school_disciplines
CREATE TABLE school_disciplines (
id_discipline INT PRIMARY KEY AUTO_INCREMENT,
name_subject VARCHAR (55),
date_start_point DATE
);

#create table students
CREATE TABLE students (
id_student INT PRIMARY KEY AUTO_INCREMENT,
name_student VARCHAR (55),
faculty_number INT,
group_number INT,
course INT
);

ALTER TABLE students
ADD COLUMN success_in_percentage INT AFTER course;

#creating list of teachers
CREATE TABLE teachers (
id_teacher INT PRIMARY KEY AUTO_INCREMENT,
name_teacher VARCHAR(55)
);

CREATE TABLE  teachers_school_disciplines(
id_discipline INT,
CONSTRAINT FOREIGN KEY (id_discipline) REFERENCES school_disciplines(id_discipline),
id_teacher INT,
CONSTRAINT FOREIGN KEY (id_teacher) REFERENCES teachers(id_teacher),
PRIMARY KEY (id_discipline,id_teacher)
);


#creating M:M exam/students and students/exam
CREATE TABLE exams_students (
id_exam INT,
CONSTRAINT FOREIGN KEY (id_exam) REFERENCES exams_info(id_exam),
id_student INT,
CONSTRAINT FOREIGN KEY (id_student) REFERENCES students(id_student),
PRIMARY KEY(id_exam, id_student)
);

#creating M:M school_disciplines/students and students/school_disciplines
CREATE TABLE school_disciplines_students (
id_discipline INT,
CONSTRAINT FOREIGN KEY (id_discipline) REFERENCES school_disciplines(id_discipline),
id_student INT,
CONSTRAINT FOREIGN KEY (id_student) REFERENCES students(id_student),
PRIMARY KEY(id_discipline, id_student)
);

#2.Напишете заявка, в която демонстрирате SELECT с ограничаващо условие по избор.
SELECT * FROM students
WHERE group_number = 49;
 
#3.Напишете заявка, в която използвате агрегатна функция и GROUP BY по ваш избор.
SELECT name_exam, COUNT(id_exam) AS countOfExams FROM exams_info
GROUP BY name_exam;

#4. Напишете заявка, в която демонстрирате INNER JOIN по ваш избор.
SELECT s.*, e.name_exam FROM students AS s
JOIN exams_info AS e ON id_student;

#5. Напишете заявка, в която демонстрирате OUTER JOIN по ваш избор.
SELECT s.*, t.name_teacher  FROM school_disciplines AS s
LEFT JOIN teachers AS t ON id_teacher;


#6. Напишете заявка, в която демонстрирате вложен SELECT по ваш избор.
SELECT s.name_student, s.faculty_number, sd.name_subject, t.name_teacher FROM students AS s
JOIN school_disciplines AS sd ON id_discipline
JOIN teachers AS t ON id_teacher;

#7.Напишете заявка, в която демонстрирате едновременно JOIN и агрегатна функция.
SELECT s.group_number, MIN(e.average_mark) AS MinimalAverageMark FROM students AS s
JOIN exams_info AS e ON id_student
GROUP BY group_number;

#8.Създайте тригер по ваш избор.
CREATE TRIGGER students_success_in_percentage_update
BEFORE UPDATE ON students
FOR EACH ROW
SET NEW.success_in_percentage = (NEW.success_in_percentage+10);

UPDATE students
SET success_in_percentage = success_in_percentage -15
WHERE group_number = 49 AND success_in_percentage > 50;

#9.Създайте процедура, в която демонстрирате използване на курсор.

DELIMITER //

CREATE PROCEDURE calculate_success(IN p_course INT, IN p_group INT)
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE total_marks DECIMAL(9,2);
DECLARE student_count INT;
DECLARE current_mark DECIMAL(9,2);
DECLARE current_id_student INT;


DECLARE cur CURSOR FOR 
    SELECT average_mark FROM exams_info 
    JOIN exams_students ON exams_info.id_exam = exams_students.id_exam 
    WHERE id_student = current_id_student;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

SELECT COUNT(*) INTO student_count FROM students 
WHERE course = p_course AND group_number = p_group;

SELECT SUM(success_in_percentage) INTO total_marks FROM students 
WHERE course = p_course AND group_number = p_group;

IF student_count = 0 THEN
    SELECT 'No students found in this course and group.' AS message;
ELSE
    OPEN cur;
    student_loop: LOOP
        FETCH cur INTO current_mark;
        
        IF done THEN
            LEAVE student_loop;
        END IF;
        
        SET total_marks = total_marks + current_mark;
    END LOOP;
    CLOSE cur;
    
    SELECT CONCAT('The average success of the students in course ', p_course, ', group ', p_group, ' is ', total_marks/student_count) AS message;
END IF;



END //
DELIMITER ;




#info into students
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('1', 'Иван Иванов', '501221001', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('2', 'Андрей Ляпчев', '501221002', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('3', 'Георги Патилов', '501221003', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('4', 'Иван Иванов', '501221004', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('5', 'Георги Иванов', '501221005', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('6', 'Ангел Бараков', '501221006', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('7', 'Иван Стоев', '501221007', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('8', 'Йордан Андреев', '501221008', '49', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('9', 'Олег Филипов', '501221009', '48', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('10', 'Иво Илиев', '501221010', '48', '2');
INSERT INTO `kursova`.`students` (`id_student`, `name_student`, `faculty_number`, `group_number`, `course`) VALUES ('11', 'Божидар Кирилов', '501221011', '48', '2');

#info into exams_students
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('2', '1');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('2', '2');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('2', '3');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('2', '4');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('2', '5');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('2', '6');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('1', '7');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('1', '8');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('1', '9');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('1', '10');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('3', '1');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('3', '2');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('3', '3');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('3', '4');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('4', '1');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('4', '2');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('4', '3');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('4', '4');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('5', '11');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('5', '10');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('5', '9');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('5', '4');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('6', '3');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('6', '2');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('6', '6');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('6', '7');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('7', '2');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('7', '3');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('7', '4');
INSERT INTO `kursova`.`exams_students` (`id_exam`, `id_student`) VALUES ('7', '8');







