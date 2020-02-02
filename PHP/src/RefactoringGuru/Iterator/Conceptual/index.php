<?php

namespace RefactoringGuru\Iterator\Conceptual;

/**
 * Паттерн Итератор
 *
 * Назначение: Даёт возможность последовательно обходить элементы составных
 * объектов, не раскрывая их внутреннего представления.
 */

use Iterator;

/**
 * PHP имеет встроенный интерфейс Итератора, который предоставляет очень удобную
 * интеграцию с циклами foreach. Вот как выглядит интерфейс:
 *
 * @link http://php.net/manual/ru/class.iterator.php
 *
 *     interface Iterator extends Traversable {
 *         // Возврат текущего элемента.
 *         public function current();
 *
 *         // Переход к следующему элементу.
 *         public function next();
 *
 *         // Возврат ключа текущего элемента.
 *         public function key();
 *
 *         // Проверяет корректность текущей позиции.
 *         public function valid();
 *
 *         // Перемотка Итератора к первому элементу.
 *         public function rewind();
 *     }
 *
 * Также есть встроенный интерфейс для коллекций:
 *
 * @link http://php.net/manual/ru/class.iteratoraggregate.php
 *
 *     interface IteratorAggregate extends Traversable {
 *         public getIterator(): Traversable;
 *     }
 */

/**
 * Конкретные Итераторы реализуют различные алгоритмы обхода. Эти классы
 * постоянно хранят текущее положение обхода.
 */
class AlphabeticalOrderIterator implements \Iterator
{
    /**
     * @var WordsCollection
     */
    private $collection;

    /**
     * @var int Хранит текущее положение обхода. У итератора может быть
     * множество других полей для хранения состояния итерации, особенно когда он
     * должен работать с определённым типом коллекции.
     */
    private $position = 0;

    /**
     * @var bool Эта переменная указывает направление обхода.
     */
    private $reverse = false;

    public function __construct($collection, $reverse = false)
    {
        $this->collection = $collection;
        $this->reverse = $reverse;
    }

    public function rewind()
    {
        $this->position = $this->reverse ?
            count($this->collection->getItems()) - 1 : 0;
    }

    public function current()
    {
        return $this->collection->getItems()[$this->position];
    }

    public function key()
    {
        return $this->position;
    }

    public function next()
    {
        $this->position = $this->position + ($this->reverse ? -1 : 1);
    }

    public function valid()
    {
        return isset($this->collection->getItems()[$this->position]);
    }
}

/**
 * Конкретные Коллекции предоставляют один или несколько методов для получения
 * новых экземпляров итератора, совместимых с классом коллекции.
 */
class WordsCollection implements \IteratorAggregate
{
    private $items = [];

    public function getItems()
    {
        return $this->items;
    }

    public function addItem($item)
    {
        $this->items[] = $item;
    }

    public function getIterator(): Iterator
    {
        return new AlphabeticalOrderIterator($this);
    }

    public function getReverseIterator(): Iterator
    {
        return new AlphabeticalOrderIterator($this, true);
    }
}

/**
 * Клиентский код может знать или не знать о Конкретном Итераторе или классах
 * Коллекций, в зависимости от уровня косвенности, который вы хотите сохранить в
 * своей программе.
 */
$collection = new WordsCollection;
$collection->addItem("First");
$collection->addItem("Second");
$collection->addItem("Third");

echo "Straight traversal:\n";
foreach ($collection->getIterator() as $item) {
    echo $item . "\n";
}

echo "\n";
echo "Reverse traversal:\n";
foreach ($collection->getReverseIterator() as $item) {
    echo $item . "\n";
}
