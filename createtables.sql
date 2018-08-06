DROP TABLE studentcheckins;
DROP TABLE students;
DROP TABLE teacherlogins;
DROP TABLE teachers;
DROP TABLE allschools;
DROP TABLE fivenumbers;

 CREATE TABLE fivenumbers (
 i int NOT NULL,
 PRIMARY KEY (i));

insert into fivenumbers (i) values (1), (2), (3), (4), (5);

 CREATE TABLE teachers (
 ID int NOT NULL AUTO_INCREMENT,
 LastName varchar(30),
 FirstName varchar(30),
 UserName varchar(30),
 PassWord varchar(30),
 PhoneWithData boolean,
 PRIMARY KEY (ID));

INSERT INTO teachers (LastName, FirstName, UserName, PassWord, PhoneWithData)
Values ('Barnes', 'Anne', 'anneb@hotmail.com', '12345', FALSE );
INSERT INTO teachers (LastName, FirstName, UserName, PassWord, PhoneWithData)
Values ('Delgado', 'Carla', 'CarlaD@gmail.com', '24680', TRUE );
INSERT INTO teachers (LastName, FirstName, UserName, PassWord, PhoneWithData)
Values ('Cumminsky', 'Brian', 'brianc@yahoo.com', '67890', TRUE );

 CREATE TABLE teacherlogins (
 ID int NOT NULL AUTO_INCREMENT,
 teacherID int,
 TimeIn timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 TimeOut timestamp,
 PRIMARY KEY (ID),
 CONSTRAINT fk_teacherlogins_teachers FOREIGN KEY (teacherID) REFERENCES teachers (id) );

CREATE TABLE allschools (
ID int NOT NULL AUTO_INCREMENT,
school varchar(30),
PRIMARY KEY (ID));

INSERT INTO allschools (school) VALUES ('Blackshear'), ('Kealing'), ('Oak Springs'), ('Zavala');

CREATE TABLE students (
ID int NOT NULL AUTO_INCREMENT,
LastName varchar(30),
FirstName varchar(30),
schoolID int,
PRIMARY KEY (ID),
 CONSTRAINT fk_school FOREIGN KEY (schoolID) REFERENCES allschools (ID));

INSERT INTO students (LastName, FirstName, schoolID) 
VALUES('Smith','Dwayne', (SELECT ID FROM allschools WHERE school  =  'Oak Springs') );
INSERT INTO students (LastName, FirstName, schoolID) 
VALUES('Sanchez','Delores', (SELECT ID FROM allschools WHERE school = 'Oak Springs') );
INSERT INTO students (LastName, FirstName, schoolID) 
VALUES('Ramos', 'Sofia', (SELECT ID FROM allschools WHERE school = 'Zavala') );
 
CREATE TABLE studentcheckins (
 ID int NOT NULL AUTO_INCREMENT,
 studentID int,
 teacherID int,
 TimeIn timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 TimeOut timestamp,
 broughtInstrument boolean,
 broughtBooks boolean,
 progress int,
 behavior int,
 PRIMARY KEY (ID),
 CONSTRAINT fk_behavior FOREIGN KEY (behavior) REFERENCES fivenumbers (i),
 CONSTRAINT fk_progress FOREIGN KEY (progress) REFERENCES fivenumbers (i),
 CONSTRAINT fk_studentcheckins_students 
  FOREIGN KEY (studentID) REFERENCES students (ID),
 CONSTRAINT fk_studentcheckins_teachers 
  FOREIGN KEY (teacherID) REFERENCES teachers (ID));
