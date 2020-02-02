# Паттерн Адаптер
#
# Назначение: Позволяет объектам с несовместимыми интерфейсами работать вместе.

# Целевой класс объявляет интерфейс, с которым может работать клиентский код.
class Target
  # @return [String]
  def request
    'Target: The default target\'s behavior.'
  end
end

# Адаптируемый класс содержит некоторое полезное поведение, но его интерфейс
# несовместим с существующим клиентским кодом. Адаптируемый класс нуждается в
# некоторой доработке, прежде чем клиентский код сможет его использовать.
class Adaptee
  # @return [String]
  def specific_request
    '.eetpadA eht fo roivaheb laicepS'
  end
end

# Адаптер делает интерфейс Адаптируемого класса совместимым с целевым
# интерфейсом.
class Adapter < Target
  # @param [Adaptee] adaptee
  def initialize(adaptee)
    @adaptee = adaptee
  end

  def request
    "Adapter: (TRANSLATED) #{@adaptee.specific_request.reverse!}"
  end
end

# Клиентский код поддерживает все классы, использующие интерфейс Target.
#
# @param [Target] target
def client_code(target)
  print target.request
end

puts 'Client: I can work just fine with the Target objects:'
target = Target.new
client_code(target)
puts "\n\n"

adaptee = Adaptee.new
puts 'Client: The Adaptee class has a weird interface. See, I don\'t understand it:'
puts "Adaptee: #{adaptee.specific_request}"
puts "\n"

puts 'Client: But I can work with it via the Adapter:'
adapter = Adapter.new(adaptee)
client_code(adapter)
