<?php

namespace RefactoringGuru\TemplateMethod\RealWorld;

/**
 * Паттерн Шаблонный метод
 *
 * Назначение: Определяет общую схему алгоритма, перекладывая реализацию
 * некоторых шагов на подклассы. Шаблонный метод позволяет подклассам
 * переопределять отдельные шаги алгоритма без изменения структуры алгоритма.
 *
 * Пример: В этом примере Шаблонный метод определяет общую схему алгоритма
 * отправки сообщений в социальных сетях. Каждый подкласс представляет отдельную
 * социальную сеть и реализует все шаги по-разному, но повторно использует
 * базовый алгоритм.
 */

/**
 * Абстрактный Класс определяет метод шаблона и объявляет все его шаги.
 */
abstract class SocialNetwork
{
    protected $username;

    protected $password;

    public function __construct(string $username, string $password)
    {
        $this->username = $username;
        $this->password = $password;
    }

    /**
     * Фактический метод шаблона вызывает абстрактные шаги в определённом
     * порядке. Подкласс может реализовать все шаги, позволяя этому методу
     * реально публиковать что-то в социальной сети.
     */
    public function post(string $message): bool
    {
        // Проверка подлинности перед публикацией. Каждая сеть использует свой
        // метод авторизации.
        if ($this->logIn($this->username, $this->password)) {
            // Отправляем почтовые данные. Все сети имеют разные API.
            $result = $this->sendData($message);
            // ...
            $this->logOut();

            return $result;
        }

        return false;
    }

    /**
     * Шаги объявлены абстрактными, чтобы заставить подклассы реализовать их
     * полностью.
     */
    abstract public function logIn(string $userName, string $password): bool;

    abstract public function sendData(string $message): bool;

    abstract public function logOut(): void;
}

/**
 * Этот Конкретный Класс реализует API Facebook (ладно, он пытается).
 */
class Facebook extends SocialNetwork
{
    public function logIn(string $userName, string $password): bool
    {
        echo "\nChecking user's credentials...\n";
        echo "Name: " . $this->username . "\n";
        echo "Password: " . str_repeat("*", strlen($this->password)) . "\n";

        simulateNetworkLatency();

        echo "\n\nFacebook: '" . $this->username . "' has logged in successfully.\n";

        return true;
    }

    public function sendData(string $message): bool
    {
        echo "Facebook: '" . $this->username . "' has posted '" . $message . "'.\n";

        return true;
    }

    public function logOut(): void
    {
        echo "Facebook: '" . $this->username . "' has been logged out.\n";
    }
}

/**
 * Этот Конкретный Класс реализует API Twitter.
 */
class Twitter extends SocialNetwork
{
    public function logIn(string $userName, string $password): bool
    {
        echo "\nChecking user's credentials...\n";
        echo "Name: " . $this->username . "\n";
        echo "Password: " . str_repeat("*", strlen($this->password)) . "\n";

        simulateNetworkLatency();

        echo "\n\nTwitter: '" . $this->username . "' has logged in successfully.\n";

        return true;
    }

    public function sendData(string $message): bool
    {
        echo "Twitter: '" . $this->username . "' has posted '" . $message . "'.\n";

        return true;
    }

    public function logOut(): void
    {
        echo "Twitter: '" . $this->username . "' has been logged out.\n";
    }
}

/**
 * Небольшая вспомогательная функция, которая делает время ожидания похожим на
 * реальность.
 */
function simulateNetworkLatency()
{
    $i = 0;
    while ($i < 5) {
        echo ".";
        sleep(1);
        $i++;
    }
}

/**
 * Клиентский код.
 */
echo "Username: \n";
$username = readline();
echo "Password: \n";
$password = readline();
echo "Message: \n";
$message = readline();

echo "\nChoose the social network to post the message:\n" .
    "1 - Facebook\n" .
    "2 - Twitter\n";
$choice = readline();

// Теперь давайте создадим правильный объект социальной сети и отправим
// сообщение.
if ($choice == 1) {
    $network = new Facebook($username, $password);
} elseif ($choice == 2) {
    $network = new Twitter($username, $password);
} else {
    die("Sorry, I'm not sure what you mean by that.\n");
}
$network->post($message);
