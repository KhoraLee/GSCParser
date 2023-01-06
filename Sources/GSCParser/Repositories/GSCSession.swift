//
//  Session.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/25.
//

import Alamofire
import Foundation

// MARK: - GSCSession

let GSC = GSCSession.shared.session

// MARK: - GSCSession

class GSCSession {

    // MARK: Lifecycle

    init() {
        session = Session(interceptor: Interceptor(retriers: [Retrier()]))
    }

    // MARK: Internal

    var session: Session

    // MARK: Fileprivate

    fileprivate static let shared = GSCSession()

}

// MARK: - Retrier

class Retrier: RequestRetrier {
    func retry(
        _ request: Alamofire.Request,
        for _: Alamofire.Session,
        dueTo error: Error,
        completion: @escaping (Alamofire.RetryResult) -> Void)
    {
        let maxRetry = 5
        if case AFError.sessionTaskFailed(let err) = error {
            if (err as? URLError)?.code == .some(.timedOut), request.retryCount < maxRetry {
                completion(.retryWithDelay(1.0))
                return
            }
        }
        completion(.doNotRetry)
    }
}
