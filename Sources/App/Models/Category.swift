import Vapor
import FluentPostgreSQL
//import FluentSQLite


final class Category: Codable {
    
    var id: Int?
    var name: String
    
    init(name: String) {
        
        self.name = name
    }
}


//extension Category: SQLiteModel { }
extension Category: PostgreSQLModel { }
extension Category: Content { }
extension Category: Parameter { }
extension Category: Migration { }


extension Category {
    
    var acronyms: Siblings<Category, Acronym, AcronymCategoryPivot> {
        
        return siblings()
    }
}


