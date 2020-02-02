<?php

namespace RefactoringGuru\Builder\RealWorld;

/**
 * Паттерн Строитель
 *
 * Назначение: Позволяет создавать сложные объекты пошагово. Строитель даёт
 * возможность использовать один и тот же код строительства для получения разных
 * представлений объектов.
 *
 * Пример: Одним из лучших применений паттерна Строитель является конструктор
 * запросов SQL. Интерфейс Строителя определяет общие шаги, необходимые для
 * построения основного SQL-запроса. В тоже время Конкретные Строители,
 * соответствующие различным диалектам SQL, реализуют эти шаги, возвращая части
 * SQL-запросов, которые могут быть выполнены в данном движке базы данных.
 */

/**
 * Интерфейс Строителя объявляет набор методов для сборки SQL-запроса.
 *
 * Все шаги построения возвращают текущий объект строителя, чтобы обеспечить
 * цепочку: $builder->select(...)->where(...)
 */
interface SQLQueryBuilder
{
    public function select(string $table, array $fields): SQLQueryBuilder;

    public function where(string $field, string $value, string $operator = '='): SQLQueryBuilder;

    public function limit(int $start, int $offset): SQLQueryBuilder;

    // +100 других методов синтаксиса SQL...

    public function getSQL(): string;
}

/**
 * Каждый Конкретный Строитель соответствует определённому диалекту SQL и может
 * реализовать шаги построения немного иначе, чем остальные.
 *
 * Этот Конкретный Строитель может создавать SQL-запросы, совместимые с MySQL.
 */
class MysqlQueryBuilder implements SQLQueryBuilder
{
    protected $query;

    protected function reset(): void
    {
        $this->query = new \stdClass;
    }

    /**
     * Построение базового запроса SELECT.
     */
    public function select(string $table, array $fields): SQLQueryBuilder
    {
        $this->reset();
        $this->query->base = "SELECT " . implode(", ", $fields) . " FROM " . $table;
        $this->query->type = 'select';

        return $this;
    }

    /**
     * Добавление условия WHERE.
     */
    public function where(string $field, string $value, string $operator = '='): SQLQueryBuilder
    {
        if (!in_array($this->query->type, ['select', 'update', 'delete'])) {
            throw new \Exception("WHERE can only be added to SELECT, UPDATE OR DELETE");
        }
        $this->query->where[] = "$field $operator '$value'";

        return $this;
    }

    /**
     * Добавление ограничения LIMIT.
     */
    public function limit(int $start, int $offset): SQLQueryBuilder
    {
        if (!in_array($this->query->type, ['select'])) {
            throw new \Exception("LIMIT can only be added to SELECT");
        }
        $this->query->limit = " LIMIT " . $start . ", " . $offset;

        return $this;
    }

    /**
     * Получение окончательной строки запроса.
     */
    public function getSQL(): string
    {
        $query = $this->query;
        $sql = $query->base;
        if (!empty($query->where)) {
            $sql .= " WHERE " . implode(' AND ', $query->where);
        }
        if (isset($query->limit)) {
            $sql .= $query->limit;
        }
        $sql .= ";";
        return $sql;
    }
}

/**
 * Этот Конкретный Строитель совместим с PostgreSQL. Хотя Postgres очень похож
 * на Mysql, в нем всё же есть ряд отличий. Чтобы повторно использовать общий
 * код, мы расширяем его от строителя MySQL, переопределяя некоторые шаги
 * построения.
 */
class PostgresQueryBuilder extends MysqlQueryBuilder
{
    /**
     * Помимо прочего, PostgreSQL имеет несколько иной синтаксис LIMIT.
     */
    public function limit(int $start, int $offset): SQLQueryBuilder
    {
        parent::limit($start, $offset);

        $this->query->limit = " LIMIT " . $start . " OFFSET " . $offset;

        return $this;
    }

    // + тонны других переопределений...
}


/**
 * Обратите внимание, что клиентский код непосредственно использует объект
 * строителя. Назначенный класс Директора в этом случае не нужен, потому что
 * клиентский код практически всегда нуждается в различных запросах, поэтому
 * последовательность шагов конструирования непросто повторно использовать.
 *
 * Поскольку все наши строители запросов создают продукты одного типа (это
 * строка), мы можем взаимодействовать со всеми строителями, используя их общий
 * интерфейс. Позднее, если мы реализуем новый класс Строителя, мы сможем
 * передать его экземпляр существующему клиентскому коду, не нарушая его,
 * благодаря интерфейсу SQLQueryBuilder.
 */
function clientCode(SQLQueryBuilder $queryBuilder)
{
    // ...

    $query = $queryBuilder
        ->select("users", ["name", "email", "password"])
        ->where("age", 18, ">")
        ->where("age", 30, "<")
        ->limit(10, 20)
        ->getSQL();

    echo $query;

    // ...
}


/**
 * Приложение выбирает подходящий тип строителя запроса в зависимости от текущей
 * конфигурации или настроек среды.
 */
// if ($_ENV['database_type'] == 'postgres') {
//     $builder = new PostgresQueryBuilder(); } else {
//     $builder = new MysqlQueryBuilder; }
//
// clientCode($builder);


echo "Testing MySQL query builder:\n";
clientCode(new MysqlQueryBuilder);

echo "\n\n";

echo "Testing PostgresSQL query builder:\n";
clientCode(new PostgresQueryBuilder);
