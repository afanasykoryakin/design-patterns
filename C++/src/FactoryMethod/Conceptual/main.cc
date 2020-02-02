#include <iostream>
#include <string>

/**
 * Паттерн Фабричный Метод
 *
 * Назначение: Определяет общий интерфейс для создания объектов в суперклассе,
 * позволяя подклассам изменять тип создаваемых объектов.
 */

/**
 * Интерфейс Продукта объявляет операции, которые должны выполнять все
 * конкретные продукты.
 */

class Product {
 public:
  virtual ~Product() {}
  virtual std::string Operation() const = 0;
};

/**
 * Конкретные Продукты предоставляют различные реализации интерфейса Продукта.
 */
class ConcreteProduct1 : public Product {
 public:
  std::string Operation() const override {
    return "{Result of the ConcreteProduct1}";
  }
};
class ConcreteProduct2 : public Product {
 public:
  std::string Operation() const override {
    return "{Result of the ConcreteProduct2}";
  }
};

/**
 * Класс Создатель объявляет фабричный метод, который должен возвращать объект
 * класса Продукт. Подклассы Создателя обычно предоставляют реализацию этого
 * метода.
 */

class Creator {
  /**
   * Обратите внимание, что Создатель может также обеспечить реализацию
   * фабричного метода по умолчанию.
   */
 public:
  virtual ~Creator(){};
  virtual Product* FactoryMethod() const = 0;
  /**
   * Также заметьте, что, несмотря на название, основная обязанность Создателя
   * не заключается в создании продуктов. Обычно он содержит некоторую базовую
   * бизнес-логику, которая основана на объектах Продуктов, возвращаемых
   * фабричным методом. Подклассы могут косвенно изменять эту бизнес-логику,
   * переопределяя фабричный метод и возвращая из него другой тип продукта.
   */

  std::string SomeOperation() const {
    // Вызываем фабричный метод, чтобы получить объект-продукт.
    Product* product = this->FactoryMethod();
    // Далее, работаем с этим продуктом.
    std::string result = "Creator: The same creator's code has just worked with " + product->Operation();
    delete product;
    return result;
  }
};

/**
 * Конкретные Создатели переопределяют фабричный метод для того, чтобы изменить
 * тип результирующего продукта.
 */
class ConcreteCreator1 : public Creator {
  /**
   * Обратите внимание, что сигнатура метода по-прежнему использует тип
   * абстрактного продукта, хотя фактически из метода возвращается конкретный
   * продукт. Таким образом, Создатель может оставаться независимым от
   * конкретных классов продуктов.
   */
 public:
  Product* FactoryMethod() const override {
    return new ConcreteProduct1();
  }
};

class ConcreteCreator2 : public Creator {
 public:
  Product* FactoryMethod() const override {
    return new ConcreteProduct2();
  }
};

/**
 * Клиентский код работает с экземпляром конкретного создателя, хотя и через его
 * базовый интерфейс. Пока клиент продолжает работать с создателем через базовый
 * интерфейс, вы можете передать ему любой подкласс создателя.
 */
void ClientCode(const Creator& creator) {
  // ...
  std::cout << "Client: I'm not aware of the creator's class, but it still works.\n"
            << creator.SomeOperation() << std::endl;
  // ...
}

/**
 * Приложение выбирает тип создателя в зависимости от конфигурации или среды.
 */

int main() {
  std::cout << "App: Launched with the ConcreteCreator1.\n";
  Creator* creator = new ConcreteCreator1();
  ClientCode(*creator);
  std::cout << std::endl;
  std::cout << "App: Launched with the ConcreteCreator2.\n";
  Creator* creator2 = new ConcreteCreator2();
  ClientCode(*creator2);

  delete creator;
  delete creator2;
  return 0;
}