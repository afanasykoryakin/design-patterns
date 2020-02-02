# Паттерн Состояние
#
# Назначение: Позволяет объектам менять поведение в зависимости от своего
# состояния. Извне создаётся впечатление, что изменился класс объекта.

# Контекст определяет интерфейс, представляющий интерес для клиентов. Он также
# хранит ссылку на экземпляр подкласса Состояния, который отображает текущее
# состояние Контекста.
#
# @abstract
class Context
  # Ссылка на текущее состояние Контекста.
  # @return [State]
  attr_accessor :state
  private :state

  # @param [State] state
  def initialize(state)
    transition_to(state)
  end

  # Контекст позволяет изменять объект Состояния во время выполнения.
  #
  # @param [State] state
  def transition_to(state)
    puts "Context: Transition to #{state.class}"
    @state = state
    @state.context = self
  end

  # Контекст делегирует часть своего поведения текущему объекту Состояния.

  def request1
    @state.handle1
  end

  def request2
    @state.handle2
  end
end

# Базовый класс Состояния объявляет методы, которые должны реализовать все
# Конкретные Состояния, а также предоставляет обратную ссылку на объект
# Контекст, связанный с Состоянием. Эта обратная ссылка может использоваться
# Состояниями для передачи Контекста другому Состоянию.
#
# @abstract
class State
  attr_accessor :context

  # @abstract
  def handle1
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def handle2
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Состояния реализуют различные модели поведения, связанные с
# состоянием Контекста.

class ConcreteStateA < State
  def handle1
    puts 'ConcreteStateA handles request1.'
    puts 'ConcreteStateA wants to change the state of the context.'
    @context.transition_to(ConcreteStateB.new)
  end

  def handle2
    puts 'ConcreteStateA handles request2.'
  end
end

class ConcreteStateB < State
  def handle1
    puts 'ConcreteStateB handles request1.'
  end

  def handle2
    puts 'ConcreteStateB handles request2.'
    puts 'ConcreteStateB wants to change the state of the context.'
    @context.transition_to(ConcreteStateA.new)
  end
end

# Клиентский код.

context = Context.new(ConcreteStateA.new)
context.request1
context.request2
