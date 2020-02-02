/// Паттерн Цепочка обязанностей
///
/// Назначение: Позволяет передавать запросы последовательно по цепочке
/// обработчиков. Каждый последующий обработчик решает, может ли он обработать
/// запрос сам и стоит ли передавать запрос дальше по цепи.

import XCTest

/// Интерфейс Обработчика объявляет метод построения цепочки обработчиков. Он
/// также объявляет метод для выполнения запроса.
protocol Handler: class {

    @discardableResult
    func setNext(handler: Handler) -> Handler

    func handle(request: String) -> String?

    var nextHandler: Handler? { get set }
}

extension Handler {

    func setNext(handler: Handler) -> Handler {
        self.nextHandler = handler

        /// Возврат обработчика отсюда позволит связать обработчики простым
        /// способом, вот так:
        /// monkey.setNext(handler: squirrel).setNext(handler: dog)
        return handler
    }

    func handle(request: String) -> String? {
        return nextHandler?.handle(request: request)
    }
}

/// Все Конкретные Обработчики либо обрабатывают запрос, либо передают его
/// следующему обработчику в цепочке.
class MonkeyHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {
        if (request == "Banana") {
            return "Monkey: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class SquirrelHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {

        if (request == "Nut") {
            return "Squirrel: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class DogHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {
        if (request == "MeatBall") {
            return "Dog: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

/// Обычно клиентский код приспособлен для работы с единственным обработчиком. В
/// большинстве случаев клиенту даже неизвестно, что этот обработчик является
/// частью цепочки.
class Client {
    // ...
    static func someClientCode(handler: Handler) {

        let food = ["Nut", "Banana", "Cup of coffee"]

        for item in food {

            print("Client: Who wants a " + item + "?\n")

            guard let result = handler.handle(request: item) else {
                print("  " + item + " was left untouched.\n")
                return
            }

            print("  " + result)
        }
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class ChainOfResponsibilityConceptual: XCTestCase {
 
    func test() {

        /// Другая часть клиентского кода создает саму цепочку.

        let monkey = MonkeyHandler()
        let squirrel = SquirrelHandler()
        let dog = DogHandler()
        monkey.setNext(handler: squirrel).setNext(handler: dog)

        /// Клиент должен иметь возможность отправлять запрос любому
        /// обработчику, а не только первому в цепочке.

        print("Chain: Monkey > Squirrel > Dog\n\n")
        Client.someClientCode(handler: monkey)
        print()
        print("Subchain: Squirrel > Dog\n\n")
        Client.someClientCode(handler: squirrel)
    }
}

