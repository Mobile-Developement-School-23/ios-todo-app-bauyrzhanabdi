import Alamofire

extension HTTPHeader {
    public static func authToken() -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: "Bearer halfnesses")
    }

    public static func revision(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "X-Last-Known-Revision", value: value)
    }
}
