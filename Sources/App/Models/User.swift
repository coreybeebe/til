import Foundation
import Vapor
import FluentPostgreSQL
//import FluentSQLite

final class User: Codable {
    
    var id: UUID?
    var name: String
    var username: String
    
    
    init(name: String, username: String) {
        
        self.name = name
        self.username = username
    }
}


//extension User: SQLiteUUIDModel { }
extension User: PostgreSQLUUIDModel { }
extension User: Content { }
extension User: Parameter { }
extension User: Migration { }

extension User {
    
    var acronyms: Children<User, Acronym> {
        
        return children(\.creatorID)
    }
}
