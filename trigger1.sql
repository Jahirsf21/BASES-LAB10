USE Tienda;
GO

CREATE TRIGGER trg_after_update
ON Producto
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditoriaPrecio (idProducto, PrecioAnterior, PrecioNuevo, FechaCambio)
    SELECT
        d.idProducto,
        d.Precio AS PrecioAnterior,
        i.Precio AS PrecioNuevo,
        GETDATE() AS FechaCambio
    FROM deleted d
    INNER JOIN inserted i
        ON d.idProducto = i.idProducto;
END;
GO
