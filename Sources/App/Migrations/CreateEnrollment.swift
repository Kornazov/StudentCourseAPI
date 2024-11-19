//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Fluent

struct CreateEnrollment: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("enrollments")
            .id()
            .field("student_id", .uuid, .required, .references("students", "id", onDelete: .cascade))
            .field("course_id", .uuid, .required, .references("courses", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("enrollments").delete()
    }
}
