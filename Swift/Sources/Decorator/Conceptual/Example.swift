/// Паттерн Декоратор
///
/// Назначение: Позволяет динамически добавлять объектам новую функциональность,
/// оборачивая их в полезные «обёртки».

import XCTest

/// Базовый интерфейс Компонента определяет поведение, которое изменяется
/// декораторами.
protocol Component {

    func operation() -> String
}

/// Конкретные Компоненты предоставляют реализации поведения по умолчанию. Может
/// быть несколько вариаций этих классов.
class ConcreteComponent: Component {

    func operation() -> String {
        return "ConcreteComponent"
    }
}

/// Базовый класс Декоратора следует тому же интерфейсу, что и другие
/// компоненты.   Основная цель этого класса - определить интерфейс обёртки для
/// всех конкретных декораторов. Реализация кода обёртки по умолчанию может
/// включать в себя  поле для хранения завёрнутого компонента и средства его
/// инициализации.
class Decorator: Component {

    private var component: Component

    init(_ component: Component) {
        self.component = component
    }

    /// Декоратор делегирует всю работу обёрнутому компоненту.
    func operation() -> String {
        return component.operation()
    }
}

/// Конкретные Декораторы вызывают обёрнутый объект и изменяют его результат
/// некоторым образом.
class ConcreteDecoratorA: Decorator {

    /// Декораторы могут вызывать родительскую реализацию операции,  вместо
    /// того, чтобы вызвать обёрнутый объект напрямую. Такой подход упрощает
    /// расширение классов декораторов.
    override func operation() -> String {
        return "ConcreteDecoratorA(" + super.operation() + ")"
    }
}

/// Декораторы могут выполнять своё поведение до или после вызова обёрнутого
/// объекта.
class ConcreteDecoratorB: Decorator {

    override func operation() -> String {
        return "ConcreteDecoratorB(" + super.operation() + ")"
    }
}

/// Клиентский код работает со всеми объектами, используя интерфейс Компонента.
/// Таким образом, он остаётся независимым от конкретных классов компонентов,  с
/// которыми работает.
class Client {
    // ...
    static func someClientCode(component: Component) {
        print("Result: " + component.operation())
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class DecoratorConceptual: XCTestCase {

    func testDecoratorConceptual() {
        // Таким образом, клиентский код может поддерживать как простые
        // компоненты...
        print("Client: I've got a simple component")
        let simple = ConcreteComponent()
        Client.someClientCode(component: simple)

        // ...так и декорированные.
        //
        // Обратите внимание, что декораторы могут обёртывать не только простые
        // компоненты, но и другие декораторы.
        let decorator1 = ConcreteDecoratorA(simple)
        let decorator2 = ConcreteDecoratorB(decorator1)
        print("\nClient: Now I've got a decorated component")
        Client.someClientCode(component: decorator2)
    }
}
