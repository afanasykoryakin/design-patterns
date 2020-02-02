/// Паттерн Фасад
///
/// Назначение: Предоставляет простой интерфейс к сложной системе классов,
/// библиотеке или фреймворку.

import XCTest

/// Класс Фасада предоставляет простой интерфейс для сложной логики одной или
/// нескольких подсистем. Фасад делегирует запросы клиентов соответствующим
/// объектам внутри подсистемы. Фасад также отвечает за управление их жизненным
/// циклом. Все это защищает клиента от нежелательной сложности подсистемы.
class Facade {

    private var subsystem1: Subsystem1
    private var subsystem2: Subsystem2

    /// В зависимости от потребностей вашего приложения вы можете предоставить
    /// Фасаду существующие объекты подсистемы или заставить Фасад создать их
    /// самостоятельно.
    init(subsystem1: Subsystem1 = Subsystem1(),
         subsystem2: Subsystem2 = Subsystem2()) {
        self.subsystem1 = subsystem1
        self.subsystem2 = subsystem2
    }

    /// Методы Фасада удобны для быстрого доступа к сложной функциональности
    /// подсистем. Однако клиенты получают только часть возможностей подсистемы.
    func operation() -> String {

        var result = "Facade initializes subsystems:"
        result += " " + subsystem1.operation1()
        result += " " + subsystem2.operation1()
        result += "\n" + "Facade orders subsystems to perform the action:\n"
        result += " " + subsystem1.operationN()
        result += " " + subsystem2.operationZ()
        return result
    }
}

/// Подсистема может принимать запросы либо от фасада, либо от клиента напрямую.
/// В любом случае, для Подсистемы Фасад – это еще один клиент,  и он не
/// является частью Подсистемы.
class Subsystem1 {

    func operation1() -> String {
        return "Sybsystem1: Ready!\n"
    }

    // ...

    func operationN() -> String {
        return "Sybsystem1: Go!\n"
    }
}

/// Некоторые фасады могут работать с разными подсистемами одновременно.
class Subsystem2 {

    func operation1() -> String {
        return "Sybsystem2: Get ready!\n"
    }

    // ...

    func operationZ() -> String {
        return "Sybsystem2: Fire!\n"
    }
}

/// Клиентский код работает со сложными подсистемами через простой интерфейс,
/// предоставляемый Фасадом. Когда фасад управляет жизненным циклом подсистемы,
/// клиент может даже не знать о существовании подсистемы. Такой подход
/// позволяет держать сложность под контролем.
class Client {
    // ...
    static func clientCode(facade: Facade) {
        print(facade.operation())
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class FacadeConceptual: XCTestCase {

    func testFacadeConceptual() {

        /// В клиентском коде могут быть уже созданы некоторые объекты
        /// подсистемы. В этом случае может оказаться целесообразным
        /// инициализировать Фасад с этими объектами вместо того, чтобы
        /// позволить Фасаду создавать новые экземпляры.

        let subsystem1 = Subsystem1()
        let subsystem2 = Subsystem2()
        let facade = Facade(subsystem1: subsystem1, subsystem2: subsystem2)
        Client.clientCode(facade: facade)
    }
}

