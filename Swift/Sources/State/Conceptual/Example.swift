/// Паттерн Состояние
///
/// Назначение: Позволяет объектам менять поведение в зависимости от своего
/// состояния. Извне создаётся впечатление, что изменился класс объекта.

import XCTest

/// Контекст определяет интерфейс, представляющий интерес для клиентов. Он также
/// хранит ссылку на экземпляр подкласса Состояния, который отображает текущее
/// состояние Контекста.
class Context {

    /// Ссылка на текущее состояние Контекста.
    private var state: State

    init(_ state: State) {
        self.state = state
        transitionTo(state: state)
    }

    /// Контекст позволяет изменять объект Состояния во время выполнения.
    func transitionTo(state: State) {
        print("Context: Transition to " + String(describing: state))
        self.state = state
        self.state.update(context: self)
    }

    /// Контекст делегирует часть своего поведения текущему объекту Состояния.
    func request1() {
        state.handle1()
    }

    func request2() {
        state.handle2()
    }
}

/// Базовый класс Состояния объявляет методы, которые должны реализовать все
/// Конкретные Состояния, а также предоставляет обратную ссылку на объект
/// Контекст, связанный с Состоянием. Эта обратная ссылка может использоваться
/// Состояниями для передачи Контекста другому Состоянию.
protocol State: class {

    func update(context: Context)

    func handle1()
    func handle2()
}

class BaseState: State {

    private(set) weak var context: Context?

    func update(context: Context) {
        self.context = context
    }

    func handle1() {}
    func handle2() {}
}

/// Конкретные Состояния реализуют различные модели поведения, связанные с
/// состоянием Контекста.
class ConcreteStateA: BaseState {

    override func handle1() {
        print("ConcreteStateA handles request1.")
        print("ConcreteStateA wants to change the state of the context.\n")
        context?.transitionTo(state: ConcreteStateB())
    }

    override func handle2() {
        print("ConcreteStateA handles request2.\n")
    }
}

class ConcreteStateB: BaseState {

    override func handle1() {
        print("ConcreteStateB handles request1.\n")
    }

    override func handle2() {
        print("ConcreteStateB handles request2.")
        print("ConcreteStateB wants to change the state of the context.\n")
        context?.transitionTo(state: ConcreteStateA())
    }
}

/// Давайте посмотрим как всё это будет работать.
class StateConceptual: XCTestCase {

    func test() {
        let context = Context(ConcreteStateA())
        context.request1()
        context.request2()
    }
}