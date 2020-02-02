/// Паттерн Строитель
///
/// Назначение: Позволяет создавать сложные объекты пошагово. Строитель даёт
/// возможность использовать один и тот же код строительства для получения
/// разных представлений объектов.

import XCTest

/// Интерфейс Строителя объявляет создающие методы для различных частей объектов
/// Продуктов.
protocol Builder {

    func producePartA()
    func producePartB()
    func producePartC()
}

/// Классы Конкретного Строителя следуют интерфейсу Строителя и предоставляют
/// конкретные реализации шагов построения. Ваша программа может иметь несколько
/// вариантов Строителей, реализованных по-разному.
class ConcreteBuilder1: Builder {

    /// Новый экземпляр строителя должен содержать пустой объект продукта,
    /// который используется в дальнейшей сборке.
    private var product = Product1()

    func reset() {
        product = Product1()
    }

    /// Все этапы производства работают с одним и тем же экземпляром продукта.
    func producePartA() {
        product.add(part: "PartA1")
    }

    func producePartB() {
        product.add(part: "PartB1")
    }

    func producePartC() {
        product.add(part: "PartC1")
    }

    /// Конкретные Строители должны предоставить свои собственные методы
    /// получения результатов. Это связано с тем, что различные типы строителей
    /// могут создавать совершенно разные продукты с разными интерфейсами.
    /// Поэтому такие методы не могут быть объявлены в базовом интерфейсе
    /// Строителя (по крайней мере, в статически типизированном языке
    /// программирования).
    ///
    /// Как правило, после возвращения конечного результата клиенту, экземпляр
    /// строителя должен быть готов к началу производства следующего продукта.
    /// Поэтому обычной практикой является вызов метода сброса в конце тела
    /// метода getProduct. Однако такое поведение не является обязательным, вы
    /// можете заставить своих строителей ждать явного запроса на сброс из кода
    /// клиента, прежде чем избавиться от предыдущего результата.
    func retrieveProduct() -> Product1 {
        let result = self.product
        reset()
        return result
    }
}

/// Директор отвечает только за выполнение шагов построения в определённой
/// последовательности. Это полезно при производстве продуктов в определённом
/// порядке или особой конфигурации. Строго говоря, класс Директор необязателен,
/// так как клиент может напрямую управлять строителями.
class Director {

    private var builder: Builder?

    /// Директор работает с любым экземпляром строителя, который передаётся ему
    /// клиентским кодом. Таким образом, клиентский код может изменить конечный
    /// тип вновь собираемого продукта.
    func update(builder: Builder) {
        self.builder = builder
    }

    /// Директор может строить несколько вариаций продукта, используя одинаковые
    /// шаги построения.
    func buildMinimalViableProduct() {
        builder?.producePartA()
    }

    func buildFullFeaturedProduct() {
        builder?.producePartA()
        builder?.producePartB()
        builder?.producePartC()
    }
}

/// Имеет смысл использовать паттерн Строитель только тогда, когда ваши продукты
/// достаточно сложны и требуют обширной конфигурации.
///
/// В отличие от других порождающих паттернов, различные конкретные строители
/// могут производить несвязанные продукты. Другими словами, результаты
/// различных строителей могут не всегда следовать одному и тому же интерфейсу.
class Product1 {

    private var parts = [String]()

    func add(part: String) {
        self.parts.append(part)
    }

    func listParts() -> String {
        return "Product parts: " + parts.joined(separator: ", ") + "\n"
    }
}

/// Клиентский код создаёт объект-строитель, передаёт его директору, а затем
/// инициирует процесс построения. Конечный результат извлекается из объекта-
/// строителя.
class Client {
    // ...
    static func someClientCode(director: Director) {
        let builder = ConcreteBuilder1()
        director.update(builder: builder)
        
        print("Standard basic product:")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())

        print("Standard full featured product:")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())

        // Помните, что паттерн Строитель можно использовать без класса
        // Директор.
        print("Custom product:")
        builder.producePartA()
        builder.producePartC()
        print(builder.retrieveProduct().listParts())
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class BuilderConceptual: XCTestCase {

    func testBuilderConceptual() {
        var director = Director();
        Client.someClientCode(director: director)
    }
}
