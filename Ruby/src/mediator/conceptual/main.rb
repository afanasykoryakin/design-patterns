# Паттерн Посредник
#
# Назначение: Позволяет уменьшить связанность множества классов между собой,
# благодаря перемещению этих связей в один класс-посредник.

# Интерфейс Посредника предоставляет метод, используемый компонентами для
# уведомления посредника о различных событиях. Посредник может реагировать на
# эти события и передавать исполнение другим компонентам.
#
# @abstract
class Mediator
  # @abstract
  #
  # @param [Object] sender
  # @param [String] event
  def notify(_sender, _event)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class ConcreteMediator < Mediator
  # @param [Component1] component1
  # @param [Component2] component2
  def initialize(component1, component2)
    @component1 = component1
    @component1.mediator = self
    @component2 = component2
    @component2.mediator = self
  end

  # @param [Object] sender
  # @param [String] event
  def notify(_sender, event)
    if event == 'A'
      puts 'Mediator reacts on A and triggers following operations:'
      @component2.do_c
    elsif event == 'D'
      puts 'Mediator reacts on D and triggers following operations:'
      @component1.do_b
      @component2.do_c
    end
  end
end

# Базовый Компонент обеспечивает базовую функциональность хранения экземпляра
# посредника внутри объектов компонентов.
class BaseComponent
  # @return [Mediator]
  attr_accessor :mediator

  # @param [Mediator] mediator
  def initialize(mediator = nil)
    @mediator = mediator
  end
end

# Конкретные Компоненты реализуют различную функциональность. Они не зависят от
# других компонентов. Они также не зависят от каких-либо конкретных классов
# посредников.
class Component1 < BaseComponent
  def do_a
    puts 'Component 1 does A.'
    @mediator.notify(self, 'A')
  end

  def do_b
    puts 'Component 1 does B.'
    @mediator.notify(self, 'B')
  end
end

class Component2 < BaseComponent
  def do_c
    puts 'Component 2 does C.'
    @mediator.notify(self, 'C')
  end

  def do_d
    puts 'Component 2 does D.'
    @mediator.notify(self, 'D')
  end
end

# Клиентский код.
c1 = Component1.new
c2 = Component2.new
ConcreteMediator.new(c1, c2)

puts 'Client triggers operation A.'
c1.do_a

puts "\n"

puts 'Client triggers operation D.'
c2.do_d
