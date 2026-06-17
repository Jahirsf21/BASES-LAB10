/*
    * Laboratorio # 10
    * Author: Deislher Sánchez Funez
    * Carnet: 2023032794
    * Curso: Bases de datos 1
    * Profesor: Ing. Luis Pablo Soto Chavez
    * I Semestre 2026
    * Grupo: 60
*/

IF DB_ID('TIENDA') IS NULL
    CREATE DATABASE TIENDA;
GO

USE TIENDA;
GO

DROP TRIGGER IF EXISTS trg_AuditoriaDDL ON DATABASE;
GO

DROP TABLE IF EXISTS Producto;
DROP TABLE IF EXISTS AuditoriaPrecio;
DROP TABLE IF EXISTS AuditoriaEliminacion;
DROP TABLE IF EXISTS BitacoraDDL;

GO

DROP TRIGGER IF EXISTS trg_after_update;
DROP TRIGGER IF EXISTS trg_after_delete;
DROP TRIGGER IF EXISTS trg_Producto_MonitoreaCampos;
DROP TRIGGER IF EXISTS trg_Producto_Recursivo;
GO

CREATE TABLE Producto(
    IdProducto INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Precio DECIMAL(10,2),
    Stock INT,
    Estado BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE AuditoriaPrecio(
    IdAuditoria INT IDENTITY PRIMARY KEY,
    IdProducto INT,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2),
    FechaCambio DATETIME,
    UsuarioBD VARCHAR(100)
);
GO

CREATE TABLE AuditoriaEliminacion(
    IdAuditoria INT IDENTITY PRIMARY KEY,
    IdProducto INT,
    Nombre VARCHAR(100),
    Precio DECIMAL(10,2),
    FechaEliminacion DATETIME,
    UsuarioBD VARCHAR(100)
);
GO

CREATE TABLE BitacoraDDL(
    IdEvento INT IDENTITY PRIMARY KEY,
    EventoDDL VARCHAR(100),
    Objeto VARCHAR(200),
    FechaEvento DATETIME,
    UsuarioBD VARCHAR(100)
);
GO

INSERT INTO Producto (IdProducto, Nombre, Precio, Stock)
VALUES
    (1, 'Camisa', 800, 12),
    (2, 'Botella', 4000, 14),
    (3, 'Pantalon', 5000, 16),
    (4, 'Cinturon', 6000, 18),
    (5, 'Zapato', 7000, 20),
    (6, 'Chaqueta', 8500, 10),
    (7, 'Gorra', 2500, 25),
    (8, 'Reloj', 15000, 8),
    (9, 'Mochila', 9000, 15),
    (10, 'Audifonos', 12000, 30),
    (11, 'Teclado', 7500, 22),
    (12, 'Mouse', 3500, 40),
    (13, 'Monitor', 45000, 5),
    (14, 'Laptop', 75000, 3),
    (15, 'Tablet', 30000, 7),
    (16, 'Telefono', 50000, 12),
    (17, 'Cargador', 2000, 50),
    (18, 'Cable USB', 1500, 60),
    (19, 'Parlante', 18000, 9),
    (20, 'Microfono', 22000, 6),
    (21, 'Silla Gamer', 65000, 4),
    (22, 'Escritorio', 40000, 11),
    (23, 'Lampara', 5500, 18),
    (24, 'Cuaderno', 1000, 100),
    (25, 'Lapicero', 500, 200),
    (26, 'Impresora', 28000, 6),
    (27, 'Camara', 60000, 4),
    (28, 'Tripode', 8000, 13),
    (29, 'Disco SSD', 35000, 20),
    (30, 'Memoria USB', 4500, 35),
    (31, 'Router', 17000, 14),
    (32, 'Control Gamer', 14000, 16),
    (33, 'Webcam', 9500, 19),
    (34, 'MicroSD', 3000, 45),
    (35, 'Power Bank', 7000, 27),
    (36, 'Lentes', 6000, 21),
    (37, 'Billetera', 3500, 33),
    (38, 'Mueble TV', 55000, 5),
    (39, 'Ventilador', 12000, 10),
    (40, 'Aspiradora', 30000, 7),
    (41, 'Teclado Mecanico', 20000, 12),
    (42, 'Sofa', 90000, 2),
    (43, 'Cama', 120000, 3),
    (44, 'Mesa', 25000, 8),
    (45, 'Licuadora', 18000, 15),
    (46, 'Microondas', 45000, 6),
    (47, 'Refrigeradora', 250000, 2),
    (48, 'Cocina', 180000, 3),
    (49, 'Lavadora', 220000, 4),
    (50, 'Televisor', 150000, 5);
GO

CREATE OR ALTER TRIGGER trg_after_update
ON Producto
AFTER UPDATE
AS
BEGIN
    PRINT 'Trigger A';
    INSERT INTO AuditoriaPrecio
        (IdProducto, PrecioAnterior, PrecioNuevo, FechaCambio, UsuarioBD)
    SELECT
        d.IdProducto,
        d.Precio AS PrecioAnterior,
        i.Precio AS PrecioNuevo,
        GETDATE() AS FechaCambio,
        SYSTEM_USER AS UsuarioBD
    FROM deleted d
    INNER JOIN inserted i
        ON d.IdProducto = i.IdProducto;
END;
GO

CREATE OR ALTER TRIGGER trg_after_delete
ON Producto
AFTER DELETE
AS
BEGIN
    PRINT 'Trigger B';
    INSERT INTO AuditoriaEliminacion
        (IdProducto, Nombre, Precio, FechaEliminacion, UsuarioBD)
    SELECT
        d.IdProducto,
        d.Nombre,
        d.Precio,
        GETDATE() AS FechaEliminacion,
        SYSTEM_USER AS UsuarioBD
    FROM deleted d;
END;
GO

CREATE OR ALTER TRIGGER trg_Producto_MonitoreaCampos
ON Producto
AFTER UPDATE
AS
BEGIN
    PRINT 'Trigger C';
    IF UPDATE(Precio)
    INSERT INTO AuditoriaPrecio
        (IdProducto, PrecioAnterior, PrecioNuevo, FechaCambio, UsuarioBD)
    SELECT
        d.IdProducto,
        d.Precio AS PrecioAnterior,
        i.Precio AS PrecioNuevo,
        GETDATE() AS FechaCambio,
        SYSTEM_USER AS UsuarioBD
    FROM deleted d
    INNER JOIN inserted i
        ON d.IdProducto = i.IdProducto;
END;
GO

CREATE OR ALTER TRIGGER trg_AuditoriaDDL
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    PRINT 'Trigger D';
    INSERT INTO BitacoraDDL
        (EventoDDL, Objeto, FechaEvento, UsuarioBD)
    SELECT
        EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'),
        EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(256)'),
        GETDATE() AS FechaEvento,
        SYSTEM_USER AS UsuarioBD;
END;
GO

CREATE OR ALTER TRIGGER trg_Producto_Recursivo
ON Producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Producto P
        INNER JOIN inserted i ON P.idProducto = i.idProducto
        WHERE i.Precio > 1000
            AND P.Estado = 0
    )
        RETURN;

    PRINT 'Trigger E';

    UPDATE P
    SET P.Estado = 1
    FROM Producto P
    INNER JOIN inserted i ON P.idProducto = i.idProducto
    WHERE i.Precio > 1000
        AND P.Estado = 0;
END;
GO

/**
 * Casos de prueba trg_after_update y trg_Producto_MonitoreaCampos
 */


/**
 *  Actualizar stock de producto con id = 1
 */
UPDATE Producto
SET Stock = 15
WHERE idProducto = 1;
GO
/**
 *  Actualizar precio de producto con id = 1
 */
UPDATE Producto
SET Precio = 3500
WHERE idProducto = 1;
GO
/**
 *  Actualizar nombre del producto con id = 1
 */
UPDATE Producto
SET Nombre = 'Natilla'
WHERE idProducto = 1;
GO
/**
 *  Actualizar stock de producto con id = 2
 */
UPDATE Producto
SET Stock = 25
WHERE idProducto = 2;
G0
/**
 *  Actualizar precio de producto con id = 2
 */
UPDATE Producto
SET Precio = 4500
WHERE idProducto = 2;
G0
/**
 *  Actualizar nombre del producto con id = 2
 */
UPDATE Producto
SET Nombre = 'Queso crema'
WHERE idProducto = 2;
G0
/**
 *  Actualizar stock de producto con id = 3
 */
UPDATE Producto
SET Stock = 35
WHERE idProducto = 3;
G0
/**
 *  Actualizar precio de producto con id = 3
 */
UPDATE Producto
SET Precio = 5500
WHERE idProducto = 3;
G0
/**
 *  Actualizar nombre del producto con id = 3
 */
UPDATE Producto
SET Nombre = 'Queso'
WHERE idProducto = 3;
GO

/**
 * Casos de prueba trg_after_delete
 */

/**
 *  Eliminar el producto con id = 1
 */
DELETE Producto
WHERE idProducto = 1;
GO
/**
 *  Eliminar el producto con id = 2
 */
DELETE Producto
WHERE idProducto = 2;
G0
/**
 *  Eliminar el producto con id = 3
 */
DELETE Producto
WHERE idProducto = 3;
G0
/**
 *  Eliminar el producto con id = 4
 */
DELETE Producto
WHERE idProducto = 4;
G0
/**
 *  Eliminar el producto con id = 5
 */
DELETE Producto
WHERE idProducto = 5;
G0


/**
 * Casos de prueba trigger anidado
 */

 UPDATE Producto
 SET Nombre = 'Queso'
 WHERE idProducto = 6;
 GO

 DELETE Producto
 WHERE idProducto = 6;
 G0

/**
 * Casos de prueba trg_AuditoriaDDL
 */
CREATE TABLE Prueba (
    id INT
);
GO

ALTER TABLE Prueba
ADD nombre VARCHAR(50);
G0

DROP TABLE Prueba;
G0


/**
 * Casos de prueba trg_Producto_Recursivo
 */
 SELECT
	idProducto,
	Nombre,
	Precio,
	Stock
 FROM Producto
 WHERE idProducto = 1;
 GO

 UPDATE Producto
 SET Precio = 1500
 WHERE idProducto = 1;
 GO

 SELECT
	idProducto,
	Nombre,
	Precio,
	Stock
 FROM Producto
 WHERE idProducto = 1;
 GO
