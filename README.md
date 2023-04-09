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

## Subject
// 타입 파라미터를 String 으로 설정
// subject 가 생성될 땐, 내부에 아무런 이벤트가 저장되어 있지 않음
let subject = PublishSubject<String>()

// subject 가 Observer 의 역할도 할 수 있기에 onNext 메서드를 사용할 수 있다.
subject.onNext("Hello") // "Hello" 라는 문자열이 찍히려면 PublishSubeject인 subject를 구독한 이후에 호출해야 문자열이 찍히는 걸 확인할 수 있다.

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)

// 정상적으로 찍히는 것을 확인할 수 있는 코드
subject.onNext("RxSwift")

let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject") // 여기서 이렇게 호출하는 순간 o1 에서도 동일한 값이 호출되는걸 볼 수 있다.

subject.onCompleted() // completed 이벤트가 전달된 이후에 생성되는 next 이벤트는 전달 되지 않는다.

//subject.onError(MyError.error) <- 한번 확인해보기

let o3 = subject.subscribe { print(">> 3", $0) }
o3.disposed(by: disposeBag)
                                    
                                    
## Operators  
                                    just

                                    
                                    
---------  
CombiningOperators  
                                    
