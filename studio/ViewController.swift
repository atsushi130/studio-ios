//
//  ViewController.swift
//  studio
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import UIKit
import RxSwift
import Data
import Model
import SwiftExtensions
import Shared
import LocalAuthentication

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // let formatter = DateFormatter.from(locale: Locale.current, format: "yyyy/MM/dd HH:mm:ss")
        // let startDate = formatter.date(from: "2019/05/06 21:00:00")!
        // let studioReservation = StudioReservation(startDate: startDate, studioType: .studioC, orderId: 46912523)!
        
        let context = LAContext()
        context.rx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)
            .flatMap { canEvaluatePolicy -> Observable<(success: Bool, error: Error?)> in
                if canEvaluatePolicy {
                    return context.rx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "認証")
                } else {
                    return .empty()
                }
            }
            .filter { $0.0 }
            .flatMap { _, _ in
                StudioApi.loginService.login(name: "", password: "")
            }
            .flatMap {
                StudioReservationManager.shared.refetchReservations(month: 5, day: 6)
            }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        StudioReservationManager.shared.reservations
            .flatMap { reservations -> Observable<StudioReservation> in
                return Observable.from(reservations)
            }
            .subscribe(onNext: { reservation in
                print(reservation)
            })
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: LAContext {
    
    func canEvaluatePolicy(_ policy: LAPolicy) -> Observable<Bool> {
        return Observable.create { observer in
            var error: NSError?
            let canEvaluatePolicy = self.base.canEvaluatePolicy(policy, error: &error)
            observer.onNext(canEvaluatePolicy)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String) -> Observable<(success: Bool, error: Error?)> {
        return Observable.create { observer in
            self.base.evaluatePolicy(policy, localizedReason: localizedReason) { success, error in
                observer.onNext((success: success, error: error))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
