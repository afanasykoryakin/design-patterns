<?php

namespace RefactoringGuru\Flyweight\RealWorld;

/**
 * Паттерн Легковес
 *
 * Назначение: Позволяет вместить бóльшее количество объектов в отведённую
 * оперативную память. Легковес экономит память, разделяя общее состояние
 * объектов между собой, вместо хранения одинаковых данных в каждом объекте.
 *
 * Пример: Прежде чем мы начнём, обратите внимание, что реальное применение
 * паттерна Легковес на PHP встречается довольно редко. Это связано с
 * однопоточным характером PHP, где вы не должны хранить ВСЕ объекты вашего
 * приложения в памяти одновременно в одном потоке. Хотя замысел этого примера
 * только наполовину серьёзен, и вся проблема с ОЗУ может быть решена, если
 * приложение структурировать по-другому, он всё же наглядно показывает
 * концепцию паттерна, как он работает в реальном мире. Итак, я вас предупредил.
 * Теперь давайте начнём.
 *
 * В этом примере паттерн Легковес применяется для минимизации использования
 * оперативной памяти объектами в базе данных животных ветеринарной клиники
 * только для кошек. Каждую запись в базе данных представляет объект-Кот. Его
 * данные состоят из двух частей:
 *
 * 1. Уникальные (внешние) данные: имя кота, возраст и инфо о владельце.
 * 2. Общие (внутренние) данные: название породы, цвет, текстура и т.д.
 *
 * Первая часть хранится непосредственно внутри класса Кот, который играет роль
 * контекста. Вторая часть, однако, хранится отдельно и может совместно
 * использоваться разными объектами котов. Эти совместно используемые данные
 * находятся внутри класса РазновидностиКотов. Все коты, имеющие схожие
 * признаки, привязаны к одному и тому же классу РазновидностейКотов, вместо
 * того чтобы хранить повторяющиеся данные в каждом из своих объектов.
 */

/**
 * Объекты Легковеса представляют данные, разделяемые несколькими объектами
 * Кошек. Это сочетание породы, цвета, текстуры и т.д.
 */
class CatVariation
{
    /**
     * Так называемое «внутреннее» состояние.
     */
    public $breed;

    public $image;

    public $color;

    public $texture;

    public $fur;

    public $size;

    public function __construct(
        string $breed,
        string $image,
        string $color,
        string $texture,
        string $fur,
        string $size
    ) {
        $this->breed = $breed;
        $this->image = $image;
        $this->color = $color;
        $this->texture = $texture;
        $this->fur = $fur;
        $this->size = $size;
    }

    /**
     * Этот метод отображает информацию о кошке. Метод принимает внешнее
     * состояние в качестве аргументов. Остальная часть состояния хранится
     * внутри полей Легковеса.
     *
     * Возможно, вы удивлены, почему мы поместили основную логику кошки в класс
     * РазновидностейКошек вместо того, чтобы держать её в классе Кошки. Я
     * согласен, это звучит странно.
     *
     * Имейте в виду, что в реальной жизни паттерн Легковес может быть либо
     * реализован с самого начала, либо принудительно применён к существующему
     * приложению, когда разработчики понимают, что они столкнулись с проблемой
     * ОЗУ.
     *
     * Во втором случае вы получаете такие же классы, как у нас. Мы как бы
     * «отрефакторили» идеальное приложение, где все данные изначально
     * находились внутри класса Кошки. Если бы мы реализовывали Легковес с
     * самого начала, названия наших классов могли бы быть другими и более
     * определёнными. Например, Кошка и КонтекстКошки.
     *
     * Однако действительная причина, по которой основное поведение должно
     * проживать в классе Легковеса, заключается в том, что у вас может вообще
     * не быть объявленного класса Контекста. Контекстные данные могут храниться
     * в массиве или какой-то другой, более эффективной структуре данных.
     */
    public function renderProfile(string $name, string  $age, string $owner)
    {
        echo "= $name =\n";
        echo "Age: $age\n";
        echo "Owner: $owner\n";
        echo "Breed: $this->breed\n";
        echo "Image: $this->image\n";
        echo "Color: $this->color\n";
        echo "Texture: $this->texture\n";
    }
}

/**
 * Контекст хранит данные, уникальные для каждой кошки.
 *
 * Создавать отдельный класс для хранения контекста необязательно и не всегда
 * целесообразно. Контекст может храниться внутри громоздкой структуры данных в
 * коде Клиента и при необходимости передаваться в методы легковеса.
 */
class Cat
{
    /**
     * Так называемое «внешнее» состояние.
     */
    public $name;

    public $age;

    public $owner;

    /**
     * @var CatVariation
     */
    private $variation;

    public function __construct(string $name, string $age, string $owner, CatVariation $variation)
    {
        $this->name = $name;
        $this->age = $age;
        $this->owner = $owner;
        $this->variation = $variation;
    }

    /**
     * Поскольку объекты Контекста не владеют всем своим состоянием, иногда для
     * удобства вы можете реализовать несколько вспомогательных методов
     * (например, для сравнения нескольких объектов Контекста между собой).
     */
    public function matches(array $query): bool
    {
        foreach ($query as $key => $value) {
            if (property_exists($this, $key)) {
                if ($this->$key != $value) {
                    return false;
                }
            } elseif (property_exists($this->variation, $key)) {
                if ($this->variation->$key != $value) {
                    return false;
                }
            } else {
                return false;
            }
        }

        return true;
    }

    /**
     * Кроме того, Контекст может определять несколько методов быстрого доступа,
     * которые делегируют исполнение объекту-Легковесу. Эти методы могут быть
     * остатками реальных методов, извлечённых в класс Легковеса во время
     * массивного рефакторинга к паттерну Легковес.
     */
    public function render(): string
    {
        $this->variation->renderProfile($this->name, $this->age, $this->owner);
    }
}

/**
 * Фабрика Легковесов хранит объекты Контекст и Легковес, эффективно скрывая
 * любое упоминание о паттерне Легковес от клиента.
 */
class CatDataBase
{
    /**
     * Список объектов-кошек (Контексты).
     */
    private $cats = [];

    /**
     * Список вариаций кошки (Легковесы).
     */
    private $variations = [];

    /**
     * При добавлении кошки в базу данных мы сначала ищем существующую вариацию
     * кошки.
     */
    public function addCat(
        string $name,
        string $age,
        string $owner,
        string $breed,
        string $image,
        string $color,
        string $texture,
        string $fur,
        string $size
    ) {
        $variation =
            $this->getVariation($breed, $image, $color, $texture, $fur, $size);
        $this->cats[] = new Cat($name, $age, $owner, $variation);
        echo "CatDataBase: Added a cat ($name, $breed).\n";
    }

    /**
     * Возвращаем существующий вариант (Легковеса) по указанным данным или
     * создаём новый, если он ещё не существует.
     */
    public function getVariation(
        string $breed,
        string $image, $color,
        string $texture,
        string $fur,
        string $size
    ): CatVariation {
        $key = $this->getKey(get_defined_vars());

        if (!isset($this->variations[$key])) {
            $this->variations[$key] =
                new CatVariation($breed, $image, $color, $texture, $fur, $size);
        }

        return $this->variations[$key];
    }

    /**
     * Эта функция помогает генерировать уникальные ключи массива.
     */
    private function getKey(array $data): string
    {
        return md5(implode("_", $data));
    }

    /**
     * Ищем кошку в базе данных, используя заданные параметры запроса.
     */
    public function findCat(array $query)
    {
        foreach ($this->cats as $cat) {
            if ($cat->matches($query)) {
                return $cat;
            }
        }
        echo "CatDataBase: Sorry, your query does not yield any results.";
    }
}

/**
 * Клиентский код.
 */
$db = new CatDataBase;

echo "Client: Let's see what we have in \"cats.csv\".\n";

// Чтобы увидеть реальный эффект паттерна, вы должны иметь большую базу данных с
// несколькими миллионами записей. Не стесняйтесь экспериментировать с кодом,
// чтобы увидеть реальные масштабы паттерна.
$handle = fopen(__DIR__ . "/cats.csv", "r");
$row = 0;
$columns = [];
while (($data = fgetcsv($handle)) !== false) {
    if ($row == 0) {
        for ($c = 0; $c < count($data); $c++) {
            $columnIndex = $c;
            $columnKey = strtolower($data[$c]);
            $columns[$columnKey] = $columnIndex;
        }
        $row++;
        continue;
    }

    $db->addCat(
        $data[$columns['name']],
        $data[$columns['age']],
        $data[$columns['owner']],
        $data[$columns['breed']],
        $data[$columns['image']],
        $data[$columns['color']],
        $data[$columns['texture']],
        $data[$columns['fur']],
        $data[$columns['size']],
    );
    $row++;
}
fclose($handle);

// ...

echo "\nClient: Let's look for a cat named \"Siri\".\n";
$cat = $db->findCat(['name' => "Siri"]);
if ($cat) {
    $cat->render();
}

echo "\nClient: Let's look for a cat named \"Bob\".\n";
$cat = $db->findCat(['name' => "Bob"]);
if ($cat) {
    $cat->render();
}
