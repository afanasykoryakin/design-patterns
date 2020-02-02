<?php

namespace RefactoringGuru\Adapter\RealWorld;

/**
 * Паттерн Адаптер
 *
 * Назначение: Позволяет объектам с несовместимыми интерфейсами работать вместе.
 *
 * Пример: Паттерн Адаптер позволяет использовать сторонние или устаревшие
 * классы, даже если они несовместимы с основной частью кода. Например, вместо
 * того, чтобы переписывать интерфейс уведомлений вашего приложения для
 * поддержки каждого стороннего сервиса вроде Slack, Facebook, SMS и прочих, вы
 * создаёте под эти сервисы набор специальных обёрток, которые приводят вызовы
 * из приложения к требуемым сторонними классами интерфейсу и формату.
 */

/**
 * Целевой интерфейс предоставляет интерфейс, которому следуют классы вашего
 * приложения.
 */
interface Notification
{
    public function send(string $title, string $message);
}

/**
 * Вот пример существующего класса, который следует за целевым интерфейсом.
 *
 * Дело в том, что у большинства приложений нет чётко определённого интерфейса.
 * В этом случае лучше было бы расширить Адаптер за счёт существующего класса
 * приложения. Если это неудобно (например, SlackNotification не похож на
 * подкласс EmailNotification), тогда первым шагом должно быть извлечение
 * интерфейса.
 */
class EmailNotification implements Notification
{
    private $adminEmail;

    public function __construct(string $adminEmail)
    {
        $this->adminEmail = $adminEmail;
    }

    public function send(string $title, string $message): void
    {
        mail($this->adminEmail, $title, $message);
        echo "Sent email with title '$title' to '{$this->adminEmail}' that says '$message'.";
    }
}

/**
 * Адаптируемый класс – некий полезный класс, несовместимый с целевым
 * интерфейсом. Нельзя просто войти и изменить код класса так, чтобы следовать
 * целевому интерфейсу, так как код может предоставляться сторонней библиотекой.
 */
class SlackApi
{
    private $login;
    private $apiKey;

    public function __construct(string $login, string $apiKey)
    {
        $this->login = $login;
        $this->apiKey = $apiKey;
    }

    public function logIn(): void
    {
        // Send authentication request to Slack web service.
        echo "Logged in to a slack account '{$this->login}'.\n";
    }

    public function sendMessage(string $chatId, string $message): void
    {
        // Send message post request to Slack web service.
        echo "Posted following message into the '$chatId' chat: '$message'.\n";
    }
}

/**
 * Адаптер – класс, который связывает Целевой интерфейс и Адаптируемый класс.
 * Это позволяет приложению использовать Slack API для отправки уведомлений.
 */
class SlackNotification implements Notification
{
    private $slack;
    private $chatId;

    public function __construct(SlackApi $slack, string $chatId)
    {
        $this->slack = $slack;
        $this->chatId = $chatId;
    }

    /**
     * Адаптер способен адаптировать интерфейсы и преобразовывать входные данные
     * в формат, необходимый Адаптируемому классу.
     */
    public function send(string $title, string $message): void
    {
        $slackMessage = "#" . $title . "# " . strip_tags($message);
        $this->slack->logIn();
        $this->slack->sendMessage($this->chatId, $slackMessage);
    }
}

/**
 * Клиентский код работает с классами, которые следуют Целевому интерфейсу.
 */
function clientCode(Notification $notification)
{
    // ...

    echo $notification->send("Website is down!",
        "<strong style='color:red;font-size: 50px;'>Alert!</strong> " .
        "Our website is not responding. Call admins and bring it up!");

    // ...
}

echo "Client code is designed correctly and works with email notifications:\n";
$notification = new EmailNotification("developers@example.com");
clientCode($notification);
echo "\n\n";


echo "The same client code can work with other classes via adapter:\n";
$slackApi = new SlackApi("example.com", "XXXXXXXX");
$notification = new SlackNotification($slackApi, "Example.com Developers");
clientCode($notification);
