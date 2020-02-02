/// Паттерн Снимок
///
/// Назначение: Фиксирует и восстанавливает внутреннее состояние объекта таким
/// образом, чтобы в дальнейшем объект можно было восстановить в этом состоянии
/// без нарушения инкапсуляции.

import XCTest

/// Создатель содержит некоторое важное состояние, которое может со временем
/// меняться. Он также объявляет метод сохранения состояния внутри снимка и
/// метод восстановления состояния из него.
class Originator {

    /// Для удобства состояние создателя хранится внутри одной переменной.
    private var state: String

    init(state: String) {
        self.state = state
        print("Originator: My initial state is: \(state)")
    }

    /// Бизнес-логика Создателя может повлиять на его внутреннее состояние.
    /// Поэтому клиент должен выполнить резервное копирование состояния с
    /// помощью метода save перед запуском методов бизнес-логики.
    func doSomething() {
        print("Originator: I'm doing something important.")
        state = generateRandomString()
        print("Originator: and my state has changed to: \(state)")
    }

    private func generateRandomString() -> String {
        return String(UUID().uuidString.suffix(4))
    }

    /// Сохраняет текущее состояние внутри снимка.
    func save() -> Memento {
        return ConcreteMemento(state: state)
    }

    /// Восстанавливает состояние Создателя из объекта снимка.
    func restore(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else { return }
        self.state = memento.state
        print("Originator: My state has changed to: \(state)")
    }
}

/// Интерфейс Снимка предоставляет способ извлечения метаданных снимка, таких
/// как дата создания или название. Однако он не раскрывает состояние Создателя.
protocol Memento {

    var name: String { get }
    var date: Date { get }
}

/// Конкретный снимок содержит инфраструктуру для хранения состояния Создателя.
class ConcreteMemento: Memento {

    /// Создатель использует этот метод, когда восстанавливает своё состояние.
    private(set) var state: String
    private(set) var date: Date

    init(state: String) {
        self.state = state
        self.date = Date()
    }

    /// Остальные методы используются Опекуном для отображения метаданных.
    var name: String { return state + " " + date.description.suffix(14).prefix(8) }
}

/// Опекун не зависит от класса Конкретного Снимка. Таким образом, он не имеет
/// доступа к состоянию создателя, хранящемуся внутри снимка. Он работает со
/// всеми снимками через базовый интерфейс Снимка.
class Caretaker {

    private lazy var mementos = [Memento]()
    private var originator: Originator

    init(originator: Originator) {
        self.originator = originator
    }

    func backup() {
        print("\nCaretaker: Saving Originator's state...\n")
        mementos.append(originator.save())
    }

    func undo() {

        guard !mementos.isEmpty else { return }
        let removedMemento = mementos.removeLast()

        print("Caretaker: Restoring state to: " + removedMemento.name)
        originator.restore(memento: removedMemento)
    }

    func showHistory() {
        print("Caretaker: Here's the list of mementos:\n")
        mementos.forEach({ print($0.name) })
    }
}

/// Давайте посмотрим как всё это будет работать.
class MementoConceptual: XCTestCase {

    func testMementoConceptual() {

        let originator = Originator(state: "Super-duper-super-puper-super.")
        let caretaker = Caretaker(originator: originator)

        caretaker.backup()
        originator.doSomething()

        caretaker.backup()
        originator.doSomething()

        caretaker.backup()
        originator.doSomething()

        print("\n")
        caretaker.showHistory()

        print("\nClient: Now, let's rollback!\n\n")
        caretaker.undo()

        print("\nClient: Once more!\n\n")
        caretaker.undo()
    }
}
