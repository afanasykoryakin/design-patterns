// Паттерн Состояние
//
// Назначение: Позволяет объектам менять поведение в зависимости от своего
// состояния. Извне создаётся впечатление, что изменился класс объекта.

using System;

namespace RefactoringGuru.DesignPatterns.State.Conceptual
{
    // Контекст определяет интерфейс, представляющий интерес для клиентов. Он
    // также хранит ссылку на экземпляр подкласса Состояния, который отображает
    // текущее состояние Контекста.
    class Context
    {
        // Ссылка на текущее состояние Контекста.
        private State _state = null;

        public Context(State state)
        {
            this.TransitionTo(state);
        }

        // Контекст позволяет изменять объект Состояния во время выполнения.
        public void TransitionTo(State state)
        {
            Console.WriteLine($"Context: Transition to {state.GetType().Name}.");
            this._state = state;
            this._state.SetContext(this);
        }

        // Контекст делегирует часть своего поведения текущему объекту
        // Состояния.
        public void Request1()
        {
            this._state.Handle1();
        }

        public void Request2()
        {
            this._state.Handle2();
        }
    }
    
    // Базовый класс Состояния объявляет методы, которые должны реализовать все
    // Конкретные Состояния, а также предоставляет обратную ссылку на объект
    // Контекст, связанный с Состоянием. Эта обратная ссылка может
    // использоваться Состояниями для передачи Контекста другому Состоянию.
    abstract class State
    {
        protected Context _context;

        public void SetContext(Context context)
        {
            this._context = context;
        }

        public abstract void Handle1();

        public abstract void Handle2();
    }

    // Конкретные Состояния реализуют различные модели поведения, связанные с
    // состоянием Контекста.
    class ConcreteStateA : State
    {
        public override void Handle1()
        {
            Console.WriteLine("ConcreteStateA handles request1.");
            Console.WriteLine("ConcreteStateA wants to change the state of the context.");
            this._context.TransitionTo(new ConcreteStateB());
        }

        public override void Handle2()
        {
            Console.WriteLine("ConcreteStateA handles request2.");
        }
    }

    class ConcreteStateB : State
    {
        public override void Handle1()
        {
            Console.Write("ConcreteStateB handles request1.");
        }

        public override void Handle2()
        {
            Console.WriteLine("ConcreteStateB handles request2.");
            Console.WriteLine("ConcreteStateB wants to change the state of the context.");
            this._context.TransitionTo(new ConcreteStateA());
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Клиентский код.
            var context = new Context(new ConcreteStateA());
            context.Request1();
            context.Request2();
        }
    }
}
