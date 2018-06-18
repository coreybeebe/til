import FluentSQLite
import Vapor

//  MARK: - Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    
    //  MARK: - Register providers first
    try services.register(FluentSQLiteProvider())
    
    
    //  MARK: - Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    
    services.register(router, as: Router.self)
    
    
    //  MARK: - Register middleware
    var middlewares = MiddlewareConfig() //Creates _empty_ middleware config
    // middlewares.use(FileMiddleware.self) //Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) //Catches errors and converts to HTTP response
    services.register(middlewares)
    
    
    //  MARK: - Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)
    
    
    // MARK: - Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    
    // MARK: - Configure migrations
    var migrations = MigrationConfig()
    
    migrations.add(model: Acronym.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Category.self, database: .sqlite)
    migrations.add(model: AcronymCategoryPivot.self, database: .sqlite)
    
    services.register(migrations)
}
