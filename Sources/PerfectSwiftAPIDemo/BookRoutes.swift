import Foundation
import PerfectHTTP
import PerfectSQLite

private let jsonContentType = MimeType.forExtension("json") + "; charset=utf-8"

extension HTTPRequest {

    fileprivate func paramAsInt(name: String, defaultValue: Int) -> Int? {
        guard let (_, value) = queryParams.filter({ $0.0 == name }).first else {
            return defaultValue
        }
        guard let intValue = Int(value, radix: 10) else {
            return nil
        }
        return intValue
    }
    
}

private struct BookParams {
    
    let limit: Int
    let offset: Int
    
    init?(request: HTTPRequest) {
        guard let limit = request.paramAsInt(name: "limit", defaultValue: 10) else {
            return nil
        }
        guard let offset = request.paramAsInt(name: "offset", defaultValue: 0) else {
            return nil
        }
        self.limit = limit
        self.offset = offset
    }
    
}

func makeURLRoutes() -> Routes {
    var routes = Routes()
    var api = Routes()

    // MARK: GET: /api/books?limit=10&offset=0
    
    api.add(method: .get, uri: "/books") { (request, response) in
        defer { response.completed() }

        guard let params = BookParams(request: request) else {
            response.status = .badRequest
            return
        }
        
        do {
            let db = try SQLite(Paths.databasePath, readOnly: true)
            defer { db.close() }
            
            var jsonArray = [Any]()
            
            let sql = "SELECT BookId, BookName, SubName "
                + "FROM Book "
                + "ORDER BY BookId "
                + "LIMIT \(params.limit) "
                + "OFFSET \(params.offset);"
            try db.forEachRow(statement: sql) { (stmt, rowNum) in
                let bookId = stmt.columnText(position: 0)
                let bookName = stmt.columnText(position: 1)
                let subName = stmt.columnText(position: 2)
                
                var obj = [String : Any]()
                obj["bookId"] = bookId
                obj["bookName"] = bookName
                obj["subName"] = subName
                
                jsonArray.append(obj)
            }
            
            if jsonArray.count == 0 {
                response.status = .notFound
                return
            }
            
            response.addHeader(.contentType, value: jsonContentType)
            response.appendBody(string: try jsonArray.jsonEncodedString())
        }
        catch {
            print("\(error)")
            response.status = .internalServerError
        }
    }
    
    // MARK: GET: /api/books/001234
    
    api.add(method: .get, uri: "/books/{id}") { (request, response) in
        defer { response.completed() }
        
        let bookId = request.urlVariables["id"]!
        if bookId.characters.count != 6 {
            response.status = .badRequest
            return
        }
        if let _ = bookId.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) {
            response.status = .badRequest
            return
        }
        
        do {
            let db = try SQLite(Paths.databasePath, readOnly: true)
            defer { db.close() }
            
            var jsonObject = [String : Any]()

            var count = 0
            var sql = "SELECT BookId, BookName, SubName, CreateDate, LastUpdate, BookCardUrl "
                + "FROM Book "
                + "WHERE BookId='\(bookId)';"
            try db.forEachRow(statement: sql) { (stmt, rowNum) in
                let bookName = stmt.columnText(position: 1)
                let subName = stmt.columnText(position: 2)
                let createDate = stmt.columnText(position: 3)
                let lastUpdate = stmt.columnText(position: 4)
                let bookCardUrl = stmt.columnText(position: 5)
                
                jsonObject["bookId"] = bookId
                jsonObject["bookName"] = bookName
                jsonObject["subName"] = subName
                jsonObject["createDate"] = createDate
                jsonObject["lastUpdate"] = lastUpdate
                jsonObject["bookCardUrl"] = bookCardUrl

                count = rowNum
            }
            
            if count == 0 {
                response.status = .notFound
                return
            }
            
            var personArray = [Any]()
            
            sql = "SELECT P.PersonId, PR.RoleFlag, LastName, FirstName, DateOfBirth, DateOfDeath "
                + "FROM Person P "
                + "INNER JOIN Person_Role PR "
                + "ON P.PersonId=PR.PersonId "
                + "WHERE PR.BookId='\(bookId)';"
            try db.forEachRow(statement: sql) { (stmt, rowNum) in
                let personId = stmt.columnText(position: 0)
                let roleFlag = stmt.columnText(position: 1)
                let lastName = stmt.columnText(position: 2)
                let firstName = stmt.columnText(position: 3)
                let dateOfBirth = stmt.columnText(position: 4)
                let dateOfDeath = stmt.columnText(position: 5)
                
                var personObject = [String : Any]()
                personObject["personId"] = personId
                personObject["roleFlag"] = roleFlag
                personObject["lastName"] = lastName
                personObject["firstName"] = firstName
                personObject["dateOfBirth"] = dateOfBirth
                personObject["dateOfDeath"] = dateOfDeath
                
                personArray.append(personObject)
            }
            
            jsonObject["persons"] = personArray
            
            response.addHeader(.contentType, value: jsonContentType)
            response.appendBody(string: try jsonObject.jsonEncodedString())
        }
        catch {
            print("\(error)")
            response.status = .internalServerError
        }
    }
    
    var apiRoutes = Routes(baseUri: "/api")
    apiRoutes.add(api)
    routes.add(apiRoutes)
    return routes
}
