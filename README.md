## RxSwift 공부  
// #1 create 연산자
let o1 = Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    
    observer.onCompleted()
    
    return Disposables.create() // Disposable은 메모리 정리에 필요한 객체
}

// #2 from 연산자
let o2 = Observable.from([0, 1])

// #1, #2 은 단순히 Observable 을 생성해준 것일뿐 아직 사용되지 않았음
// 그렇다면 언제 이걸 사용할 수 있을까? 바로 Subscribe 행위가 일어났을때!
// Subscribe 메서드(혹은 연산자)는 Observable 과 Observer 를 연결해주는 역할을 한다.

// #1 구독방법 (그냥 한방에 받아버리는 것)
// Observable 의 역할이 종료된 후 그 결과 값이 클로저 형태로 들어오게 되는 것
// 그리고 중요한 규칙이 있는데 Observable 이 값을 방출할땐 한번에 하나의 이벤트를 방출한다는 것. Start / End 로그가 찍히는걸 보면 확인할 수 있다.
o1.subscribe {
    print("Start")
    if let element = $0.element {
        print(element)
    }
    print("End")
}

print("-----------------------------")

// #2 구독방법 (개별 이벤트를 별도의 클로저에서 받고싶을때 사용하는 방법)
o1.subscribe(onNext: { element in
    print(element)
})
