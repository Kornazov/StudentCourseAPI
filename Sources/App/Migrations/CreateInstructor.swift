//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Fluent


struct CreateInstructor: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("instructors")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("instructors").delete()
    }
}
