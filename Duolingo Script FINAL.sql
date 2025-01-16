-- CREATE DUOLINGO DB
-- Drop the database if it exists
DROP DATABASE IF EXISTS duolingo_db;

-- Create a new database
CREATE DATABASE duolingo_db;

-- Drop tables in the correct order (dependent tables first)
DROP TABLE IF EXISTS product_placement_inclusion;
DROP TABLE IF EXISTS product_placement;
DROP TABLE IF EXISTS content_type;
DROP TABLE IF EXISTS friendship;
DROP TABLE IF EXISTS friend;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS join_league;
DROP TABLE IF EXISTS score;
DROP TABLE IF EXISTS test_question_info;
DROP TABLE IF EXISTS test_answer;
DROP TABLE IF EXISTS test_question;
DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS lesson;
DROP TABLE IF EXISTS duo_user;
DROP TABLE IF EXISTS subscription_plan;
DROP TABLE IF EXISTS user_plan;
DROP TABLE IF EXISTS league;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS client_company;

-- Create user_plan table
CREATE TABLE "user_plan" (
  "user_plan_id" INTEGER NOT NULL,
  "plan_status" VARCHAR(50) NOT NULL,
  "start_date" DATE,
  "end_date" DATE,
  PRIMARY KEY ("user_plan_id")
);

-- Create duo_user table
CREATE TABLE "duo_user" (
  "user_id" VARCHAR(25) NOT NULL,
  "user_first_name" VARCHAR(100),
  "user_last_name" VARCHAR(100),
  "user_email" VARCHAR(250) NOT NULL,
  "user_age" INTEGER NOT NULL,
  "user_join_date" DATE NOT NULL,
  "user_score" INTEGER NOT NULL,
  "user_native_language" VARCHAR(100) NOT NULL,
  "user_plan_id" INTEGER NOT NULL,
  PRIMARY KEY ("user_id"),
  CONSTRAINT "FK_duo_user.user_plan_id"
    FOREIGN KEY ("user_plan_id")
      REFERENCES "user_plan"("user_plan_id")
);

-- Create course table
CREATE TABLE "course" (
  "course_id" INTEGER NOT NULL,
  "course_name" VARCHAR(200) NOT NULL,
  "course_level" INTEGER NOT NULL,
  "course_percent_progress" DECIMAL NOT NULL,
  PRIMARY KEY ("course_id")
);

-- Create lesson table
CREATE TABLE "lesson" (
  "lesson_id" INTEGER NOT NULL,
  "lanuage_name" VARCHAR(100) NOT NULL,
  "lesson_level" INTEGER NOT NULL,
  "completion_date" DATE,
  "course_id" INTEGER NOT NULL,
  "user_id" VARCHAR(25) NOT NULL,
  PRIMARY KEY ("lesson_id"),
  CONSTRAINT "FK_lesson.user_id"
    FOREIGN KEY ("user_id")
      REFERENCES "duo_user"("user_id"),
  CONSTRAINT "FK_lesson.course_id"
    FOREIGN KEY ("course_id")
      REFERENCES "course"("course_id")
);

-- Create league table
CREATE TABLE "league" (
  "league_id" INTEGER NOT NULL,
  "league_name" VARCHAR(100) NOT NULL,
  "user_rank" INTEGER,
  PRIMARY KEY ("league_id")
);

-- Create score table
CREATE TABLE "score" (
  "score_id" INTEGER NOT NULL,
  "accuracy_percentage" INTEGER NOT NULL,
  "lesson_time" TIME NOT NULL,
  "earned_xp" INTEGER NOT NULL,
  "lesson_id" INTEGER NOT NULL,
  "user_id" VARCHAR(25) NOT NULL,
  "league_id" INTEGER NOT NULL,
  PRIMARY KEY ("score_id"),
  CONSTRAINT "FK_score.lesson_id"
    FOREIGN KEY ("lesson_id")
      REFERENCES "lesson"("lesson_id"),
  CONSTRAINT "FK_score.league_id"
    FOREIGN KEY ("league_id")
      REFERENCES "league"("league_id"),
  CONSTRAINT "FK_score.user_id"
    FOREIGN KEY ("user_id")
      REFERENCES "duo_user"("user_id")
);

-- Create friend table
CREATE TABLE "friend" (
  "friend_id" VARCHAR(25),
  "friend_first_name" VARCHAR(100),
  "friend_last_name" VARCHAR(100),
  PRIMARY KEY ("friend_id")
);

-- Create frienship table
CREATE TABLE "friendship" (
  "friend_id" VARCHAR(25) NOT NULL,
  "user_id" VARCHAR(25) NOT NULL,
  "friendship_date" DATE,
  "friendship_time" DATE,
  PRIMARY KEY ("friend_id", "user_id"),
  CONSTRAINT "FK_friendship.user_id"
    FOREIGN KEY ("user_id")
      REFERENCES "duo_user"("user_id"),
  CONSTRAINT "FK_friendship.friend_id"
    FOREIGN KEY ("friend_id")
      REFERENCES "friend"("friend_id")
);

-- Create join_league table
CREATE TABLE "join_league" (
  "user_id" VARCHAR(25) NOT NULL,
  "league_id" INTEGER NOT NULL,
  "join_date" DATE,
  PRIMARY KEY ("user_id", "league_id"),
  CONSTRAINT "FK_join_league.user_id"
    FOREIGN KEY ("user_id")
      REFERENCES "duo_user"("user_id"),
  CONSTRAINT "FK_join_league.league_id"
    FOREIGN KEY ("league_id")
      REFERENCES "league"("league_id")
);

-- Create subscription_plan table
CREATE TABLE "subscription_plan" (
  "plan_id" INTEGER NOT NULL,
  "plan_name" VARCHAR(100) NOT NULL,
  "plan_description" VARCHAR(1000),
  "user_plan_id" INTEGER NOT NULL,
  PRIMARY KEY ("plan_id"),
  CONSTRAINT "FK_subscription_plan.user_plan_id"
    FOREIGN KEY ("user_plan_id")
      REFERENCES "user_plan"("user_plan_id")
);

-- Create test_question table
CREATE TABLE "test_question" (
  "question_id" INTEGER NOT NULL,
  "question_text" VARCHAR(200) NOT NULL,
  "question_type" VARCHAR(200),
  PRIMARY KEY ("question_id")
);

-- Create test_answer table
CREATE TABLE "test_answer" (
  "answer_id" INTEGER NOT NULL,
  "answer_text" VARCHAR(200) NOT NULL,
  "answer_correct" BOOLEAN NOT NULL,
  "quesion_id" INTEGER NOT NULL,
  PRIMARY KEY ("answer_id"),
  CONSTRAINT "FK_test_answer.quesion_id"
    FOREIGN KEY ("quesion_id")
      REFERENCES "test_question"("question_id")
);

-- Create enrollment table 
CREATE TABLE "enrollment" (
  "user_id" VARCHAR(25) NOT NULL,
  "course_id" INTEGER NOT NULL,
  "enrollment_date" DATE,
  "enrollment_time" TIME,
  PRIMARY KEY ("user_id", "course_id"),
  CONSTRAINT "FK_enrollment.user_id"
    FOREIGN KEY ("user_id")
      REFERENCES "duo_user"("user_id"),
  CONSTRAINT "FK_enrollment.course_id"
    FOREIGN KEY ("course_id")
      REFERENCES "course"("course_id")
);

-- Create notification table
CREATE TABLE "notification" (
  "notification_id" INTEGER NOT NULL,
  "notification_title" VARCHAR(100) NOT NULL,
  "notification_text" VARCHAR(1000) NOT NULL,
  "user_id" VARCHAR(25) NOT NULL,
  PRIMARY KEY ("notification_id"),
  CONSTRAINT "FK_notification.user_id"
    FOREIGN KEY ("user_id")
      REFERENCES "duo_user"("user_id")
);

-- Create test table
CREATE TABLE "test" (
  "test_id" INTEGER NOT NULL,
  "test_result" DECIMAL,
  "test_type" VARCHAR(100),
  "user_id" VARCHAR(25) NOT NULL,
  PRIMARY KEY ("test_id")
);

-- Create client company table
CREATE TABLE "client_company" (
  "company_id" INTEGER NOT NULL,
  "company_name" VARCHAR(200),
  PRIMARY KEY ("company_id")
);

-- Create product placement table
CREATE TABLE "product_placement" (
  "product_id" INTEGER NOT NULL,
  "product_name" VARCHAR(200) NOT NULL,
  "product_word" VARCHAR(200) NOT NULL,
  "product_type" VARCHAR(200) NOT NULL,
  "product_country" VARCHAR(200) NOT NULL,
  "incident_price" DECIMAL NOT NULL,
  "company_id" INTEGER NOT NULL,
  PRIMARY KEY ("product_id"),
  CONSTRAINT "FK_product_placement.company_id"
    FOREIGN KEY ("company_id")
      REFERENCES "client_company"("company_id")
);

-- Create product_placement_inclusion table
CREATE TABLE "product_placement_inclusion" (
  "product_id" INTEGER NOT NULL,
  "lesson_id" INTEGER NOT NULL,
  "inclusion_date" DATE,
  PRIMARY KEY ("product_id", "lesson_id"),
  CONSTRAINT "FK_product_placement_inclusion.lesson_id"
    FOREIGN KEY ("lesson_id")
      REFERENCES "lesson"("lesson_id"),
  CONSTRAINT "FK_product_placement_inclusion.product_id"
    FOREIGN KEY ("product_id")
      REFERENCES "product_placement"("product_id")
);

-- Create content_type table
CREATE TABLE "content_type" (
  "content_type_id" INTEGER NOT NULL,
  "content_type_description" VARCHAR(200),
  "lesson_id" INTEGER NOT NULL,
  PRIMARY KEY ("content_type_id"),
  CONSTRAINT "FK_content_type.lesson_id"
    FOREIGN KEY ("lesson_id")
      REFERENCES "lesson"("lesson_id")
);

-- Create test_question_info table
CREATE TABLE "test_question_info" (
  "test_id" INTEGER NOT NULL,
  "question_id" INTEGER NOT NULL,
  PRIMARY KEY ("test_id", "question_id"),
  CONSTRAINT "FK_test_question_info.test_id"
    FOREIGN KEY ("test_id")
      REFERENCES "test"("test_id"),
  CONSTRAINT "FK_test_question_info.question_id"
    FOREIGN KEY ("question_id")
      REFERENCES "test_question"("question_id")
);


--DUOLINGO DB INSERT DATA
-- Script 1: Insert data for user-related tables (duo_user, user_plan, subscription_plan)

-- Insert into user_plan
INSERT INTO user_plan (user_plan_id, plan_status, start_date, end_date) VALUES
(1, 'Active', '2023-01-01', NULL),
(2, 'Inactive', '2022-01-01', '2022-12-31'),
(3, 'Active', '2024-01-01', NULL),
(4, 'Inactive', '2022-10-01', '2023-10-01'),
(5, 'Active', '2024-03-20', NULL),
(6, 'Inactive', '2023-07-01', '2024-07-01'),
(7, 'Active', '2024-04-01', NULL),
(8, 'Inactive', '2021-05-01', '2022-05-01'),
(9, 'Active', '2024-05-01', NULL),
(10, 'Inactive', '2023-08-15', '2024-02-15');

-- Query user_plan
SELECT *
FROM user_plan up;

-- Insert into subscription_plan
INSERT INTO subscription_plan (plan_id, plan_name, plan_description, user_plan_id) VALUES
(1, 'Free Plan', 'Basic access with ads', 1),
(2, 'Plus Plan', 'Ad-free experience and offline lessons', 2),
(3, 'Family Plan', 'Access for up to 6 family members', 3);

-- Query subscription_plan
SELECT *
FROM subscription_plan sp;

-- Insert into duo_user
INSERT INTO duo_user (user_id, user_first_name, user_last_name, user_email, user_age, user_join_date, user_score, user_native_language, user_plan_id) VALUES
('user001', 'John', 'Doe', 'john.doe@example.com', 25, '2023-03-01', 1500, 'English', 1),
('user002', 'Jane', 'Smith', 'jane.smith@example.com', 30, '2023-04-01', 2000, 'Spanish', 10),
('user003', 'Alice', 'Johnson', 'alice.johnson@example.com', 28, '2022-05-15', 1700, 'French', 2),
('user004', 'Bob', 'Brown', 'bob.brown@example.com', 22, '2023-06-20', 1200, 'German', 5),
('user005', 'Charlie', 'Davis', 'charlie.davis@example.com', 35, '2023-07-10', 1900, 'Italian', 3),
('user006', 'Diana', 'Miller', 'diana.miller@example.com', 29, '2023-08-05', 2100, 'Portuguese', 4),
('user007', 'Eve', 'Wilson', 'eve.wilson@example.com', 27, '2023-09-01', 1600, 'Japanese', 7),
('user008', 'Frank', 'Clark', 'frank.clark@example.com', 32, '2023-10-01', 1400, 'Korean', 6),
('user009', 'Grace', 'Lee', 'grace.lee@example.com', 24, '2023-11-01', 1800, 'Chinese', 9),
('user010', 'Hank', 'Martin', 'hank.martin@example.com', 31, '2023-12-01', 1550, 'Russian', 8);

-- Query duo_user
SELECT *
FROM duo_user du;

-- Script 2: Insert data for course, lesson, enrollment, and related tables

-- Insert into course
INSERT INTO course (course_id, course_name, course_level, course_percent_progress) VALUES
(1, 'Spanish for Beginners', 1, 20.5),
(2, 'French Intermediate', 2, 45.0),
(3, 'German Advanced', 3, 70.0),
(4, 'Italian for Beginners', 1, 15.0),
(5, 'Portuguese Intermediate', 2, 50.0),
(6, 'Japanese Advanced', 3, 80.0),
(7, 'Korean for Beginners', 1, 25.0),
(8, 'Chinese Intermediate', 2, 60.0),
(9, 'Russian Advanced', 3, 75.0),
(10, 'English for Spanish Speakers', 1, 30.0);

-- Query course
SELECT *
FROM course c;

-- Insert into lesson
INSERT INTO lesson (lesson_id, lanuage_name, lesson_level, completion_date, course_id, user_id) VALUES
(1, 'Spanish', 1, '2023-03-15', 1, 'user001'),
(2, 'French', 2, '2023-04-20', 2, 'user002'),
(3, 'German', 3, '2023-06-25', 3, 'user004'),
(4, 'Spanish', 1, '2023-07-15', 1, 'user005'),
(5, 'French', 2, '2023-08-10', 2, 'user006'),
(6, 'Italian', 1, '2023-09-15', 4, 'user005'),
(7, 'Portuguese', 2, '2023-10-10', 5, 'user006'),
(8, 'Japanese', 3, '2023-11-20', 6, 'user007'),
(9, 'Korean', 1, '2023-12-05', 7, 'user008'),
(10, 'Chinese', 2, '2023-12-15', 8, 'user009');

-- Query lesson
SELECT *
FROM lesson l;

-- Insert into enrollment
INSERT INTO enrollment (user_id, course_id, enrollment_date, enrollment_time) VALUES
('user001', 1, '2023-03-01', '09:00:00'),
('user002', 2, '2023-04-01', '10:00:00'),
('user004', 3, '2023-06-20', '11:00:00'),
('user005', 1, '2023-07-10', '12:00:00'),
('user006', 2, '2023-08-05', '13:00:00'),
('user005', 4, '2023-09-01', '14:00:00'),
('user006', 5, '2023-10-01', '15:00:00'),
('user007', 6, '2023-11-01', '16:00:00'),
('user008', 7, '2023-12-01', '17:00:00'),
('user009', 8, '2023-12-05', '18:00:00');

-- Query enrollment
SELECT *
FROM enrollment e;

-- Insert into league
INSERT INTO league (league_id, league_name, user_rank) VALUES
(1, 'Bronze League', 1),
(2, 'Silver League', 2),
(3, 'Gold League', 3),
(4, 'Platinum League', 4),
(5, 'Diamond League', 5),
(6, 'Emerald League', 6),
(7, 'Ruby League', 7),
(8, 'Sapphire League', 8),
(9, 'Amethyst League', 9),
(10, 'Obsidian League', 10);

-- Query league
SELECT *
FROM league le;

-- Insert into join_league
INSERT INTO join_league (user_id, league_id, join_date) VALUES
('user001', 1, '2023-03-10'),
('user002', 2, '2023-04-15'),
('user004', 3, '2023-06-25'),
('user005', 1, '2023-07-20'),
('user006', 2, '2023-08-15'),
('user007', 3, '2023-11-10'),
('user008', 1, '2023-12-01'),
('user009', 2, '2023-12-10'),
('user010', 3, '2023-12-15');

-- Query join_league
SELECT *
FROM join_league jl;

-- Script 3: Insert data for friend, friendship, score, notification, client_company, and product_placement tables

-- Insert into friend
INSERT INTO friend (friend_id, friend_first_name, friend_last_name) VALUES
('friend001', 'Michael', 'Anderson'),
('friend002', 'Nina', 'Roberts'),
('friend003', 'Oliver', 'Garcia'),
('friend004', 'Paul', 'Walker'),
('friend005', 'Samantha', 'White');

-- Query friend
SELECT *
FROM friend f;

-- Insert into friendship
INSERT INTO friendship (friend_id, user_id, friendship_date, friendship_time) VALUES
('friend001', 'user001', '2023-03-20 14:00:00+00', '2023-03-20 14:00:00+00'::timestamp),
('friend002', 'user002', '2023-04-25 15:00:00+00', '2023-04-25 15:00:00+00'::timestamp),
('friend003', 'user004', '2023-06-30 16:00:00+00', '2023-06-30 16:00:00+00'::timestamp),
('friend004', 'user005', '2023-08-15 17:00:00+00', '2023-08-15 17:00:00+00'::timestamp),
('friend005', 'user006', '2023-09-10 18:00:00+00', '2023-09-10 18:00:00+00'::timestamp);

-- Query friendship
SELECT *
FROM friendship fs;

-- Insert into score
INSERT INTO score (score_id, accuracy_percentage, lesson_time, earned_xp, lesson_id, user_id, league_id) VALUES
(1, 95, '00:20:00', 150, 1, 'user001', 1),
(2, 90, '00:25:00', 200, 2, 'user002', 2),
(3, 85, '00:30:00', 250, 3, 'user004', 3),
(4, 88, '00:22:00', 180, 4, 'user005', 1),
(5, 92, '00:27:00', 220, 5, 'user006', 2),
(6, 89, '00:24:00', 190, 6, 'user005', 1),
(7, 94, '00:26:00', 210, 7, 'user006', 2),
(8, 91, '00:28:00', 230, 8, 'user007', 3),
(9, 87, '00:23:00', 170, 9, 'user008', 1),
(10, 93, '00:29:00', 240, 10, 'user009', 2);

-- Query score
SELECT *
FROM score s;

-- Insert into notification
INSERT INTO notification (notification_id, notification_title, notification_text, user_id) VALUES
(1, 'Lesson Reminder', 'Don’t forget to complete your lesson today!', 'user001'),
(2, 'New Achievement', 'You have earned a new badge!', 'user002'),
(3, 'League Update', 'You moved up in the league rankings!', 'user004'),
(4, 'Friend Request', 'You have a new friend request!', 'user005'),
(5, 'Course Completion', 'Congratulations on completing your course!', 'user006');

-- Query notification
SELECT *
FROM notification n;

-- Insert into client_company
INSERT INTO client_company (company_id, company_name) VALUES
(1, 'LanguageCorp'),
(2, 'EduWorld'),
(3, 'Learnify');

-- Query client_company
SELECT *
FROM client_company;

-- Insert into product_placement
INSERT INTO product_placement (product_id, product_name, product_word, product_type, product_country, incident_price, company_id) VALUES
(1, 'Language Book', 'Libro', 'Book', 'Spain', 15.99, 1),
(2, 'Flashcards', 'Cartes', 'Cards', 'France', 9.99, 2),
(3, 'Vocabulary App', 'Vokabeln', 'App', 'Germany', 4.99, 3),
(4, 'Headphones', 'Auriculares', 'Electronics', 'Spain', 29.99, 1),
(5, 'Notebook', 'Cahier', 'Stationery', 'France', 5.49, 2),
(6, 'Language Guide', 'Leitfaden', 'Book', 'Germany', 12.99, 3),
(7, 'Tablet', 'Tablette', 'Electronics', 'France', 199.99, 2),
(8, 'Smartphone', 'Handy', 'Electronics', 'Germany', 299.99, 3),
(9, 'Bluetooth Speaker', 'Altavoz', 'Electronics', 'Spain', 49.99, 1),
(10, 'Grammar Book', 'Grammatikbuch', 'Book', 'Germany', 20.00, 3);

-- Query product_placement
SELECT *
FROM product_placement pp;

-- Script 4: Insert data for test, test_question, test_answer, product_placement_inclusion, content_type, and related tables

-- Insert into test
INSERT INTO test (test_id, test_result, test_type, user_id) VALUES
(1, 85.5, 'Midterm', 'user001'),
(2, 90.0, 'Final', 'user002'),
(3, 88.0, 'Quiz', 'user004'),
(4, 92.5, 'Practice', 'user006');

-- Query test
SELECT *
FROM test t;

-- Insert into test_question
INSERT INTO test_question (question_id, question_text, question_type) VALUES
(1, 'Translate "Hello" to Spanish', 'Translation'),
(2, 'What is the capital of France?', 'Multiple Choice'),
(3, 'Translate "Goodbye" to French', 'Translation'),
(4, 'What is 2 + 2?', 'Multiple Choice'),
(5, 'Translate "How are you?" to German', 'Translation'),
(6, 'What is the largest planet?', 'Multiple Choice'),
(7, 'Translate "Thank you" to Italian', 'Translation'),
(8, 'What is the chemical symbol for water?', 'Multiple Choice'),
(9, 'Translate "See you later" to Portuguese', 'Translation'),
(10, 'What is the square root of 16?', 'Multiple Choice'),
(11, 'Translate "Good morning" to Japanese', 'Translation'),
(12, 'Who wrote "Hamlet"?', 'Multiple Choice'),
(13, 'Translate "I love you" to Korean', 'Translation'),
(14, 'What is the capital of Italy?', 'Multiple Choice'),
(15, 'Translate "Goodnight" to Russian', 'Translation'),
(16, 'What is 3 * 3?', 'Multiple Choice'),
(17, 'Translate "Please" to Chinese', 'Translation'),
(18, 'What is the capital of Japan?', 'Multiple Choice'),
(19, 'Translate "Excuse me" to French', 'Translation'),
(20, 'What is the freezing point of water in Celsius?', 'Multiple Choice'),
(21, 'Translate "Where is the bathroom?" to Spanish', 'Translation'),
(22, 'Who painted the Mona Lisa?', 'Multiple Choice'),
(23, 'Translate "Have a nice day" to Italian', 'Translation'),
(24, 'What is the speed of light?', 'Multiple Choice'),
(25, 'Translate "See you tomorrow" to German', 'Translation'),
(26, 'What is the atomic number of oxygen?', 'Multiple Choice'),
(27, 'Translate "Can you help me?" to Portuguese', 'Translation'),
(28, 'What is the tallest mountain in the world?', 'Multiple Choice'),
(29, 'Translate "I am hungry" to French', 'Translation'),
(30, 'What is the capital of Australia?', 'Multiple Choice'),
(31, 'Translate "Good afternoon" to Russian', 'Translation'),
(32, 'What is the capital of Canada?', 'Multiple Choice'),
(33, 'Translate "Happy birthday" to Japanese', 'Translation'),
(34, 'What is the smallest prime number?', 'Multiple Choice'),
(35, 'Translate "Congratulations" to Korean', 'Translation'),
(36, 'Who discovered America?', 'Multiple Choice'),
(37, 'Translate "I need a doctor" to Chinese', 'Translation'),
(38, 'What is the capital of Brazil?', 'Multiple Choice'),
(39, 'Translate "Good luck" to Italian', 'Translation'),
(40, 'What is the hottest planet?', 'Multiple Choice'),
(41, 'Translate "Take care" to Spanish', 'Translation'),
(42, 'What is the deepest ocean?', 'Multiple Choice'),
(43, 'Translate "I am lost" to German', 'Translation'),
(44, 'What is 5 + 7?', 'Multiple Choice'),
(45, 'Translate "Do you speak English?" to French', 'Translation'),
(46, 'What is the capital of Russia?', 'Multiple Choice'),
(47, 'Translate "Happy New Year" to Portuguese', 'Translation'),
(48, 'What is the largest desert?', 'Multiple Choice'),
(49, 'Translate "Goodbye" to Chinese', 'Translation'),
(50, 'What is the currency of Japan?', 'Multiple Choice');

-- Query test_question
SELECT *
FROM test_question tq;

-- Insert into test_answer
INSERT INTO test_answer (answer_id, answer_text, answer_correct, quesion_id) VALUES
(1, 'Hola', TRUE, 1),
(2, 'Madrid', FALSE, 2),
(3, 'Paris', TRUE, 2),
(4, 'Adieu', FALSE, 3),
(5, 'Au revoir', TRUE, 3),
(6, '4', TRUE, 4),
(7, '5', FALSE, 4),
(8, 'Wie geht es dir?', TRUE, 5),
(9, 'Mars', FALSE, 6),
(10, 'Jupiter', TRUE, 6),
(11, 'Grazie', FALSE, 7),
(12, 'Thank you', TRUE, 7),
(13, 'H2O', TRUE, 8),
(14, 'Carbon Dioxide', FALSE, 8),
(15, 'Até logo', TRUE, 9),
(16, 'Hasta luego', FALSE, 9),
(17, '4', TRUE, 10),
(18, '5', FALSE, 10),
(19, 'おはよう', TRUE, 11),
(20, 'こんにちは', FALSE, 11),
(21, 'William Shakespeare', TRUE, 12),
(22, 'Charles Dickens', FALSE, 12),
(23, '사랑해요', TRUE, 13),
(24, '고마워요', FALSE, 13),
(25, 'Rome', TRUE, 14),
(26, 'Venice', FALSE, 14),
(27, 'Спокойной ночи', TRUE, 15),
(28, 'Добрый вечер', FALSE, 15),
(29, '9', TRUE, 16),
(30, '6', FALSE, 16),
(31, '请', TRUE, 17),
(32, '谢谢', FALSE, 17),
(33, 'Tokyo', TRUE, 18),
(34, 'Osaka', FALSE, 18),
(35, 'Excusez-moi', TRUE, 19),
(36, 'Pardon', FALSE, 19),
(37, '0', FALSE, 20),
(38, '32', TRUE, 20),
(39, '¿Dónde está el baño?', TRUE, 21),
(40, '¿Dónde está la cocina?', FALSE, 21),
(41, 'Leonardo da Vinci', TRUE, 22),
(42, 'Vincent van Gogh', FALSE, 22),
(43, 'Buona giornata', TRUE, 23),
(44, 'Arrivederci', FALSE, 23),
(45, '299,792 km/s', TRUE, 24),
(46, '150,000 km/s', FALSE, 24),
(47, 'Bis morgen', TRUE, 25),
(48, 'Bis bald', FALSE, 25),
(49, '8', FALSE, 26),
(50, '16', TRUE, 26),
(51, 'Pode ajudar-me?', TRUE, 27),
(52, 'Preciso de um médico', FALSE, 27),
(53, 'Mount Everest', TRUE, 28),
(54, 'K2', FALSE, 28),
(55, 'Je suis affamé', TRUE, 29),
(56, 'Je suis fatigué', FALSE, 29),
(57, 'Canberra', TRUE, 30),
(58, 'Sydney', FALSE, 30),
(59, 'Добрый день', TRUE, 31),
(60, 'Доброе утро', FALSE, 31),
(61, 'お誕生日おめでとう', TRUE, 33),
(62, 'さようなら', FALSE, 33),
(63, '축하해요', TRUE, 35),
(64, '감사합니다', FALSE, 35),
(65, 'Christopher Columbus', TRUE, 36),
(66, 'Ferdinand Magellan', FALSE, 36),
(67, '我需要医生', TRUE, 37),
(68, '我需要帮助', FALSE, 37),
(69, 'Brasilia', TRUE, 38),
(70, 'Rio de Janeiro', FALSE, 38),
(71, 'Buona fortuna', TRUE, 39),
(72, 'Ciao', FALSE, 39),
(73, 'Venus', FALSE, 40),
(74, 'Mercury', TRUE, 40),
(75, 'Cuídate', TRUE, 41),
(76, 'Hasta luego', FALSE, 41),
(77, 'Der Pazifik', TRUE, 42),
(78, 'Der Atlantik', FALSE, 42),
(79, 'Ich bin verloren', TRUE, 43),
(80, 'Ich bin müde', FALSE, 43),
(81, '12', TRUE, 44),
(82, '13', FALSE, 44),
(83, 'Parlez-vous anglais?', TRUE, 45),
(84, 'Parlez-vous français?', FALSE, 45),
(85, 'Moscow', TRUE, 46),
(86, 'Saint Petersburg', FALSE, 46),
(87, 'Feliz Ano Novo', TRUE, 47),
(88, 'Bom dia', FALSE, 47),
(89, 'Sahara', TRUE, 48),
(90, 'Gobi', FALSE, 48),
(91, '再见', TRUE, 49),
(92, '你好', FALSE, 49),
(93, 'Yen', TRUE, 50),
(94, 'Won', FALSE, 50);

-- Query test_answer
SELECT *
FROM test_answer ta;

-- Insert into test_question_info
INSERT INTO test_question_info (test_id, question_id) VALUES
(1, 1),
(1, 5),
(1, 9),
(1, 13),
(1, 17),
(2, 2),
(2, 6),
(2, 10),
(2, 14),
(2, 18),
(3, 3),
(3, 7),
(3, 11),
(3, 15),
(3, 19),
(4, 4),
(4, 8),
(4, 12),
(4, 16),
(4, 20);

-- Query test_question_info
SELECT *
FROM test_question_info tqi;

-- Insert into product_placement_inclusion
INSERT INTO product_placement_inclusion (product_id, lesson_id, inclusion_date) VALUES
(1, 1, '2023-03-15'),
(2, 2, '2023-04-20'),
(3, 3, '2023-06-25'),
(4, 4, '2023-07-15'),
(5, 5, '2023-08-10'),
(6, 6, '2023-09-15'),
(7, 7, '2023-10-10'),
(8, 8, '2023-11-20'),
(9, 9, '2023-12-05'),
(10, 10, '2023-12-15');

-- Query product_placement_inclusion
SELECT *
FROM product_placement_inclusion ppi;

-- Insert into content_type
INSERT INTO content_type (content_type_id, content_type_description, lesson_id) VALUES
(1, 'Vocabulary', 1),
(2, 'Grammar', 2),
(3, 'Listening', 3),
(4, 'Speaking', 4);

-- Query content_type
SELECT *
FROM content_type ct;


-- DUOLINGO DB QUERIES
-- Query to list the most popular courses by enrollment
SELECT c.course_name, COUNT(e.user_id) AS total_enrollments
FROM course c
JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY total_enrollments DESC;


-- Query to Get the Top-Performing Users Based on XP Earned
SELECT u.user_first_name, u.user_last_name, SUM(s.earned_xp) AS total_xp
FROM duo_user u
JOIN score s ON u.user_id = s.user_id
GROUP BY u.user_first_name, u.user_last_name
ORDER BY total_xp DESC
LIMIT 10;


-- Query to Find top Revenue by Company
SELECT c.company_name, SUM(p.incident_price) AS total_revenue
FROM product_placement p
JOIN client_company c ON p.company_id = c.company_id
GROUP BY c.company_name
ORDER BY total_revenue DESC
LIMIT 3;


 -- Query to find users who have completed a specific course and their scores
SELECT u.user_first_name, u.user_last_name, c.course_name, l.completion_date, s.accuracy_percentage, s.earned_xp
FROM duo_user u
JOIN lesson l ON u.user_id = l.user_id
JOIN course c ON l.course_id = c.course_id
JOIN score s ON l.lesson_id = s.lesson_id
WHERE l.completion_date IS NOT NULL;


-- Query to Find Product Placement in Lessons
SELECT pp.product_name, c.course_name, l.lesson_level, ppi.inclusion_date
FROM product_placement pp
JOIN product_placement_inclusion ppi ON pp.product_id = ppi.product_id
JOIN lesson l ON ppi.lesson_id = l.lesson_id
JOIN course c ON l.course_id = c.course_id
ORDER BY ppi.inclusion_date DESC, l.lesson_level;


-- Query to Find Average Test Scores by Course
SELECT c.course_name, AVG(t.test_result) AS average_test_score
FROM course c
JOIN lesson l ON c.course_id = l.course_id
JOIN test t ON l.user_id = t.user_id
GROUP BY c.course_name
ORDER BY average_test_score DESC;
