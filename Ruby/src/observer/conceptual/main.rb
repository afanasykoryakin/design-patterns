# Паттерн Наблюдатель
#
# Назначение: Создаёт механизм подписки, позволяющий одним объектам следить и
# реагировать на события, происходящие в других объектах.
#
# Обратите внимание, что существует множество различных терминов с похожими
# значениями, связанных с этим паттерном. Просто помните, что Субъекта также
# называют Издателем, а Наблюдателя часто называют Подписчиком и наоборот. Также
# глаголы «наблюдать», «слушать» или «отслеживать» обычно означают одно и то же.

# Интферфейс издателя объявляет набор методов для управлениями подпискичами.
#
# @abstract
class Subject
  # Присоединяет наблюдателя к издателю.
  #
  # @abstract
  #
  # @param [Observer] observer
  def attach(observer)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # Отсоединяет наблюдателя от издателя.
  #
  # @abstract
  #
  # @param [Observer] observer
  def detach(observer)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # Уведомляет всех наблюдателей о событии.
  #
  # @abstract
  def notify
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Издатель владеет некоторым важным состоянием и оповещает наблюдателей о его
# изменениях.
class ConcreteSubject < Subject
  # Для удобства в этой переменной хранится состояние Издателя, необходимое всем
  # подписчикам.
  attr_accessor :state

  # @!attribute observers
  # @return [Array<Observer>] attr_accessor :observers private :observers

  def initialize
    @observers = []
  end

  # Список подписчиков. В реальной жизни список подписчиков может храниться в
  # более подробном виде (классифицируется по типу события и т.д.)

  # @param [Obserser] observer
  def attach(observer)
    puts 'Subject: Attached an observer.'
    @observers << observer
  end

  # @param [Obserser] observer
  def detach(observer)
    @observers.delete(observer)
  end

  # Методы управления подпиской.

  # Запуск обновления в каждом подписчике.
  def notify
    puts 'Subject: Notifying observers...'
    @observers.each { |observer| observer.update(self) }
  end

  # Обычно логика подписки – только часть того, что делает Издатель. Издатели
  # часто содержат некоторую важную бизнес-логику, которая запускает метод
  # уведомления всякий раз, когда должно произойти что-то важное (или после
  # этого).
  def some_business_logic
    puts "\nSubject: I'm doing something important."
    @state = rand(0..10)

    puts "Subject: My state has just changed to: #{@state}"
    notify
  end
end

# Интерфейс Наблюдателя объявляет метод уведомления, который издатели используют
# для оповещения своих подписчиков.
#
# @abstract
class Observer
  # Получить обновление от субъекта.
  #
  # @abstract
  #
  # @param [Subject] subject
  def update(_subject)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Наблюдатели реагируют на обновления, выпущенные Издателем, к
# которому они прикреплены.

class ConcreteObserverA < Observer
  # @param [Subject] subject
  def update(subject)
    puts 'ConcreteObserverA: Reacted to the event' if subject.state < 3
  end
end

class ConcreteObserverB < Observer
  # @param [Subject] subject
  def update(subject)
    return unless subject.state.zero? || subject.state >= 2

    puts 'ConcreteObserverB: Reacted to the event'
  end
end

# Клиентский код.

subject = ConcreteSubject.new

observer_a = ConcreteObserverA.new
subject.attach(observer_a)

observer_b = ConcreteObserverB.new
subject.attach(observer_b)

subject.some_business_logic
subject.some_business_logic

subject.detach(observer_a)

subject.some_business_logic
