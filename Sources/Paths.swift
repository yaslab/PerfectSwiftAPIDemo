import Foundation

class Paths {

    // note: `URL` dose not work in Linux.
    private class var documentURL: /*URL*/ String {
        let path = String(cString: getenv("HOME")) + "/PerfectSwiftAPIDemo/Resources"
        //return URL(fileURLWithPath: path, isDirectory: true)
        return path
    }

    class var webRootPath: String {
        var url = documentURL
        //try! url.appendPathComponent("webroot", isDirectory: true)
        //return url.path!
        return url + "/webroot"
    }
    
    class var indexHtmlPath: String {
        var url = documentURL
        //try! url.appendPathComponent("webroot/index.html", isDirectory: false)
        //return url.path!
        return url + "/webroot/index.html"
    }

    class var databasePath: String {
        var url = documentURL
        //try! url.appendPathComponent("database.sqlite", isDirectory: false)
        //return url.path!
        return url + "/database.sqlite"
    }

}
