import Foundation

class Paths {

    private class var documentURL: URL {
        let path = String(cString: getenv("HOME")) + "/PerfectSwiftAPIDemo/Resources"
        return URL(fileURLWithPath: path, isDirectory: true)
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
