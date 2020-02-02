# Паттерн Шаблонный метод
#
# Назначение: Определяет общую схему алгоритма, перекладывая реализацию
# некоторых шагов на подклассы. Шаблонный метод позволяет подклассам
# переопределять отдельные шаги алгоритма без изменения структуры алгоритма.

# Абстрактный Класс определяет шаблонный метод, содержащий скелет некоторого
# алгоритма, состоящего из вызовов (обычно) абстрактных примитивных операций.
#
# Конкретные подклассы должны реализовать эти операции, но оставить сам
# шаблонный метод без изменений.
#
# @abstract
class AbstractClass
  # Шаблонный метод определяет скелет алгоритма.
  def template_method
    base_operation1
    required_operations1
    base_operation2
    hook1
    required_operations2
    base_operation3
    hook2
  end

  # Эти операции уже имеют реализации.

  def base_operation1
    puts 'AbstractClass says: I am doing the bulk of the work'
  end

  def base_operation2
    puts 'AbstractClass says: But I let subclasses override some operations'
  end

  def base_operation3
    puts 'AbstractClass says: But I am doing the bulk of the work anyway'
  end

  # А эти операции должны быть реализованы в подклассах.
  #
  # @abstract
  def required_operations1
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def required_operations2
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # Это «хуки». Подклассы могут переопределять их, но это не обязательно,
  # поскольку у хуков уже есть стандартная (но пустая) реализация. Хуки
  # предоставляют дополнительные точки расширения в некоторых критических местах
  # алгоритма.

  def hook1; end

  def hook2; end
end

# Конкретные классы должны реализовать все абстрактные операции базового класса.
# Они также могут переопределить некоторые операции с реализацией по умолчанию.
class ConcreteClass1 < AbstractClass
  def required_operations1
    puts 'ConcreteClass1 says: Implemented Operation1'
  end

  def required_operations2
    puts 'ConcreteClass1 says: Implemented Operation2'
  end
end

# Обычно конкретные классы переопределяют только часть операций базового класса.
class ConcreteClass2 < AbstractClass
  def required_operations1
    puts 'ConcreteClass2 says: Implemented Operation1'
  end

  def required_operations2
    puts 'ConcreteClass2 says: Implemented Operation2'
  end

  def hook1
    puts 'ConcreteClass2 says: Overridden Hook1'
  end
end

# Клиентский код вызывает шаблонный метод для выполнения алгоритма. Клиентский
# код не должен знать конкретный класс объекта, с которым работает, при условии,
# что он работает с объектами через интерфейс их базового класса.
#
# @param [AbstractClass] abstract_class
def client_code(abstract_class)
  # ...
  abstract_class.template_method
  # ...
end

puts 'Same client code can work with different subclasses:'
client_code(ConcreteClass1.new)
puts "\n"

puts 'Same client code can work with different subclasses:'
client_code(ConcreteClass2.new)
