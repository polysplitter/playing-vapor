import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get("api", "hello") { req -> String in
        return "Hello"
    }
    
    // creates a new acronym.
    router.post("api", "acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self, { acronym in
                return acronym.save(on: req)
            })
    }
    
    // gets all acronyms
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).all()
    }
    
    // get one acronym
    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try req.parameters.next(Acronym.self)
    }
    
    // update an acronym
    router.put("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try flatMap(to: Acronym.self, req.parameters.next(Acronym.self), req.content.decode(Acronym.self), { acronym, updatedAcronym in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            
            return acronym.save(on: req)
        })
    }
    
    // delete an acronym
    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Acronym.self)
                        .delete(on: req)
                        .transform(to: HTTPStatus.noContent)
    }
}
