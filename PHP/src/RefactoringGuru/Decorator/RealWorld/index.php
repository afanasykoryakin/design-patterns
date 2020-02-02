<?php

namespace RefactoringGuru\Decorator\RealWorld;

/**
 * Паттерн Декоратор
 *
 * Назначение: Позволяет динамически добавлять объектам новую функциональность,
 * оборачивая их в полезные «обёртки».
 *
 * Пример: В этом примере паттерн Декоратора помогает создать сложные правила
 * фильтрации текста для приведения информации в порядок перед её отображением
 * на веб-странице. Разные типы информации, такие как комментарии, сообщения на
 * форуме или личные сообщения, требуют разных наборов фильтров.
 *
 * Например, вы хотели бы удалить весь HTML из комментариев и в тоже время
 * сохранить некоторые основные теги HTML в сообщениях на форуме. Кроме того, вы
 * можете пожелать разрешить публикацию в формате Markdown, который должен быть
 * обработан перед какой-либо фильтрацией HTML. Все эти правила фильтрации могут
 * быть представлены в виде отдельных классов декораторов, которые могут быть
 * сложены в стек по-разному, в зависимости от характера содержимого.
 */

/**
 * Интерфейс Компонента объявляет метод фильтрации, который должен быть
 * реализован всеми конкретными компонентами и декораторами.
 */
interface InputFormat
{
    public function formatText(string $text): string;
}

/**
 * Конкретный Компонент является основным элементом декорирования. Он содержит
 * исходный текст как есть, без какой-либо фильтрации или форматирования.
 */
class TextInput implements InputFormat
{
    public function formatText(string $text): string
    {
        return $text;
    }
}

/**
 * Базовый класс Декоратора не содержит реальной логики фильтрации или
 * форматирования. Его основная цель – реализовать базовую инфраструктуру
 * декорирования: поле для хранения обёрнутого компонента или другого декоратора
 * и базовый метод форматирования, который делегирует работу обёрнутому объекту.
 * Реальная работа по форматированию выполняется подклассами.
 */
class TextFormat implements InputFormat
{
    /**
     * @var InputFormat
     */
    protected $inputFormat;

    public function __construct(InputFormat $inputFormat)
    {
        $this->inputFormat = $inputFormat;
    }

    /**
     * Декоратор делегирует всю работу обёрнутому компоненту.
     */
    public function formatText(string $text): string
    {
        return $this->inputFormat->formatText($text);
    }
}

/**
 * Этот Конкретный Декоратор удаляет все теги HTML из данного текста.
 */
class PlainTextFilter extends TextFormat
{
    public function formatText(string $text): string
    {
        $text = parent::formatText($text);
        return strip_tags($text);
    }
}

/**
 * Этот Конкретный Декоратор удаляет только опасные теги и атрибуты HTML,
 * которые могут привести к XSS-уязвимости.
 */
class DangerousHTMLTagsFilter extends TextFormat
{
    private $dangerousTagPatterns = [
        "|<script.*?>([\s\S]*)?</script>|i", // ...
    ];

    private $dangerousAttributes = [
        "onclick", "onkeypress", // ...
    ];


    public function formatText(string $text): string
    {
        $text = parent::formatText($text);

        foreach ($this->dangerousTagPatterns as $pattern) {
            $text = preg_replace($pattern, '', $text);
        }

        foreach ($this->dangerousAttributes as $attribute) {
            $text = preg_replace_callback('|<(.*?)>|', function ($matches) use ($attribute) {
                $result = preg_replace("|$attribute=|i", '', $matches[1]);
                return "<" . $result . ">";
            }, $text);
        }

        return $text;
    }
}

/**
 * Этот Конкретный Декоратор предоставляет элементарное преобразование Markdown
 * → HTML.
 */
class MarkdownFormat extends TextFormat
{
    public function formatText(string $text): string
    {
        $text = parent::formatText($text);

        // Форматирование элементов блока.
        $chunks = preg_split('|\n\n|', $text);
        foreach ($chunks as &$chunk) {
            // Форматирование заголовков.
            if (preg_match('|^#+|', $chunk)) {
                $chunk = preg_replace_callback('|^(#+)(.*?)$|', function ($matches) {
                    $h = strlen($matches[1]);
                    return "<h$h>" . trim($matches[2]) . "</h$h>";
                }, $chunk);
            } // Форматирование параграфов.
            else {
                $chunk = "<p>$chunk</p>";
            }
        }
        $text = implode("\n\n", $chunks);

        // Форматирование встроенных элементов.
        $text = preg_replace("|__(.*?)__|", '<strong>$1</strong>', $text);
        $text = preg_replace("|\*\*(.*?)\*\*|", '<strong>$1</strong>', $text);
        $text = preg_replace("|_(.*?)_|", '<em>$1</em>', $text);
        $text = preg_replace("|\*(.*?)\*|", '<em>$1</em>', $text);

        return $text;
    }
}


/**
 * Клиентский код может быть частью реального веб-сайта, который отображает
 * создаваемый пользователями контент. Поскольку он работает с модулями
 * форматирования через интерфейс компонента, ему всё равно, получает ли он
 * простой объект компонента или обёрнутый.
 */
function displayCommentAsAWebsite(InputFormat $format, string $text)
{
    // ..

    echo $format->formatText($text);

    // ..
}

/**
 * Модули форматирования пользовательского ввода очень удобны при работе с
 * контентом, создаваемым пользователями. Отображение такого контента «как есть»
 * может быть очень опасным, особенно когда его могут создавать анонимные
 * пользователи (например, комментарии). Ваш сайт не только рискует получить
 * массу спам-ссылок, но также может быть подвергнут XSS-атакам.
 */
$dangerousComment = <<<HERE
Hello! Nice blog post!
Please visit my <a href='http://www.iwillhackyou.com'>homepage</a>.
<script src="http://www.iwillhackyou.com/script.js">
  performXSSAttack();
</script>
HERE;

/**
 * Наивное отображение комментариев (небезопасное).
 */
$naiveInput = new TextInput;
echo "Website renders comments without filtering (unsafe):\n";
displayCommentAsAWebsite($naiveInput, $dangerousComment);
echo "\n\n\n";

/**
 * Отфильтрованное отображение комментариев (безопасное).
 */
$filteredInput = new PlainTextFilter($naiveInput);
echo "Website renders comments after stripping all tags (safe):\n";
displayCommentAsAWebsite($filteredInput, $dangerousComment);
echo "\n\n\n";


/**
 * Декоратор позволяет складывать несколько входных форматов для получения
 * точного контроля над отображаемым содержимым.
 */
$dangerousForumPost = <<<HERE
# Welcome

This is my first post on this **gorgeous** forum.

<script src="http://www.iwillhackyou.com/script.js">
  performXSSAttack();
</script>
HERE;

/**
 * Наивное отображение сообщений (небезопасное, без форматирования).
 */
$naiveInput = new TextInput;
echo "Website renders a forum post without filtering and formatting (unsafe, ugly):\n";
displayCommentAsAWebsite($naiveInput, $dangerousForumPost);
echo "\n\n\n";

/**
 * Форматтер Markdown + фильтрация опасных тегов (безопасно, красиво).
 */
$text = new TextInput;
$markdown = new MarkdownFormat($text);
$filteredInput = new DangerousHTMLTagsFilter($markdown);
echo "Website renders a forum post after translating markdown markup" .
    "and filtering some dangerous HTML tags and attributes (safe, pretty):\n";
displayCommentAsAWebsite($filteredInput, $dangerousForumPost);
echo "\n\n\n";
