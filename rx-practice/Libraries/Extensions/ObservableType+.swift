//
//  ObservableType+.swift
//  young-jump-ios
//
//  Created by doi on 2019/09/10.
//

import RxCocoa
import RxSwift

// MARK: ObservableType where E: OptionalType
extension ObservableType where Element: OptionalType {

    /// Filters out the nil elements of a sequence of optional elements
    /// - returns: An observable sequence of only the non-nil elements
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { item -> Observable<Element.Wrapped> in
            if let value = item.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

extension ObservableType {
    
    /// Error Map
    ///
    /// - Parameter handler: error変換関数
    /// - Returns: Observable
    func errorMap(_ handler: @escaping (Swift.Error) -> Swift.Error) -> Observable<Element> {
        return catchError { error -> Observable<Element> in
            .error(handler(error))
        }
    }
    
    /// キャスト(失敗はエラーもしくはcomplete)
    /// - Parameter resultType: Cast.Type
    /// - Parameter isThrowableError: Bool
    func castOrThrow<Cast>(_ resultType: Cast.Type, isThrowableError: Bool = true) -> Observable<Cast> {
        return flatMap { item -> Observable<Cast> in
            guard let cast = item as? Cast else {
                return isThrowableError ?
                    .error(RxCocoaError.castingError(object: item, targetType: resultType)) :
                    .empty()
            }
            return .just(cast)
        }
    }
    
    /// bind(onNext: ) の循環参照回避
    /// - Parameters:
    ///   - object: Object(self)
    ///   - selector: method
    func bind<Object: AnyObject>(to object: Object, selector: @escaping (Object) -> (Element) -> Void) -> Disposable {
        return bind { [weak object] element in
            object.map(selector)?(element)
        }
    }
    
    /// bind(onNext: ) の循環参照回避
    /// - Parameters:
    ///   - object: Object(self)
    ///   - selector: method
    func bind<Object: AnyObject>(to object: Object, selector: @escaping (Object) -> () -> Void) -> Disposable {
        return bind { [weak object] _ in
            object.map(selector)?()
        }
    }

    /// BinderObjectではないもののbind
    /// - Parameters:
    ///   - object: Object(self)
    ///   - keyPath: Element
    func bind<Object: AnyObject>(to object: Object, keyPath: ReferenceWritableKeyPath<Object, Element>...) -> Disposable {
        return bind { [weak object] element in
            keyPath.forEach {
                object?[keyPath: $0] = element
            }
        }
    }
}

// swiftlint:disable syntactic_sugar
extension ObservableType where Element == Array<Any> {
    
    /// キャスト(失敗はエラーもしくはcomplete)
    /// - Parameter resultType: Cast.Type
    /// - Parameter isThrowableError: Bool
    func castOrThrow<Cast>(_ resultType: Cast.Type, with index: Int, isThrowableError: Bool = true) -> Observable<Cast> {
        return flatMap { item -> Observable<Cast> in
            guard let cast = item[safe: index] as? Cast else {
                return isThrowableError ?
                    .error(RxCocoaError.castingError(object: item, targetType: resultType)) :
                    .empty()
            }
            return .just(cast)
        }
    }
}
