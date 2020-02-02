/// Паттерн Шаблонный метод
///
/// Назначение: Определяет скелет алгоритма, перекладывая ответственность за
/// некоторые его шаги на подклассы. Паттерн позволяет подклассам переопределять
/// шаги алгоритма, не меняя его общей структуры.

import XCTest


/// Абстрактный Протокол и его расширение определяет шаблонный метод, содержащий
/// скелет некоторого алгоритма, состоящего из вызовов (обычно) абстрактных
/// примитивных операций.
///
/// Конкретные подклассы должны реализовать эти операции, но оставить сам
/// шаблонный метод без изменений.
protocol AbstractProtocol {

    /// Шаблонный метод определяет скелет алгоритма.
    func templateMethod()

    /// Эти операции уже имеют реализации.
    func baseOperation1()

    func baseOperation2()

    func baseOperation3()

    /// А эти операции должны быть реализованы в подклассах.
    func requiredOperations1()
    func requiredOperation2()

    /// Это «хуки». Подклассы могут переопределять их, но это не обязательно,
    /// поскольку у хуков уже есть стандартная (но пустая) реализация. Хуки
    /// предоставляют дополнительные точки расширения в некоторых критических
    /// местах алгоритма.
    func hook1()
    func hook2()
}

extension AbstractProtocol {

    func templateMethod() {
        baseOperation1()
        requiredOperations1()
        baseOperation2()
        hook1()
        requiredOperation2()
        baseOperation3()
        hook2()
    }

    /// Эти операции уже имеют реализации.
    func baseOperation1() {
        print("AbstractProtocol says: I am doing the bulk of the work\n")
    }

    func baseOperation2() {
        print("AbstractProtocol says: But I let subclasses override some operations\n")
    }

    func baseOperation3() {
        print("AbstractProtocol says: But I am doing the bulk of the work anyway\n")
    }

    func hook1() {}
    func hook2() {}
}

/// Конкретные классы должны реализовать все абстрактные операции базового
/// класса. Они также могут переопределить некоторые операции с реализацией по
/// умолчанию.
class ConcreteClass1: AbstractProtocol {

    func requiredOperations1() {
        print("ConcreteClass1 says: Implemented Operation1\n")
    }

    func requiredOperation2() {
        print("ConcreteClass1 says: Implemented Operation2\n")
    }

    func hook2() {
        print("ConcreteClass1 says: Overridden Hook2\n")
    }
}

/// Обычно конкретные классы переопределяют только часть операций базового
/// класса.
class ConcreteClass2: AbstractProtocol {

    func requiredOperations1() {
        print("ConcreteClass2 says: Implemented Operation1\n")
    }

    func requiredOperation2() {
        print("ConcreteClass2 says: Implemented Operation2\n")
    }

    func hook1() {
        print("ConcreteClass2 says: Overridden Hook1\n")
    }
}

/// Клиентский код вызывает шаблонный метод для выполнения алгоритма. Клиентский
/// код не должен знать конкретный класс объекта, с которым работает, при
/// условии, что он работает с объектами через интерфейс их базового класса.
class Client {
    // ...
    static func clientCode(use object: AbstractProtocol) {
        // ...
        object.templateMethod()
        // ...
    }
    // ...
}


/// Давайте посмотрим как всё это будет работать.
class TemplateMethodConceptual: XCTestCase {

    func test() {

        print("Same client code can work with different subclasses:\n")
        Client.clientCode(use: ConcreteClass1())

        print("\nSame client code can work with different subclasses:\n")
        Client.clientCode(use: ConcreteClass2())
    }
}
