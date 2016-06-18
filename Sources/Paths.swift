import Foundation

class Paths {

    private class var documentURL: URL {
        var url = URL(fileURLWithPath: String(cString: getenv("HOME")), isDirectory: true)
        try! url.appendPathComponent("Documents/PerfectSwiftAPIDemo", isDirectory: true)
        return url
    }

    class var webRootPath: String {
        var url = documentURL
        try! url.appendPathComponent("webroot", isDirectory: true)
        return url.path!
    }
    
    class var indexHtmlPath: String {
        var url = documentURL
        try! url.appendPathComponent("webroot/index.html", isDirectory: false)
        return url.path!
    }

    class var databasePath: String {
        var url = documentURL
        try! url.appendPathComponent("database.sqlite", isDirectory: false)
        return url.path!
    }

}
