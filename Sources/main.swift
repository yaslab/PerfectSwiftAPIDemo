import Foundation
import PerfectLib

// Initialize base-level services
PerfectServer.initializeServices()

// Create our webroot
// This will serve all static content by default
let webRoot = Paths.webRootPath
try Dir(webRoot).create()

// Add our routes and such
// Register your own routes and handlers
Routing.Routes["/"] = { (request, response) in
    defer { response.requestCompleted() }
    
    do {
        let html = try File(Paths.indexHtmlPath).readString()
        response.addHeader(name: "Content-Type", value: "text/html")
        response.appendBody(string: html)
    }
    catch {
        let message = "Internal Server Error"
        response.appendBody(string: message)
        response.setStatus(code: 500, message: message)
    }
}

addBookRoutes()

print("\(Routing.Routes.description)")

do {
    // Launch the HTTP server on port 8181
    try HTTPServer(documentRoot: webRoot).start(port: 8181)
}
catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
