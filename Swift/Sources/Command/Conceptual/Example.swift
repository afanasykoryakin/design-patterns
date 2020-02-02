/// Паттерн Команда
///
/// Назначение: Превращает запросы в объекты, позволяя передавать их как
/// аргументы при вызове методов, ставить запросы в очередь, логировать их, а
/// также поддерживать отмену операций.

import XCTest

/// Интерфейс Команды объявляет метод для выполнения команд.
protocol Command {

    func execute()
}

/// Некоторые команды способны выполнять простые операции самостоятельно.
class SimpleCommand: Command {

    private var payload: String

    init(_ payload: String) {
        self.payload = payload
    }

    func execute() {
        print("SimpleCommand: See, I can do simple things like printing (" + payload + ")")
    }
}

/// Но есть и команды, которые делегируют более сложные операции другим
/// объектам, называемым «получателями».
class ComplexCommand: Command {

    private var receiver: Receiver

    /// Данные о контексте, необходимые для запуска методов получателя.
    private var a: String
    private var b: String

    /// Сложные команды могут принимать один или несколько объектов-получателей
    /// вместе с любыми данными о контексте через конструктор.
    init(_ receiver: Receiver, _ a: String, _ b: String) {
        self.receiver = receiver
        self.a = a
        self.b = b
    }

    /// Команды могут делегировать выполнение любым методам получателя.
    func execute() {
        print("ComplexCommand: Complex stuff should be done by a receiver object.\n")
        receiver.doSomething(a)
        receiver.doSomethingElse(b)
    }
}

/// Классы Получателей содержат некую важную бизнес-логику. Они умеют выполнять
/// все виды операций, связанных с выполнением запроса. Фактически, любой класс
/// может выступать Получателем.
class Receiver {

    func doSomething(_ a: String) {
        print("Receiver: Working on (" + a + ")\n")
    }

    func doSomethingElse(_ b: String) {
        print("Receiver: Also working on (" + b + ")\n")
    }
}

/// Отпрвитель связан с одной или несколькими командами. Он отправляет запрос
/// команде.
class Invoker {

    private var onStart: Command?

    private var onFinish: Command?

    /// Инициализация команд.
    func setOnStart(_ command: Command) {
        onStart = command
    }

    func setOnFinish(_ command: Command) {
        onFinish = command
    }

    /// Отправитель не зависит от классов конкретных команд и получателей.
    /// Отправитель передаёт запрос получателю косвенно, выполняя команду.
    func doSomethingImportant() {

        print("Invoker: Does anybody want something done before I begin?")

        onStart?.execute()

        print("Invoker: ...doing something really important...")
        print("Invoker: Does anybody want something done after I finish?")

        onFinish?.execute()
    }
}

/// Давайте посмотрим как всё это будет работать.
class CommandConceptual: XCTestCase {

    func test() {
        /// Клиентский код может параметризовать отправителя любыми командами.

        let invoker = Invoker()
        invoker.setOnStart(SimpleCommand("Say Hi!"))

        let receiver = Receiver()
        invoker.setOnFinish(ComplexCommand(receiver, "Send email", "Save report"))
        invoker.doSomethingImportant()
    }
}


