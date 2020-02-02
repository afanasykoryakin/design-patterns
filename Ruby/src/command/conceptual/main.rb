# Паттерн Команда
#
# Назначение: Превращает запросы в объекты, позволяя передавать их как аргументы
# при вызове методов, ставить запросы в очередь, логировать их, а также
# поддерживать отмену операций.

# Интерфейс Команды объявляет метод для выполнения команд.
#
# @abstract
class Command
  # @abstract
  def execute
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Некоторые команды способны выполнять простые операции самостоятельно.
class SimpleCommand < Command
  # @param [String] payload
  def initialize(payload)
    @payload = payload
  end

  def execute
    puts "SimpleCommand: See, I can do simple things like printing (#{@payload})"
  end
end

# Но есть и команды, которые делегируют более сложные операции другим объектам,
# называемым «получателями».
class ComplexCommand < Command
  # Сложные команды могут принимать один или несколько объектов-получателей
  # вместе с любыми данными о контексте через конструктор.
  #
  # @param [Receiver] receiver
  # @param [String] a
  # @param [String] b
  def initialize(receiver, a, b)
    @receiver = receiver
    @a = a
    @b = b
  end

  # Команды могут делегировать выполнение любым методам получателя.
  def execute
    print 'ComplexCommand: Complex stuff should be done by a receiver object'
    @receiver.do_something(@a)
    @receiver.do_something_else(@b)
  end
end

# Классы Получателей содержат некую важную бизнес-логику. Они умеют выполнять
# все виды операций, связанных с выполнением запроса. Фактически, любой класс
# может выступать Получателем.
class Receiver
  # @param [String] a
  def do_something(a)
    print "\nReceiver: Working on (#{a}.)"
  end

  # @param [String] b
  def do_something_else(b)
    print "\nReceiver: Also working on (#{b}.)"
  end
end

# Отправитель связан с одной или несколькими командами. Он отправляет запрос
# команде.
class Invoker
  # Инициализация команд.

  # @param [Command] command
  def on_start=(command)
    @on_start = command
  end

  # @param [Command] command
  def on_finish=(command)
    @on_finish = command
  end

  # Отправитель не зависит от классов конкретных команд и получателей.
  # Отправитель передаёт запрос получателю косвенно, выполняя команду.
  def do_something_important
    puts 'Invoker: Does anybody want something done before I begin?'
    @on_start.execute if @on_start.is_a? Command

    puts 'Invoker: ...doing something really important...'

    puts 'Invoker: Does anybody want something done after I finish?'
    @on_finish.execute if @on_finish.is_a? Command
  end
end

# Клиентский код может параметризовать отправителя любыми командами.
invoker = Invoker.new
invoker.on_start = SimpleCommand.new('Say Hi!')
receiver = Receiver.new
invoker.on_finish = ComplexCommand.new(receiver, 'Send email', 'Save report')

invoker.do_something_important
