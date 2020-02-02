/// Паттерн Посредник
///
/// Назначение: Позволяет уменьшить связанность множества классов между собой,
/// благодаря перемещению этих связей в один класс-посредник.

import XCTest

/// Интерфейс Посредника предоставляет метод, используемый компонентами для
/// уведомления посредника о различных событиях. Посредник может реагировать на
/// эти события и передавать исполнение другим компонентам.
protocol Mediator: AnyObject {

    func notify(sender: BaseComponent, event: String)
}

/// Конкретные Посредники реализуют совместное поведение, координируя отдельные
/// компоненты.
class ConcreteMediator: Mediator {

    private var component1: Component1
    private var component2: Component2

    init(_ component1: Component1, _ component2: Component2) {
        self.component1 = component1
        self.component2 = component2

        component1.update(mediator: self)
        component2.update(mediator: self)
    }

    func notify(sender: BaseComponent, event: String) {
        if event == "A" {
            print("Mediator reacts on A and triggers following operations:")
            self.component2.doC()
        }
        else if (event == "D") {
            print("Mediator reacts on D and triggers following operations:")
            self.component1.doB()
            self.component2.doC()
        }
    }
}

/// Базовый Компонент обеспечивает базовую функциональность хранения экземпляра
/// посредника внутри объектов компонентов.
class BaseComponent {

    fileprivate weak var mediator: Mediator?

    init(mediator: Mediator? = nil) {
        self.mediator = mediator
    }

    func update(mediator: Mediator) {
        self.mediator = mediator
    }
}

/// Конкретные Компоненты реализуют различную функциональность. Они не зависят
/// от других компонентов. Они также не зависят от каких-либо конкретных классов
/// посредников.
class Component1: BaseComponent {

    func doA() {
        print("Component 1 does A.")
        mediator?.notify(sender: self, event: "A")
    }

    func doB() {
        print("Component 1 does B.\n")
        mediator?.notify(sender: self, event: "B")
    }
}

class Component2: BaseComponent {

    func doC() {
        print("Component 2 does C.")
        mediator?.notify(sender: self, event: "C")
    }

    func doD() {
        print("Component 2 does D.")
        mediator?.notify(sender: self, event: "D")
    }
}

/// Давайте посмотрим как всё это будет работать.
class MediatorConceptual: XCTestCase {

    func testMediatorConceptual() {

        let component1 = Component1()
        let component2 = Component2()

        let mediator = ConcreteMediator(component1, component2)
        print("Client triggers operation A.")
        component1.doA()

        print("\nClient triggers operation D.")
        component2.doD()

        print(mediator)
    }
}
