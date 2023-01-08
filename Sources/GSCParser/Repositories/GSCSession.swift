//
//  Session.swift
//  GSCParser
//
//  Created by 이승윤 on 2022/12/25.
//

import Alamofire
import Foundation

let Requester = GSCSession.shared.session

class GSCSession {

    init() {
        session = Session(interceptor: Interceptor(retriers: [Retrier()]))
    }

    var session: Session

    fileprivate static let shared = GSCSession()

}

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
