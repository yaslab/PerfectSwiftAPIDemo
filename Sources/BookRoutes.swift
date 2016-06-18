import Foundation
import PerfectLib
import SQLite

private let jsonContentType = MimeType.forExtension("json") + "; charset=utf-8"

private struct BookParams {
    
    let limit: Int
    let offset: Int
    
    init?(queryParams: [(String, String)]) {
        var limit = 10
        var offset = 0
        
        let limitStr = queryParams
            .filter { $0.0 == "limit" }
            .first?.1
        let offsetStr = queryParams
            .filter { $0.0 == "offset" }
            .first?.1
        
        if limitStr != nil {
            guard let i = Int(limitStr!) else {
                return nil
            }
            guard i > 0 else {
                return nil
            }
            limit = i
        }
        if offsetStr != nil {
            guard let i = Int(offsetStr!) else {
                return nil
            }
            guard i >= 0 else {
                return nil
            }
            offset = i
        }
        
        self.limit = limit
        self.offset = offset
    }
    
}

func addBookRoutes() {
    
    // MARK: GET: /api/books?limit=10&offset=0
    
    Routing.Routes[.get, "/api/books"] = { (request, response) in
        defer { response.requestCompleted() }

        guard let params = BookParams(queryParams: request.queryParams) else {
            response.setStatus(code: 400, message: "Bad Request")
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
                response.setStatus(code: 404, message: "Not Found")
                return
            }
            
            response.addHeader(name: "Content-Type", value: jsonContentType)
            response.appendBody(string: try jsonArray.jsonEncodedString())
        }
        catch let error {
            print("\(error)")
            response.setStatus(code: 500, message: "Internal Server Error")
        }
    }
    
    // MARK: GET: /api/books/001234
    
    Routing.Routes[.get, "/api/books/{id}"] = { (request, response) in
        defer { response.requestCompleted() }
        
        let bookId = request.urlVariables["id"]!
        if bookId.characters.count != 6 {
            response.setStatus(code: 400, message: "Bad Request")
            return
        }
        // note: `CharacterSet` dose not work in Linux.
        //if let _ = bookId.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) {
        //    response.setStatus(code: 400, message: "Bad Request")
        //    return
        //}
        
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
                response.setStatus(code: 404, message: "Not Found")
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
            
            response.addHeader(name: "Content-Type", value: jsonContentType)
            response.appendBody(string: try jsonObject.jsonEncodedString())
        }
        catch let error {
            print("\(error)")
            response.setStatus(code: 500, message: "Internal Server Error")
        }
    }
    
}
