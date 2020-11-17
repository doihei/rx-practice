//___FILEHEADER___

import APIKit

public enum ___VARIABLE_productName___APIError: DatasourceErrorProtocol {

    /// 必ずErrorResponseをasociatedValueで渡してください！
    public init?(_ errorResponse: ErrorResponse) {
        switch errorResponse.errorCode {
        default:
            return nil
        }
    }
}
