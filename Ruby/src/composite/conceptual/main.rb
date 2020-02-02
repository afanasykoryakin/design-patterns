# Паттерн Компоновщик
#
# Назначение: Позволяет сгруппировать объекты в древовидную структуру, а затем
# работать с ними так, как будто это единичный объект.

# Базовый класс Компонент объявляет общие операции как для простых, так и для
# сложных объектов структуры.
#
# @abstract
class Component
  # @return [Component]
  def parent
    @parent
  end

  # При необходимости базовый Компонент может объявить интерфейс для установки и
  # получения родителя компонента в древовидной структуре. Он также может
  # предоставить некоторую реализацию по умолчанию для этих методов.
  #
  # @param [Component] parent
  def parent=(parent)
    @parent = parent
  end

  # В некоторых случаях целесообразно определить операции управления потомками
  # прямо в базовом классе Компонент. Таким образом, вам не нужно будет
  # предоставлять конкретные классы компонентов клиентскому коду, даже во время
  # сборки дерева объектов. Недостаток такого подхода в том, что эти методы
  # будут пустыми для компонентов уровня листа.
  #
  # @abstract
  #
  # @param [Component] component
  def add(component)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  #
  # @param [Component] component
  def remove(component)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # Вы можете предоставить метод, который позволит клиентскому коду понять,
  # может ли компонент иметь вложенные объекты.
  #
  # @return [Boolean]
  def composite?
    false
  end

  # Базовый Компонент может сам реализовать некоторое поведение по умолчанию или
  # поручить это конкретным классам, объявив метод, содержащий поведение
  # абстрактным.
  #
  # @abstract
  #
  # @return [String]
  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Класс Лист представляет собой конечные объекты структуры. Лист не может иметь
# вложенных компонентов.
#
# Обычно объекты Листьев выполняют фактическую работу, тогда как объекты
# Контейнера лишь делегируют работу своим подкомпонентам.
class Leaf < Component
  # return [String]
  def operation
    'Leaf'
  end
end

# Класс Контейнер содержит сложные компоненты, которые могут иметь вложенные
# компоненты. Обычно объекты Контейнеры делегируют фактическую работу своим
# детям, а затем «суммируют» результат.
class Composite < Component
  def initialize
    @children = []
  end

  # Объект контейнера может как добавлять компоненты в свой список вложенных
  # компонентов, так и удалять их, как простые, так и сложные.

  # @param [Component] component
  def add(component)
    @children.append(component)
    component.parent = self
  end

  # @param [Component] component
  def remove(component)
    @children.remove(component)
    component.parent = nil
  end

  # @return [Boolean]
  def composite?
    true
  end

  # Контейнер выполняет свою основную логику особым образом. Он проходит
  # рекурсивно через всех своих детей, собирая и суммируя их результаты.
  # Поскольку потомки контейнера передают эти вызовы своим потомкам и так далее,
  # в результате обходится всё дерево объектов.
  #
  # @return [String]
  def operation
    results = []
    @children.each { |child| results.append(child.operation) }
    "Branch(#{results.join('+')})"
  end
end

# Клиентский код работает со всеми компонентами через базовый интерфейс.
#
# @param [Component] component
def client_code(component)
  puts "RESULT: #{component.operation}"
end

# Благодаря тому, что операции управления потомками объявлены в базовом классе
# Компонента, клиентский код может работать как с простыми, так и со сложными
# компонентами, вне зависимости от их конкретных классов.
#
# @param [Component] component
# @param [Component] component2
def client_code2(component1, component2)
  component1.add(component2) if component1.composite?

  print "RESULT: #{component1.operation}"
end

# Таким образом, клиентский код может поддерживать простые компоненты-листья...
simple = Leaf.new
puts 'Client: I\'ve got a simple component:'
client_code(simple)
puts "\n"

# ...а также сложные контейнеры.
tree = Composite.new

branch1 = Composite.new
branch1.add(Leaf.new)
branch1.add(Leaf.new)

branch2 = Composite.new
branch2.add(Leaf.new)

tree.add(branch1)
tree.add(branch2)

puts 'Client: Now I\'ve got a composite tree:'
client_code(tree)
puts "\n"

puts 'Client: I don\'t need to check the components classes even when managing the tree:'
client_code2(tree, simple)
