import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create server object.
let server = HTTPServer()

// Listen on port 8181.
server.serverPort = 8181

// This will serve all static content by default
server.documentRoot = Paths.webRootPath

// Add our routes.
var routes = makeURLRoutes()

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
