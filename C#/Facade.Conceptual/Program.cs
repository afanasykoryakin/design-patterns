// Паттерн Фасад
//
// Назначение: Предоставляет простой интерфейс к сложной системе классов,
// библиотеке или фреймворку.

using System;

namespace RefactoringGuru.DesignPatterns.Facade.Conceptual
{
    // Класс Фасада предоставляет простой интерфейс для сложной логики одной или
    // нескольких подсистем. Фасад делегирует запросы клиентов соответствующим
    // объектам внутри подсистемы. Фасад также отвечает за управление их
    // жизненным циклом. Все это защищает клиента от нежелательной сложности
    // подсистемы.
    public class Facade
    {
        protected Subsystem1 _subsystem1;
		
        protected Subsystem2 _subsystem2;

        public Facade(Subsystem1 subsystem1, Subsystem2 subsystem2)
        {
            this._subsystem1 = subsystem1;
            this._subsystem2 = subsystem2;
        }
		
        // Методы Фасада удобны для быстрого доступа к сложной функциональности
        // подсистем. Однако клиенты получают только часть возможностей
        // подсистемы.
        public string Operation()
        {
            string result = "Facade initializes subsystems:\n";
            result += this._subsystem1.operation1();
            result += this._subsystem2.operation1();
            result += "Facade orders subsystems to perform the action:\n";
            result += this._subsystem1.operationN();
            result += this._subsystem2.operationZ();
            return result;
        }
    }
    
    // Подсистема может принимать запросы либо от фасада, либо от клиента
    // напрямую. В любом случае, для Подсистемы Фасад – это еще один клиент, и
    // он не является частью Подсистемы.
    public class Subsystem1
    {
        public string operation1()
        {
            return "Subsystem1: Ready!\n";
        }

        public string operationN()
        {
            return "Subsystem1: Go!\n";
        }
    }
	
    // Некоторые фасады могут работать с разными подсистемами одновременно.
    public class Subsystem2
    {
        public string operation1()
        {
            return "Subsystem2: Get ready!\n";
        }

        public string operationZ()
        {
            return "Subsystem2: Fire!\n";
        }
    }


    class Client
    {
        // Клиентский код работает со сложными подсистемами через простой
        // интерфейс, предоставляемый Фасадом. Когда фасад управляет жизненным
        // циклом подсистемы, клиент может даже не знать о существовании
        // подсистемы. Такой подход позволяет держать сложность под контролем.
        public static void ClientCode(Facade facade)
        {
            Console.Write(facade.Operation());
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            // В клиентском коде могут быть уже созданы некоторые объекты
            // подсистемы. В этом случае может оказаться целесообразным
            // инициализировать Фасад с этими объектами вместо того, чтобы
            // позволить Фасаду создавать новые экземпляры.
            Subsystem1 subsystem1 = new Subsystem1();
            Subsystem2 subsystem2 = new Subsystem2();
            Facade facade = new Facade(subsystem1, subsystem2);
            Client.ClientCode(facade);
        }
    }
}
