//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor

struct InstructorController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let instructors = routes.grouped("instructors")
        
        instructors.get(use: index) // List all instructors
        instructors.post(use: create) // Create a new instructor
        instructors.group(":instructorID") { instructor in
            instructor.delete(use: delete) // Delete an instructor
            instructor.get("courses", use: courses) // Get courses taught by an instructor
        }
    }

    // List all instructors
    func index(req: Request) throws -> EventLoopFuture<[Instructor]> {
        Instructor.query(on: req.db).all()
    }

    // Create a new instructor
    func create(req: Request) throws -> EventLoopFuture<Instructor> {
        let instructor = try req.content.decode(Instructor.self)
        return instructor.save(on: req.db).map { instructor }
    }

    // Delete an instructor
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Instructor.find(req.parameters.get("instructorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    // Get all courses taught by an instructor
    func courses(req: Request) throws -> EventLoopFuture<[Course]> {
        Instructor.find(req.parameters.get("instructorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { instructor in
                instructor.$courses.query(on: req.db).all()
            }
    }
}
