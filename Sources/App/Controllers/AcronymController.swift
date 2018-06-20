import Vapor

struct AcronymController: RouteCollection {
    
    //  MARK: - Boot
    func boot(router: Router) throws {
        
        let routes = router.grouped("api", "acronyms")
        
        //GET
        routes.get(Acronym.parameter, use: get)
        routes.get(use: getAll)
        routes.get(Acronym.parameter, "creator", use: getCreator)
        routes.get(Acronym.parameter, "categories", use: getCategories)
        
        //POST
        routes.post(use: create)
        routes.post(Acronym.parameter, "categories", Category.parameter, use: addCategories)
        
        //PUT
        routes.put(Acronym.parameter, use: update)
        
        //DELETE
        routes.delete(Acronym.parameter, use: delete)
    }
    
    
    //  MARK: - Request Handlers
    func create(_ request: Request) throws -> Future<Acronym> {
        
        return try request.content.decode(Acronym.self).flatMap(to: Acronym.self) { acronym in
            
            return acronym.save(on: request)
        }
    }
    
    
    func get(_ request: Request) throws -> Future<Acronym> {
        
        return try request.parameters.next(Acronym.self)
    }
    
    
    func getAll(_ request: Request) throws -> Future<[Acronym]> {
        
        return Acronym.query(on: request).all()
    }
    
    
    func update(_ request: Request) throws -> Future<Acronym> {
        
        return try flatMap(to: Acronym.self, request.parameters.next(Acronym.self), request.content.decode(Acronym.self)) { acronym, updatedAcronym in
            
            acronym.abbreviation = updatedAcronym.abbreviation
            acronym.description = updatedAcronym.description
            
            return acronym.save(on: request)
        }
    }
    
    
    func delete(_ request: Request) throws -> Future<HTTPStatus> {
        
        return try request.parameters.next(Acronym.self).flatMap(to: HTTPStatus.self) { acronym in
            
            return acronym.delete(on: request).transform(to: .noContent)
        }
    }
    
    
    func getCreator(_ request: Request) throws -> Future<User> {
        
        return try request.parameters.next(Acronym.self).flatMap(to: User.self) { acronym in
            
            return acronym.creator.get(on: request)
        }
    }
    
    
    func getCategories(_ request: Request) throws -> Future<[Category]> {
        
        
        return try request.parameters.next(Acronym.self).flatMap(to: [Category].self) { acronym in
            
            return try acronym.categories.query(on: request).all()
        }
    }
    
    
    func addCategories(_ request: Request) throws -> Future<HTTPStatus> {
        
        return try request.parameters.next(Acronym.self).flatMap(to: HTTPStatus.self) { acronym in
            
            return try request.parameters.next(Category.self).flatMap(to: HTTPStatus.self) { category in
                
                let pivot = try AcronymCategoryPivot(acronym.requireID(), category.requireID())
                
                return pivot.save(on: request).transform(to: .ok)
            }
        }
    }
}

