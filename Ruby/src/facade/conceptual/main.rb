# Паттерн Фасад
#
# Назначение: Предоставляет простой интерфейс к сложной системе классов,
# библиотеке или фреймворку.

# Класс Фасада предоставляет простой интерфейс для сложной логики одной или
# нескольких подсистем. Фасад делегирует запросы клиентов соответствующим
# объектам внутри подсистемы. Фасад также отвечает за управление их жизненным
# циклом. Все это защищает клиента от нежелательной сложности подсистемы.
class Facade
  # В зависимости от потребностей вашего приложения вы можете предоставить
  # Фасаду существующие объекты подсистемы или заставить Фасад создать их
  # самостоятельно.
  #
  # @param [Subsystem1] subsystem1
  # @param [Subsystem2] subsystem2
  def initialize(subsystem1, subsystem2)
    @subsystem1 = subsystem1 || Subsystem1.new
    @subsystem2 = subsystem2 || Subsystem2.new
  end

  # Методы Фасада удобны для быстрого доступа к сложной функциональности
  # подсистем. Однако клиенты получают только часть возможностей подсистемы.
  #
  # @return [String]
  def operation
    results = []
    results.append('Facade initializes subsystems:')
    results.append(@subsystem1.operation1)
    results.append(@subsystem2.operation1)
    results.append('Facade orders subsystems to perform the action:')
    results.append(@subsystem1.operation_n)
    results.append(@subsystem2.operation_z)
    results.join("\n")
  end
end

# Подсистема может принимать запросы либо от фасада, либо от клиента напрямую. В
# любом случае, для Подсистемы Фасад – это ещё один клиент, и он не является
# частью Подсистемы.
class Subsystem1
  # @return [String]
  def operation1
    'Subsystem1: Ready!'
  end

  # ...

  # @return [String]
  def operation_n
    'Subsystem1: Go!'
  end
end

# Некоторые фасады могут работать с разными подсистемами одновременно.
class Subsystem2
  # @return [String]
  def operation1
    'Subsystem2: Get ready!'
  end

  # ...

  # @return [String]
  def operation_z
    'Subsystem2: Fire!'
  end
end

# Клиентский код работает со сложными подсистемами через простой интерфейс,
# предоставляемый Фасадом. Когда фасад управляет жизненным циклом подсистемы,
# клиент может даже не знать о существовании подсистемы. Такой подход позволяет
# держать сложность под контролем.
#
# @param [Facade] facade
def client_code(facade)
  print facade.operation
end

# В клиентском коде могут быть уже созданы некоторые объекты подсистемы. В этом
# случае может оказаться целесообразным инициализировать Фасад с этими объектами
# вместо того, чтобы позволить Фасаду создавать новые экземпляры.
subsystem1 = Subsystem1.new
subsystem2 = Subsystem2.new
facade = Facade.new(subsystem1, subsystem2)
client_code(facade)
