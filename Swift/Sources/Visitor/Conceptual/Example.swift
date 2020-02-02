/// Паттерн Посетитель
///
/// Назначение: Позволяет создавать новые операции, не меняя классы объектов,
/// над которыми эти операции могут выполняться.

import XCTest

/// Интерфейс Компонента объявляет метод принятия, который в качестве аргумента
/// может получать любой объект, реализующий интерфейс посетителя.
protocol Component {

    func accept(_ visitor: Visitor)
}

/// Каждый Конкретный Компонент должен реализовать метод принятия таким образом,
/// чтобы он вызывал метод посетителя, соотвествующий классу компонента.
class ConcreteComponentA: Component {

    /// Обратите внимание, мы вызываем visitConcreteComponentA, что
    /// соответствует названию текущего класса. Таким образом мы позволяем
    /// посетителю узнать, с каким классом компонента он работает.
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentA(element: self)
    }

    /// Конкретные Компоненты могут иметь особые методы, не объявленные в их
    /// базовом классе или интерфейсе. Посетитель всё же может использовать эти
    /// методы, поскольку он знает о конкретном классе компонента.
    func exclusiveMethodOfConcreteComponentA() -> String {
        return "A"
    }
}

class ConcreteComponentB: Component {

    /// То же самое здесь: visitConcreteComponentB => ConcreteComponentB
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentB(element: self)
    }

    func specialMethodOfConcreteComponentB() -> String {
        return "B"
    }
}

/// Интерфейс Посетителя объявляет набор методов посещения, соответствующих
/// классам компонентов. Сигнатура метода посещения позволяет посетителю
/// определить конкретный класс компонента, с которым он имеет дело.
protocol Visitor {

    func visitConcreteComponentA(element: ConcreteComponentA)
    func visitConcreteComponentB(element: ConcreteComponentB)
}

/// Конкретные Посетители реализуют несколько версий одного и того же алгоритма,
/// которые могут работать со всеми классами конкретных компонентов.
///
/// Максимальную выгоду от паттерна Посетитель вы почувствуете, используя его со
/// сложной структурой объектов, такой как дерево Компоновщика. В этом случае
/// было бы полезно хранить некоторое промежуточное состояние алгоритма при
/// выполнении методов посетителя над различными объектами структуры.
class ConcreteVisitor1: Visitor {

    func visitConcreteComponentA(element: ConcreteComponentA) {
        print(element.exclusiveMethodOfConcreteComponentA() + " + ConcreteVisitor1\n")
    }

    func visitConcreteComponentB(element: ConcreteComponentB) {
        print(element.specialMethodOfConcreteComponentB() + " + ConcreteVisitor1\n")
    }
}

class ConcreteVisitor2: Visitor {

    func visitConcreteComponentA(element: ConcreteComponentA) {
        print(element.exclusiveMethodOfConcreteComponentA() + " + ConcreteVisitor2\n")
    }

    func visitConcreteComponentB(element: ConcreteComponentB) {
        print(element.specialMethodOfConcreteComponentB() + " + ConcreteVisitor2\n")
    }
}

/// Клиентский код может выполнять операции посетителя над любым набором
/// элементов, не выясняя их конкретных классов. Операция принятия направляет
/// вызов к соответствующей операции в объекте посетителя.
class Client {
    // ...
    static func clientCode(components: [Component], visitor: Visitor) {
        // ...
        components.forEach({ $0.accept(visitor) })
        // ...
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class VisitorConceptual: XCTestCase {

    func test() {
        let components: [Component] = [ConcreteComponentA(), ConcreteComponentB()]

        print("The client code works with all visitors via the base Visitor interface:\n")
        let visitor1 = ConcreteVisitor1()
        Client.clientCode(components: components, visitor: visitor1)

        print("\nIt allows the same client code to work with different types of visitors:\n")
        let visitor2 = ConcreteVisitor2()
        Client.clientCode(components: components, visitor: visitor2)
    }
}