// Паттерн Наблюдатель
//
// Назначение: Создаёт механизм подписки, позволяющий одним объектам следить и
// реагировать на события, происходящие в других объектах.
//
// Обратите внимание, что существует множество различных терминов с похожими
// значениями, связанных с этим паттерном. Просто помните, что Субъекта также
// называют Издателем, а Наблюдателя часто называют Подписчиком и наоборот.
// Также глаголы «наблюдать», «слушать» или «отслеживать» обычно означают одно и
// то же.

using System;
using System.Collections.Generic;
using System.Threading;

namespace RefactoringGuru.DesignPatterns.Observer.Conceptual
{
    public interface IObserver
    {
        // Получает обновление от издателя
        void Update(ISubject subject);
    }

    public interface ISubject
    {
        // Присоединяет наблюдателя к издателю.
        void Attach(IObserver observer);

        // Отсоединяет наблюдателя от издателя.
        void Detach(IObserver observer);

        // Уведомляет всех наблюдателей о событии.
        void Notify();
    }

    // Издатель владеет некоторым важным состоянием и оповещает наблюдателей о
    // его изменениях.
    public class Subject : ISubject
    {
        // Для удобства в этой переменной хранится состояние Издателя,
        // необходимое всем подписчикам.
        public int State { get; set; } = -0;

        // Список подписчиков. В реальной жизни список подписчиков может
        // храниться в более подробном виде (классифицируется по типу события и
        // т.д.)
        private List<IObserver> _observers = new List<IObserver>();

        // Методы управления подпиской.
        public void Attach(IObserver observer)
        {
            Console.WriteLine("Subject: Attached an observer.");
            this._observers.Add(observer);
        }

        public void Detach(IObserver observer)
        {
            this._observers.Remove(observer);
            Console.WriteLine("Subject: Detached an observer.");
        }

        // Запуск обновления в каждом подписчике.
        public void Notify()
        {
            Console.WriteLine("Subject: Notifying observers...");

            foreach (var observer in _observers)
            {
                observer.Update(this);
            }
        }

        // Обычно логика подписки – только часть того, что делает Издатель.
        // Издатели часто содержат некоторую важную бизнес-логику, которая
        // запускает метод уведомления всякий раз, когда должно произойти что-то
        // важное (или после этого).
        public void SomeBusinessLogic()
        {
            Console.WriteLine("\nSubject: I'm doing something important.");
            this.State = new Random().Next(0, 10);

            Thread.Sleep(15);

            Console.WriteLine("Subject: My state has just changed to: " + this.State);
            this.Notify();
        }
    }

    // Конкретные Наблюдатели реагируют на обновления, выпущенные Издателем, к
    // которому они прикреплены.
    class ConcreteObserverA : IObserver
    {
        public void Update(ISubject subject)
        {            
            if ((subject as Subject).State < 3)
            {
                Console.WriteLine("ConcreteObserverA: Reacted to the event.");
            }
        }
    }

    class ConcreteObserverB : IObserver
    {
        public void Update(ISubject subject)
        {
            if ((subject as Subject).State == 0 || (subject as Subject).State >= 2)
            {
                Console.WriteLine("ConcreteObserverB: Reacted to the event.");
            }
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            // Клиентский код.
            var subject = new Subject();
            var observerA = new ConcreteObserverA();
            subject.Attach(observerA);

            var observerB = new ConcreteObserverB();
            subject.Attach(observerB);

            subject.SomeBusinessLogic();
            subject.SomeBusinessLogic();

            subject.Detach(observerB);

            subject.SomeBusinessLogic();
        }
    }
}
