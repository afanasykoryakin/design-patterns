# Паттерн Строитель
#
# Назначение: Позволяет создавать сложные объекты пошагово. Строитель даёт
# возможность использовать один и тот же код строительства для получения разных
# представлений объектов.

# Интерфейс Строителя объявляет создающие методы для различных частей объектов
# Продуктов.
#
# @abstract
class Builder
  # @abstract
  def produce_part_a
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def produce_part_b
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def produce_part_c
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Классы Конкретного Строителя следуют интерфейсу Строителя и предоставляют
# конкретные реализации шагов построения. Ваша программа может иметь несколько
# вариантов Строителей, реализованных по-разному.
class ConcreteBuilder1 < Builder
  # Новый экземпляр строителя должен содержать пустой объект продукта, который
  # используется в дальнейшей сборке.
  def initialize
    reset
  end

  def reset
    @product = Product1.new
  end

  # Конкретные Строители должны предоставить свои собственные методы получения
  # результатов. Это связано с тем, что различные типы строителей могут
  # создавать совершенно разные продукты с разными интерфейсами. Поэтому такие
  # методы не могут быть объявлены в базовом интерфейсе Строителя (по крайней
  # мере, в статически типизированном языке программирования).
  #
  # Как правило, после возвращения конечного результата клиенту, экземпляр
  # строителя должен быть готов к началу производства следующего продукта.
  # Поэтому обычной практикой является вызов метода сброса в конце тела метода
  # getProduct. Однако такое поведение не является обязательным, вы можете
  # заставить своих строителей ждать явного запроса на сброс из кода клиента,
  # прежде чем избавиться от предыдущего результата.
  #
  # @return [Product1]
  def product
    product = @product
    reset
    product
  end

  def produce_part_a
    @product.add('PartA1')
  end

  def produce_part_b
    @product.add('PartB1')
  end

  def produce_part_c
    @product.add('PartC1')
  end
end

# Имеет смысл использовать паттерн Строитель только тогда, когда ваши продукты
# достаточно сложны и требуют обширной конфигурации.
#
# В отличие от других порождающих паттернов, различные конкретные строители
# могут производить несвязанные продукты. Другими словами, результаты различных
# строителей могут не всегда следовать одному и тому же интерфейсу.
class Product1
  def initialize
    @parts = []
  end

  # @param [String] part
  def add(part)
    @parts << part
  end

  def list_parts
    print "Product parts: #{@parts.join(', ')}"
  end
end

# Директор отвечает только за выполнение шагов построения в определённой
# последовательности. Это полезно при производстве продуктов в определённом
# порядке или особой конфигурации. Строго говоря, класс Директор необязателен,
# так как клиент может напрямую управлять строителями.
class Director
  # @return [Builder]
  attr_accessor :builder

  def initialize
    @builder = nil
  end

  # Директор работает с любым экземпляром строителя, который передаётся ему
  # клиентским кодом. Таким образом, клиентский код может изменить конечный тип
  # вновь собираемого продукта.
  #
  # @param [Builder] builder
  def builder=(builder)
    @builder = builder
  end

  # Директор может строить несколько вариаций продукта, используя одинаковые
  # шаги построения.

  def build_minimal_viable_product
    @builder.produce_part_a
  end

  def build_full_featured_product
    @builder.produce_part_a
    @builder.produce_part_b
    @builder.produce_part_c
  end
end

# Клиентский код создаёт объект-строитель, передаёт его директору, а затем
# инициирует процесс построения. Конечный результат извлекается из объекта-
# строителя.

director = Director.new
builder = ConcreteBuilder1.new
director.builder = builder

puts 'Standard basic product: '
director.build_minimal_viable_product
builder.product.list_parts

puts "\n\n"

puts 'Standard full featured product: '
director.build_full_featured_product
builder.product.list_parts

puts "\n\n"

# Помните, что паттерн Строитель можно использовать без класса Директор.
puts 'Custom product: '
builder.produce_part_a
builder.produce_part_b
builder.product.list_parts
