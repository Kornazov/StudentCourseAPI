//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    // Students
    app.get("students") { req -> EventLoopFuture<[Student]> in
        Student.query(on: req.db).all() // Get all students
    }
    
    app.post("students") { req -> EventLoopFuture<Student> in
        let student = try req.content.decode(Student.self)
        return student.save(on: req.db).map { student } // Create a new student
    }
    
    app.delete("students", ":studentID") { req -> EventLoopFuture<HTTPStatus> in
        // Extract studentID from URL parameters
        let studentID = try req.parameters.require("studentID", as: UUID.self)
        
        return Student.find(studentID, on: req.db).flatMap { student in
            // If the student is not found, return a 404 Not Found response
            guard let student = student else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Student not found"))
            }
            
            // If the student is found, delete the student from the database
            return student.delete(on: req.db).transform(to: .noContent) // Respond with no content after deletion
        }
    }
    
    // Get courses a student is enrolled in
    app.get("students", ":studentID", "courses") { req -> EventLoopFuture<[Course]> in
        // Extract studentID from the URL parameters
        let studentID = try req.parameters.require("studentID", as: UUID.self)
        
        return Student.find(studentID, on: req.db).flatMap { student in
            // If the student is not found, return a 404 Not Found response
            guard let student = student else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Student not found"))
            }
            
            // If the student is found, return the courses they are enrolled in
            return student.$courses.get(on: req.db) // Fetch the courses the student is enrolled in
        }
    }

    // Courses
    app.get("courses") { req -> EventLoopFuture<[Course]> in
        Course.query(on: req.db).all() // Get all courses
    }

    app.post("courses") { req -> EventLoopFuture<Course> in
        let course = try req.content.decode(Course.self)
        return course.save(on: req.db).map { course } // Create a new course
    }

    app.delete("courses", ":courseID") { req -> EventLoopFuture<HTTPStatus> in
        // Extract courseID from the URL parameters
        let courseID = try req.parameters.require("courseID", as: UUID.self)
        
        return Course.find(courseID, on: req.db).flatMap { course in
            // If the course is not found, return a 404 Not Found response
            guard let course = course else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Course not found"))
            }
            
            // If the course is found, delete the course and return a 204 No Content response
            return course.delete(on: req.db).transform(to: .noContent)
        }
    }
    
    // Get students enrolled in a course
    app.get("courses", ":courseID", "students") { req -> EventLoopFuture<[Student]> in
        // Extract courseID from the URL parameters
        let courseID = try req.parameters.require("courseID", as: UUID.self)
        
        return Course.find(courseID, on: req.db).flatMap { course in
            // If the course is not found, return a 404 Not Found response
            guard let course = course else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Course not found"))
            }
            
            // If the course is found, fetch the students enrolled in it
            return course.$students.get(on: req.db) // Retrieve the students enrolled in the course
        }
    }

    // Instructors
    app.get("instructors") { req -> EventLoopFuture<[Instructor]> in
        Instructor.query(on: req.db).all() // Get all instructors
    }

    app.post("instructors") { req -> EventLoopFuture<Instructor> in
        let instructor = try req.content.decode(Instructor.self)
        return instructor.save(on: req.db).map { instructor } // Create a new instructor
    }
    
    app.post("instructors") { req -> EventLoopFuture<Instructor> in
        let instructorData = try req.content.decode(Instructor.self)
        return instructorData.save(on: req.db).map { instructorData }
    }

    app.delete("instructors", ":instructorID") { req -> EventLoopFuture<HTTPStatus> in
        // Extract instructorID from the URL parameters
        let instructorID = try req.parameters.require("instructorID", as: UUID.self)
        
        return Instructor.find(instructorID, on: req.db).flatMap { instructor in
            // If the instructor is not found, return a 404 Not Found response
            guard let instructor = instructor else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Instructor not found"))
            }
            
            // If the instructor is found, delete the instructor and return a 204 No Content response
            return instructor.delete(on: req.db).transform(to: .noContent)
        }
    }
    
    app.post("courses") { req -> EventLoopFuture<Course> in
        // Decode the incoming request data into a Course object
        let courseData = try req.content.decode(Course.self)
        
        // Look up the instructor by ID
        return Instructor.find(courseData.$instructor.id, on: req.db).flatMap { instructor in
            // Check if the instructor is found
            if let instructor = instructor {
                // If instructor exists, save the course
                return courseData.save(on: req.db).map { courseData }
            } else {
                // If instructor is not found, return a failed future with an error
                return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Instructor not found."))
            }
        }
    }

    app.get("instructors", ":instructorID", "courses") { req -> EventLoopFuture<[Course]> in
        // Extract instructorID from the URL parameters
        let instructorID = try req.parameters.require("instructorID", as: UUID.self)
        
        return Instructor.find(instructorID, on: req.db).flatMap { instructor in
            // If the instructor is not found, return a 404 Not Found response
            guard let instructor = instructor else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Instructor not found"))
            }
            
            // If the instructor is found, fetch the courses taught by the instructor
            return instructor.$courses.get(on: req.db) // Retrieve the courses taught by the instructor
        }
    }

    // Enrollments
    app.get("enrollments") { req -> EventLoopFuture<[Enrollment]> in
        Enrollment.query(on: req.db).all() // Get all enrollments
    }

    app.post("enrollments") { req -> EventLoopFuture<Enrollment> in
        let enrollment = try req.content.decode(Enrollment.self)
        return enrollment.save(on: req.db).map { enrollment } // Create a new enrollment
    }

    app.delete("enrollments", ":enrollmentID") { req -> EventLoopFuture<HTTPStatus> in
        // Extract enrollmentID from the URL parameters
        let enrollmentID = try req.parameters.require("enrollmentID", as: UUID.self)
        
        return Enrollment.find(enrollmentID, on: req.db).flatMap { enrollment in
            // If the enrollment is not found, return a 404 Not Found response
            guard let enrollment = enrollment else {
                return req.eventLoop.future(error: Abort(.notFound, reason: "Enrollment not found"))
            }
            
            // If the enrollment is found, delete the enrollment and return a 204 No Content response
            return enrollment.delete(on: req.db).transform(to: .noContent)
        }
    }
}
