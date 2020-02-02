<?php

namespace RefactoringGuru\Strategy\RealWorld;

/**
 * Паттерн Стратегия
 *
 * Назначение: Определяет семейство схожих алгоритмов и помещает каждый из них в
 * собственный класс, после чего алгоритмы можно взаимозаменять прямо во время
 * исполнения программы.
 *
 * Пример: В этом примере паттерн Стратегия используется для представления
 * способов оплаты в приложении электронной коммерции.
 *
 * Каждый способ оплаты может отображать форму оплаты для сбора надлежащих
 * платёжных реквизитов пользователя и отправки его в компанию по обработке
 * платежей. После того, как компания по обработке платежей перенаправляет
 * пользователя обратно на сайт, метод оплаты проверяет возвращаемые параметры и
 * помогает решить, был ли заказ завершён.
 */

/**
 * Это роутер и контроллер нашего приложения. Получив запрос, этот класс решает,
 * какое поведение должно выполняться. Когда приложение получает требование об
 * оплате, класс OrderController также решает, какой способ оплаты следует
 * использовать для его обработки. Таким образом, этот класс действует как
 * Контекст и в то же время как Клиент.
 */
class OrderController
{
    /**
     * Обрабатываем запросы POST.
     *
     * @param $url
     * @param $data
     * @throws \Exception
     */
    public function post(string $url, array $data)
    {
        echo "Controller: POST request to $url with " . json_encode($data) . "\n";

        $path = parse_url($url, PHP_URL_PATH);

        if (preg_match('#^/orders?$#', $path, $matches)) {
            $this->postNewOrder($data);
        } else {
            echo "Controller: 404 page\n";
        }
    }

    /**
     * Обрабатываем запросы GET.
     *
     * @param $url
     * @throws \Exception
     */
    public function get(string $url): void
    {
        echo "Controller: GET request to $url\n";

        $path = parse_url($url, PHP_URL_PATH);
        $query = parse_url($url, PHP_URL_QUERY);
        parse_str($query, $data);

        if (preg_match('#^/orders?$#', $path, $matches)) {
            $this->getAllOrders();
        } elseif (preg_match('#^/order/([0-9]+?)/payment/([a-z]+?)(/return)?$#', $path, $matches)) {
            $order = Order::get($matches[1]);

            // Способ оплаты (стратегия) выбирается в соответствии со значением,
            // переданным в запросе.
            $paymentMethod = PaymentFactory::getPaymentMethod($matches[2]);

            if (!isset($matches[3])) {
                $this->getPayment($paymentMethod, $order, $data);
            } else {
                $this->getPaymentReturn($paymentMethod, $order, $data);
            }
        } else {
            echo "Controller: 404 page\n";
        }
    }

    /**
     * POST /order {data}
     */
    public function postNewOrder(array $data): void
    {
        $order = new Order($data);
        echo "Controller: Created the order #{$order->id}.\n";
    }

    /**
     * GET /orders
     */
    public function getAllOrders(): void
    {
        echo "Controller: Here's all orders:\n";
        foreach (Order::get() as $order) {
            echo json_encode($order, JSON_PRETTY_PRINT) . "\n";
        }
    }

    /**
     * GET /order/123/payment/XX
     */
    public function getPayment(PaymentMethod $method, Order $order, array $data): void
    {
        // Фактическая работа делегируется объекту метода оплаты.
        $form = $method->getPaymentForm($order);
        echo "Controller: here's the payment form:\n";
        echo $form . "\n";
    }

    /**
     * GET /order/123/payment/XXX/return?key=AJHKSJHJ3423&success=true
     */
    public function getPaymentReturn(PaymentMethod $method, Order $order, array $data): void
    {
        try {
            // Другой тип работы, делегированный методу оплаты.
            if ($method->validateReturn($order, $data)) {
                echo "Controller: Thanks for your order!\n";
                $order->complete();
            }
        } catch (\Exception $e) {
            echo "Controller: got an exception (" . $e->getMessage() . ")\n";
        }
    }
}

/**
 * Упрощенное представление класса Заказа.
 */
class Order
{
    /**
     * Для простоты, мы будем хранить все созданные заказы здесь...
     */
    private static $orders = [];

    /**
     * ...и получать к ним доступ отсюда.
     *
     * @param int $orderId
     * @return mixed
     */
    public static function get(int $orderId = null)
    {
        if ($orderId === null) {
            return static::$orders;
        } else {
            return static::$orders[$orderId];
        }
    }

    /**
     * Конструктор Заказа присваивает значения полям заказа. Чтобы всё было
     * просто, нет никакой проверки.
     *
     * @param array $attributes
     */
    public function __construct(array $attributes)
    {
        $this->id = count(static::$orders);
        $this->status = "new";
        foreach ($attributes as $key => $value) {
            $this->{$key} = $value;
        }
        static::$orders[$this->id] = $this;
    }

    /**
     * Метод позвонить при оплате заказа.
     */
    public function complete(): void
    {
        $this->status = "completed";
        echo "Order: #{$this->id} is now {$this->status}.";
    }
}

/**
 * Этот класс помогает создать правильный объект стратегии для обработки
 * платежа.
 */
class PaymentFactory
{
    /**
     * Получаем способ оплаты по его ID.
     *
     * @param $id
     * @return PaymentMethod
     * @throws \Exception
     */
    public static function getPaymentMethod(string $id): PaymentMethod
    {
        switch ($id) {
            case "cc":
                return new CreditCardPayment;
            case "paypal":
                return new PayPalPayment;
            default:
                throw new \Exception("Unknown Payment Method");
        }
    }
}

/**
 * Интерфейс Стратегии описывает, как клиент может использовать различные
 * Конкретные Стратегии.
 *
 * Обратите внимание, что в большинстве примеров, которые можно найти в
 * интернете, стратегии чаще всего делают какую-нибудь мелочь в рамках одного
 * метода.
 */
interface PaymentMethod
{
    public function getPaymentForm(Order $order): string;
    
    public function validateReturn(Order $order, array $data): bool;
}

/**
 * Эта Конкретная Стратегия предоставляет форму оплаты и проверяет результаты
 * платежей кредитными картам.
 */
class CreditCardPayment implements PaymentMethod
{
    static private $store_secret_key = "swordfish";

    public function getPaymentForm(Order $order): string
    {
        $returnURL = "https://our-website.com/" .
            "order/{$order->id}/payment/cc/return";

        return <<<FORM
<form action="https://my-credit-card-processor.com/charge" method="POST">
    <input type="hidden" id="email" value="{$order->email}">
    <input type="hidden" id="total" value="{$order->total}">
    <input type="hidden" id="returnURL" value="$returnURL">
    <input type="text" id="cardholder-name">
    <input type="text" id="credit-card">
    <input type="text" id="expiration-date">
    <input type="text" id="ccv-number">
    <input type="submit" value="Pay">
</form>
FORM;
    }

    public function validateReturn(Order $order, array $data): bool
    {
        echo "CreditCardPayment: ...validating... ";

        if ($data['key'] != md5($order->id . static::$store_secret_key)) {
            throw new \Exception("Payment key is wrong.");
        }

        if (!isset($data['success']) || !$data['success'] || $data['success'] == 'false') {
            throw new \Exception("Payment failed.");
        }

        // ...

        if (floatval($data['total']) < $order->total) {
            throw new \Exception("Payment amount is wrong.");
        }

        echo "Done!\n";

        return true;
    }
}

/**
 * Эта Конкретная Стратегия предоставляет форму оплаты и проверяет результаты
 * платежей PayPal.
 */
class PayPalPayment implements PaymentMethod
{
    public function getPaymentForm(Order $order): string
    {
        $returnURL = "https://our-website.com/" .
            "order/{$order->id}/payment/paypal/return";

        return <<<FORM
<form action="https://paypal.com/payment" method="POST">
    <input type="hidden" id="email" value="{$order->email}">
    <input type="hidden" id="total" value="{$order->total}">
    <input type="hidden" id="returnURL" value="$returnURL">
    <input type="submit" value="Pay on PayPal">
</form>
FORM;
    }

    public function validateReturn(Order $order, array $data): bool
    {
        echo "PayPalPayment: ...validating... ";

        // ...

        echo "Done!\n";

        return true;
    }
}

/**
 * Клиентский код.
 */

$controller = new OrderController;

echo "Client: Let's create some orders\n";

$controller->post("/orders", [
    "email" => "me@example.com",
    "product" => "ABC Cat food (XL)",
    "total" => 9.95,
]);

$controller->post("/orders", [
    "email" => "me@example.com",
    "product" => "XYZ Cat litter (XXL)",
    "total" => 19.95,
]);

echo "\nClient: List my orders, please\n";

$controller->get("/orders");

echo "\nClient: I'd like to pay for the second, show me the payment form\n";

$controller->get("/order/1/payment/paypal");

echo "\nClient: ...pushes the Pay button...\n";
echo "\nClient: Oh, I'm redirected to the PayPal.\n";
echo "\nClient: ...pays on the PayPal...\n";
echo "\nClient: Alright, I'm back with you, guys.\n";

$controller->get("/order/1/payment/paypal/return" .
    "?key=c55a3964833a4b0fa4469ea94a057152&success=true&total=19.95");
