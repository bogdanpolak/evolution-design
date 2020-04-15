public class SimplePizza : IPizza {
    SimplePizza(string pizzaName) {}
}
public interface IPizza {}

public class Foo
{
    public IPizza _pizza;
    
    public void BuildPizza_SimpleFactory()
    {
        Func<string,IPizza> simpleFactoryDelegate = (pizzaName => new SimplePizza(pizzaName));
        _pizza = simpleFactoryDelegate("menu-item-3");
    }
    
    public void BuildPizza_FactoryMethod()
    {
        _pizza = _pizzaFactory.build("menu-item-3");
    }
    
    public void BuildPizza_AbstractFactory()
    {
        _pizza = new Pizza(
            _pizzaAbstractFactory.buildCrust("chicago-style"),
            _pizzaAbstractFactory.buildCheese("mozzarella"),
            _pizzaAbstractFactory.buildTopping(new[]{"mozzarella","ham"})
        );
    }
    
    public void BuildPizza_BuilderPattern()
    {
        pizza = pizzaBuilder()
            .setCrust("chicago-style")
            .setCheese("mozzarella")
            .setTopping("pineapple")
            .setTopping("ham")
            .build();    
    }
}

