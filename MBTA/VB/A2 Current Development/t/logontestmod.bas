Attribute VB_Name = "Module1"

Public Sub Lt1()

    Dim mlr As MaxLogonResult
    Dim mlp As MaxLogonProxy
    
    Dim oDS As A2IDataSource
    Set oDS = New A2SQLDataSource
    'oDS.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    oDS.ConnectionString = "Provider=sqloledb;Data Source=OPSTECH2\A2PROD;Initial Catalog=attend2"
    
    Set mlp = New MaxLogonProxy
    Set mlr = mlp.GetA2App(oDS, "ajv6412", "doggers")

End Sub
