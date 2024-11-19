//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//


import Vapor

struct CourseController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let courses = routes.grouped("courses")
        
        courses.get(use: index) // List all courses
        courses.post(use: create) // Create a new course
        courses.group(":courseID") { course in
            course.get(use: show) // Show a specific course
            course.put(use: update) // Update a specific course
            course.delete(use: delete) // Delete a specific course
        }
    }

    // List all courses
    func index(req: Request) throws -> EventLoopFuture<[Course]> {
        Course.query(on: req.db).all()
    }

    // Create a new course
    func create(req: Request) throws -> EventLoopFuture<Course> {
        let course = try req.content.decode(Course.self)
        return course.save(on: req.db).map { course }
    }

    // Show details of a specific course
    func show(req: Request) throws -> EventLoopFuture<Course> {
        Course.find(req.parameters.get("courseID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    // Update a specific course
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let updatedCourse = try req.content.decode(Course.self)
        return Course.find(req.parameters.get("courseID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { course in
                course.title = updatedCourse.title
                course.$instructor.id = updatedCourse.$instructor.id
                return course.save(on: req.db).transform(to: .ok)
            }
    }

    // Delete a specific course
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Course.find(req.parameters.get("courseID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
