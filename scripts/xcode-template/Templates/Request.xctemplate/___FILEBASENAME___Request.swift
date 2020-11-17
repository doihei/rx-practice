//___FILEHEADER___

import APIKit

struct ___VARIABLE_productName___Request: Requestable {

    typealias Response = // TODO: type

    var path: String {
        return // TODO: path
    }

    var method: HTTPMethod {
        return // TODO: method
    }

    var queryParameters: [String : Any]? {
        return // TODO: params
    }

    /// 個別APIでのエラー定義
    /// あれば、APIErrorProtocol継承のerrorを定義し、こちらでconvert
    func convertError(_ errorResponse: ErrorResponse) -> DatasourceErrorProtocol? {
        return nil
    }
}
