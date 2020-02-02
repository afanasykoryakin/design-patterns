# Паттерн Прототип
#
# Назначение: Позволяет копировать объекты, не вдаваясь в подробности их
# реализации.

# Пример класса, имеющего возможность клонирования. Мы посмотрим как происходит
# клонирование значений полей разных типов.
class Prototype
  attr_accessor :primitive, :component, :circular_reference

  def initialize
    @primitive = nil
    @component = nil
    @circular_reference = nil
  end

  # @return [Prototype]
  def clone
    @component = deep_copy(@component)

    # Клонирование объекта, который имеет вложенный объект с обратной ссылкой,
    # требует специального подхода. После завершения клонирования вложенный
    # объект должен указывать на клонированный объект, а не на исходный объект.
    @circular_reference = deep_copy(@circular_reference)
    @circular_reference.prototype = self
    deep_copy(self)
  end

  # Нередко метод deep_copy использует хак «маршалинг», чтобы создать глубокую
  # копию объекта. Однако это медленное и неэффективно, поэтому в реальных
  # приложениях используйте для этой задачи соответствующий пакет.
  #
  # @param [Object] object
  private def deep_copy(object)
    Marshal.load(Marshal.dump(object))
  end
end

class ComponentWithBackReference
  attr_accessor :prototype

  # @param [Prototype] prototype
  def initialize(prototype)
    @prototype = prototype
  end
end

# Клиентский код.
p1 = Prototype.new
p1.primitive = 245
p1.component = Time.now
p1.circular_reference = ComponentWithBackReference.new(p1)

p2 = p1.clone

if p1.primitive == p2.primitive
  puts 'Primitive field values have been carried over to a clone. Yay!'
else
  puts 'Primitive field values have not been copied. Booo!'
end

if p1.component.equal?(p2.component)
  puts 'Simple component has not been cloned. Booo!'
else
  puts 'Simple component has been cloned. Yay!'
end

if p1.circular_reference.equal?(p2.circular_reference)
  puts 'Component with back reference has not been cloned. Booo!'
else
  puts 'Component with back reference has been cloned. Yay!'
end

if p1.circular_reference.prototype.equal?(p2.circular_reference.prototype)
  print 'Component with back reference is linked to original object. Booo!'
else
  print 'Component with back reference is linked to the clone. Yay!'
end
