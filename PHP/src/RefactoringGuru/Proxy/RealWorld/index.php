<?php

namespace RefactoringGuru\Proxy\RealWorld;

/**
 * Паттерн Заместитель
 *
 * Назначение: Позволяет подставлять вместо реальных объектов специальные
 * объекты-заменители. Эти объекты перехватывают вызовы к оригинальному объекту,
 * позволяя сделать что-то до или после передачи вызова оригиналу.
 *
 * Пример: Существует бесчисленное множество направлений, где могут быть
 * использованы заместители: кэширование, логирование, контроль доступа,
 * отложенная инициализация и т.д. В этом примере показано, как паттерн
 * Заместитель может повысить производительность объекта-загрузчика путём
 * кэширования его результатов.
 */

/**
 * Интерфейс Субъекта описывает интерфейс реального объекта.
 *
 * Дело в том, что у большинства приложений нет чётко определённого интерфейса.
 * В этом случае лучше было бы расширить Заместителя за счёт существующего
 * класса приложения. Если это неудобно, тогда первым шагом должно быть
 * извлечение правильного интерфейса.
 */
interface Downloader
{
    public function download(string $url): string;
}

/**
 * Реальный Субъект делает реальную работу, хотя и не самым эффективным
 * способом. Когда клиент пытается загрузить тот же самый файл во второй раз,
 * наш загрузчик именно это и делает, вместо того, чтобы извлечь результат из
 * кэша.
 */
class SimpleDownloader implements Downloader
{
    public function download(string $url): string
    {
        echo "Downloading a file from the Internet.\n";
        $result = file_get_contents($url);
        echo "Downloaded bytes: " . strlen($result) . "\n";
        
        return $result;
    }
}

/**
 * Класс Заместителя – это попытка сделать загрузку более эффективной. Он
 * обёртывает реальный объект загрузчика и делегирует ему первые запросы на
 * скачивание. Затем результат кэшируется, что позволяет последующим вызовам
 * возвращать уже имеющийся файл вместо его повторной загрузки.
 */
class CachingDownloader implements Downloader
{
    /**
     * @var SimpleDownloader
     */
    private $downloader;

    /**
     * @var string[]
     */
    private $cache = [];

    public function __construct(SimpleDownloader $downloader)
    {
        $this->downloader = $downloader;
    }

    public function download(string $url): string
    {
        if (!isset($this->cache[$url])) {
            echo "CacheProxy MISS. ";
            $result = $this->downloader->download($url);
            $this->cache[$url] = $result;
        } else {
            echo "CacheProxy HIT. Retrieving result from cache.\n";
        }
        return $this->cache[$url];
    }
}

/**
 * Клиентский код может выдать несколько похожих запросов на загрузку. В этом
 * случае кэширующий заместитель экономит время и трафик, подавая результаты из
 * кэша.
 *
 * Клиент не знает, что он работает с заместителем, потому что он работает с
 * загрузчиками через абстрактный интерфейс.
 */
function clientCode(Downloader $subject)
{
    // ...

    $result = $subject->download("http://example.com/");

    // Повторяющиеся запросы на загрузку могут кэшироваться для увеличения
    // скорости.

    $result = $subject->download("http://example.com/");

    // ...
}

echo "Executing client code with real subject:\n";
$realSubject = new SimpleDownloader;
clientCode($realSubject);

echo "\n";

echo "Executing the same client code with a proxy:\n";
$proxy = new CachingDownloader($realSubject);
clientCode($proxy);
