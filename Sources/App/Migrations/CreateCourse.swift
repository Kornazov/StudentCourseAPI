//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Fluent

struct CreateCourse: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("courses")
            .id()
            .field("title", .string, .required)
            .field("description", .string)
            .field("instructorID", .uuid, .required, .references("instructors", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("courses").delete()
    }
}
