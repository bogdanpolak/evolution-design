unit Composer;

interface

uses
    Model.Interfaces,
    Spring.Container;

type
    TComposer = class
        class procedure RegisterTypes();
        class function GetCompositionRoot: IOrderProcessor;
        class function GetOrderStore: IOrdersStore;
    end;

implementation

uses
    Model.OrderProcessor,
    Model.OrderStore;


class function TComposer.GetCompositionRoot: IOrderProcessor;
begin
    Result := GlobalContainer.Resolve<IOrderProcessor>;
end;


class function TComposer.GetOrderStore: IOrdersStore;
begin
    Result := GlobalContainer.Resolve<IOrdersStore>;
end;


class procedure TComposer.RegisterTypes();
var
    aContainer: TContainer;
begin
    aContainer := GlobalContainer;
    aContainer.RegisterType<TOrderStore>.AsSingleton();
    aContainer.RegisterType<TOrderProcessor>;
    aContainer.Build;
end;

end.
