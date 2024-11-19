//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Vapor
import Fluent

final class Enrollment: Model, Content {
    static let schema = "enrollments"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "studentID")
    var student: Student

    @Parent(key: "courseID")
    var course: Course

    init() {}

    init(id: UUID? = nil, studentID: UUID, courseID: UUID) {
        self.id = id
        self.$student.id = studentID
        self.$course.id = courseID
    }
}
