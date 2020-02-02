/// Паттерн Стратегия
///
/// Назначение: Определяет семейство схожих алгоритмов и помещает каждый из них
/// в собственный класс, после чего алгоритмы можно взаимозаменять прямо во
/// время исполнения программы.

import XCTest

/// Контекст определяет интерфейс, представляющий интерес для клиентов.
class Context {

    /// Контекст хранит ссылку на один из объектов Стратегии. Контекст не знает
    /// конкретного класса стратегии. Он должен работать со всеми стратегиями
    /// через интерфейс Стратегии.
    private var strategy: Strategy

    /// Обычно Контекст принимает стратегию через конструктор, а также
    /// предоставляет сеттер для её изменения во время выполнения.
    init(strategy: Strategy) {
        self.strategy = strategy
    }

    /// Обычно Контекст позволяет заменить объект Стратегии во время выполнения.
    func update(strategy: Strategy) {
        self.strategy = strategy
    }

    /// Вместо того, чтобы самостоятельно реализовывать множественные версии
    /// алгоритма, Контекст делегирует некоторую работу объекту Стратегии.
    func doSomeBusinessLogic() {
        print("Context: Sorting data using the strategy (not sure how it'll do it)\n")

        let result = strategy.doAlgorithm(["a", "b", "c", "d", "e"])
        print(result.joined(separator: ","))
    }
}

/// Интерфейс Стратегии объявляет операции, общие для всех поддерживаемых версий
/// некоторого алгоритма.
///
/// Контекст использует этот интерфейс для вызова алгоритма, определённого
/// Конкретными Стратегиями.
protocol Strategy {

    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T]
}

/// Конкретные Стратегии реализуют алгоритм, следуя базовому интерфейсу
/// Стратегии. Этот интерфейс делает их взаимозаменяемыми в Контексте.
class ConcreteStrategyA: Strategy {

    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T] {
        return data.sorted()
    }
}

class ConcreteStrategyB: Strategy {

    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T] {
        return data.sorted(by: >)
    }
}

/// Давайте посмотрим как всё это будет работать.
class StrategyConceptual: XCTestCase {

    func test() {

        /// Клиентский код выбирает конкретную стратегию и передаёт её в
        /// контекст. Клиент должен знать о различиях между стратегиями, чтобы
        /// сделать правильный выбор.

        let context = Context(strategy: ConcreteStrategyA())
        print("Client: Strategy is set to normal sorting.\n")
        context.doSomeBusinessLogic()

        print("\nClient: Strategy is set to reverse sorting.\n")
        context.update(strategy: ConcreteStrategyB())
        context.doSomeBusinessLogic()
    }
}