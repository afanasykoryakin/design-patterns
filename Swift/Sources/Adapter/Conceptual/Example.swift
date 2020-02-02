/// Паттерн Адаптер
///
/// Назначение: Позволяет объектам с несовместимыми интерфейсами работать
/// вместе.

import XCTest

/// Целевой класс объявляет интерфейс, с которым может работать клиентский код.
class Target {

    func request() -> String {
        return "Target: The default target's behavior."
    }
}

/// Адаптируемый класс содержит некоторое полезное поведение, но его интерфейс
/// несовместим с существующим клиентским кодом. Адаптируемый класс нуждается в
/// некоторой доработке, прежде чем клиентский код сможет его использовать.
class Adaptee {

    public func specificRequest() -> String {
        return ".eetpadA eht fo roivaheb laicepS"
    }
}

/// Адаптер делает интерфейс Адаптируемого класса совместимым с целевым
/// интерфейсом.
class Adapter: Target {

    private var adaptee: Adaptee

    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() -> String {
        return "Adapter: (TRANSLATED) " + adaptee.specificRequest().reversed()
    }
}

/// Клиентский код поддерживает все классы, использующие целевой интерфейс.
class Client {
    // ...
    static func someClientCode(target: Target) {
        print(target.request())
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class AdapterConceptual: XCTestCase {

    func testAdapterConceptual() {
        print("Client: I can work just fine with the Target objects:")
        Client.someClientCode(target: Target())

        let adaptee = Adaptee()
        print("Client: The Adaptee class has a weird interface. See, I don't understand it:")
        print("Adaptee: " + adaptee.specificRequest())

        print("Client: But I can work with it via the Adapter:")
        Client.someClientCode(target: Adapter(adaptee))
    }
}
