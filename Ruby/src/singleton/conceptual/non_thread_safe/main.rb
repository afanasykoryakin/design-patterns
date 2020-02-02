# Паттерн Одиночка
#
# Назначение: Гарантирует, что у класса есть только один экземпляр, и
# предоставляет к нему глобальную точку доступа.

# Класс Одиночка предоставляет метод instance, который позволяет клиентам
# получить доступ к уникальному экземпляру одиночки.
class Singleton
  @instance = new

  private_class_method :new

  # Статический метод, управляющий доступом к экземпляру одиночки.
  #
  # Эта реализация позволяет вам расширять класс Одиночки, сохраняя повсюду
  # только один экземпляр каждого подкласса.
  def self.instance
    @instance
  end

  # Наконец, любой одиночка должен содержать некоторую бизнес-логику, которая
  # может быть выполнена на его экземпляре.
  def some_business_logic
    # ...
  end
end

# Клиентский код.

s1 = Singleton.instance
s2 = Singleton.instance

if s1.equal?(s2)
  print 'Singleton works, both variables contain the same instance.'
else
  print 'Singleton failed, variables contain different instances.'
end
