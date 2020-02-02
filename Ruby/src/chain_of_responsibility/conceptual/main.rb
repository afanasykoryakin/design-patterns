# Паттерн Цепочка обязанностей
#
# Назначение: Позволяет передавать запросы последовательно по цепочке
# обработчиков. Каждый последующий обработчик решает, может ли он обработать
# запрос сам и стоит ли передавать запрос дальше по цепи.

# Интерфейс Обработчика объявляет метод построения цепочки обработчиков. Он
# также объявляет метод для выполнения запроса.
#
# @abstract
class Handler
  # @abstract
  #
  # @param [Handler] handler
  def next_handler=(handler)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  #
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Поведение цепочки по умолчанию может быть реализовано внутри базового сса
# обработчика.
class AbstractHandler < Handler
  # @return [Handler]
  attr_writer :next_handler

  # @param [Handler] handler
  #
  # @return [Handler]
  def next_handler(handler)
    @next_handler = handler
    # Возврат обработчика отсюда позволит связать обработчики простым способом,
    # вот так:
    # monkey.next_handler(squirrel).next_handler(dog)
    handler
  end

  # @abstract
  #
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    return @next_handler.handle(request) if @next_handler

    nil
  end
end

# Все Конкретные Обработчики либо обрабатывают запрос, либо передают его
# следующему обработчику в цепочке.
class MonkeyHandler < AbstractHandler
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    if request == 'Banana'
      "Monkey: I'll eat the #{request}"
    else
      super(request)
    end
  end
end

class SquirrelHandler < AbstractHandler
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    if request == 'Nut'
      "Squirrel: I'll eat the #{request}"
    else
      super(request)
    end
  end
end

class DogHandler < AbstractHandler
  # @param [String] request
  #
  # @return [String, nil]
  def handle(request)
    if request == 'MeatBall'
      "Dog: I'll eat the #{request}"
    else
      super(request)
    end
  end
end

# Обычно клиентский код приспособлен для работы с единственным обработчиком. В
# большинстве случаев клиенту даже неизвестно, что этот обработчик является
# частью цепочки.
#
# @param [Handler] handler
def client_code(handler)
  ['Nut', 'Banana', 'Cup of coffee'].each do |food|
    puts "\nClient: Who wants a #{food}?"
    result = handler.handle(food)
    if result
      print "  #{result}"
    else
      print "  #{food} was left untouched."
    end
  end
end

monkey = MonkeyHandler.new
squirrel = SquirrelHandler.new
dog = DogHandler.new

monkey.next_handler(squirrel).next_handler(dog)

# Клиент должен иметь возможность отправлять запрос любому обработчику, а не
# только первому в цепочке.
puts 'Chain: Monkey > Squirrel > Dog'
client_code(monkey)
puts "\n\n"

puts 'Subchain: Squirrel > Dog'
client_code(squirrel)
