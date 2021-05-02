CREATE EXTENSION pgcrypto;

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS 
'BEGIN
  NEW.modified_at = NOW();
  RETURN NEW;
END;'
LANGUAGE plpgsql;

CREATE TABLE branch (
  branchid serial primary key not null,
  branchname text unique not null
);

-- INSERT INTO branch (branchname)
-- VALUES
--   ('B.Tech IT'),
--   ('B.Tech ECE'),
--   ('B.Tech IT-BI');

CREATE TABLE course (
  courseid serial primary key not null,
  coursename text not null
);

-- INSERT INTO course (coursename)
-- VALUES
--   ('Engineering Physics'),
--   ('Linear Algebra'),
--   ('Introduction to Programming'),
--   ('Fundamentals of Electrical & Electronics Engg'),
--   ('Professional Communication'),
--   ('Principles of Management'),
--   ('Discrete Mathematical Structures'),
--   ('Univariate and Multivariate Calculus'),
--   ('Computer Organization and Architecture'),
--   ('Data Structures'),
--   ('Principles of Communication Engineering'),
--   ('Principles of Economics'),
--   ('Probability and Statistics'),
--   ('Theory of Computation'),
--   ('Object Oriented Methodologies'),
--   ('Operating System'),
--   ('Introduction to Finance'),
--   ('Introduction to Marketing'),
--   ('Design and Analysis of Algorithms'),
--   ('Principles of Programming Language'),
--   ('Database Management System'),
--   ('Computer Networks'),
--   ('Software Engineering'),
--   ('Network Security'),
--   ('Graphics and Visual Computing'),
--   ('Introduction to Machine Learning'),
--   ('Image and Video Processing'),
--   ('Artificial Intelligence'),
--   ('Mini Project - I'),
--   ('Data Mining'),
--   ('Mini Project - II'),
--   ('Elective 1'),
--   ('Elective 2'),
--   ('Elective 3'),
--   ('Mini Project III'),
--   ('Elective 4'),
--   ('Elective 5'),
--   ('Project'),
--   ('Elective'),
--   ('Digital System Design'),
--   ('Electronic Devices and Circuits'),
--   ('Electromagnetic Field and Waves'),
--   ('Electronic Workshop'),
--   ('Analog Communication'),
--   ('Analog Electronics'),
--   ('Electrical Engineering'),
--   ('Electronics Measurement and Instrumentation'),
--   ('Micro Processor Interface and Programming'),
--   ('Discrete Time Signals'),
--   ('Control Systems'),
--   ('Digital IC Design'),
--   ('Integrated Circuit Technology'),
--   ('Antenna and Wave Propogation'),
--   ('Digital Communication'),
--   ('Embedded System Design'),
--   ('Microwave Engineering'),
--   ('SMT Workshop'),
--   ('Power Electronics'),
--   ('Digital Signal Processing'),
--   ('Optical Communication'),
--   ('Principles of Wireless Communication'),
--   ('Mini Project'),
--   ('Minor Project'),
--   ('Major Project');

CREATE TABLE admin (
  adminid serial primary key not null,
  email text unique not null,
  password text not null
);

-- INSERt INTO admin (email, password)
-- VALUES
--   ('director@iiita.ac.in', crypt('director@iiita.ac.in', gen_salt('bf'))),
--   ('hod.it@iiita.ac.in', crypt('hod.it@iiita.ac.in', gen_salt('bf'))),
--   ('gymkhana@iiita.ac.in', crypt('gymkhana@iiita.ac.in', gen_salt('bf'))),
--   ('adean.aaa@iiita.ac.in', crypt('adean.aaa@iiita.ac.in', gen_salt('bf'))),
--   ('cow@iiita.ac.in', crypt('cow@iiita.ac.in', gen_salt('bf')));
    
CREATE TABLE faculty (
  facultyid serial primary key not null,
  email text unique not null,
  password text not null,
  name text not null,
);

-- INSERT INTO faculty (email, password, name, courseid)
-- VALUES
--   ('1@iiita.ac.in', crypt('1@iiita.ac.in', gen_salt('bf')), '1'),
--   ('2@iiita.ac.in', crypt('2@iiita.ac.in', gen_salt('bf')), '2'),
--   ('3@iiita.ac.in', crypt('3@iiita.ac.in', gen_salt('bf')), '3'),
--   ('4@iiita.ac.in', crypt('4@iiita.ac.in', gen_salt('bf')), '4'),
--   ('5@iiita.ac.in', crypt('5@iiita.ac.in', gen_salt('bf')), '5'),
--   ('6@iiita.ac.in', crypt('6@iiita.ac.in', gen_salt('bf')), '6'),
--   ('7@iiita.ac.in', crypt('7@iiita.ac.in', gen_salt('bf')), '7'),
--   ('8@iiita.ac.in', crypt('8@iiita.ac.in', gen_salt('bf')), '8'),
--   ('9@iiita.ac.in', crypt('9@iiita.ac.in', gen_salt('bf')), '9'),
--   ('10@iiita.ac.in', crypt('10@iiita.ac.in', gen_salt('bf')), '10'),
--   ('11@iiita.ac.in', crypt('11@iiita.ac.in', gen_salt('bf')), '11'),
--   ('12@iiita.ac.in', crypt('12@iiita.ac.in', gen_salt('bf')), '12'),
--   ('13@iiita.ac.in', crypt('13@iiita.ac.in', gen_salt('bf')), '13'),
--   ('14@iiita.ac.in', crypt('14@iiita.ac.in', gen_salt('bf')), '14'),
--   ('15@iiita.ac.in', crypt('15@iiita.ac.in', gen_salt('bf')), '15'),
--   ('16@iiita.ac.in', crypt('16@iiita.ac.in', gen_salt('bf')), '16'),
--   ('17@iiita.ac.in', crypt('17@iiita.ac.in', gen_salt('bf')), '17'),
--   ('18@iiita.ac.in', crypt('18@iiita.ac.in', gen_salt('bf')), '18'),
--   ('rkala@iiita.ac.in', crypt('rkala@iiita.ac.in', gen_salt('bf')), 'Rahul Kala'),
--   ('anshu@iiita.ac.in', crypt('anshu@iiita.ac.in', gen_salt('bf')), 'Anshu Anand'),
--   ('anjaligautam@iiita.ac.in', crypt('anjaligautam@iiita.ac.in', gen_salt('bf')), 'Anjali Gautam'),
--   ('sverma@iiita.ac.in', crypt('sverma@iiita.ac.in', gen_salt('bf')), 'Shekhar Verma'),
--   ('jkokila@iiita.ac.in', crypt('jkokila@iiita.ac.in', gen_salt('bf')), 'J. Kokila'),
--   ('24@iiita.ac.in', crypt('24@iiita.ac.in', gen_salt('bf')), '24'),
--   ('25@iiita.ac.in', crypt('25@iiita.ac.in', gen_salt('bf')), '25'),
--   ('26@iiita.ac.in', crypt('26@iiita.ac.in', gen_salt('bf')), '26'),
--   ('27@iiita.ac.in', crypt('27@iiita.ac.in', gen_salt('bf')), '27'),
--   ('28@iiita.ac.in', crypt('28@iiita.ac.in', gen_salt('bf')), '28'),
--   ('29@iiita.ac.in', crypt('29@iiita.ac.in', gen_salt('bf')), '29'),
--   ('30@iiita.ac.in', crypt('30@iiita.ac.in', gen_salt('bf')), '30'),
--   ('31@iiita.ac.in', crypt('31@iiita.ac.in', gen_salt('bf')), '31'),
--   ('32@iiita.ac.in', crypt('32@iiita.ac.in', gen_salt('bf')), '32'),
--   ('33@iiita.ac.in', crypt('33@iiita.ac.in', gen_salt('bf')), '33'),
--   ('34@iiita.ac.in', crypt('34@iiita.ac.in', gen_salt('bf')), '34'),
--   ('35@iiita.ac.in', crypt('35@iiita.ac.in', gen_salt('bf')), '35'),
--   ('36@iiita.ac.in', crypt('36@iiita.ac.in', gen_salt('bf')), '36'),
--   ('37@iiita.ac.in', crypt('37@iiita.ac.in', gen_salt('bf')), '37'),
--   ('38@iiita.ac.in', crypt('38@iiita.ac.in', gen_salt('bf')), '38'),
--   ('39@iiita.ac.in', crypt('39@iiita.ac.in', gen_salt('bf')), '39'),
--   ('40@iiita.ac.in', crypt('40@iiita.ac.in', gen_salt('bf')), '40'),
--   ('41@iiita.ac.in', crypt('41@iiita.ac.in', gen_salt('bf')), '41'),
--   ('42@iiita.ac.in', crypt('42@iiita.ac.in', gen_salt('bf')), '42'),
--   ('43@iiita.ac.in', crypt('43@iiita.ac.in', gen_salt('bf')), '43'),
--   ('44@iiita.ac.in', crypt('44@iiita.ac.in', gen_salt('bf')), '44'),
--   ('45@iiita.ac.in', crypt('45@iiita.ac.in', gen_salt('bf')), '45'),
--   ('46@iiita.ac.in', crypt('46@iiita.ac.in', gen_salt('bf')), '46'),
--   ('47@iiita.ac.in', crypt('47@iiita.ac.in', gen_salt('bf')), '47'),
--   ('48@iiita.ac.in', crypt('48@iiita.ac.in', gen_salt('bf')), '48'),
--   ('49@iiita.ac.in', crypt('49@iiita.ac.in', gen_salt('bf')), '49'),
--   ('50@iiita.ac.in', crypt('50@iiita.ac.in', gen_salt('bf')), '50'),
--   ('51@iiita.ac.in', crypt('51@iiita.ac.in', gen_salt('bf')), '51'),
--   ('52@iiita.ac.in', crypt('52@iiita.ac.in', gen_salt('bf')), '52'),
--   ('53@iiita.ac.in', crypt('53@iiita.ac.in', gen_salt('bf')), '53'),
--   ('54@iiita.ac.in', crypt('54@iiita.ac.in', gen_salt('bf')), '54'),
--   ('55@iiita.ac.in', crypt('55@iiita.ac.in', gen_salt('bf')), '55'),
--   ('56@iiita.ac.in', crypt('56@iiita.ac.in', gen_salt('bf')), '56'),
--   ('57@iiita.ac.in', crypt('57@iiita.ac.in', gen_salt('bf')), '57'),
--   ('58@iiita.ac.in', crypt('58@iiita.ac.in', gen_salt('bf')), '58'),
--   ('59@iiita.ac.in', crypt('59@iiita.ac.in', gen_salt('bf')), '59'),
--   ('60@iiita.ac.in', crypt('60@iiita.ac.in', gen_salt('bf')), '60'),
--   ('61@iiita.ac.in', crypt('61@iiita.ac.in', gen_salt('bf')), '61'),
--   ('62@iiita.ac.in', crypt('62@iiita.ac.in', gen_salt('bf')), '62'),
--   ('63@iiita.ac.in', crypt('63@iiita.ac.in', gen_salt('bf')), '63'),
--   ('64@iiita.ac.in', crypt('64@iiita.ac.in', gen_salt('bf')), '64');

CREATE TABLE faculty_course (
  facultyid int references faculty (facultyid) on update cascade on delete cascade,
  courseid int references course (courseid) on update cascade on delete cascade
)

-- INSERT INTO faculty_course
-- VALUES
--   ('1', '1'),
--   ('2', '2'),
--   ('3', '3'),
--   ('4', '4'),
--   ('5', '5'),
--   ('6', '6'),
--   ('7', '7'),
--   ('8', '8'),
--   ('9', '9'),
--   ('10', '10'),
--   ('11', '11'),
--   ('12', '12'),
--   ('13', '13'),
--   ('14', '14'),
--   ('15', '15'),
--   ('16', '16'),
--   ('17', '17'),
--   ('18', '18'),
--   ('19', '19'),
--   ('20', '20'),
--   ('21', '21'),
--   ('22', '22'),
--   ('23', '23'),
--   ('24', '24'),
--   ('25', '25'),
--   ('26', '26'),
--   ('27', '27'),
--   ('28', '28'),
--   ('29', '29'),
--   ('30', '30'),
--   ('31', '31'),
--   ('32', '32'),
--   ('33', '33'),
--   ('34', '34'),
--   ('35', '35'),
--   ('36', '36'),
--   ('37', '37'),
--   ('38', '38'),
--   ('39', '39'),
--   ('40', '40'),
--   ('41', '41'),
--   ('42', '42'),
--   ('43', '43'),
--   ('44', '44'),
--   ('45', '45'),
--   ('46', '46'),
--   ('47', '47'),
--   ('48', '48'),
--   ('49', '49'),
--   ('50', '50'),
--   ('51', '51'),
--   ('52', '52'),
--   ('53', '53'),
--   ('54', '54'),
--   ('55', '55'),
--   ('56', '56'),
--   ('57', '57'),
--   ('58', '58'),
--   ('59', '59'),
--   ('60', '60'),
--   ('61', '61'),
--   ('62', '62'),
--   ('63', '63'),
--   ('64', '64'),
--   ('66', '6');

CREATE TABLE student (
  studentid serial primary key not null,
  enroll text unique not null,
  email text unique not null, 
  password text not null,
  name text not null,
  branchid int references branch (branchid) on update cascade on delete cascade,
  year int check(year > 1999) not null
);
    
-- INSERT INTO student (enroll, email, password, name, branchid, year)
-- VALUES
--   ('iit2019009', 'iit2019009@iiita.ac.in', crypt('iit2019009@iiita.ac.in', gen_salt('bf')), 'Aditya Prakash', '1', '2019'),
--   ('iit2019010', 'iit2019010@iiita.ac.in', crypt('iit2019010@iiita.ac.in', gen_salt('bf')), 'Akshat Baranwal', '1', '2019'),
--   ('iit2019015', 'iit2019015@iiita.ac.in', crypt('iit2019015@iiita.ac.in', gen_salt('bf')), 'Akash Anand', '1', '2019'),
--   ('iit2019019', 'iit2019019@iiita.ac.in', crypt('iit2019019@iiita.ac.in', gen_salt('bf')), 'Biswajeet Das', '1', '2019'),
--   ('iec2019010', 'iec2019010@iiita.ac.in', crypt('iec2019010@iiita.ac.in', gen_salt('bf')), 'Tejas', '2', '2019'),
--   ('iec2019011', 'iec2019011@iiita.ac.in', crypt('iec2019011@iiita.ac.in', gen_salt('bf')), 'Pranshu', '2', '2019');

CREATE TABLE branch_sem (
  branchsemid serial primary key not null, 
  branchid int references branch (branchid) on update cascade on delete cascade,
  sem int not null
);

-- INSERT INTO branch_sem (branchid, sem)
-- VALUES
--   ('1', '1'),
--   ('1', '2'),
--   ('1', '3'),
--   ('1', '4'),
--   ('1', '5'),
--   ('1', '6'),
--   ('1', '7'),
--   ('1', '8'),
--   ('2', '1'),
--   ('2', '2'),
--   ('2', '3'),
--   ('2', '4'),
--   ('2', '5'),
--   ('2', '6'),
--   ('2', '7'),
--   ('2', '8');
  
CREATE TABLE branch_course (
  branchsemid int references branch_sem (branchsemid) on update cascade on delete cascade,
  courseid int references course (courseid) on update cascade on delete cascade,
  primary key (branchsemid, courseid)
);
    
-- INSERT INTO branch_course
-- VALUES
--   ('1', '1'),
--   ('1', '2'),
--   ('1', '3'),
--   ('1', '4'),
--   ('1', '5'),
--   ('1', '6'),
--   ('2', '7'),
--   ('2', '8'),
--   ('2', '9'),
--   ('2', '10'),
--   ('2', '11'),
--   ('2', '12'),
--   ('3', '13'),
--   ('3', '14'),
--   ('3', '15'),
--   ('3', '16'),
--   ('3', '17'),
--   ('3', '18'),
--   ('4', '19'),
--   ('4', '20'),
--   ('4', '21'),
--   ('4', '22'),
--   ('4', '23'),
--   ('5', '24'),
--   ('5', '25'),
--   ('5', '26'),
--   ('5', '27'),
--   ('5', '28'),
--   ('5', '29'),
--   ('6', '30'),
--   ('6', '31'),
--   ('6', '32'),
--   ('6', '33'),
--   ('6', '34'),
--   ('7', '35'),
--   ('7', '36'),
--   ('7', '37'),
--   ('8', '38'),
--   ('8', '39'),
--   ('9', '1'),
--   ('9', '2'),
--   ('9', '3'),
--   ('9', '4'),
--   ('9', '5'),
--   ('9', '6'),
--   ('10', '8'),
--   ('10', '40'),
--   ('10', '9'),
--   ('10', '41'),
--   ('10', '42'),
--   ('10', '43'),
--   ('11', '44'),
--   ('11', '45'),
--   ('11', '46'),
--   ('11', '47'),
--   ('11', '48'),
--   ('11', '13'),
--   ('12', '49'),
--   ('12', '50'),
--   ('12', '51'),
--   ('12', '52'),
--   ('12', '53'),
--   ('12', '16'),
--   ('13', '54'),
--   ('13', '22'),
--   ('13', '55'),
--   ('13', '56'),
--   ('13', '57'),
--   ('13', '58'),
--   ('14', '59'),
--   ('14', '60'),
--   ('14', '61'),
--   ('14', '32'),
--   ('14', '33'),
--   ('14', '62'),
--   ('15', '63'),
--   ('15', '34'),
--   ('15', '36'),
--   ('16', '64'),
--   ('16', '37');
  
CREATE TABLE admin_faculty (
  id serial primary key not null,
  facultyid int references faculty (facultyid) on update cascade on delete cascade,
  type text not null check ( type = 'opinion' or type = 'request' or type = 'query' ),
  subject text not null,
  body text not null,
  created_at timestamptz not null default now(),
  modified_at timestamptz not null default now()
);

-- INSERT INTO admin_faculty (facultyid, type, subject, body)
-- VALUES
--   ('19', 'opinion', 'Plea For More Contests', 'Bachhoon ki gand maarni hai thoda aur contest rakh lete hain kya kehte ho'),
--   ('19', 'request', 'Salary Badha', 'Ghar ka kharcha nai chal rha mc'),
--   ('19', 'query', 'Kab Badhyega be', 'Plz bhai badhaaa'),
--   ('20', 'opinion', 'Plea For More Contests', 'Bachhoon ki gand maarni hai thoda aur contest rakh lete hain kya kehte ho'),
--   ('20', 'request', 'Salary Badha', 'Ghar ka kharcha nai chal rha mc'),
--   ('20', 'query', 'Kab Badhyega be', 'Plz bhai badhaaa'),
--   ('21', 'opinion', 'Plea For More Contests', 'Bachhoon ki gand maarni hai thoda aur contest rakh lete hain kya kehte ho'),
--   ('21', 'request', 'Salary Badha', 'Ghar ka kharcha nai chal rha mc'),
--   ('21', 'query', 'Kab Badhyega be', 'Plz bhai badhaaa'),
--   ('22', 'opinion', 'Plea For More Contests', 'Bachhoon ki gand maarni hai thoda aur contest rakh lete hain kya kehte ho'),
--   ('22', 'request', 'Salary Badha', 'Ghar ka kharcha nai chal rha mc'),
--   ('22', 'query', 'Kab Badhyega be', 'Plz bhai badhaaa'),
--   ('23', 'opinion', 'Plea For More Contests', 'Bachhoon ki gand maarni hai thoda aur contest rakh lete hain kya kehte ho'),
--   ('23', 'request', 'Salary Badha', 'Ghar ka kharcha nai chal rha mc'),
--   ('23', 'query', 'Kab Badhyega be', 'Plz bhai badhaaa');

CREATE TABLE admin_student (
  id serial primary key not null,
  studentid int references student (studentid) on update cascade on delete cascade,
  type text not null check ( type = 'opinion' or type = 'request' or type = 'query' ),
  subject text not null,
  body text not null,
  created_at timestamptz not null default now(),
  modified_at timestamptz not null default now()
);

-- INSERT INTO admin_student (studentid, type, subject, body)
-- VALUES
--   ('1', 'opinion', 'College khul jana chahiye', 'bula le'),
--   ('1', 'request', 'Exam mat krwa bhai', 'kyu pareshaan krte ho bhai'),
--   ('1', 'query', 'clg kab khulega', 'kya be kholdena plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz '),
--   ('2', 'opinion', 'College khul jana chahiye', 'bula le'),
--   ('2', 'request', 'Exam mat krwa bhai', 'kyu pareshaan krte ho bhai'),
--   ('2', 'query', 'clg kab khulega', 'kya be kholdena plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz plz ');

CREATE TABLE faculty_student (
  id serial primary key not null,
  studentid int references student (studentid) on update cascade on delete cascade,
  facultyid int references faculty (facultyid) on update cascade on delete cascade,
  subject text not null,
  body text not null,
  created_at timestamptz not null default now(),
  modified_at timestamptz not null default now()
);

-- INSERT INTO faculty_student (studentid, facultyid, subject, body)
-- VALUES
--   ('2', '19', 'pakka??', 'plag ka number nai katega na?'),
--   ('1', '19', 'pakka??', 'plag ka number nai katega na?'),
--   ('2', '20', 'chutiya ho?', 'maar khani hai sale bsdk? samajh nai ata transformer fat gaya tha????????? bsdk'),
--   ('1', '20', 'chutiya ho?', 'maar khani hai sale bsdk? samajh nai ata transformer fat gaya tha????????? bsdk');

CREATE TABLE faculty_rating (
  facultyid int references faculty (facultyid) on update cascade on delete cascade,
  studentid int references student (studentid) on update cascade on delete cascade,
  lecture int check ( lecture between 0 and 100),
  demo int check ( demo between 0 and 100),
  slide int check ( slide between 0 and 100),
  lab int check ( lab between 0 and 100),
  syllabus int check ( syllabus between 0 and 100),
  interaction int check ( interaction between 0 and 100),
  courseid int references course (courseid) on update cascade on delete cascade,
  primary key ( facultyid, studentid, courseid )
);

-- INSERT INTO faculty_rating
-- VALUES
--  ('1', '2', '10', '20', '30', '40', '50', '60'),
--  ('2', '2', '10', '20', '30', '40', '50', '60'),
--  ('1', '1', '10', '20', '30', '40', '50', '60'),
--  ('2', '1', '10', '20', '30', '40', '50', '60');

CREATE TABLE student_faculty (
  id int primary key references faculty_student (id) on update cascade on delete cascade,
  reply text not null,
  created_at timestamptz not null default now(),
  modified_at timestamptz not null default now()
);

-- INSERT INTO student_faculty (id, reply)
-- VALUES
--   ('1', 'nahi'),
--   ('2', 'nahi nahi'),
--   ('3', 'nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi'),
--   ('4', 'nahi nahi nahi nahi');


CREATE TABLE student_admin (
  id int primary key references admin_student (id) on update cascade on delete cascade,
  reply text not null,
  created_at timestamptz not null default now(),
  modified_at timestamptz not null default now()
);

-- INSERT INTO student_admin (id, reply)
-- VALUES
--   ('1', 'nahi'),
--   ('2', 'nahi nahi'),
--   ('3', 'nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi'),
--   ('4', 'nahi nahi nahi nahi'),
--   ('5', 'nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi'),
--   ('6', 'nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi');

CREATE TABLE faculty_admin (
  id int primary key references admin_faculty (id) on update cascade on delete cascade,
  reply text not null,
  created_at timestamptz not null default now(),
  modified_at timestamptz not null default now()
);

-- INSERT INTO faculty_admin (id, reply)
-- VALUES
--   ('1', 'nahi'),
--   ('2', 'nahi nahi'),
--   ('3', 'nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi nahi'),
--   ('4', 'nahi nahi nahi nahi');

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON admin_faculty
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON admin_student
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON faculty_student
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON student_faculty
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON student_admin
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON faculty_admin
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();




-- DATABASE DESIGN

admin:
(adminid)* email password

student:
(studentid)* email password enroll name branchid year

faculty:
(facultyid)* email password name courseid

faculty_course:
(facultyid courseid)*

branch_course:
(branchsemid courseid)*

branch_sem:
(branchsemid)* branchid sem

course:
(courseid)* coursename

branch:
(branchid)* branchname

admin_faculty:
(id)* facultyid type subject body created_at modified_at

admin_student:
(id)* studentid type subject body created_at modified_at

faculty_student:
(id)* facultyid studentid subject body created_at modified_at

faculty_rating:
(facultyid studentid)* lecture demo slide lab syllabus interaction

student_faculty:
(id)* reply created_at modified_at

student_admin:
(id)* reply created_at modified_at

faculty_admin:
(id)* reply created_at modified_at