//
//  ViewController.swift
//  ExRxSwiftLoadImage
//
//  Created by eileenyou on 2022/05/23.
//

// 참고 강의 : https://www.youtube.com/watch?v=iHKBNYMWd5I

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    let LARGE_IMAGE_URL = "https://picsum.photos/1024/768/?random"
    let LARGER_IMAGE_URL = "https://picsum.photos/1280/720/?random"
    let LARGEST_IMAGE_URL = "https://picsum.photos/2560/1440/?random"
    
    func syncLoadImage(from imageUrl: String) -> UIImage? {
        guard let url = URL(string: imageUrl) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }

        let image = UIImage(data: data)
        return image
    }
    
    func asyncLoadImage(from imageUrl: String, completed: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let image = self.syncLoadImage(from: imageUrl)
            completed(image)
        }
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

         rxswiftLoadImage(from: LARGER_IMAGE_URL)
            .observeOn(MainScheduler.instance)  // DispatchQueue.main 과 동일한 역할을 하는것
            .subscribe({ result in
                switch result {
                case let .next(image):
                    self.imageView.image = image

                case let .error(err):
                    print(err.localizedDescription)

                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag) // 방법1.
        //disposeBag.insert(disposable) // 방법2.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        // TODO: cancel image loading
        disposeBag = DisposeBag() // disposeBag 안에 담긴 dispoable을 개별로 지울 수 없기 떄문에 새로운 DisposeBag 객체를 만들어주는걸로 초기화시킬 수 있다.
    }
    
    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            self.asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
}

