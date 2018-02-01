import Foundation

class Paths {

    private class var documentURL: /*URL*/ String {
        let path = "./Resources"
        return path
    }

    class var webRootPath: String {
        let url = documentURL
        return url + "/webroot"
    }
    
    class var indexHtmlPath: String {
        let url = documentURL
        return url + "/webroot/index.html"
    }

    class var databasePath: String {
        let url = documentURL
        return url + "/database.sqlite"
    }

}
