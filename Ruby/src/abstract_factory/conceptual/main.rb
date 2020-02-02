# Паттерн Абстрактная Фабрика
#
# Назначение: Предоставляет интерфейс для создания семейств связанных или
# зависимых объектов без привязки к их конкретным классам.

# Интерфейс Абстрактной Фабрики объявляет набор методов, которые возвращают
# различные абстрактные продукты. Эти продукты называются семейством и связаны
# темой или концепцией высокого уровня. Продукты одного семейства обычно могут
# взаимодействовать между собой. Семейство продуктов может иметь несколько
# вариаций, но продукты одной вариации несовместимы с продуктами другой.
#
# @abstract
class AbstractFactory
  # @abstract
  def create_product_a
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def create_product_b
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретная Фабрика производит семейство продуктов одной вариации. Фабрика
# гарантирует совместимость полученных продуктов. Обратите внимание, что
# сигнатуры методов Конкретной Фабрики возвращают абстрактный продукт, в то
# время как внутри метода создается экземпляр конкретного продукта.
class ConcreteFactory1 < AbstractFactory
  def create_product_a
    ConcreteProductA1.new
  end

  def create_product_b
    ConcreteProductB1.new
  end
end

# Каждая Конкретная Фабрика имеет соответствующую вариацию продукта.
class ConcreteFactory2 < AbstractFactory
  def create_product_a
    ConcreteProductA2.new
  end

  def create_product_b
    ConcreteProductB2.new
  end
end

# Каждый отдельный продукт семейства продуктов должен иметь базовый интерфейс.
# Все вариации продукта должны реализовывать этот интерфейс.
#
# @abstract
class AbstractProductA
  # @abstract
  #
  # @return [String]
  def useful_function_a
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные продукты создаются соответствующими Конкретными Фабриками.
class ConcreteProductA1 < AbstractProductA
  def useful_function_a
    'The result of the product A1.'
  end
end

class ConcreteProductA2 < AbstractProductA
  def useful_function_a
    'The result of the product A2.'
  end
end

# Базовый интерфейс другого продукта. Все продукты могут взаимодействовать друг
# с другом, но правильное взаимодействие возможно только между продуктами одной
# и той же конкретной вариации.
#
# @abstract
class AbstractProductB
  # Продукт B способен работать самостоятельно...
  #
  # @abstract
  def useful_function_b
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # ...а также взаимодействовать с Продуктами Б той же вариации.
  #
  # Абстрактная Фабрика гарантирует, что все продукты, которые она создает,
  # имеют одинаковую вариацию и, следовательно, совместимы.
  #
  # @abstract
  #
  # @param [AbstractProductA] collaborator
  def another_useful_function_b(_collaborator)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Продукты создаются соответствующими Конкретными Фабриками.
class ConcreteProductB1 < AbstractProductB
  # @return [String]
  def useful_function_b
    'The result of the product B1.'
  end

  # Продукт B1 может корректно работать только с Продуктом A1. Тем не менее, он
  # принимает любой экземпляр Абстрактного Продукта А в качестве аргумента.
  #
  # @param [AbstractProductA] collaborator
  #
  # @return [String]
  def another_useful_function_b(collaborator)
    result = collaborator.useful_function_a
    "The result of the B1 collaborating with the (#{result})"
  end
end

class ConcreteProductB2 < AbstractProductB
  # @return [String]
  def useful_function_b
    'The result of the product B2.'
  end

  # Продукт B2 может корректно работать только с Продуктом A2. Тем не менее, он
  # принимает любой экземпляр Абстрактного Продукта А в качестве аргумента.
  #
  # @param [AbstractProductA] collaborator
  def another_useful_function_b(collaborator)
    result = collaborator.useful_function_a
    "The result of the B2 collaborating with the (#{result})"
  end
end

# Клиентский код работает с фабриками и продуктами только через абстрактные
# типы: Абстрактная Фабрика и Абстрактный Продукт. Это позволяет передавать
# любой подкласс фабрики или продукта клиентскому коду, не нарушая его.
#
# @param [AbstractFactory] factory
def client_code(factory)
  product_a = factory.create_product_a
  product_b = factory.create_product_b

  puts product_b.useful_function_b.to_s
  puts product_b.another_useful_function_b(product_a).to_s
end

# Клиентский код может работать с любым конкретным классом фабрики.
puts 'Client: Testing client code with the first factory type:'
client_code(ConcreteFactory1.new)

puts "\n"

puts 'Client: Testing the same client code with the second factory type:'
client_code(ConcreteFactory2.new)
