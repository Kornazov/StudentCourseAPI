//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor

struct EnrollmentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let enrollments = routes.grouped("enrollments")
        
        enrollments.get(use: index) // List all enrollments
        enrollments.post(use: create) // Create a new enrollment
        enrollments.group(":enrollmentID") { enrollment in
            enrollment.delete(use: delete) // Delete a specific enrollment
        }
    }

    // List all enrollments
    func index(req: Request) throws -> EventLoopFuture<[Enrollment]> {
        Enrollment.query(on: req.db).all()
    }

    // Create a new enrollment
    func create(req: Request) throws -> EventLoopFuture<Enrollment> {
        let enrollment = try req.content.decode(Enrollment.self)
        return enrollment.save(on: req.db).map { enrollment }
    }

    // Delete an enrollment
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Enrollment.find(req.parameters.get("enrollmentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
