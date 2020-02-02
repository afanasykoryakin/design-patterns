# Паттерн Стратегия
#
# Назначение: Определяет семейство схожих алгоритмов и помещает каждый из них в
# собственный класс, после чего алгоритмы можно взаимозаменять прямо во время
# исполнения программы.

# Контекст определяет интерфейс, представляющий интерес для клиентов.
class Context
  # Контекст хранит ссылку на один из объектов Стратегии. Контекст не знает
  # конкретного класса стратегии. Он должен работать со всеми стратегиями через
  # интерфейс Стратегии.
  # @return [Strategy]
  attr_writer :strategy

  # Обычно Контекст принимает стратегию через конструктор, а также предоставляет
  # сеттер для её изменения во время выполнения.
  #
  # @param [Strategy] strategy
  def initialize(strategy)
    @strategy = strategy
  end

  # Обычно Контекст позволяет заменить объект Стратегии во время выполнения.
  #
  # @param [Strategy] strategy
  def strategy=(strategy)
    @strategy = strategy
  end

  # Вместо того, чтобы самостоятельно реализовывать множественные версии
  # алгоритма, Контекст делегирует некоторую работу объекту Стратегии.
  def do_some_business_logic
    # ...

    puts 'Context: Sorting data using the strategy (not sure how it\'ll do it)'
    result = @strategy.do_algorithm(%w[a b c d e])
    print result.join(',')

    # ...
  end
end

# Интерфейс Стратегии объявляет операции, общие для всех поддерживаемых версий
# некоторого алгоритма.
#
# Контекст использует этот интерфейс для вызова алгоритма, определённого
# Конкретными Стратегиями.
#
# @abstract
class Strategy
  # @abstract
  #
  # @param [Array] data
  def do_algorithm(_data)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Стратегии реализуют алгоритм, следуя базовому интерфейсу Стратегии.
# Этот интерфейс делает их взаимозаменяемыми в Контексте.

class ConcreteStrategyA < Strategy
  # @param [Array] data
  #
  # @return [Array]
  def do_algorithm(data)
    data.sort
  end
end

class ConcreteStrategyB < Strategy
  # @param [Array] data
  #
  # @return [Array]
  def do_algorithm(data)
    data.sort.reverse
  end
end

# Клиентский код выбирает конкретную стратегию и передаёт её в контекст. Клиент
# должен знать о различиях между стратегиями, чтобы сделать правильный выбор.

context = Context.new(ConcreteStrategyA.new)
puts 'Client: Strategy is set to normal sorting.'
context.do_some_business_logic
puts "\n\n"

puts 'Client: Strategy is set to reverse sorting.'
context.strategy = ConcreteStrategyB.new
context.do_some_business_logic
