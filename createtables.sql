DROP TABLE studentcheckins;
Drop TABLE classroll;
DROP TABLE students;
Drop TABLE classes;
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
 CONSTRAINT fk_teacherlogins_teachers
  FOREIGN KEY (teacherID) REFERENCES teachers (id));

# need to decide these on a case by case basis for each foreign key
# ON DELETE NO ACTION); # won't let you delete a record that's referred to
#                       # by a foreign key
# ON DELETE SET NULL);  # sets foreign key to null if the key it refers to
#                       # is deleted   
# ON DELETE CASCADE);   # deletes any record that refers to foreign key
#                       # if that key is deleted

CREATE TABLE allschools (
ID int NOT NULL AUTO_INCREMENT,
school varchar(30),
PRIMARY KEY (ID));

INSERT INTO allschools (school) VALUES ('Blackshear'), ('Kealing'), ('Oak Springs'), ('Zavala');

CREATE TABLE classes (
ID int NOT NULL AUTO_INCREMENT,
schoolID int,
teacherID int,
className varchar(30),
PRIMARY KEY (ID),
CONSTRAINT fk_classes_allschools
  FOREIGN KEY (schoolID) REFERENCES allschools (ID) ON DELETE SET NULL,
 CONSTRAINT fk_classes_teachers 
  FOREIGN KEY (teacherID) REFERENCES teachers (ID) ON DELETE SET NULL);

CREATE TABLE students (
ID int NOT NULL AUTO_INCREMENT,
LastName varchar(30),
FirstName varchar(30),
schoolID int,
PRIMARY KEY (ID),
 CONSTRAINT fk_students_allschools
  FOREIGN KEY (schoolID) REFERENCES allschools (ID));

INSERT INTO students (LastName, FirstName, schoolID) 
VALUES('Smith','Dwayne', (SELECT ID FROM allschools WHERE school  =  'Oak Springs') );
INSERT INTO students (LastName, FirstName, schoolID) 
VALUES('Sanchez','Delores', (SELECT ID FROM allschools WHERE school = 'Oak Springs') );
INSERT INTO students (LastName, FirstName, schoolID) 
VALUES('Ramos', 'Sofia', (SELECT ID FROM allschools WHERE school = 'Zavala') );
 
create TABLE classroll (
 ID int NOT NULL AUTO_INCREMENT,
 classID int NOT NULL,
 studentID int NOT NULL,
 PRIMARY KEY (ID),
 CONSTRAINT fk_classroll_classes 
  FOREIGN KEY (classID) REFERENCES classes (ID),
 CONSTRAINT fk_class_roll_students 
  FOREIGN KEY (studentID) REFERENCES students (ID));
