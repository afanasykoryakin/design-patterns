// Паттерн Декоратор
//
// Назначение: Позволяет динамически добавлять объектам новую функциональность,
// оборачивая их в полезные «обёртки».

using System;

namespace RefactoringGuru.DesignPatterns.Composite.Conceptual
{
    // Базовый интерфейс Компонента определяет поведение, которое изменяется
    // декораторами.
    public abstract class Component
    {
        public abstract string Operation();
    }

    // Конкретные Компоненты предоставляют реализации поведения по умолчанию.
    // Может быть несколько вариаций этих классов.
    class ConcreteComponent : Component
    {
        public override string Operation()
        {
            return "ConcreteComponent";
        }
    }

    // Базовый класс Декоратора следует тому же интерфейсу, что и другие
    // компоненты. Основная цель этого класса - определить интерфейс обёртки для
    // всех конкретных декораторов. Реализация кода обёртки по умолчанию может
    // включать в себя  поле для хранения завёрнутого компонента и средства его
    // инициализации.
    abstract class Decorator : Component
    {
        protected Component _component;

        public Decorator(Component component)
        {
            this._component = component;
        }

        public void SetComponent(Component component)
        {
            this._component = component;
        }

        // Декоратор делегирует всю работу обёрнутому компоненту.
        public override string Operation()
        {
            if (this._component != null)
            {
                return this._component.Operation();
            }
            else
            {
                return string.Empty;
            }
        }
    }

    // Конкретные Декораторы вызывают обёрнутый объект и изменяют его результат
    // некоторым образом.
    class ConcreteDecoratorA : Decorator
    {
        public ConcreteDecoratorA(Component comp) : base(comp)
        {
        }

        // Декораторы могут вызывать родительскую реализацию операции, вместо
        // того, чтобы вызвать обёрнутый объект напрямую. Такой подход упрощает
        // расширение классов декораторов.
        public override string Operation()
        {
            return $"ConcreteDecoratorA({base.Operation()})";
        }
    }

    // Декораторы могут выполнять своё поведение до или после вызова обёрнутого
    // объекта.
    class ConcreteDecoratorB : Decorator
    {
        public ConcreteDecoratorB(Component comp) : base(comp)
        {
        }

        public override string Operation()
        {
            return $"ConcreteDecoratorB({base.Operation()})";
        }
    }
    
    public class Client
    {
        // Клиентский код работает со всеми объектами, используя интерфейс
        // Компонента. Таким образом, он остаётся независимым от конкретных
        // классов компонентов, с которыми работает.
        public void ClientCode(Component component)
        {
            Console.WriteLine("RESULT: " + component.Operation());
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Client client = new Client();

            var simple = new ConcreteComponent();
            Console.WriteLine("Client: I get a simple component:");
            client.ClientCode(simple);
            Console.WriteLine();

            // ...так и декорированные.
            //
            // Обратите внимание, что декораторы могут обёртывать не только
            // простые компоненты, но и другие декораторы.
            ConcreteDecoratorA decorator1 = new ConcreteDecoratorA(simple);
            ConcreteDecoratorB decorator2 = new ConcreteDecoratorB(decorator1);
            Console.WriteLine("Client: Now I've got a decorated component:");
            client.ClientCode(decorator2);
        }
    }
}
