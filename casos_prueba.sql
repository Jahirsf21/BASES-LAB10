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
 UPDATE Producto
 SET Precio = 1500
 WHERE idProducto = 1;
 GO
