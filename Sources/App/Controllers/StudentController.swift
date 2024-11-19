//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor

struct StudentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let students = routes.grouped("students")
        
        students.get(use: index) // List all students
        students.post(use: create) // Create a new student
        students.group(":studentID") { student in
            student.get(use: show) // Show a specific student
            student.put(use: update) // Update a specific student
            student.delete(use: delete) // Delete a specific student
        }
    }

    // List all students
    func index(req: Request) throws -> EventLoopFuture<[Student]> {
        Student.query(on: req.db).all()
    }

    // Create a new student
    func create(req: Request) throws -> EventLoopFuture<Student> {
        let student = try req.content.decode(Student.self)
        return student.save(on: req.db).map { student }
    }

    // Show details of a specific student
    func show(req: Request) throws -> EventLoopFuture<Student> {
        Student.find(req.parameters.get("studentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    // Update a specific student
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let updatedStudent = try req.content.decode(Student.self)
        return Student.find(req.parameters.get("studentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { student in
                student.name = updatedStudent.name
                student.age = updatedStudent.age
                return student.save(on: req.db).transform(to: .ok)
            }
    }

    // Delete a specific student
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Student.find(req.parameters.get("studentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
