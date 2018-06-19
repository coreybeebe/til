import Vapor
//import FluentSQLite
import FluentPostgreSQL

final class Acronym: Codable {
    
    var id: Int?
    var abbreviation: String
    var description: String
    var creatorID: User.ID
    
    init(abbreviation: String, description: String, creatorID: User.ID) {
        
        self.abbreviation = abbreviation
        self.description = description
        self.creatorID = creatorID
    }
}


//extension Acronym: SQLiteModel {}
extension Acronym: PostgreSQLModel { }
extension Acronym: Content {}
extension Acronym: Parameter {}
extension Acronym: Migration {}

extension Acronym {
    
    var creator: Parent<Acronym, User> {
        
        return parent(\.creatorID)
    }
    
    var categories: Siblings<Acronym, Category, AcronymCategoryPivot> {
        
        return siblings()
    }
}

