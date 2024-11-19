//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor
import Fluent

final class Student: Model, Content {
    static let schema = "students"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "age")
    var age: Int

    // Siblings relationship between Student and Course via Enrollment
    @Siblings(through: Enrollment.self, from: \.$student, to: \.$course)
    var courses: [Course]

    init() {}

    init(id: UUID? = nil, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }
}
