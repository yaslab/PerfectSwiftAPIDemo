import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create server object.
let server = HTTPServer()

// Listen on port 8181.
server.serverPort = 8181

// Create our webroot
// This will serve all static content by default
let webRoot = Paths.webRootPath
try Dir(webRoot).create()

// Add our routes.
var routes = makeURLRoutes()

routes.add(method: .get, uri: "/") { (request, response) in
    defer { response.completed() }

    do {
        let html = try File(Paths.indexHtmlPath).readString()
        response.addHeader(.contentType, value: MimeType.forExtension("html"))
        response.appendBody(string: html)
    }
    catch {
        response.status = .internalServerError
        response.appendBody(string: response.status.description)
    }
}

// Check the console to see the logical structure of what was installed.
print("\(routes.navigator.description)")
server.addRoutes(routes)

do {
    // Launch the HTTP server
    try server.start()
}
catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
