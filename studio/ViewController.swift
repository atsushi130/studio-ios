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

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let formatter = DateFormatter.from(locale: Locale.current, format: "yyyy/MM/dd HH:mm:ss")
        let startDate = formatter.date(from: "2019/05/06 17:30:00")!
        let studioReservation = StudioReservation(startDate: startDate, studioType: .studioC)!
        StudioApi.loginService.login(name: "", password: "")
            .flatMap {
                StudioApi.reservationService.fetchReservations(month: 5, day: 6)
            }
            // .flatMap {
            //     StudioApi.reservationService.reserve(studioReservation: studioReservation)
            // }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: self.disposeBag)
    }


}

