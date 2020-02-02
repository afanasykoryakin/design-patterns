/// Паттерн Итератор
///
/// Назначение: Даёт возможность последовательно обходить элементы составных
/// объектов, не раскрывая их внутреннего представления.
///
/// Язык Swift имеет встроенную поддержку итераторов:
///
/// - Протокол `IteratorProtocol` описывает базовый интерфейс итератора:
/// https://developer.apple.com/documentation/swift/iteratorprotocol
///
/// - Структура `AnyIterator<Element>` предоставляет простую реализацию
/// итератора по-умолчанию:
/// https://developer.apple.com/documentation/swift/anyiterator
///
/// В этом примере мы увидим как работают оба этих механизма.

import XCTest

/// Это коллекция, которую мы будем перебирать используя итератор, реализующий
/// IteratorProtocol.
class WordsCollection {

    fileprivate lazy var items = [String]()

    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordsCollection: Sequence {

    func makeIterator() -> WordsIterator {
        return WordsIterator(self)
    }
}

/// Конкретные Итераторы реализуют различные алгоритмы обхода. Эти классы
/// постоянно хранят текущее положение обхода.
class WordsIterator: IteratorProtocol {

    private let collection: WordsCollection
    private var index = 0

    init(_ collection: WordsCollection) {
        self.collection = collection
    }

    func next() -> String? {
        defer { index += 1 }
        return index < collection.items.count ? collection.items[index] : nil
    }
}


/// Это другая коллекция, которая будет возвращать AnyIterator, способный
/// перебирать её элементы.
class NumbersCollection {

    fileprivate lazy var items = [Int]()

    func append(_ item: Int) {
        self.items.append(item)
    }
}

extension NumbersCollection: Sequence {

    func makeIterator() -> AnyIterator<Int> {
        var index = self.items.count - 1

        return AnyIterator {
            defer { index -= 1 }
            return index >= 0 ? self.items[index] : nil
        }
    }
}

/// Клиент не знает о внутреннем представлении данной последовательности.
class Client {
    // ...
    static func clientCode<S: Sequence>(sequence: S) {
        for item in sequence {
            print(item)
        }
    }
    // ...
}

/// Давайте посмотрим как всё это будет работать.
class IteratorConceptual: XCTestCase {

    func testIteratorProtocol() {

        let words = WordsCollection()
        words.append("First")
        words.append("Second")
        words.append("Third")

        print("Straight traversal using IteratorProtocol:")
        Client.clientCode(sequence: words)
    }

    func testAnyIterator() {

        let numbers = NumbersCollection()
        numbers.append(1)
        numbers.append(2)
        numbers.append(3)

        print("\nReverse traversal using AnyIterator:")
        Client.clientCode(sequence: numbers)
    }
}
