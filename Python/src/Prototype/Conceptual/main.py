"""
Паттерн Прототип

Назначение: Позволяет копировать объекты, не вдаваясь в подробности их
реализации.
"""


from __future__ import annotations
from datetime import datetime
from copy import deepcopy
from typing import Any


class Prototype:
    """
    Пример класса, имеющего возможность клонирования. Мы посмотрим как
    происходит клонирование значений полей разных типов.
    """

    def __init__(self) -> None:
        self._primitive = None
        self._component = None
        self._circular_reference = None

    @property
    def primitive(self) -> Any:
        return self._primitive

    @primitive.setter
    def primitive(self, value: Any) -> None:
        self._primitive = value

    @property
    def component(self) -> object:
        return self._component

    @component.setter
    def component(self, value: object) -> None:
        self._component = value

    @property
    def circular_reference(self) -> ComponentWithBackReference:
        return self._circular_reference

    @circular_reference.setter
    def circular_reference(self, value: ComponentWithBackReference) -> None:
        self._circular_reference = value

    def clone(self) -> Prototype:
        self.component = deepcopy(self.component)

        # Клонирование объекта, который имеет вложенный объект с обратной
        # ссылкой, требует специального подхода. После завершения клонирования
        # вложенный объект должен указывать на клонированный объект, а не на
        # исходный объект.
        self.circular_reference = deepcopy(self.circular_reference)
        self.circular_reference.prototype = self
        return deepcopy(self)


class ComponentWithBackReference:
    def __init__(self, prototype: Prototype):
        self._prototype = prototype

    @property
    def prototype(self) -> Prototype:
        return self._prototype

    @prototype.setter
    def prototype(self, value: Prototype) -> None:
        self._prototype = value


if __name__ == "__main__":
    # Клиентский код.
    p1 = Prototype()
    p1.primitive = 245
    p1.component = datetime.now()
    p1.circular_reference = ComponentWithBackReference(p1)

    p2 = p1.clone()

    if p1.primitive is p2.primitive:
        print("Primitive field values have been carried over to a clone. Yay!")
    else:
        print("Primitive field values have not been copied. Booo!")

    if p1.component is p2.component:
        print("Simple component has not been cloned. Booo!")
    else:
        print("Simple component has been cloned. Yay!")

    if p1.circular_reference is p2.circular_reference:
        print("Component with back reference has not been cloned. Booo!")
    else:
        print("Component with back reference has been cloned. Yay!")

    if p1.circular_reference.prototype is p2.circular_reference.prototype:
        print("Component with back reference is linked to original object. Booo!", end="")
    else:
        print("Component with back reference is linked to the clone. Yay!", end="")
