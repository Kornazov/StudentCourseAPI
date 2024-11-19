//
//
//  Created by Kornazov, Kristiyan (GfK) on 19.11.24.
//

import Fluent
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) throws {
    // Configure SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Register migrations
    app.migrations.add(CreateStudent())
    app.migrations.add(CreateCourse())
    app.migrations.add(CreateInstructor())
    app.migrations.add(CreateEnrollment())

    // Run migrations
    try app.autoMigrate().wait()

    // Register routes
    try routes(app)
}
