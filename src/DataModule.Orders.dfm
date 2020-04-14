object DataModuleOrders: TDataModuleOrders
  OldCreateOrder = False
  Height = 147
  Width = 277
  object FDConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQLite_Demo')
    LoginPrompt = False
    Left = 57
    Top = 21
  end
  object fdqOrders: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT * FROM Orders')
    Left = 169
    Top = 21
    object fdqOrdersOrderID: TFDAutoIncField
      FieldName = 'OrderID'
      Origin = 'OrderID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object fdqOrdersCustomerID: TStringField
      FieldName = 'CustomerID'
      Origin = 'CustomerID'
      FixedChar = True
      Size = 5
    end
    object fdqOrdersEmployeeID: TIntegerField
      FieldName = 'EmployeeID'
      Origin = 'EmployeeID'
    end
    object fdqOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
      Origin = 'OrderDate'
    end
    object fdqOrdersRequiredDate: TDateTimeField
      FieldName = 'RequiredDate'
      Origin = 'RequiredDate'
    end
    object fdqOrdersShippedDate: TDateTimeField
      FieldName = 'ShippedDate'
      Origin = 'ShippedDate'
    end
    object fdqOrdersShipVia: TIntegerField
      FieldName = 'ShipVia'
      Origin = 'ShipVia'
    end
    object fdqOrdersFreight: TCurrencyField
      FieldName = 'Freight'
      Origin = 'Freight'
    end
    object fdqOrdersShipName: TStringField
      FieldName = 'ShipName'
      Origin = 'ShipName'
      Size = 40
    end
    object fdqOrdersShipAddress: TStringField
      FieldName = 'ShipAddress'
      Origin = 'ShipAddress'
      Size = 60
    end
    object fdqOrdersShipCity: TStringField
      FieldName = 'ShipCity'
      Origin = 'ShipCity'
      Size = 15
    end
    object fdqOrdersShipRegion: TStringField
      FieldName = 'ShipRegion'
      Origin = 'ShipRegion'
      Size = 15
    end
    object fdqOrdersShipPostalCode: TStringField
      FieldName = 'ShipPostalCode'
      Origin = 'ShipPostalCode'
      Size = 10
    end
    object fdqOrdersShipCountry: TStringField
      FieldName = 'ShipCountry'
      Origin = 'ShipCountry'
      Size = 15
    end
  end
end
