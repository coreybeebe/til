import Vapor


struct CategoryController: RouteCollection {
    
    //  MARK: - Boot
    func boot(router: Router) throws {
        
        let routes = router.grouped("api", "category")
        
        routes.post(use: create)
        routes.get(Category.parameter, use: get)
        routes.get(use: getAll)
        routes.get(Category.parameter, "acronyms", use: getAcronyms)
    }
    
    
    //  MARK: - Request Handlers
    func create(_ request: Request) throws -> Future<Category> {
        
        return try request.content.decode(Category.self).flatMap(to: Category.self) { category in
            
            return category.save(on: request)
        }
    }
    
    
    func get(_ request: Request) throws -> Future<Category> {
        
        return try request.parameters.next(Category.self)
    }
    
    
    func getAll(_ request: Request) throws -> Future<[Category]> {
        
        return Category.query(on: request).all()
    }
    
    
    func getAcronyms(_ request: Request) throws -> Future<[Acronym]> {
        
        return try request.parameters.next(Category.self).flatMap(to: [Acronym].self) { category in
            
            return try category.acronyms.query(on: request).all()
        }
    }
}

