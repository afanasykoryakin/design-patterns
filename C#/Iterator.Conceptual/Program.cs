// Паттерн Итератор
//
// Назначение: Даёт возможность последовательно обходить элементы составных
// объектов, не раскрывая их внутреннего представления.

using System;
using System.Collections;
using System.Collections.Generic;

namespace RefactoringGuru.DesignPatterns.Iterator.Conceptual
{
    abstract class Iterator : IEnumerator
    {
        object IEnumerator.Current => Current();

        // Возвращает ключ текущего элемента
        public abstract int Key();
		
        // Возвращает текущий элемент.
        public abstract object Current();
		
        // Переходит к следующему элементу.
        public abstract bool MoveNext();
		
        // Перематывает Итератор к первому элементу.
        public abstract void Reset();
    }

    abstract class IteratorAggregate : IEnumerable
    {
        // Возвращает Iterator или другой IteratorAggregate для реализующего
        // объекта.
        public abstract IEnumerator GetEnumerator();
    }

    // Конкретные Итераторы реализуют различные алгоритмы обхода. Эти классы
    // постоянно хранят текущее положение обхода.
    class AlphabeticalOrderIterator : Iterator
    {
        private WordsCollection _collection;
		
        // Хранит текущее положение обхода. У итератора может быть множество
        // других полей для хранения состояния итерации, особенно когда он
        // должен работать с определённым типом коллекции.
        private int _position = -1;
		
        private bool _reverse = false;

        public AlphabeticalOrderIterator(WordsCollection collection, bool reverse = false)
        {
            this._collection = collection;
            this._reverse = reverse;

            if (reverse)
            {
                this._position = collection.getItems().Count;
            }
        }
		
        public override object Current()
        {
            return this._collection.getItems()[_position];
        }

        public override int Key()
        {
            return this._position;
        }
		
        public override bool MoveNext()
        {
            int updatedPosition = this._position + (this._reverse ? -1 : 1);

            if (updatedPosition >= 0 && updatedPosition < this._collection.getItems().Count)
            {
                this._position = updatedPosition;
                return true;
            }
            else
            {
                return false;
            }
        }
		
        public override void Reset()
        {
            this._position = this._reverse ? this._collection.getItems().Count - 1 : 0;
        }
    }

    // Конкретные Коллекции предоставляют один или несколько методов для
    // получения новых экземпляров итератора, совместимых с классом коллекции.
    class WordsCollection : IteratorAggregate
    {
        List<string> _collection = new List<string>();
		
        bool _direction = false;
        
        public void ReverseDirection()
        {
            _direction = !_direction;
        }
		
        public List<string> getItems()
        {
            return _collection;
        }
		
        public void AddItem(string item)
        {
            this._collection.Add(item);
        }
		
        public override IEnumerator GetEnumerator()
        {
            return new AlphabeticalOrderIterator(this, _direction);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Клиентский код может знать или не знать о Конкретном Итераторе
            // или классах Коллекций, в зависимости от уровня косвенности,
            // который вы хотите сохранить в своей программе.
            var collection = new WordsCollection();
            collection.AddItem("First");
            collection.AddItem("Second");
            collection.AddItem("Third");

            Console.WriteLine("Straight traversal:");

            foreach (var element in collection)
            {
                Console.WriteLine(element);
            }

            Console.WriteLine("\nReverse traversal:");

            collection.ReverseDirection();

            foreach (var element in collection)
            {
                Console.WriteLine(element);
            }
        }
    }
}
