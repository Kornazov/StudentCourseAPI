//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor
import Fluent

final class Instructor: Model, Content {
    static let schema = "instructors"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Children(for: \.$instructor)
    var courses: [Course]

    init() {}

    init(id: UUID? = nil, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
