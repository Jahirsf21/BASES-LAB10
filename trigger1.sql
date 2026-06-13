USE Tienda;
GO

ALTER TRIGGER trg_after_update
ON Producto
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditoriaPrecio
        (idProducto, PrecioAnterior, PrecioNuevo, FechaCambio, UsuarioBD)
    SELECT
        d.idProducto,
        d.Precio AS PrecioAnterior,
        i.Precio AS PrecioNuevo,
        GETDATE() AS FechaCambio,
        SYSTEM_USER AS UsuarioBD
    FROM deleted d
    INNER JOIN inserted i
        ON d.idProducto = i.idProducto;
END;
GO
