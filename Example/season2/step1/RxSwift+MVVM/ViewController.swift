//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // Observable의 생명주기 (기본형태)
    // 1. Create
    // 2. Subscribe
    // 3. onNext
    // -----  끝 ------
    // 4. onCompleted / onError
    // 5. Disposed
    
    func downloadJSON(_ url: String) -> Observable<String> {
        return Observable.create { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard error == nil else {
                    emitter.onError(error!)
                    return
                }
                
                if let dat = data, let json = String(data: dat, encoding: .utf8) {
                    emitter.onNext(json)
                }
                
                emitter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: SYNC
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
        let jsonObservable = downloadJSON(MEMBER_LIST_URL)
        let helloObservable = Observable.just("Hello World")
        
        // zip 사용 예시  -> 두가지 Observable을 합침
        Observable.zip(jsonObservable, helloObservable) { $1 + "\n" + $0 }
            .observeOn(MainScheduler.instance) // <- DispatchQueue.main.async 의 기능을 해줌
            .subscribe(onNext: { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
            .disposed(by: disposeBag)
    }
}
