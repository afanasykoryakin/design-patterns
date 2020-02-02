# Паттерн Посетитель
#
# Назначение: Позволяет создавать новые операции, не меняя классы объектов, над
# которыми эти операции могут выполняться.

# Интерфейс Компонента объявляет метод accept, который в качестве аргумента
# может получать любой объект, реализующий интерфейс посетителя.
class Component
  # @abstract
  #
  # @param [Visitor] visitor
  def accept(_visitor)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Каждый Конкретный Компонент должен реализовать метод accept таким образом,
# чтобы он вызывал метод посетителя, соответствующий классу компонента.
class ConcreteComponentA < Component
  # Обратите внимание, мы вызываем visitConcreteComponentA, что соответствует
  # названию текущего класса. Таким образом мы позволяем посетителю узнать, с
  # каким классом компонента он работает.
  #
  # @param [Visitor] visitor
  def accept(visitor)
    visitor.visit_concrete_component_a(self)
  end

  # Конкретные Компоненты могут иметь особые методы, не объявленные в их базовом
  # классе или интерфейсе. Посетитель всё же может использовать эти методы,
  # поскольку он знает о конкретном классе компонента.
  def exclusive_method_of_concrete_component_a
    'A'
  end
end

# То же самое здесь: visit_concrete_component_b => ConcreteComponentB
class ConcreteComponentB < Component
  # @param [Visitor] visitor
  def accept(visitor)
    visitor.visit_concrete_component_b(self)
  end

  def special_method_of_concrete_component_b
    'B'
  end
end

# Интерфейс Посетителя объявляет набор методов посещения, соответствующих
# классам компонентов. Сигнатура метода посещения позволяет посетителю
# определить конкретный класс компонента, с которым он имеет дело.
#
# @abstract
class Visitor
  # @abstract
  #
  # @param [ConcreteComponentA] element
  def visit_concrete_component_a(_element)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  #
  # @param [ConcreteComponentB] element
  def visit_concrete_component_b(_element)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Посетители реализуют несколько версий одного и того же алгоритма,
# которые могут работать со всеми классами конкретных компонентов.
#
# Максимальную выгоду от паттерна Посетитель вы почувствуете, используя его со
# сложной структурой объектов, такой как дерево Компоновщика. В этом случае было
# бы полезно хранить некоторое промежуточное состояние алгоритма при выполнении
# методов посетителя над различными объектами структуры.
class ConcreteVisitor1 < Visitor
  def visit_concrete_component_a(element)
    puts "#{element.exclusive_method_of_concrete_component_a} + #{self.class}"
  end

  def visit_concrete_component_b(element)
    puts "#{element.special_method_of_concrete_component_b} + #{self.class}"
  end
end

class ConcreteVisitor2 < Visitor
  def visit_concrete_component_a(element)
    puts "#{element.exclusive_method_of_concrete_component_a} + #{self.class}"
  end

  def visit_concrete_component_b(element)
    puts "#{element.special_method_of_concrete_component_b} + #{self.class}"
  end
end

# Клиентский код может выполнять операции посетителя над любым набором
# элементов, не выясняя их конкретных классов. Операция принятия направляет
# вызов к соответствующей операции в объекте посетителя.
#
# @param [Array<Component>] components
# @param [Visitor] visitor
def client_code(components, visitor)
  # ...
  components.each do |component|
    component.accept(visitor)
  end
  # ...
end

components = [ConcreteComponentA.new, ConcreteComponentB.new]

puts 'The client code works with all visitors via the base Visitor interface:'
visitor1 = ConcreteVisitor1.new
client_code(components, visitor1)

puts 'It allows the same client code to work with different types of visitors:'
visitor2 = ConcreteVisitor2.new
client_code(components, visitor2)
