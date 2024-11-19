//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor
import Fluent

final class Course: Model, Content {
    static let schema = "courses"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String?

    @Parent(key: "instructorID")
    var instructor: Instructor

    // Siblings relationship between Course and Student via Enrollment
    @Siblings(through: Enrollment.self, from: \.$course, to: \.$student)
    var students: [Student]

    init() {}

    init(id: UUID? = nil, title: String, description: String?, instructorID: UUID) {
        self.id = id
        self.title = title
        self.description = description
        self.$instructor.id = instructorID
    }
}
