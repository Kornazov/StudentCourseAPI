RESTful API, реализиран с Vapor и Fluent (Swift Frameworks). API-то позволява управление на студенти, курсове, инструктори и записвания в курсове (enrollments).

Основни функционалности

	1.	Управление на студенти: Създаване, извличане, изтриване на студенти и извличане на записани курсове.
	2.	Управление на курсове: Създаване, извличане, изтриване на курсове и извличане на записаните студенти.
	3.	Управление на инструктори: Създаване, извличане, изтриване на инструктори и извличане на курсовете, които преподават.
	4.	Управление на записвания: Създаване, извличане и изтриване на записвания на студенти в курсове.

Основни ендпойнти

1. Студенти

	•	GET /students
Извлича всички студенти.
Отговор: 200 OK - списък с всички студенти.
	•	POST /students
Създава нов студент.
Параметри: name (String), email (String)
Пример:

{ "name": "Kristiyan Kornazov", "email": "kristiyan.kornazov@example.com" }

Отговор: 201 Created - създаденият студент.

	•	DELETE /students/:studentID
Изтрива студент по зададено ID.
Параметри: studentID (UUID)
Отговор: 204 No Content
	•	GET /students/:studentID/courses
Извлича всички курсове, в които е записан студент.
Параметри: studentID (UUID)
Отговор: 200 OK - списък с курсове.

2. Курсове

	•	GET /courses
Извлича всички курсове.
Отговор: 200 OK - списък с всички курсове.
	•	POST /courses
Създава нов курс.
Параметри: title (String), description (String), instructorID (UUID)
Пример:

{ "title": "Swift 101", "description": "Intro to Swift", "instructorID": "UUID" }

Отговор: 201 Created - създаденият курс.

	•	DELETE /courses/:courseID
Изтрива курс по зададено ID.
Параметри: courseID (UUID)
Отговор: 204 No Content
	•	GET /courses/:courseID/students
Извлича всички студенти, записани в даден курс.
Параметри: courseID (UUID)
Отговор: 200 OK - списък със студенти.

3. Инструктори

	•	GET /instructors
Извлича всички инструктори.
Отговор: 200 OK - списък с всички инструктори.
	•	POST /instructors
Създава нов инструктор.
Параметри: name (String), email (String)
Пример:

{ "name": "Ivan Ivanov", "email": "ivan.ivanov@example.com" }

Отговор: 201 Created - създаденият инструктор.

	•	DELETE /instructors/:instructorID
Изтрива инструктор по зададено ID.
Параметри: instructorID (UUID)
Отговор: 204 No Content
	•	GET /instructors/:instructorID/courses
Извлича всички курсове, които даден инструктор преподава.
Параметри: instructorID (UUID)
Отговор: 200 OK - списък с курсове.

4. Записвания

	•	GET /enrollments
Извлича всички записвания.
Отговор: 200 OK - списък с всички записвания.
	•	POST /enrollments
Създава ново записване на студент в курс.
Параметри: studentID (UUID), courseID (UUID)
Пример:

{ "studentID": "UUID", "courseID": "UUID" }

Отговор: 201 Created - създаденото записване.

	•	DELETE /enrollments/:enrollmentID
Изтрива записване по зададено ID.
Параметри: enrollmentID (UUID)
Отговор: 204 No Content

Технологии

	•	Vapor: Framework за изграждане на сървърни приложения с Swift.
	•	Fluent: ORM (Object Relational Mapper) за управление на бази данни.

База данни

	•	Таблици:
	•	Students: Съдържа информация за студенти (id, name, email).
	•	Courses: Съдържа информация за курсове (id, title, description, instructorID).
	•	Instructors: Съдържа информация за инструктори (id, name, email).
	•	Enrollments: Асоциативна таблица между студенти и курсове (id, studentID, courseID).
