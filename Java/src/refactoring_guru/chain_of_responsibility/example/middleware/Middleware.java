package refactoring_guru.chain_of_responsibility.example.middleware;

/**
 * Базовый класс цепочки.
 */
public abstract class Middleware {
    private Middleware next;

    /**
     * Помогает строить цепь из объектов-проверок.
     */
    public Middleware linkWith(Middleware next) {
        this.next = next;
        return next;
    }

    /**
     * Подклассы реализуют в этом методе конкретные проверки.
     */
    public abstract boolean check(String email, String password);

    /**
     * Запускает проверку в следующем объекте или завершает проверку, если мы в
     * последнем элементе цепи.
     */
    protected boolean checkNext(String email, String password) {
        if (next == null) {
            return true;
        }
        return next.check(email, password);
    }
}
