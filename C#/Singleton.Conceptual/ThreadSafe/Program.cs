// Паттерн Одиночка
//
// Назначение: Гарантирует, что у класса есть только один экземпляр, и
// предоставляет к нему глобальную точку доступа.

using System;
using System.Threading;

namespace Singleton
{
    // Эта реализация Одиночки называется "блокировка с двойной проверкой"
    // (double check lock). Она безопасна в многопоточной среде, а также
    // позволяет отложенную инициализацию объекта Одиночки.
    class Singleton
    {
        private Singleton() { }

        private static Singleton _instance;

        // У нас теперь есть объект-блокировка для синхронизации потоков во
        // время первого доступа к Одиночке.
        private static readonly object _lock = new object();

        public static Singleton GetInstance(string value)
        {
            // Это условие нужно для того, чтобы не стопорить потоки блокировкой
            // после того как объект-одиночка уже создан.
            if (_instance == null)
            {
                // Теперь представьте, что программа была только-только
                // запущена. Объекта-одиночки ещё никто не создавал, поэтому
                // несколько потоков вполне могли одновременно пройти через
                // предыдущее условие и достигнуть блокировки. Самый быстрый
                // поток поставит блокировку и двинется внутрь секции, пока
                // другие будут здесь его ожидать.
                lock (_lock)
                {
                    // Первый поток достигает этого условия и проходит внутрь,
                    // создавая объект-одиночку. Как только этот поток покинет
                    // секцию и освободит блокировку, следующий поток может
                    // снова установить блокировку и зайти внутрь. Однако теперь
                    // экземпляр одиночки уже будет создан и поток не сможет
                    // пройти через это условие, а значит новый объект не будет
                    // создан.
                    if (_instance == null)
                    {
                        _instance = new Singleton();
                        _instance.Value = value;
                    }
                }
            }
            return _instance;
        }

        // Мы используем это поле, чтобы доказать, что наш Одиночка
        // действительно работает.
        public string Value { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Клиентский код.
            
            Console.WriteLine(
                "{0}\n{1}\n\n{2}\n",
                "If you see the same value, then singleton was reused (yay!)",
                "If you see different values, then 2 singletons were created (booo!!)",
                "RESULT:"
            );
            
            Thread process1 = new Thread(() =>
            {
                TestSingleton("FOO");
            });
            Thread process2 = new Thread(() =>
            {
                TestSingleton("BAR");
            });
            
            process1.Start();
            process2.Start();
            
            process1.Join();
            process2.Join();
        }
        
        public static void TestSingleton(string value)
        {
            Singleton singleton = Singleton.GetInstance(value);
            Console.WriteLine(singleton.Value);
        } 
    }
}
