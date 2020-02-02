﻿// Паттерн Компоновщик
//
// Назначение: Позволяет сгруппировать объекты в древовидную структуру, а затем
// работать с ними так, как будто это единичный объект.

using System;
using System.Collections.Generic;

namespace RefactoringGuru.DesignPatterns.Composite.Conceptual
{
    // Базовый класс Компонент объявляет общие операции как для простых, так и
    // для сложных объектов структуры.
    abstract class Component
    {
        public Component() { }

        // Базовый Компонент может сам реализовать некоторое поведение по
        // умолчанию или поручить это конкретным классам, объявив метод,
        // содержащий поведение абстрактным.
        public abstract string Operation();

        // В некоторых случаях целесообразно определить операции управления
        // потомками прямо в базовом классе Компонент. Таким образом, вам не
        // нужно будет предоставлять  конкретные классы компонентов клиентскому
        // коду, даже во время сборки дерева объектов. Недостаток такого подхода
        // в том, что эти методы будут пустыми для компонентов уровня листа.
        public virtual void Add(Component component)
        {
            throw new NotImplementedException();
        }

        public virtual void Remove(Component component)
        {
            throw new NotImplementedException();
        }

        // Вы можете предоставить метод, который позволит клиентскому коду
        // понять, может ли компонент иметь вложенные объекты.
        public virtual bool IsComposite()
        {
            return true;
        }
    }

    // Класс Лист представляет собой конечные объекты структуры. Лист не может
    // иметь вложенных компонентов.
    //
    // Обычно объекты Листьев выполняют фактическую работу, тогда как объекты
    // Контейнера лишь делегируют работу своим подкомпонентам.
    class Leaf : Component
    {
        public override string Operation()
        {
            return "Leaf";
        }

        public override bool IsComposite()
        {
            return false;
        }
    }

    // Класс Контейнер содержит сложные компоненты, которые могут иметь
    // вложенные компоненты. Обычно объекты Контейнеры делегируют фактическую
    // работу своим детям, а затем «суммируют» результат.
    class Composite : Component
    {
        protected List<Component> _children = new List<Component>();
        
        public override void Add(Component component)
        {
            this._children.Add(component);
        }

        public override void Remove(Component component)
        {
            this._children.Remove(component);
        }

        // Контейнер выполняет свою основную логику особым образом. Он проходит
        // рекурсивно через всех своих детей, собирая и суммируя их результаты.
        // Поскольку потомки контейнера передают эти вызовы своим потомкам и так
        // далее,  в результате обходится всё дерево объектов.
        public override string Operation()
        {
            int i = 0;
            string result = "Branch(";

            foreach (Component component in this._children)
            {
                result += component.Operation();
                if (i != this._children.Count - 1)
                {
                    result += "+";
                }
                i++;
            }
            
            return result + ")";
        }
    }

    class Client
    {
        // Клиентский код работает со всеми компонентами через базовый
        // интерфейс.
        public void ClientCode(Component leaf)
        {
            Console.WriteLine($"RESULT: {leaf.Operation()}\n");
        }

        // Благодаря тому, что операции управления потомками объявлены в базовом
        // классе Компонента, клиентский код может работать как с простыми, так
        // и со сложными компонентами, вне зависимости от их конкретных классов.
        public void ClientCode2(Component component1, Component component2)
        {
            if (component1.IsComposite())
            {
                component1.Add(component2);
            }
            
            Console.WriteLine($"RESULT: {component1.Operation()}");
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Client client = new Client();

            // Таким образом, клиентский код может поддерживать простые
            // компоненты-листья...
            Leaf leaf = new Leaf();
            Console.WriteLine("Client: I get a simple component:");
            client.ClientCode(leaf);

            // ...а также сложные контейнеры.
            Composite tree = new Composite();
            Composite branch1 = new Composite();
            branch1.Add(new Leaf());
            branch1.Add(new Leaf());
            Composite branch2 = new Composite();
            branch2.Add(new Leaf());
            tree.Add(branch1);
            tree.Add(branch2);
            Console.WriteLine("Client: Now I've got a composite tree:");
            client.ClientCode(tree);

            Console.Write("Client: I don't need to check the components classes even when managing the tree:\n");
            client.ClientCode2(tree, leaf);
        }
    }
}
