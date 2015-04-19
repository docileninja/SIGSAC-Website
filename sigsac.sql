DROP DATABASE IF EXISTS sigsac;
CREATE DATABASE sigsac;
USE sigsac;

-- TABLES

CREATE TABLE members (

    handle char(32) NOT NULL,
    first_name char(32) NOT NULL,
    last_name char(32) NOT NULL,
    phone char(10) NOT NULL,
    email char(64) NOT NULL,
    acm_id INT,
    join_date DATE NOT NULL,

    PRIMARY KEY (handle)

);

-- CADET STUFF

CREATE TABLE grad_years (

    grad_year char(4) NOT NULL,

    PRIMARY KEY (grad_year)

);

CREATE TABLE majors (

    major_name char(32) NOT NULL,

    PRIMARY KEY (major_name)

);

CREATE TABLE cadets (

    handle char(32) NOT NULL,
    xnumber char(5),
    grad_year char(4),
    major char(32),

    PRIMARY KEY (handle),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(grad_year) REFERENCES grad_years(grad_year),
    FOREIGN KEY f3(major) REFERENCES majors(major_name)

);

-- OFFICER STUFF

CREATE TABLE ranks (

    rank char(16) NOT NULL,

    PRIMARY KEY (rank)

);

CREATE TABLE officers (

    handle char(32) NOT NULL,
    rank char(16),

    PRIMARY KEY (handle),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(rank) REFERENCES ranks(rank)

);

-- STUFF FOR MEMBERS

CREATE TABLE certifications (

    certification_name char(64) NOT NULL,

    PRIMARY KEY (certification_name)

);

CREATE TABLE duty_positions (

    duty_position char(32) NOT NULL,

    PRIMARY KEY (duty_position)

);

-- CHALLENGE STUFF

CREATE TABLE challenge_categories (

    category_name char(16) NOT NULL,

    PRIMARY KEY (category_name)

);

CREATE TABLE challenges (

    challenge_name char(32) NOT NULL,
    html_description TEXT,
    description TEXT,
    points INT NOT NULL,
    start_date DATE,
    category char(16) NOT NULL,

    PRIMARY KEY (challenge_name),
    FOREIGN KEY f1(category) REFERENCES challenge_categories(category_name)

);

-- EVENT STUFF

CREATE TABLE zips (

    zip char(5) NOT NULL,
    city char(32) NOT NULL,
    state char(2) NOT NULL,

    PRIMARY KEY (zip)

);

CREATE TABLE locations (

    location_name char(32) NOT NULL,
    address char(64),
    zip char(5) NOT NULL,

    PRIMARY KEY (location_name),
    FOREIGN KEY f1(zip) REFERENCES zips(zip)

);

CREATE TABLE event_categories (

    category_name char(16) NOT NULL,

    PRIMARY KEY (category_name)

);

CREATE TABLE events (

    event_name char(32) NOT NULL,
    location char(32) NOT NULL,
    category char(16),
    start_date DATE NOT NULL,
    start_time TIME,
    end_date DATE,
    end_time TIME,
    html_description TEXT,
    description TEXT,

    PRIMARY KEY (event_name, start_date),
    FOREIGN KEY f1(location) REFERENCES locations(location_name),
    FOREIGN KEY f2(category) REFERENCES event_categories(category_name)

);

-- LESSON STUFF

CREATE TABLE lessons (

    lesson_name char(32) NOT NULL,
    html_description TEXT,
    description TEXT,
    image_link char(255),
    video_link char(255),
    on_date DATE,

    PRIMARY KEY (lesson_name)

);

-- CONNECTIONS

CREATE TABLE member_holds_position (

    handle char(32) NOT NULL,
    duty_position char(32) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    PRIMARY KEY (handle, duty_position, start_date),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(duty_position) REFERENCES duty_positions(duty_position)

);

CREATE TABLE member_solves_challenge (

    handle char(32) NOT NULL,
    challenge char(32) NOT NULL,
    solve_date DATE NOT NULL,

    PRIMARY KEY (handle, challenge),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(challenge) REFERENCES challenges(challenge_name)

);

CREATE TABLE member_attends_event (

    handle char(32) NOT NULL,
    event char(32) NOT NULL,
    start_date DATE NOT NULL,

    PRIMARY KEY (handle, event, start_date),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(event, start_date) REFERENCES events(event_name, start_date)

);

CREATE TABLE member_attends_lesson (

    handle char(32) NOT NULL,
    lesson char(32) NOT NULL,

    PRIMARY KEY (handle, lesson),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(lesson) REFERENCES lessons(lesson_name)

);

CREATE TABLE challenge_for_lesson (

    challenge char(32),
    lesson char(32),

    PRIMARY KEY (challenge, lesson),
    FOREIGN KEY f1(challenge) REFERENCES challenges(challenge_name),
    FOREIGN KEY f2(lesson) REFERENCES lessons(lesson_name)

);

CREATE TABLE challenge_at_event (

    challenge char(32),
    event char(32),

    PRIMARY KEY (challenge, event),
    FOREIGN KEY f1(challenge) REFERENCES challenges(challenge_name),
    FOREIGN KEY f2(event) REFERENCES events(event_name)

);

CREATE TABLE member_has_certification (

    handle char(32) NOT NULL,
    certification char(64) NOT NULL,
    earn_date DATE,
    exp_date DATE,

    PRIMARY KEY (handle, certification, earn_date),
    FOREIGN KEY f1(handle) REFERENCES members(handle),
    FOREIGN KEY f2(certification) REFERENCES certifications(certification_name)

);



-- POPULATE DATABASE

INSERT INTO members (handle, first_name, last_name, phone, email, acm_id, join_date) VALUES
    ('geedubz','Washington','George','2348571998','george.washington@usma.edu',38275,'1999-08-21'),
    ('haxor','Adams','John','2349871468','johnyboy@gmail.com',39571,'2004-01-15'),
    ( 'librarian','Jefferson','Thomas','8489061234','thomas.jefferson@usma.edu',19045,'2012-12-31'),
    ( 'uMadSon?','Madison','James','8456781230','proskater1800@aol.com',88834,'1995-11-13');

-- CADET STUFF

INSERT INTO grad_years (grad_year) VALUES
    ('2013'),
    ('2014'),
    ('2015'),
    ('2016'),
    ('2017'),
    ('2018');

INSERT INTO majors (major_name) VALUES
    ('electrical engineering'),
    ('computer science'),
    ('memory corruption'),
    ('mathematical sciences'),
    ('management'),
    ('cyber security');

INSERT INTO cadets (handle, xnumber, grad_year, major) VALUES
    ('geedubz','49294','2014','management'),
    ('haxor','39581','2016','cyber security');

-- OFFICER STUFF

INSERT INTO ranks (rank) VALUES
    ('captian'),
    ('major'),
    ('colonel'),
    ('general');

INSERT INTO officers (handle, rank) VALUES
    ('librarian','colonel'),
    ('uMadSon?','general');

-- MEMBER STUFF

INSERT INTO certifications (certification_name) values
    ('CISSP'),
    ('Net+'),
    ('A+'),
    ('Sec+'),
    ('GPEN');

INSERT INTO duty_positions (duty_position) VALUES
    ('CIC'),
    ('OIC'),
    ('XO');

-- CHALLENGE STUFF

INSERT INTO challenge_categories (category_name) VALUES
    ('reversing'),
    ('exploitation'),
    ('crypto'),
    ('stego'),
    ('recon');

INSERT INTO challenges (challenge_name, points, start_date, category) VALUES
    ('find me',150,'2013-01-15','recon'),
    ('echo',200,'2012-05-16','reversing'),
    ('RSAy what is up',500,'2014-06-13','crypto'),
    ('NOP what you expect',400,'2013-07-14','exploitation');

-- EVENT STUFF

INSERT INTO zips (zip, city, state) VALUES
    ('10996','West Point','NY'),
    ('90210','Beverly Hills','CA'),
    ('20009','Washington','DC'),
    ('89109','Las Vegas','NV'),
    ('21201','Baltimore','MD');

INSERT INTO locations (location_name, address, zip) VALUES
    ('Rio Hotel','3570 Las Vegas Blvd','89109'),
    ('Thayer 212','Thayer Hall, Cullum Road','10996'),
    ('Hilton Washington','1919 Connecticuit Ave','20009'),
    ('Hilton Baltimore','401 West Pratt St','21201');

INSERT INTO event_categories (category_name) VALUES
    ('meeting'),
    ('convention'),
    ('lecture'),
    ('training'),
    ('other');

INSERT INTO events (event_name, location, category, start_date, start_time, end_date, end_time, description) VALUES
    ('DEFCON 22','Rio Hotel','convention','2013-08-15','10:30:00','2013-08-18','20:00:00','largest gathering of hackers in the world'),
    ('Shmoocon 10','Hilton Washington','convention','2012-01-20','10:45:00','2012-01-22','14:00:00','biggest East Coast convention'),
    ('Buffer Overflows 101','Thayer 212','meeting','2014-11-14','19:30:00','2014-11-14','21:00:00','geedubz goes hands-on with introductory exploitation'),
    ('SANSFire 2014','Hilton Baltimore','training','2014-07-09','12:00:00','2014-07-15','14:00:00','top notch training, 12 slots for cadets');

-- LESSON STUFF

INSERT INTO lessons (lesson_name, description, image_link, on_date) VALUES
    ("Lesson 12 - Buffer Overflows", "overflow the buffer darnit", "https://i.ytimg.com/vi/sWIsYWnJIBU/mqdefault.jpg", "2015-02-01"),
    ("Lesson 11 - Format Strings", "format the strings", "https://i.ytimg.com/vi/sWIsYWnJIBU/mqdefault.jpg", "2015-01-01");

-- LINKAGE

INSERT INTO member_holds_position (handle, duty_position, start_date, end_date) VALUES
    ('librarian','OIC','2013-01-01','2014-01-01'),
    ('geedubz','CIC','2013-01-01','2015-01-01'),
    ('haxor','XO','2013-01-01','2014-12-30');

INSERT INTO member_solves_challenge (handle, challenge, solve_date) VALUES
    ('haxor','find me','2013-02-14'),
    ('haxor','echo','2012-06-16'),
    ('haxor','NOP what you expect','2013-07-20'),
    ('librarian','RSAy what is up','2014-07-01'),
    ('geedubz','echo','2012-05-30');

INSERT INTO member_attends_event (handle, event, start_date) VALUES
    ('librarian','Buffer Overflows 101','2014-11-14'),
    ('haxor','Buffer Overflows 101','2014-11-14'),
    ('geedubz','DEFCON 22','2013-08-15');

INSERT INTO member_attends_lesson (handle, lesson) VALUES
    ("geedubz", "Lesson 11 - Format Strings"),
    ("geedubz", "Lesson 12 - Buffer Overflows"),
    ("haxor", "Lesson 11 - Format Strings");

INSERT INTO challenge_for_lesson (challenge, lesson) VALUES
    ("echo", "Lesson 11 - Format Strings"),
    ("NOP what you expect", "Lesson 12 - Buffer Overflows");

INSERT INTO challenge_at_event (challenge, event) VALUES
    ("echo", "Shmoocon 10"),
    ("NOP what you expect", "Buffer Overflows 101");

INSERT INTO member_has_certification (handle, certification, earn_date, exp_date) VALUES
    ('geedubz','CISSP','2001-11-11','2005-11-11'),
    ('haxor','Net+','1999-12-10','2002-12-10'),
    ('librarian','GPEN','2012-10-05','2016-10-05');


-- -- PROCEDURES

-- DELIMITER $$

-- -- ENTERING INFO

-- CREATE PROCEDURE enterMember (
-- 	IN who char(32),
--     IN fname char(32),
--     IN lname char(32),
--     IN pnum char(10),
--     IN email char(32),
--     IN acm INT,
--     IN joind DATE
-- )
-- BEGIN
-- 	INSERT INTO member (who, firstName, lastName, phone, email, acmId, joinDate) VALUES
-- 	(handle,fname,lname,pnum,email,acm,joind);
-- END $$

-- CREATE PROCEDURE enterEvent (
-- 	IN name char(32),
--     IN loc char(32),
--     IN cat CHAR(16),
--     IN startd DATE,
--     IN starts TIME,
--     IN endd DATE,
--     IN endt TIME,
--     IN description TEXT
-- )
-- BEGIN
-- 	INSERT INTO event (eventName, locName, category, startDate, startTime, endDate, endTime, description) VALUES
-- 	(name,loc,cat,startd,starts,endd,endt,description);
-- END $$

-- CREATE PROCEDURE enterAttendance (
-- 	IN who char(32),
--     IN name char(32),
--     IN date DATE
-- )
-- BEGIN
-- 	INSERT INTO memberAttendsEvent (handle, eventName) VALUES
-- 	(who,name,date);
-- END $$

-- CREATE PROCEDURE enterChallenge (
-- 	IN name char(32),
--     IN val INT,
--     IN startd DATE,
--     IN cat char(16)
-- )
-- BEGIN
-- 	INSERT INTO challenge (chalName, points, startDate, category) VALUES
-- 	(name,val,startd,cat);
-- END $$

-- CREATE PROCEDURE enterChallengeSolve (
-- 	IN who char(32),
--     IN chal char(32),
--     IN solved DATE
-- )
-- BEGIN
-- 	INSERT INTO memberSolvesChallenge (handle, chalName, solveDate) VALUES
-- 	(who,chal,sovled);
-- END $$

-- CREATE PROCEDURE enterCertificationEarn (
-- 	IN who char(32),
--     IN cert char(64),
--     IN earned DATE,
--     IN expires DATE
-- )
-- BEGIN
-- 	INSERT INTO memberHasCert (handle, certName, earnDate, expDate) VALUES
-- 	(who,cert,earned,expires);
-- END $$

-- CREATE PROCEDURE enterPosition (
-- 	IN who char(32),
--     IN psn char(32),
--     IN startd DATE,
--     IN endd DATE
-- )
-- BEGIN
-- 	INSERT INTO memberHoldsPosition (handle, dutyPosition, startDate, endDate) VALUES
-- 	(who,psn,startd,endd);
-- END $$

-- -- RETRIEVING INFO

-- CREATE PROCEDURE listScores ()
-- BEGIN
-- 	SELECT handle, SUM(points) AS score FROM memberSolvesChallenge, challenge
--     WHERE memberSolvesChallenge.chalname = challenge.chalName
--     GROUP BY handle
--     ORDER BY score DESC;
-- END $$

-- CREATE PROCEDURE listCadets ()
-- BEGIN
-- 	SELECT member.handle, firstName, lastName, email, acmId, joinDate, xNum, gradYear, major
--     FROM member, cadet
--     WHERE cadet.handle = member.handle;
-- END $$

-- CREATE PROCEDURE listOfficers ()
-- BEGIN
-- 	SELECT member.handle, rank, firstName, lastName, email, acmId, joinDate
--     FROM member, officer, memberHasCert
--     WHERE officer.handle = member.handle;
-- END $$

-- CREATE PROCEDURE listAttendance (
-- 	IN eventvar CHAR(32)
-- )
-- BEGIN
-- 	SELECT handle
--     FROM memberAttendsEvent
--     WHERE eventName = eventvar
--     ORDER BY handle;
-- END $$

-- CREATE PROCEDURE listSolves (
-- 	IN which char(32)
-- )
-- BEGIN
-- 	SELECT handle, solveDate
--     FROM memberSolvesChallenge
--     WHERE chalName = which
--     ORDER BY solveDate;
-- END $$

-- CREATE PROCEDURE listLeadership ()
-- BEGIN
-- 	SELECT *
--     FROM memberHoldsPosition
--     WHERE startDate <= CURDATE() AND endDate >= CURDATE();
-- END $$

-- DELIMITER ;


-- -- USERS

-- DROP USER OIC; FLUSH PRIVILEGES;
-- CREATE USER OIC IDENTIFIED BY 'oicpass';

-- DROP USER CIC; FLUSH PRIVILEGES;
-- CREATE USER CIC IDENTIFIED BY 'cicpass';

-- DROP USER XO; FLUSH PRIVILEGES;
-- CREATE USER XO IDENTIFIED BY 'xopass';

-- DROP USER webApp; FLUSH PRIVILEGES;
-- CREATE USER webApp IDENTIFIED BY 'webpass';

-- DROP USER OIC; FLUSH PRIVILEGES;
-- CREATE USER OIC IDENTIFIED BY 'oicpass';

-- DROP USER member; FLUSH PRIVILEGES;
-- CREATE USER member IDENTIFIED BY '';


-- -- PERMISSIONS

-- GRANT EXECUTE ON PROCEDURE listOfficers TO OIC, CIC, XO;
-- GRANT EXECUTE ON PROCEDURE listCadets TO OIC, CIC, XO;
-- GRANT EXECUTE ON PROCEDURE listAttendance TO OIC, CIC, XO;
-- GRANT EXECUTE ON PROCEDURE enterEvent TO OIC, CIC;
-- GRANT EXECUTE ON PROCEDURE enterPosition TO OIC;
-- GRANT EXECUTE ON PROCEDURE enterChallenge TO CIC;
-- GRANT EXECUTE ON PROCEDURE enterMember TO XO;
-- GRANT EXECUTE ON PROCEDURE enterAttendance TO XO;
-- GRANT EXECUTE ON PROCEDURE enterCertificationEarn TO XO;
-- GRANT EXECUTE ON PROCEDURE enterChallengeSolve TO webApp;
-- GRANT EXECUTE ON PROCEDURE listSolves TO OIC, CIC, XO, member;
-- GRANT EXECUTE ON PROCEDURE listScores TO OIC, CIC, XO, member;
-- GRANT EXECUTE ON PROCEDURE listLeadership TO OIC, CIC, XO, member;