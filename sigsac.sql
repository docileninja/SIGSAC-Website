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

    hash char(60) NOT NULL,

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

    name char(32) NOT NULL,
    markdown text NOT NULL,
    description text NOT NULL,
    image_link char(255) NOT NULL,
    video_link char(255) NOT NULL,
    on_date date NOT NULL,
    code char(32),

    PRIMARY KEY (name)

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
    FOREIGN KEY f2(lesson) REFERENCES lessons(name)

);

CREATE TABLE challenge_for_lesson (

    challenge char(32),
    lesson char(32),

    PRIMARY KEY (challenge, lesson),
    FOREIGN KEY f1(challenge) REFERENCES challenges(challenge_name),
    FOREIGN KEY f2(lesson) REFERENCES lessons(name)

);

CREATE TABLE challenge_at_event (

    challenge char(32),
    event char(32),

    PRIMARY KEY (challenge, event),
    FOREIGN KEY f1(challenge) REFERENCES challenges(challenge_name),
    FOREIGN KEY f2(event) REFERENCES events(event_name)

);

-- PAGES

CREATE TABLE resources (

    title char(64) NOT NULL,
    markdown text NOT NULL,
    html text NOT NULL,
    rank int NOT NULL,

    PRIMARY KEY (title)

);

CREATE TABLE pages (

    name char(64) NOT NULL,
    markdown text NOT NULL,
    html text NOT NULL,

    PRIMARY KEY (name)

);

-- POPULATE DATABASE

-- CADET STUFF

INSERT INTO grad_years (grad_year) VALUES
    ('2013'),
    ('2014'),
    ('2015'),
    ('2016'),
    ('2017'),
    ('2018');

INSERT INTO majors (major_name) VALUES
    ('Electrical Engineering'),
    ('Computer Science'),
    ('memory corruption'),
    ('Mathematical Sciences'),
    ('Management'),
    ('Cyber Security');

-- OFFICER STUFF

INSERT INTO ranks (rank) VALUES
    ('captian'),
    ('major'),
    ('colonel'),
    ('general');

-- MEMBER STUFF

INSERT INTO duty_positions (duty_position) VALUES
    ('CIC'),
    ('OIC'),
    ('XO'),
    ('Admin');

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

INSERT INTO lessons (name, markdown, description, image_link, video_link, on_date) VALUES
    ("Lesson 12 - Buffer Overflows", "", "overflow the buffer darnit", "https://i.ytimg.com/vi/sWIsYWnJIBU/mqdefault.jpg", "", "2015-02-01"),
    ("Lesson 11 - Format Strings", "", "format the strings", "https://i.ytimg.com/vi/sWIsYWnJIBU/mqdefault.jpg", "", "2015-01-01");

-- LINKAGE

INSERT INTO challenge_for_lesson (challenge, lesson) VALUES
    ("echo", "Lesson 11 - Format Strings"),
    ("NOP what you expect", "Lesson 12 - Buffer Overflows");

INSERT INTO challenge_at_event (challenge, event) VALUES
    ("echo", "Shmoocon 10"),
    ("NOP what you expect", "Buffer Overflows 101");

-- PAGES

INSERT INTO pages (name, html, markdown) VALUES
    ("Home", "<p><em>sample homepage</em></p>", "*sample homepage*"),
    ("About", "<h2>sample markdown</h2", "##sample markdown");

INSERT INTO resources (title, rank, html, markdown) VALUES
    ("Welcome", -1, "<p>This is the main page</p>", "This is the main page"),
    ("Getting Started", 1, "<p>This is the getting started section of the resources page. This will point you to some pages about how to install VMs, use the command, and other introductory tasks.</p>", "This is the getting started section of the resources page. This will point you to some pages about how to install VMs, use the command, and other introductory tasks.");

