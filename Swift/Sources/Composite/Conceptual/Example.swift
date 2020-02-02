/// Паттерн Компоновщик
///
/// Назначение: Позволяет сгруппировать объекты в древовидную структуру, а затем
/// работать с ними так, как будто это единичный объект.

import XCTest

/// Базовый класс Компонент объявляет общие операции как для простых, так и для
/// сложных объектов структуры.
protocol Component {

    /// При необходимости базовый Компонент может объявить интерфейс для
    /// установки и получения родителя компонента в древовидной структуре. Он
    /// также может предоставить  некоторую реализацию по умолчанию для этих
    /// методов.
    var parent: Component? { get set }

    /// В некоторых случаях целесообразно определить операции управления
    /// потомками прямо в базовом классе Компонент. Таким образом, вам не нужно
    /// будет предоставлять  конкретные классы компонентов клиентскому коду,
    /// даже во время сборки дерева объектов. Недостаток такого подхода в том,
    /// что эти методы будут пустыми для компонентов уровня листа.
    func add(component: Component)
    func remove(component: Component)

    /// Вы можете предоставить метод, который позволит клиентскому коду понять,
    /// может ли компонент иметь вложенные объекты.
    func isComposite() -> Bool

    /// Базовый Компонент может сам реализовать некоторое поведение по умолчанию
    /// или поручить это конкретным классам.
    func operation() -> String
}

extension Component {

    func add(component: Component) {}
    func remove(component: Component) {}
    func isComposite() -> Bool {
        return false
    }
}

/// Класс Лист представляет собой конечные объекты структуры.  Лист не может
/// иметь вложенных компонентов.
///
/// Обычно объекты Листьев выполняют фактическую работу, тогда как объекты
/// Контейнера лишь делегируют работу своим подкомпонентам.
class Leaf: Component {

    var parent: Component?

    func operation() -> String {
        return "Leaf"
    }
}

/// Класс Контейнер содержит сложные компоненты, которые могут иметь вложенные
/// компоненты. Обычно объекты Контейнеры делегируют фактическую работу своим
/// детям, а затем «суммируют» результат.
class Composite: Component {

    var parent: Component?

    /// Это поле содержит поддерево компонентов.
    private var children = [Component]()

    /// Объект контейнера может как добавлять компоненты в свой список вложенных
    /// компонентов, так и удалять их, как простые, так и сложные.
    func add(component: Component) {
        var item = component
        item.parent = self
        children.append(item)
    }

    func remove(component: Component) {
        // ...
    }

    func isComposite() -> Bool {
        return true
    }

    /// Контейнер выполняет свою основную логику особым образом. Он проходит
    /// рекурсивно через всех своих детей, собирая и суммируя их результаты.
    /// Поскольку потомки контейнера передают эти вызовы своим потомкам и так
    /// далее,  в результате обходится всё дерево объектов.
    func operation() -> String {
        let result = children.map({ $0.operation() })
        return "Branch(" + result.joined(separator: " ") + ")"
    }
}

class Client {

    /// Клиентский код работает со всеми компонентами через базовый интерфейс.
    static func someClientCode(component: Component) {
        print("Result: " + component.operation())
    }

    /// Благодаря тому, что операции управления потомками объявлены в базовом
    /// классе Компонента, клиентский код может работать как с простыми, так и
    /// со сложными компонентами.
    static func moreComplexClientCode(leftComponent: Component, rightComponent: Component) {
        if leftComponent.isComposite() {
            leftComponent.add(component: rightComponent)
        }
        print("Result: " + leftComponent.operation())
    }
}

/// Давайте посмотрим как всё это будет работать.
class CompositeConceptual: XCTestCase {

    func testCompositeConceptual() {

        /// Таким образом, клиентский код может поддерживать простые компоненты-
        /// листья...
        print("Client: I've got a simple component:")
        Client.someClientCode(component: Leaf())

        /// ...а также сложные контейнеры.
        let tree = Composite()

        let branch1 = Composite()
        branch1.add(component: Leaf())
        branch1.add(component: Leaf())

        let branch2 = Composite()
        branch2.add(component: Leaf())
        branch2.add(component: Leaf())

        tree.add(component: branch1)
        tree.add(component: branch2)

        print("\nClient: Now I've got a composite tree:")
        Client.someClientCode(component: tree)

        print("\nClient: I don't need to check the components classes even when managing the tree:")
        Client.moreComplexClientCode(leftComponent: tree, rightComponent: Leaf())
    }
}
