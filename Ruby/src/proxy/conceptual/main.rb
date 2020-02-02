# Паттерн Заместитель
#
# Назначение: Позволяет подставлять вместо реальных объектов специальные
# объекты-заменители. Эти объекты перехватывают вызовы к оригинальному объекту,
# позволяя сделать что-то до или после передачи вызова оригиналу.

# Интерфейс Субъекта объявляет общие операции как для Реального Субъекта, так и
# для Заместителя. Пока клиент работает с Реальным Субъектом, используя этот
# интерфейс, вы сможете передать ему заместителя вместо реального субъекта.
#
# @abstract
class Subject
  # @abstract
  def request
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Реальный Субъект содержит некоторую базовую бизнес-логику. Как правило,
# Реальные Субъекты способны выполнять некоторую полезную работу, которая к тому
# же может быть очень медленной или точной – например, коррекция входных данных.
# Заместитель может решить эти задачи без каких-либо изменений в коде Реального
# Субъекта.
class RealSubject < Subject
  def request
    puts 'RealSubject: Handling request.'
  end
end

# Интерфейс Заместителя идентичен интерфейсу Реального Субъекта.
class Proxy < Subject
  # @param [RealSubject] real_subject
  def initialize(real_subject)
    @real_subject = real_subject
  end

  # Наиболее распространёнными областями применения паттерна Заместитель
  # являются ленивая загрузка, кэширование, контроль доступа, ведение журнала и
  # т.д. Заместитель может выполнить одну из этих задач, а затем, в зависимости
  # от результата, передать выполнение одноимённому методу в связанном объекте
  # класса Реального Субъекта.
  def request
    return unless check_access

    @real_subject.request
    log_access
  end

  # @return [Boolean]
  def check_access
    puts 'Proxy: Checking access prior to firing a real request.'
    true
  end

  def log_access
    print 'Proxy: Logging the time of request.'
  end
end

# Клиентский код должен работать со всеми объектами (как с реальными, так и
# заместителями) через интерфейс Субъекта, чтобы поддерживать как реальные
# субъекты, так и заместителей. В реальной жизни, однако, клиенты в основном
# работают с реальными субъектами напрямую. В этом случае, для более простой
# реализации паттерна, можно расширить заместителя из класса реального субъекта.
#
# @param [Subject] subject
def client_code(subject)
  # ...

  subject.request

  # ...
end

puts 'Client: Executing the client code with a real subject:'
real_subject = RealSubject.new
client_code(real_subject)

puts "\n"

puts 'Client: Executing the same client code with a proxy:'
proxy = Proxy.new(real_subject)
client_code(proxy)
