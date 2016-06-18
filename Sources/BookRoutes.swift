import Foundation
import PerfectLib
import SQLite

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
        
        var json = "{\"books\":["
        
        do {
            let db = try SQLite(Paths.databasePath, readOnly: true)
            defer { db.close() }
            
            var found = false
            let sql = "SELECT BookId, BookName, SubName "
                + "FROM Book "
                + "ORDER BY BookId "
                + "LIMIT \(params.limit) "
                + "OFFSET \(params.offset);"
            try db.forEachRow(statement: sql) { (stmt, rowNum) in
                found = true
                let bookId = stmt.columnText(position: 0)
                let bookName = stmt.columnText(position: 1)
                let subName = stmt.columnText(position: 2)
                print("\(bookId): \(bookName) (\(subName))")
                json += "{"
                    + "\"bookId\":\"\(bookId)\","
                    + "\"bookName\":\"\(bookName)\","
                    + "\"subName\":\"\(subName)\""
                    + "},"
            }
            
            guard found else {
                response.setStatus(code: 404, message: "Not Found")
                return
            }
            
            if json.characters.last == "," {
                json.characters.removeLast(1)
            }
        }
        catch let error {
            print("\(error)")
            response.setStatus(code: 500, message: "Internal Server Error")
            return
        }
        
        json += "]}"
        
        response.addHeader(name: "Content-Type", value: "application/json; charset=utf-8")
        response.appendBody(string: json)
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
        
        var json = "{"
        
        do {
            let db = try SQLite(Paths.databasePath, readOnly: true)
            defer { db.close() }

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
                print("\(bookId): \(bookName) (\(subName))")
                json += "\"bookId\":\"\(bookId)\","
                    + "\"bookName\":\"\(bookName)\","
                    + "\"subName\":\"\(subName)\","
                    + "\"createDate\":\"\(createDate)\","
                    + "\"lastUpdate\":\"\(lastUpdate)\","
                    + "\"bookCardUrl\":\"\(bookCardUrl)\""
                count = rowNum
            }
            
            if count == 0 {
                response.setStatus(code: 404, message: "Not Found")
                return
            }
            
            var personsJson = "\"persons\":["
            
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
                personsJson += "{"
                    + "\"personId\":\"\(personId)\","
                    + "\"roleFlag\":\"\(roleFlag)\","
                    + "\"lastName\":\"\(lastName)\","
                    + "\"firstName\":\"\(firstName)\","
                    + "\"dateOfBirth\":\"\(dateOfBirth)\","
                    + "\"dateOfDeath\":\"\(dateOfDeath)\""
                    + "},"
            }
            
            if personsJson.characters.last == "," {
                personsJson.characters.removeLast(1)
            }
            
            personsJson += "]"
            
            json += "," + personsJson
        }
        catch let error {
            print("\(error)")
            response.setStatus(code: 500, message: "Internal Server Error")
            return
        }
        
        json += "}"

        response.addHeader(name: "Content-Type", value: "application/json; charset=utf-8")
        response.appendBody(string: json)
    }
    
}
