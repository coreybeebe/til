//import FluentSQLite
import FluentPostgreSQL
import Vapor

//  MARK: - Called before your application initializes.

//PostgreSQL
public func configure (_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    try services.register(FluentPostgreSQLProvider())
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    
    //  MARK: - Database Configuration
    var databases = DatabasesConfig()
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    
    let databaseConfig = PostgreSQLDatabaseConfig (hostname: hostname, username: username, database: databaseName, password: password)
    
    let database = PostgreSQLDatabase(config: databaseConfig)
    
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    
    //  MARK: - Model migrations
    var migrations = MigrationConfig()

    migrations.add(model: Acronym.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: AcronymCategoryPivot.self, database: .psql)
    services.register(migrations)
}




//SQLite
//public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
//
//
//    //  MARK: - Register providers first
//    try services.register(FluentSQLiteProvider())
//
//
//    //  MARK: - Register routes to the router
//    let router = EngineRouter.default()
//    try routes(router)
//
//    services.register(router, as: Router.self)
//
//
//    //  MARK: - Register middleware
//    var middlewares = MiddlewareConfig() //Creates _empty_ middleware config
//    // middlewares.use(FileMiddleware.self) //Serves files from `Public/` directory
//    middlewares.use(ErrorMiddleware.self) //Catches errors and converts to HTTP response
//    services.register(middlewares)
//
//
//    //  MARK: - Configure a SQLite database
//    let sqlite = try SQLiteDatabase(storage: .memory)
//    var databases = DatabasesConfig()
//
//    databases.add(database: sqlite, as: .sqlite)
//    services.register(databases)
//    // Registers the configured SQLite database to the database config.
//
//
//    // MARK: - Configure migrations
//    var migrations = MigrationConfig()
//
//    migrations.add(model: Acronym.self, database: .sqlite)
//    migrations.add(model: User.self, database: .sqlite)
//    migrations.add(model: Category.self, database: .sqlite)
//    migrations.add(model: AcronymCategoryPivot.self, database: .sqlite)
//
//    services.register(migrations)
//}“docker run --name postgres -e POSTGRES_DB=vapor \
/*
docker run --name postgres -e POSTGRES_DB=vapor \
-e POSTGRES_USER=vapor -e POSTGRES_PASSWORD=password \
-p 5432:5432 -d postgres

*/


