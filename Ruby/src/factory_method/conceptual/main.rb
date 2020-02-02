# Паттерн Фабричный Метод
#
# Назначение: Определяет общий интерфейс для создания объектов в суперклассе,
# позволяя подклассам изменять тип создаваемых объектов.

# Класс Создатель объявляет фабричный метод, который должен возвращать объект
# класса Продукт. Подклассы Создателя обычно предоставляют реализацию этого
# метода.
#
# @abstract
class Creator
  # Обратите внимание, что Создатель может также обеспечить реализацию
  # фабричного метода по умолчанию.
  #
  # @abstract
  def factory_method
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # Также заметьте, что, несмотря на название, основная обязанность Создателя не
  # заключается в создании продуктов. Обычно он содержит некоторую базовую
  # бизнес-логику, которая основана на объектах Продуктов, возвращаемых
  # фабричным методом. Подклассы могут косвенно изменять эту бизнес-логику,
  # переопределяя фабричный метод и возвращая из него другой тип продукта.
  #
  # @return [String]
  def some_operation
    # Вызываем фабричный метод, чтобы получить объект-продукт.
    product = factory_method

    # Далее, работаем с этим продуктом.
    result = "Creator: The same creator's code has just worked with #{product.operation}"

    result
  end
end

# Конкретные Создатели переопределяют фабричный метод для того, чтобы изменить
# тип результирующего продукта.
class ConcreteCreator1 < Creator
  # Обратите внимание, что сигнатура метода по-прежнему использует тип
  # абстрактного продукта, хотя фактически из метода возвращается конкретный
  # продукт. Таким образом, Создатель может оставаться независимым от конкретных
  # классов продуктов.
  #
  # @return [ConcreteProduct1]
  def factory_method
    ConcreteProduct1.new
  end
end

class ConcreteCreator2 < Creator
  # @return [ConcreteProduct2]
  def factory_method
    ConcreteProduct2.new
  end
end

# Интерфейс Продукта объявляет операции, которые должны выполнять все конкретные
# продукты.
#
# @abstract
class Product
  # return [String]
  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Продукты предоставляют различные реализации интерфейса Продукта.
class ConcreteProduct1 < Product
  # @return [String]
  def operation
    '{Result of the ConcreteProduct1}'
  end
end

class ConcreteProduct2 < Product
  # @return [String]
  def operation
    '{Result of the ConcreteProduct2}'
  end
end

# Клиентский код работает с экземпляром конкретного создателя, хотя и через его
# базовый интерфейс. Пока клиент продолжает работать с создателем через базовый
# интерфейс, вы можете передать ему любой подкласс создателя.
#
# @param [Creator] creator
def client_code(creator)
  print "Client: I'm not aware of the creator's class, but it still works.\n"\
        "#{creator.some_operation}"
end

puts 'App: Launched with the ConcreteCreator1.'
client_code(ConcreteCreator1.new)
puts "\n\n"

puts 'App: Launched with the ConcreteCreator2.'
client_code(ConcreteCreator2.new)
