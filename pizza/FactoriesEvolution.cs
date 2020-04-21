public class SimplePizza : IPizza {
    SimplePizza(string pizzaName) {}
}
public interface IPizza {}

public class Foo
{
    public IPizza _pizza;
    Func<string,IPizza> simpleFactoryDelegate = (pizzaName) => new SimplePizza(pizzaName);
    
    public void BuildPizza_SimpleFactory()
    {
        _pizza = simpleFactoryDelegate("Hawaiian");
    }
    
    public void BuildPizza_FactoryMethod()
    {
        _pizza = _pizzaFactory.build("Hawaiian");
    }
    
    public void BuildPizza_AbstractFactory()
    {
        _pizza = new Pizza(
            _pizzaAbstractFactory.buildCrusts("chicago-style"),
            _pizzaAbstractFactory.buildCheese("mozzarella"),
            _pizzaAbstractFactory.buildTopping(new[]{"pinapple","ham"})
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

