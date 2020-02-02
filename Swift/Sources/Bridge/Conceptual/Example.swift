/// Паттерн Мост
///
/// Назначение: Разделяет один или несколько классов на две отдельные иерархии —
/// абстракцию и реализацию, позволяя изменять их независимо друг от друга.
///
///               A
///            /     \                        A         N
///          Aa      Ab        ===>        /     \     / \
///         / \     /  \                 Aa(N) Ab(N)  1   2
///       Aa1 Aa2  Ab1 Ab2

import XCTest

/// Абстракция устанавливает интерфейс для «управляющей» части двух иерархий
/// классов. Она содержит ссылку на объект из иерархии Реализации и делегирует
/// ему всю настоящую работу.
class Abstraction {

    fileprivate var implementation: Implementation

    init(_ implementation: Implementation) {
        self.implementation = implementation
    }

    func operation() -> String {
        let operation = implementation.operationImplementation()
        return "Abstraction: Base operation with:\n" + operation
    }
}

/// Можно расширить Абстракцию без изменения классов Реализации.
class ExtendedAbstraction: Abstraction {

    override func operation() -> String {
        let operation = implementation.operationImplementation()
        return "ExtendedAbstraction: Extended operation with:\n" + operation
    }
}

/// Реализация устанавливает интерфейс для всех классов реализации. Он не должен
/// соответствовать интерфейсу Абстракции. На практике оба интерфейса могут быть
/// совершенно разными. Как правило, интерфейс Реализации предоставляет только
/// примитивные операции, в то время как Абстракция определяет операции более
/// высокого уровня, основанные на этих примитивах.
protocol Implementation {

    func operationImplementation() -> String
}

/// Каждая Конкретная Реализация соответствует определённой платформе и
/// реализует интерфейс Реализации с использованием API этой платформы.
class ConcreteImplementationA: Implementation {

    func operationImplementation() -> String {
        return "ConcreteImplementationA: Here's the result on the platform A.\n"
    }
}

class ConcreteImplementationB: Implementation {

    func operationImplementation() -> String {
        return "ConcreteImplementationB: Here's the result on the platform B\n"
    }
}

/// За исключением этапа инициализации, когда объект Абстракции связывается с
/// определённым объектом Реализации, клиентский код должен зависеть только от
/// класса Абстракции. Таким образом, клиентский код может поддерживать любую
/// комбинацию абстракции и реализации.
class Client {
    // ...
    static func someClientCode(abstraction: Abstraction) {
        print(abstraction.operation())
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class BridgeConceptual: XCTestCase {

    func testBridgeConceptual() {
        // Клиентский код должен работать с любой предварительно
        // сконфигурированной комбинацией абстракции и реализации.
        let implementation = ConcreteImplementationA()
        Client.someClientCode(abstraction: Abstraction(implementation))

        let concreteImplementation = ConcreteImplementationB()
        Client.someClientCode(abstraction: ExtendedAbstraction(concreteImplementation))
    }
}