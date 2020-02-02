/// Паттерн Одиночка
///
/// Назначение: Гарантирует, что у класса есть только один экземпляр, и
/// предоставляет к нему глобальную точку доступа.

import XCTest

/// Класс Одиночка предоставляет поле `shared`, которое позволяет клиентам
/// получать доступ к уникальному экземпляру одиночки.
class Singleton {

    /// Статическое поле, управляющие доступом к экземпляру одиночки.
    ///
    /// Эта реализация позволяет вам расширять класс Одиночки, сохраняя повсюду
    /// только один экземпляр каждого подкласса.
    static var shared: Singleton = {
        let instance = Singleton()
        // ... настройка объекта
        // ...
        return instance
    }()

    /// Инициализатор Одиночки всегда должен быть скрытым, чтобы предотвратить
    /// прямое создание объекта через инициализатор.
    private init() {}

    /// Наконец, любой одиночка должен содержать некоторую бизнес-логику,
    /// которая может быть выполнена на его экземпляре.
    func someBusinessLogic() -> String {
        // ...
        return "Result of the 'someBusinessLogic' call"
    }
}

/// Одиночки не должны быть клонируемыми.
extension Singleton: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

/// Клиентский код.
class Client {
    // ...
    static func someClientCode() {
        let instance1 = Singleton.shared
        let instance2 = Singleton.shared

        if (instance1 === instance2) {
            print("Singleton works, both variables contain the same instance.");
        } else {
            print("Singleton failed, variables contain different instances.");
        }
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class SingletonConceptual: XCTestCase {

    func testSingletonConceptual() {
        Client.someClientCode();
    }
}
