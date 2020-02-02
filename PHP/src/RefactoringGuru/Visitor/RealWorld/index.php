<?php

namespace RefactoringGuru\Visitor\RealWorld;

/**
 * Паттерн Посетитель
 *
 * Назначение: Позволяет создавать новые операции, не меняя классы объектов, над
 * которыми эти операции могут выполняться.
 *
 * Пример: В этом примере паттерн Посетитель помогает внедрить функцию
 * отчётности в существующую иерархию классов:
 *
 * Компания > Отдел > Сотрудник
 *
 * После реализации Посетителя вы можете легко добавлять в приложение другие
 * подобные поведения без изменения существующих классов.
 */

/**
 * Интерфейс Компонента объявляет метод принятия объектов-посетителей.
 *
 * В этом методе Конкретный Компонент вызывает конкретный метод Посетителя, с
 * тем же типом параметра, что и у компонента.
 */
interface Entity
{
    public function accept(Visitor $visitor): string;
}

/**
 * Конкретный Компонент Компании.
 */
class Company implements Entity
{
    private $name;

    /**
     * @var Department[]
     */
    private $departments;

    public function __construct(string $name, array $departments)
    {
        $this->name = $name;
        $this->departments = $departments;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getDepartments(): array
    {
        return $this->departments;
    }

    // ...

    public function accept(Visitor $visitor): string
    {
        // Смотрите, Компонент Компании должен вызвать метод visitCompany. Тот
        // же принцип применяется ко всем компонентам.
        return $visitor->visitCompany($this);
    }
}

/**
 * Конкретный Компонент Отдела.
 */
class Department implements Entity
{
    private $name;

    /**
     * @var Employee[]
     */
    private $employees;

    public function __construct(string $name, array $employees)
    {
        $this->name = $name;
        $this->employees = $employees;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getEmployees(): array
    {
        return $this->employees;
    }

    public function getCost(): int
    {
        $cost = 0;
        foreach ($this->employees as $employee) {
            $cost += $employee->getSalary();
        }

        return $cost;
    }

    // ...

    public function accept(Visitor $visitor): string
    {
        return $visitor->visitDepartment($this);
    }
}

/**
 * Конкретный Компонент Сотрудника.
 */
class Employee implements Entity
{
    private $name;

    private $position;

    private $salary;

    public function __construct(string $name, string $position, int $salary)
    {
        $this->name = $name;
        $this->position = $position;
        $this->salary = $salary;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getPosition(): string
    {
        return $this->position;
    }

    public function getSalary(): int
    {
        return $this->salary;
    }

    // ...

    public function accept(Visitor $visitor): string
    {
        return $visitor->visitEmployee($this);
    }
}

/**
 * Интерфейс Посетителя объявляет набор методов посещения для каждого класса
 * Конкретного Компонента.
 */
interface Visitor
{
    public function visitCompany(Company $company): string;

    public function visitDepartment(Department $department): string;

    public function visitEmployee(Employee $employee): string;
}

/**
 * Конкретный Посетитель должен предоставить реализации для каждого из классов
 * Конкретных Компонентов.
 */
class SalaryReport implements Visitor
{
    public function visitCompany(Company $company): string
    {
        $output = "";
        $total = 0;

        foreach ($company->getDepartments() as $department) {
            $total += $department->getCost();
            $output .= "\n--" . $this->visitDepartment($department);
        }

        $output = $company->getName() .
            " (" . money_format("%i", $total) . ")\n" . $output;

        return $output;
    }

    public function visitDepartment(Department $department): string
    {
        $output = "";

        foreach ($department->getEmployees() as $employee) {
            $output .= "   " . $this->visitEmployee($employee);
        }

        $output = $department->getName() .
            " (" . money_format("%i", $department->getCost()) . ")\n\n" .
            $output;

        return $output;
    }

    public function visitEmployee(Employee $employee): string
    {
        return money_format("%#6n", $employee->getSalary()) .
            " " . $employee->getName() .
            " (" . $employee->getPosition() . ")\n";
    }
}

/**
 * Клиентский код.
 */

$mobileDev = new Department("Mobile Development", [
    new Employee("Albert Falmore", "designer", 100000),
    new Employee("Ali Halabay", "programmer", 100000),
    new Employee("Sarah Konor", "programmer", 90000),
    new Employee("Monica Ronaldino", "QA engineer", 31000),
    new Employee("James Smith", "QA engineer", 30000),
]);
$techSupport = new Department("Tech Support", [
    new Employee("Larry Ulbrecht", "supervisor", 70000),
    new Employee("Elton Pale", "operator", 30000),
    new Employee("Rajeet Kumar", "operator", 30000),
    new Employee("John Burnovsky", "operator", 34000),
    new Employee("Sergey Korolev", "operator", 35000),
]);
$company = new Company("SuperStarDevelopment", [$mobileDev, $techSupport]);

setlocale(LC_MONETARY, 'en_US');
$report = new SalaryReport;

echo "Client: I can print a report for a whole company:\n\n";
echo $company->accept($report);

echo "\nClient: ...or just for a single department:\n\n";
echo $techSupport->accept($report);

// $export = new JSONExport; 
// echo $company->accept($export);
