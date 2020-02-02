<?php

namespace RefactoringGuru\Mediator\RealWorld;

/**
 * Паттерн Посредник
 *
 * Назначение: Позволяет уменьшить связанность множества классов между собой,
 * благодаря перемещению этих связей в один класс-посредник.
 *
 * Пример: В этом примере паттерн Посредник расширяет базовую идею паттерна
 * Наблюдатель, предоставляя централизованный диспетчер событий. Он позволяет
 * любому объекту отслеживать и запускать события в других объектах, независимо
 * от их классов.
 */

/**
 * Класс Диспетчера Событий выполняет функции Посредника и содержит логику
 * подписки и уведомлений. Хотя классический Посредник часто зависит от
 * конкретных классов компонентов, этот привязан только к их абстрактным
 * интерфейсам.
 *
 * Достичь слабой связанности между компонентами можно благодаря особому способу
 * установления связей между ними. Компоненты сами могут подписаться на
 * интересующие их конкретные события через интерфейс подписки Посредника.
 *
 * Обратите внимание, что мы не можем использовать здесь встроенные в PHP
 * интерфейсы Subject/Observer, так как они не дадут нам реализовать расширенные
 * методы подписки и оповещений.
 */
class EventDispatcher
{
    /**
     * @var array
     */
    private $observers = [];

    public function __construct()
    {
        // Специальная группа событий для наблюдателей, которые хотят слушать
        // все события.
        $this->observers["*"] = [];
    }

    private function initEventGroup(string &$event = "*"): void
    {
        if (!isset($this->observers[$event])) {
            $this->observers[$event] = [];
        }
    }

    private function getEventObservers(string $event = "*"): array
    {
        $this->initEventGroup($event);
        $group = $this->observers[$event];
        $all = $this->observers["*"];

        return array_merge($group, $all);
    }

    public function attach(Observer $observer, string $event = "*"): void
    {
        $this->initEventGroup($event);

        $this->observers[$event][] = $observer;
    }

    public function detach(Observer $observer, string $event = "*"): void
    {
        foreach ($this->getEventObservers($event) as $key => $s) {
            if ($s === $observer) {
                unset($this->observers[$event][$key]);
            }
        }
    }

    public function trigger(string $event, object $emitter, $data = null): void
    {
        echo "EventDispatcher: Broadcasting the '$event' event.\n";
        foreach ($this->getEventObservers($event) as $observer) {
            $observer->update($event, $emitter, $data);
        }
    }
}

/**
 * Простая вспомогательная функция для предоставления глобального доступа к
 * диспетчеру событий.
 */
function events(): EventDispatcher
{
    static $eventDispatcher;
    if (!$eventDispatcher) {
        $eventDispatcher = new EventDispatcher;
    }

    return $eventDispatcher;
}

/**
 * Интерфейс Наблюдателя определяет, как компоненты получают уведомления о
 * событиях.
 */
interface Observer
{
    public function update(string $event, object $emitter, $data = null);
}

/**
 * В отличие от нашего примера паттерна Наблюдатель, этот пример заставляет
 * ПользовательскийРепозиторий действовать как обычный компонент, который не
 * имеет никаких специальных методов, связанных с событиями. Как и любой другой
 * компонент, этот класс использует ДиспетчерСобытий для трансляции своих
 * событий и прослушивания других.
 *
 * @see \RefactoringGuru\Observer\RealWorld\UserRepository
 */
class UserRepository implements Observer
{
    /**
     * @var array Список пользователей приложения.
     */
    private $users = [];

    /**
     * Компоненты могут подписаться на события самостоятельно или через
     * клиентский код.
     */
    public function __construct()
    {
        events()->attach($this, "users:deleted");
    }

    /**
     * Компоненты могут принять решение, будут ли они обрабатывать событие,
     * используя его название, источник или какие-то контекстные данные,
     * переданные вместе с событием.
     */
    public function update(string $event, object $emitter, $data = null): void
    {
        switch ($event) {
            case "users:deleted":
                if ($emitter === $this) {
                    return;
                }
                $this->deleteUser($data, true);
                break;
        }
    }

    // Эти методы представляют бизнес-логику класса.

    public function initialize(string $filename): void
    {
        echo "UserRepository: Loading user records from a file.\n";
        // ...
        events()->trigger("users:init", $this, $filename);
    }

    public function createUser(array $data, bool $silent = false): User
    {
        echo "UserRepository: Creating a user.\n";

        $user = new User;
        $user->update($data);

        $id = bin2hex(openssl_random_pseudo_bytes(16));
        $user->update(["id" => $id]);
        $this->users[$id] = $user;

        if (!$silent) {
            events()->trigger("users:created", $this, $user);
        }

        return $user;
    }

    public function updateUser(User $user, array $data, bool $silent = false): User
    {
        echo "UserRepository: Updating a user.\n";

        $id = $user->attributes["id"];
        if (!isset($this->users[$id])) {
            return null;
        }

        $user = $this->users[$id];
        $user->update($data);

        if (!$silent) {
            events()->trigger("users:updated", $this, $user);
        }

        return $user;
    }

    public function deleteUser(User $user, bool $silent = false): void
    {
        echo "UserRepository: Deleting a user.\n";

        $id = $user->attributes["id"];
        if (!isset($this->users[$id])) {
            return;
        }

        unset($this->users[$id]);

        if (!$silent) {
            events()->trigger("users:deleted", $this, $user);
        }
    }
}

/**
 * Давайте сохраним класс Пользователя тривиальным, так как он не является
 * главной темой нашего примера.
 */
class User
{
    public $attributes = [];

    public function update($data): void
    {
        $this->attributes = array_merge($this->attributes, $data);
    }

    /**
     * Все объекты могут вызывать события.
     */
    public function delete(): void
    {
        echo "User: I can now delete myself without worrying about the repository.\n";
        events()->trigger("users:deleted", $this, $this);
    }
}

/**
 * Этот Конкретный Компонент регистрирует все события, на которые он подписан.
 */
class Logger implements Observer
{
    private $filename;

    public function __construct($filename)
    {
        $this->filename = $filename;
        if (file_exists($this->filename)) {
            unlink($this->filename);
        }
    }

    public function update(string $event, object $emitter, $data = null)
    {
        $entry = date("Y-m-d H:i:s") . ": '$event' with data '" . json_encode($data) . "'\n";
        file_put_contents($this->filename, $entry, FILE_APPEND);

        echo "Logger: I've written '$event' entry to the log.\n";
    }
}

/**
 * Этот Конкретный Компонент отправляет начальные инструкции новым
 * пользователям. Клиент несёт ответственность за присоединение этого компонента
 * к соответствующему событию создания пользователя.
 */
class OnboardingNotification implements Observer
{
    private $adminEmail;

    public function __construct(string $adminEmail)
    {
        $this->adminEmail = $adminEmail;
    }

    public function update(string $event, object $emitter, $data = null): void
    {
        // mail($this->adminEmail,
        //     "Onboarding required",
        //     "We have a new user. Here's his info: " .json_encode($data));

        echo "OnboardingNotification: The notification has been emailed!\n";
    }
}

/**
 * Клиентский код.
 */

$repository = new UserRepository;
events()->attach($repository, "facebook:update");

$logger = new Logger(__DIR__ . "/log.txt");
events()->attach($logger, "*");

$onboarding = new OnboardingNotification("1@example.com");
events()->attach($onboarding, "users:created");

// ...

$repository->initialize(__DIR__ . "users.csv");

// ...

$user = $repository->createUser([
    "name" => "John Smith",
    "email" => "john99@example.com",
]);

// ...

$user->delete();
