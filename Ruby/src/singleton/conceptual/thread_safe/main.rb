# Паттерн Одиночка
#
# Назначение: Гарантирует, что у класса есть только один экземпляр, и
# предоставляет к нему глобальную точку доступа.

# Класс Одиночка предоставляет метод instance, который позволяет клиентам
# получить доступ к уникальному экземпляру одиночки.
class Singleton
  attr_reader :value

  @instance_mutex = Mutex.new

  private_class_method :new

  def initialize(value)
    @value = value
  end

  # Статический метод, управляющий доступом к экземпляру одиночки.
  #
  # Эта реализация позволяет вам расширять класс Одиночки, сохраняя повсюду
  # только один экземпляр каждого подкласса.
  def self.instance(value)
    return @instance if @instance

    @instance_mutex.synchronize do
      @instance ||= new(value)
    end

    @instance
  end

  # Наконец, любой одиночка должен содержать некоторую бизнес-логику, которая
  # может быть выполнена на его экземпляре.
  def some_business_logic
    # ...
  end
end

# @param [String] value
def test_singleton(value)
  singleton = Singleton.instance(value)
  puts singleton.value
end

# Клиентский код.

puts "If you see the same value, then singleton was reused (yay!)\n"\
     "If you see different values, then 2 singletons were created (booo!!)\n\n"\
     "RESULT:\n\n"

process1 = Thread.new { test_singleton('FOO') }
process2 = Thread.new { test_singleton('BAR') }
process1.join
process2.join
