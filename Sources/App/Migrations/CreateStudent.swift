//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Fluent

struct CreateStudent: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("students")
            .id()
            .field("name", .string, .required)
            .field("age", .int, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("students").delete()
    }
}
