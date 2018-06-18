import Vapor


struct UserController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let route = router.grouped("api", "users")
        
        //GET
        route.get(User.parameter, use: get)
        route.get(use: getAll)
        route.get(User.parameter, "acronyms", use: getAcronyms)
        
        //POST
        route.post(use: create)
        
    }
    
    
    func create(_ request: Request) throws -> Future<User> {
        
        return try request.content.decode(User.self).flatMap(to: User.self) { user in
            
            return user.save(on: request)
        }
    }
    
    
    func get(_ request: Request) throws -> Future<User> {
        
        return try request.parameters.next(User.self)
    }
    
    
    func getAll(_ request: Request) throws -> Future<[User]> {
        
        return User.query(on: request).all()
    }
    
    
    func getAcronyms(_ request: Request) throws -> Future<[Acronym]> {
        
        return try request.parameters.next(User.self).flatMap(to: [Acronym].self) { user in
            
            return try user.acronyms.query(on: request).all()
        }
    }
}

