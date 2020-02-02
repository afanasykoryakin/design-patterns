/// Паттерн Наблюдатель
///
/// Назначение: Создаёт механизм подписки, позволяющий одним объектам следить и
/// реагировать на события, происходящие в других объектах.
///
/// Обратите внимание, что существует множество различных терминов с похожими
/// значениями, связанных с этим паттерном. Просто помните, что Субъекта также
/// называют Издателем, а Наблюдателя часто называют Подписчиком и наоборот.
/// Также глаголы «наблюдать», «слушать» или «отслеживать» обычно означают одно
/// и то же.
///
/// Язык Swift имеет несколько способов реализации Наблюдателя. Вот некоторые из
/// них:
///
/// - KVO. Вот замечательный пример того, как можно реализовать паттерн с
/// помощью дюжины строк кода:
/// https://www.objc.io/blog/2018/04/24/bindings-with-kvo-and-keypaths/
///
/// - NotificationCenter:
/// https://developer.apple.com/documentation/foundation/notificationcenter
///
/// - RxSwift:
/// https://github.com/ReactiveX/RxSwift
///
/// В этом примере, однако, мы попробуем реализовать Наблюдатель самостоятельно.

import XCTest

/// Издатель владеет некоторым важным состоянием и оповещает наблюдателей о его
/// изменениях.
class Subject {

    /// Для удобства в этой переменной хранится состояние Издателя, необходимое
    /// всем подписчикам.
    var state: Int = { return Int(arc4random_uniform(10)) }()

    /// @var array Список подписчиков. В реальной жизни список подписчиков может
    /// храниться в более подробном виде (классифицируется по типу события и
    /// т.д.)
    private lazy var observers = [Observer]()

    /// Методы управления подпиской.
    func attach(_ observer: Observer) {
        print("Subject: Attached an observer.\n")
        observers.append(observer)
    }

    func detach(_ observer: Observer) {
        if let idx = observers.index(where: { $0 === observer }) {
            observers.remove(at: idx)
            print("Subject: Detached an observer.\n")
        }
    }

    /// Запуск обновления в каждом подписчике.
    func notify() {
        print("Subject: Notifying observers...\n")
        observers.forEach({ $0.update(subject: self)})
    }

    /// Обычно логика подписки – только часть того, что делает Издатель.
    /// Издатели часто содержат некоторую важную бизнес-логику, которая
    /// запускает метод уведомления всякий раз, когда должно произойти что-то
    /// важное (или после этого).
    func someBusinessLogic() {
        print("\nSubject: I'm doing something important.\n")
        state = Int(arc4random_uniform(10))
        print("Subject: My state has just changed to: \(state)\n")
        notify()
    }
}

/// Наблюдатель объявляет метод уведомления, который используют издатели для
/// оповещения.
protocol Observer: class {

    func update(subject: Subject)
}

/// Конкретные Наблюдатели реагируют на обновления, выпущенные Издателем, к
/// которому они прикреплены.
class ConcreteObserverA: Observer {

    func update(subject: Subject) {

        if subject.state < 3 {
            print("ConcreteObserverA: Reacted to the event.\n")
        }
    }
}

class ConcreteObserverB: Observer {

    func update(subject: Subject) {

        if subject.state >= 3 {
            print("ConcreteObserverB: Reacted to the event.\n")
        }
    }
}

/// Давайте посмотрим как всё это будет работать.
class ObserverConceptual: XCTestCase {

    func testObserverConceptual() {

        let subject = Subject()

        let observer1 = ConcreteObserverA()
        let observer2 = ConcreteObserverB()

        subject.attach(observer1)
        subject.attach(observer2)

        subject.someBusinessLogic()
        subject.someBusinessLogic()
        subject.detach(observer2)
        subject.someBusinessLogic()
    }
}
