import Foundation
import Vapor
import FluentPostgreSQL
//import FluentSQLite


final class AcronymCategoryPivot: PostgreSQLUUIDPivot { //SQLiteUUIDPivot
    
    var id: UUID?
    var acronymID: Acronym.ID
    var categoryID: Category.ID
    
    typealias Left = Acronym
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \AcronymCategoryPivot.acronymID
    static let rightIDKey: RightIDKey = \AcronymCategoryPivot.categoryID
    
    
    init(_ acronymID: Acronym.ID, _ categoryID: Category.ID) {
        
        self.acronymID = acronymID
        self.categoryID = categoryID
    }
}



extension AcronymCategoryPivot: Migration { }

