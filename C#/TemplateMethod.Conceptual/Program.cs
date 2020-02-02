// Паттерн Шаблонный метод
//
// Назначение: Определяет скелет алгоритма, перекладывая ответственность за
// некоторые его шаги на подклассы. Паттерн позволяет подклассам переопределять
// шаги алгоритма, не меняя его общей структуры.

using System;

namespace RefactoringGuru.DesignPatterns.TemplateMethod.Conceptual
{
    // Абстрактный Класс определяет шаблонный метод, содержащий скелет
    // некоторого алгоритма, состоящего из вызовов (обычно) абстрактных
    // примитивных операций.
    //
    // Конкретные подклассы должны реализовать эти операции, но оставить сам
    // шаблонный метод без изменений.
    abstract class AbstractClass
    {
        // Шаблонный метод определяет скелет алгоритма.
        public void TemplateMethod()
        {
            this.BaseOperation1();
            this.RequiredOperations1();
            this.BaseOperation2();
            this.Hook1();
            this.RequiredOperation2();
            this.BaseOperation3();
            this.Hook2();
        }

        // Эти операции уже имеют реализации.
        protected void BaseOperation1()
        {
            Console.WriteLine("AbstractClass says: I am doing the bulk of the work");
        }

        protected void BaseOperation2()
        {
            Console.WriteLine("AbstractClass says: But I let subclasses override some operations");
        }

        protected void BaseOperation3()
        {
            Console.WriteLine("AbstractClass says: But I am doing the bulk of the work anyway");
        }
        
        // А эти операции должны быть реализованы в подклассах.
        protected abstract void RequiredOperations1();

        protected abstract void RequiredOperation2();
        
        // Это «хуки». Подклассы могут переопределять их, но это не обязательно,
        // поскольку у хуков уже есть стандартная (но пустая) реализация. Хуки
        // предоставляют дополнительные точки расширения в некоторых критических
        // местах алгоритма.
        protected virtual void Hook1() { }

        protected virtual void Hook2() { }
    }

    // Конкретные классы должны реализовать все абстрактные операции базового
    // класса. Они также могут переопределить некоторые операции с реализацией
    // по умолчанию.
    class ConcreteClass1 : AbstractClass
    {
        protected override void RequiredOperations1()
        {
            Console.WriteLine("ConcreteClass1 says: Implemented Operation1");
        }

        protected override void RequiredOperation2()
        {
            Console.WriteLine("ConcreteClass1 says: Implemented Operation2");
        }
    }

    // Обычно конкретные классы переопределяют только часть операций базового
    // класса.
    class ConcreteClass2 : AbstractClass
    {
        protected override void RequiredOperations1()
        {
            Console.WriteLine("ConcreteClass2 says: Implemented Operation1");
        }

        protected override void RequiredOperation2()
        {
            Console.WriteLine("ConcreteClass2 says: Implemented Operation2");
        }

        protected override void Hook1()
        {
            Console.WriteLine("ConcreteClass2 says: Overridden Hook1");
        }
    }

    class Client
    {
        // Клиентский код вызывает шаблонный метод для выполнения алгоритма.
        // Клиентский код не должен знать конкретный класс объекта, с которым
        // работает, при условии, что он работает с объектами через интерфейс их
        // базового класса.
        public static void ClientCode(AbstractClass abstractClass)
        {
            // ...
            abstractClass.TemplateMethod();
            // ...
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Same client code can work with different subclasses:");

            Client.ClientCode(new ConcreteClass1());

            Console.Write("\n");
            
            Console.WriteLine("Same client code can work with different subclasses:");
            Client.ClientCode(new ConcreteClass2());
        }
    }
}
