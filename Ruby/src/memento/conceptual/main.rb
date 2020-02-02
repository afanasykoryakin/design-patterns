# Паттерн Снимок
#
# Назначение: Фиксирует и восстанавливает внутреннее состояние объекта таким
# образом, чтобы в дальнейшем объект можно было восстановить в этом состоянии
# без нарушения инкапсуляции.

# Создатель содержит некоторое важное состояние, которое может со временем
# меняться. Он также объявляет метод сохранения состояния внутри снимка и метод
# восстановления состояния из него.
class Originator
  # Для удобства состояние создателя хранится внутри одной переменной.
  attr_accessor :state
  private :state

  # @param [String] state
  def initialize(state)
    @state = state
    puts "Originator: My initial state is: #{@state}"
  end

  # Бизнес-логика Создателя может повлиять на его внутреннее состояние. Поэтому
  # клиент должен выполнить резервное копирование состояния с помощью метода
  # save перед запуском методов бизнес-логики.
  def do_something
    puts 'Originator: I\'m doing something important.'
    @state = generate_random_string(30)
    puts "Originator: and my state has changed to: #{@state}"
  end

  private def generate_random_string(length = 10)
    ascii_letters = [*'a'..'z', *'A'..'Z']
    (0...length).map { ascii_letters.sample }.join
  end

  # Сохраняет текущее состояние внутри снимка.
  #
  # @return [Memento]
  def save
    ConcreteMemento.new(@state)
  end

  # Восстанавливает состояние Создателя из объекта снимка.
  #
  # @param [Memento] memento
  def restore(memento)
    @state = memento.state
    puts "Originator: My state has changed to: #{@state}"
  end
end

# Интерфейс Снимка предоставляет способ извлечения метаданных снимка, таких как
# дата создания или название. Однако он не раскрывает состояние Создателя.
#
# @abstract
class Memento
  # @abstract
  #
  # @return [String]
  def name
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  #
  # @return [String]
  def date
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class ConcreteMemento < Memento
  # @param [String] state
  def initialize(state)
    @state = state
    @date = Time.now.strftime('%F %T')
  end

  # Создатель использует этот метод, когда восстанавливает своё состояние.
  #
  # @return [String]
  attr_reader :state

  # Остальные методы используются Опекуном для отображения метаданных.
  #
  # @return [String]
  def name
    "#{@date} / (#{@state[0, 9]}...)"
  end

  # @return [String]
  attr_reader :date
end

# Опекун не зависит от класса Конкретного Снимка. Таким образом, он не имеет
# доступа к состоянию создателя, хранящемуся внутри снимка. Он работает со всеми
# снимками через базовый интерфейс Снимка.
class Caretaker
  # @param [Originator] originator
  def initialize(originator)
    @mementos = []
    @originator = originator
  end

  def backup
    puts "\nCaretaker: Saving Originator's state..."
    @mementos << @originator.save
  end

  def undo
    return if @mementos.empty?

    memento = @mementos.pop
    puts "Caretaker: Restoring state to: #{memento.name}"

    begin
      @originator.restore(memento)
    rescue StandardError
      undo
    end
  end

  def show_history
    puts 'Caretaker: Here\'s the list of mementos:'

    @mementos.each { |memento| puts memento.name }
  end
end

originator = Originator.new('Super-duper-super-puper-super.')
caretaker = Caretaker.new(originator)

caretaker.backup
originator.do_something

caretaker.backup
originator.do_something

caretaker.backup
originator.do_something

puts "\n"
caretaker.show_history

puts "\nClient: Now, let's rollback!\n"
caretaker.undo

puts "\nClient: Once more!\n"
caretaker.undo
