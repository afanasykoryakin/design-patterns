# Паттерн Декоратор
#
# Назначение: Позволяет динамически добавлять объектам новую функциональность,
# оборачивая их в полезные «обёртки».

# Базовый интерфейс Компонента определяет поведение, которое изменяется
# декораторами.
class Component
  # @return [String]
  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретные Компоненты предоставляют реализации поведения по умолчанию. Может
# быть несколько вариаций этих классов.
class ConcreteComponent < Component
  # @return [String]
  def operation
    'ConcreteComponent'
  end
end

# Базовый класс Декоратора следует тому же интерфейсу, что и другие компоненты.
# Основная цель этого класса - определить интерфейс обёртки для всех конкретных
# декораторов. Реализация кода обёртки по умолчанию может включать в себя поле
# для хранения завёрнутого компонента и средства его инициализации.
class Decorator < Component
  attr_accessor :component

  # @param [Component] component
  def initialize(component)
    @component = component
  end

  # Декоратор делегирует всю работу обёрнутому компоненту.
  #
  # @return [String]
  def operation
    @component.operation
  end
end

# Конкретные Декораторы вызывают обёрнутый объект и изменяют его результат
# некоторым образом.
class ConcreteDecoratorA < Decorator
  # Декораторы могут вызывать родительскую реализацию операции, вместо того,
  # чтобы вызвать обёрнутый объект напрямую. Такой подход упрощает расширение
  # классов декораторов.
  #
  # @return [String]
  def operation
    "ConcreteDecoratorA(#{@component.operation})"
  end
end

# Декораторы могут выполнять своё поведение до или после вызова обёрнутого
# объекта.
class ConcreteDecoratorB < Decorator
  # @return [String]
  def operation
    "ConcreteDecoratorB(#{@component.operation})"
  end
end

# Клиентский код работает со всеми объектами, используя интерфейс Компонента.
# Таким образом, он остаётся независимым от конкретных классов компонентов, с
# которыми работает.
#
# @param [Component] component
def client_code(component)
  # ...

  print "RESULT: #{component.operation}"

  # ...
end

# Таким образом, клиентский код может поддерживать как простые компоненты...
simple = ConcreteComponent.new
puts 'Client: I\'ve got a simple component:'
client_code(simple)
puts "\n\n"

# ...так и декорированные.
#
# Обратите внимание, что декораторы могут обёртывать не только простые
# компоненты, но и другие декораторы.
decorator1 = ConcreteDecoratorA.new(simple)
decorator2 = ConcreteDecoratorB.new(decorator1)
puts 'Client: Now I\'ve got a decorated component:'
client_code(decorator2)
