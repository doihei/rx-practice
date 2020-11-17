//
//  Requestable.swift
//  young-jump-ios-datasource
//
//  Created by doi on 2019/09/10.
//

import APIKit
import SwiftProtobuf
import SwiftyBeaver
import SwiftyUserDefaults

enum IOType {
    case json
    case protobuf
}

/// APIKitリクエスト基底
protocol Requestable: Request, CustomStringConvertible {
    
    var ioType: IOType { get }
    
    var protoParameters: SwiftProtobuf.Message? { get }
    
    var isAuthenticate: Bool { get }
    
    var isEncryption: Bool { get }
    
    var isMock: Bool { get }
    
    var mockResponse: Response? { get }
    
    var retryType: RetryType { get }
    
    func convertError(_ errorResponse: ErrorResponse) -> DatasourceErrorProtocol?
}

// MARK: - Requestable
extension Requestable {
    
    var baseURL: URL {
        switch Environment.configuration {
        case .debug, .development:
            return URL(string: "https://dev.yj-app.xyz")!
        case .qualityAssurance:
            return URL(string: "https://api-qa3.ynjn.jp")!
        case .stressCheck:
            return URL(string: "https://stresscheck.yj-app.xyz")!
        case .staging:
            return URL(string: "https://api-stg.ynjn.jp")!
        case .release:
            let isCamoflage: Bool = UserDefaultsGatewayProvider.provide().get(DefaultsKeys.isCamouflage)
            return isCamoflage ? URL(string: "https://api-app.ynjn.jp")! : URL(string: "https://api-prod.ynjn.jp")!
        }
    }
    
    var headerFields: [String: String] {
        var fields: [String: String] = [:]
        
        fields["Device-Type"] = "1" // iosは1
        fields["App-Version"] = String(AppInfo.versionInInteger)
        
        if isAuthenticate, let accessToken = try? RealmGatewayProvider.provide().values(AuthObject.self).first?.accessToken {
            fields["Access-Token"] = accessToken
        }
        
        return fields
    }

    /// 基本的にはtrueにする(そっちの方が多いので)
    var isAuthenticate: Bool {
        return true
    }

    /// 暗号化の有無
    /// /auth/login /auth/sprashなど暗号化をしないのもあるので、確認
    var isEncryption: Bool {
        switch Environment.configuration {
        case .debug, .development, .qualityAssurance, .stressCheck, .staging, .release:
            return true
        }
    }
    
    /// Mockかどうか
    /// DEBUGでは trueですが、 個々リクエスト側でmockResponseを定義しないと流さない
    var isMock: Bool {
        switch Environment.configuration {
        case .debug:
            return true
        case .development, .qualityAssurance, .stressCheck, .staging, .release:
            return false
        }
    }

    /// モックで動くレスポンスの定義　default: nil
    var mockResponse: Response? {
        return nil
    }
    
    /// リトライタイプ
    var retryType: RetryType {
        return .none
    }
    
    /// 各種APIでのエラー定義
    func convertError(_ errorResponse: ErrorResponse) -> DatasourceErrorProtocol? {
        return nil
    }
    
    /// I/Oタイプ jsonのみ
    var ioType: IOType {
        return .json
    }
    
    /// リクエスト時付加Proto定義パラメータ
    /// こちらを主に継承して使用
    var protoParameters: SwiftProtobuf.Message? {
        return nil
    }
    
    /// こちらは原則継承しない
    var bodyParameters: BodyParameters? {
        guard let protoParameters = protoParameters else { return nil }
        switch ioType {
        case .json:
            if isEncryption {
                guard let jsonString = try? protoParameters.jsonString(options: Self.jsonEncodingOptions),
                    let encryptedString = try? CryptoHelperImpl.encrypt(input: jsonString, iv: CryptoHelperImpl.createIv()) else {
                    return nil
                }
                return APIKit.JSONBodyParameters(JSONObject: ["data": encryptedString])
            } else {
                guard let serializedData = try? protoParameters.jsonUTF8Data(options: Self.jsonEncodingOptions) else { return nil }
                return JSONBodyParameters(serializedData)
            }
        case .protobuf:
            return nil
        }
    }
    
    /// リクエスト割り込み処理
    ///
    /// - Parameter urlRequest: URLRequest
    /// - Returns: URLRequest
    /// - Throws:
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        switch Environment.configuration {
        case .debug, .development:
            urlRequest.timeoutInterval = 30.0
        case .staging, .qualityAssurance, .release, .stressCheck:
            urlRequest.timeoutInterval = 15.0
        }
        
        return urlRequest
    }
    
    /// レスポンス割り込み処理
    ///
    /// - Parameters:
    ///   - object: Any
    ///   - urlResponse: URLResponse
    /// - Returns: Any
    /// - Throws:
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            guard let data = object as? Data else {
                throw ResponseError.unexpectedObject(object)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decordedData = try decoder.decode(BaseResponse.self, from: data)
            guard isEncryption && decordedData.isEncrypted else {
                throw failureConvertError(from: decordedData.data)
            }
            let decryptedString = try CryptoHelperImpl.decrypt(input: decordedData.data)
            throw failureConvertError(from: decryptedString)
        }
        return object
    }
    
    private static var jsonEncodingOptions: JSONEncodingOptions {
        var options = JSONEncodingOptions()
        options.preserveProtoFieldNames = true
        return options
    }
    
    private static var jsonDecodingOptions: JSONDecodingOptions {
        var options = JSONDecodingOptions()
        options.ignoreUnknownFields = true
        return options
    }
    
    private func failureConvertError<T>(from data: T) -> Error {
        let errorData: Data
        if let data = data as? Data {
            errorData = data
        } else if let jsonString = data as? String {
            guard let jsonData = jsonString.data(using: .utf8) else {
                return ResponseError.unexpectedObject(jsonString)
            }
            errorData = jsonData
        } else {
            return ResponseError.unexpectedObject(data)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let errorReponse = try decoder.decode(ErrorResponse.self, from: errorData)
            guard let apiErrorData = DatasourceErrorData(errorReponse, requestRetryType: retryType, requestError: convertError(errorReponse)) else {
                return DatasourceErrorData(DatasourceError.internal("undefined error"), requestRetryType: retryType)
            }
            return apiErrorData
        } catch let error {
            return error
        }
    }
}

// MARK: - Response: SwiftProtobuf.Message
extension Requestable where Response: SwiftProtobuf.Message {
    
    var dataParser: DataParser {
        switch ioType {
        case .json:
            return JSONDataParser()
        case .protobuf:
            return ProtobufDataParser()
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        switch ioType {
        case .json:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(BaseResponse.self, from: data)
                guard isEncryption && decodedData.isEncrypted else {
                    return try response(from: decodedData.data, isSuccess: decodedData.isSuccess)
                }
                let decryptedString = try CryptoHelperImpl.decrypt(input: decodedData.data)
                return try response(from: decryptedString, isSuccess: decodedData.isSuccess)
            } catch let error {
                guard let decodingError = error as? DecodingError else {
                    throw error
                }
                throw DatasourceErrorData(DatasourceError.internal(decodingError.localizedDescription), requestRetryType: retryType)
            }
        case .protobuf:
            throw DatasourceErrorData(DatasourceError.internal("cannot use protobuf"), requestRetryType: retryType)
        }
    }
    
    /// isSuccessによる切り分け
    /// - Parameters:
    ///   - jsonString: Any(Data or String)
    ///   - isSuccess: 成功したかどうか
    private func response<T>(from json: T, isSuccess: Bool) throws -> Response {
        if isSuccess {
            if let jsonString = json as? String {
                return try Response(jsonString: jsonString, options: Self.jsonDecodingOptions)
            } else if let jsonData = json as? Data {
                return try Response(jsonUTF8Data: jsonData, options: Self.jsonDecodingOptions)
            } else {
                throw ResponseError.unexpectedObject(json)
            }
        } else {
            throw failureConvertError(from: json)
        }
    }
}

// MARK: - CustomStringConvertible
extension Requestable {
    
    var description: String {
        let body = (try? protoParameters?.jsonString(options: Self.jsonEncodingOptions)) ?? ""
        var query: String = ""
        if let queryParameters = queryParameters {
            query = queryParameters.description
        }
        
        return "\(Self.self)\n" +
            "[\(method)] \(baseURL)\(path)\n" +
            "Header: \(headerFields)\n" +
            "Body: \(body)\n" +
            "Query: \(query)"
    }
}
