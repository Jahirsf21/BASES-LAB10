CREATE DATABASE TIENDA;
USE TIENDA;

CREATE TABLE Producto(
    IdProducto INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Precio DECIMAL(10,2),
    Stock INT,
    Estado BIT NOT NULL DEFAULT 0
);

CREATE TABLE AuditoriaPrecio(
    IdAuditoria INT IDENTITY PRIMARY KEY,
    IdProducto INT,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2),
    FechaCambio DATETIME,
    UsuarioBD VARCHAR(100)
);

CREATE TABLE AuditoriaEliminacion(
    IdAuditoria INT IDENTITY PRIMARY KEY,
    IdProducto INT,
    Nombre VARCHAR(100),
    Precio DECIMAL(10,2),
    FechaEliminacion DATETIME,
    UsuarioBD VARCHAR(100)
);

CREATE TABLE BitacoraDDL(
    IdEvento INT IDENTITY PRIMARY KEY,
    EventoDDL VARCHAR(100),
    Objeto VARCHAR(200),
    FechaEvento DATETIME,
    UsuarioBD VARCHAR(100)
);
