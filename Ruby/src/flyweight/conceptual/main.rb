# Паттерн Легковес
#
# Назначение: Позволяет вместить бóльшее количество объектов в отведённую
# оперативную память. Легковес экономит память, разделяя общее состояние
# объектов между собой, вместо хранения одинаковых данных в каждом объекте.

require 'json'

# Легковес хранит общую часть состояния (также называемую внутренним
# состоянием), которая принадлежит нескольким реальным бизнес-объектам. Легковес
# принимает оставшуюся часть состояния (внешнее состояние, уникальное для
# каждого объекта) через его параметры метода.
class Flyweight
  # @param [String] shared_state
  def initialize(shared_state)
    @shared_state = shared_state
  end

  # @param [String] unique_state
  def operation(unique_state)
    s = @shared_state.to_json
    u = unique_state.to_json
    print "Flyweight: Displaying shared (#{s}) and unique (#{u}) state."
  end
end

# Фабрика Легковесов создает объекты-Легковесы и управляет ими. Она обеспечивает
# правильное разделение легковесов. Когда клиент запрашивает легковес, фабрика
# либо возвращает существующий экземпляр, либо создает новый, если он ещё не
# существует.
class FlyweightFactory
  # @param [Hash] initial_flyweights
  def initialize(initial_flyweights)
    @flyweights = {}
    initial_flyweights.each do |state|
      @flyweights[get_key(state)] = Flyweight.new(state)
    end
  end

  # Возвращает хеш строки Легковеса для данного состояния.
  #
  # @param [Array] state
  #
  # @return [String]
  def get_key(state)
    state.sort.join('_')
  end

  # Возвращает существующий Легковес с заданным состоянием или создает новый.
  #
  # @param [Array] shared_state
  #
  # @return [Flyweight]
  def get_flyweight(shared_state)
    key = get_key(shared_state)

    if !@flyweights.key?(key)
      puts "FlyweightFactory: Can't find a flyweight, creating new one."
      @flyweights[key] = Flyweight.new(shared_state)
    else
      puts 'FlyweightFactory: Reusing existing flyweight.'
    end

    @flyweights[key]
  end

  def list_flyweights
    puts "FlyweightFactory: I have #{@flyweights.size} flyweights:"
    print @flyweights.keys.join("\n")
  end
end

# @param [FlyweightFactory] factory
# @param [String] plates
# @param [String] owner
# @param [String] brand
# @param [String] model
# @param [String] color
def add_car_to_police_database(factory, plates, owner, brand, model, color)
  puts "\n\nClient: Adding a car to database."
  flyweight = factory.get_flyweight([brand, model, color])
  # Клиентский код либо сохраняет, либо вычисляет внешнее состояние и передает
  # его методам легковеса.
  flyweight.operation([plates, owner])
end

# Клиентский код обычно создает кучу предварительно заполненных легковесов на
# этапе инициализации приложения.

factory = FlyweightFactory.new([
                                 %w[Chevrolet Camaro2018 pink],
                                 ['Mercedes Benz', 'C300', 'black'],
                                 ['Mercedes Benz', 'C500', 'red'],
                                 %w[BMW M5 red],
                                 %w[BMW X6 white]
                               ])

factory.list_flyweights

add_car_to_police_database(factory, 'CL234IR', 'James Doe', 'BMW', 'M5', 'red')

add_car_to_police_database(factory, 'CL234IR', 'James Doe', 'BMW', 'X1', 'red')

puts "\n\n"

factory.list_flyweights
