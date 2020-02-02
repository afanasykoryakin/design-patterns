/// Паттерн Фабричный Метод
///
/// Назначение: Определяет общий интерфейс для создания объектов в суперклассе,
/// позволяя подклассам изменять тип создаваемых объектов.

import XCTest

/// Класс Создатель объявляет фабричный метод, который должен возвращать объект
/// класса Продукт. Подклассы Создателя обычно предоставляют реализацию этого
/// метода.
protocol Creator {

    /// Обратите внимание, что Создатель может также обеспечить реализацию
    /// фабричного метода по умолчанию.
    func factoryMethod() -> Product

    /// Также заметьте, что, несмотря на название, основная обязанность
    /// Создателя не заключается в создании продуктов. Обычно он содержит
    /// некоторую базовую бизнес-логику, которая основана на объектах Продуктов,
    /// возвращаемых фабричным методом. Подклассы могут косвенно изменять эту
    /// бизнес-логику, переопределяя фабричный метод и возвращая из него другой
    /// тип продукта.
    func someOperation() -> String
}

/// Это расширение реализует базовое поведение Создателя. Оно может быть
/// переопределено в подклассах.
extension Creator {

    func someOperation() -> String {
        // Вызываем фабричный метод, чтобы получить объект-продукт.
        let product = factoryMethod()

        // Далее, работаем с этим продуктом.
        return "Creator: The same creator's code has just worked with " + product.operation()
    }
}

/// Конкретные Создатели переопределяют фабричный метод для того, чтобы изменить
/// тип результирующего продукта.
class ConcreteCreator1: Creator {

    /// Обратите внимание, что сигнатура метода по-прежнему использует тип
    /// абстрактного продукта, хотя фактически из метода возвращается конкретный
    /// продукт. Таким образом, Создатель может оставаться независимым от
    /// конкретных классов продуктов.
    public func factoryMethod() -> Product {
        return ConcreteProduct1()
    }
}

class ConcreteCreator2: Creator {

    public func factoryMethod() -> Product {
        return ConcreteProduct2()
    }
}

/// Протокол Продукта объявляет операции, которые должны выполнять все
/// конкретные продукты.
protocol Product {

    func operation() -> String
}

/// Конкретные Продукты предоставляют различные реализации протокола Продукта.
class ConcreteProduct1: Product {

    func operation() -> String {
        return "{Result of the ConcreteProduct1}"
    }
}

class ConcreteProduct2: Product {

    func operation() -> String {
        return "{Result of the ConcreteProduct2}"
    }
}


/// Клиентский код работает с экземпляром конкретного создателя, хотя и через
/// его базовый протокол. Пока клиент продолжает работать с создателем через
/// базовый протокол, вы можете передать ему любой подкласс создателя.
class Client {
    // ...
    static func someClientCode(creator: Creator) {
        print("Client: I'm not aware of the creator's class, but it still works.\n"
            + creator.someOperation());
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class FactoryMethodConceptual: XCTestCase {

    func testFactoryMethodConceptual() {

        /// Приложение выбирает тип создателя в зависимости от конфигурации или
        /// среды.

        print("App: Launched with the ConcreteCreator1.");
        Client.someClientCode(creator: ConcreteCreator1())

        print("\nApp: Launched with the ConcreteCreator2.");
        Client.someClientCode(creator: ConcreteCreator2())
    }
}
