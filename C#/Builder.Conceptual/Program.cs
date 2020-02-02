// Паттерн Строитель
//
// Назначение: Позволяет создавать сложные объекты пошагово. Строитель даёт
// возможность использовать один и тот же код строительства для получения разных
// представлений объектов.

using System;
using System.Collections.Generic;

namespace RefactoringGuru.DesignPatterns.Builder.Conceptual
{
    // Интерфейс Строителя объявляет создающие методы для различных частей
    // объектов Продуктов.
    public interface IBuilder
    {
        void BuildPartA();
		
        void BuildPartB();
		
        void BuildPartC();
    }
    
    // Классы Конкретного Строителя следуют интерфейсу Строителя и предоставляют
    // конкретные реализации шагов построения. Ваша программа может иметь
    // несколько вариантов Строителей, реализованных по-разному.
    public class ConcreteBuilder : IBuilder
    {
        private Product _product = new Product();
        
        // Новый экземпляр строителя должен содержать пустой объект продукта,
        // который используется в дальнейшей сборке.
        public ConcreteBuilder()
        {
            this.Reset();
        }
        
        public void Reset()
        {
            this._product = new Product();
        }
		
        // Все этапы производства работают с одним и тем же экземпляром
        // продукта.
        public void BuildPartA()
        {
            this._product.Add("PartA1");
        }
		
        public void BuildPartB()
        {
            this._product.Add("PartB1");
        }
		
        public void BuildPartC()
        {
            this._product.Add("PartC1");
        }
		
        // Конкретные Строители должны предоставить свои собственные методы
        // получения результатов. Это связано с тем, что различные типы
        // строителей могут создавать совершенно разные продукты с разными
        // интерфейсами. Поэтому такие методы не могут быть объявлены в базовом
        // интерфейсе Строителя (по крайней мере, в статически типизированном
        // языке программирования).
        //
        // Как правило, после возвращения конечного результата клиенту,
        // экземпляр строителя должен быть готов к началу производства
        // следующего продукта. Поэтому обычной практикой является вызов метода
        // сброса в конце тела метода GetProduct. Однако такое поведение не
        // является обязательным, вы можете заставить своих строителей ждать
        // явного запроса на сброс из кода клиента, прежде чем избавиться от
        // предыдущего результата.
        public Product GetProduct()
        {
            Product result = this._product;

            this.Reset();

            return result;
        }
    }
    
    // Имеет смысл использовать паттерн Строитель только тогда, когда ваши
    // продукты достаточно сложны и требуют обширной конфигурации.
    //
    // В отличие от других порождающих паттернов, различные конкретные строители
    // могут производить несвязанные продукты. Другими словами, результаты
    // различных строителей  могут не всегда следовать одному и тому же
    // интерфейсу.
    public class Product
    {
        private List<object> _parts = new List<object>();
		
        public void Add(string part)
        {
            this._parts.Add(part);
        }
		
        public string ListParts()
        {
            string str = string.Empty;

            for (int i = 0; i < this._parts.Count; i++)
            {
                str += this._parts[i] + ", ";
            }

            str = str.Remove(str.Length - 2); // removing last ",c"

            return "Product parts: " + str + "\n";
        }
    }
    
    // Директор отвечает только за выполнение шагов построения в определённой
    // последовательности. Это полезно при производстве продуктов в определённом
    // порядке или особой конфигурации. Строго говоря, класс Директор
    // необязателен, так как клиент может напрямую управлять строителями.
    public class Director
    {
        private IBuilder _builder;
        
        public IBuilder Builder
        {
            set { _builder = value; } 
        }
        
        // Директор может строить несколько вариаций продукта, используя
        // одинаковые шаги построения.
        public void buildMinimalViableProduct()
        {
            this._builder.BuildPartA();
        }
		
        public void buildFullFeaturedProduct()
        {
            this._builder.BuildPartA();
            this._builder.BuildPartB();
            this._builder.BuildPartC();
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Клиентский код создаёт объект-строитель, передаёт его директору,
            // а затем инициирует  процесс построения. Конечный результат
            // извлекается из объекта-строителя.
            var director = new Director();
            var builder = new ConcreteBuilder();
            director.Builder = builder;
            
            Console.WriteLine("Standard basic product:");
            director.buildMinimalViableProduct();
            Console.WriteLine(builder.GetProduct().ListParts());

            Console.WriteLine("Standard full featured product:");
            director.buildFullFeaturedProduct();
            Console.WriteLine(builder.GetProduct().ListParts());

            // Помните, что паттерн Строитель можно использовать без класса
            // Директор.
            Console.WriteLine("Custom product:");
            builder.BuildPartA();
            builder.BuildPartC();
            Console.Write(builder.GetProduct().ListParts());
        }
    }
}
