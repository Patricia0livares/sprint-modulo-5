#Deben crear un usuario con privilegios para crear, eliminar y modificar tablas, insertar registros.
#TeLoVendo
#Tabla proveedores para comercializarlos.
#nombre del representante legal, su nombre corporativo, al menos dos teléfonos de contacto
# (y el nombre de quien recibe las llamadas),
#la categoría de sus productos (solo nos pueden indicar una categoría)
#y un correo electrónico para enviar la factura.
#Sabemos que la mayoría de los proveedores son de productos electrónicos. 
#Agregue 5 proveedores
#Tabla clientes, ingresemos solo 5 
#un nombre, apellido, dirección (solo pueden ingresar una).
#Tabla productos, Ingrese 10 productos
#y su respectivo stock, precio, su categoría, proveedor y color

#1 Cuál es la categoría de productos que más se repite.
#2 Cuáles son los productos con mayor stock
#3  Qué color de producto es más común en nuestra tienda.
#4 Cual o cuales son los proveedores con menor stock de productos.
#5 Por último: Cambien categoría de productos más popular por ‘Electrónica y computación’.

CREATE SCHEMA telovendo2;

CREATE USER 'telovender' IDENTIFIED BY '123456';
GRANT INSERT, UPDATE , DELETE, SELECT, CREATE ON telovendo2.* TO 'telovender'
WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE DATABASE telovendo2;
USE telovendo2;

#Tabla proveedores para comercializarlos.
#nombre del representante legal, su nombre corporativo, al menos dos teléfonos de contacto
# (y el nombre de quien recibe las llamadas),
#la categoría de sus productos (solo nos pueden indicar una categoría)
#y un correo electrónico para enviar la factura.
#Sabemos que la mayoría de los proveedores son de productos electrónicos. 
#Agregue 5 proveedores

CREATE TABLE proveedores (
	id_proveedor int primary key not null auto_increment,
	representante_legal varchar(50) not null,
    razon_social varchar (40),
    telefono1 varchar (40),
    telefono2 varchar (40),
    nom_contacto varchar (50),
	categoria_producto varchar (50),
    email varchar (50),
    UNIQUE KEY (id_proveedor,categoria_producto));
    
INSERT INTO proveedores (representante_legal, razon_social, telefono1, telefono2, nom_contacto, categoria_producto, email) VALUES
('Mario Soto', 'Sony Ltda.', '123456','235698','Pablo Marmol','Televisores','sony@sony.cl'),
('Pedro Romo', 'Aiwa Ltda.', '222333','741085','Pedro Picapiedra','Parlantes','aiwa@aiwa.cl'),
('Juan Lira', 'LG Ltda.', '333444','268415','Peter Parker','Televisores','lg@lg.cl'),
('Santiago Vicencio', 'Samsung Ltda.', '555689','458965','Louse Lane','Telefonia','samsung@samsumg.cl'),
('Roberto Zapata', 'Panasonic Ltda.', '789456','158469','Clark Kent','Audifonos','panasonic@panasonic.cl');

#Tabla clientes, ingresemos solo 5 
#un nombre, apellido, dirección (solo pueden ingresar una).

CREATE TABLE cliente (
	id_cliente int primary key not null auto_increment,
    nombre varchar (30),
    apellido varchar (30),
    direccion varchar (60)
);

INSERT INTO cliente (nombre, apellido, direccion) VALUES
('Elena', 'Bello', 'Los Puentes 33'),
('Alba', 'Prado', 'Los Puentes 26'),
('Susan', 'Pozo', 'Los Puentes 45'),
('Carla', 'Castillo', 'Los Puentes 56'),
('Karem', 'Torreblanca', 'Los Puentes 88');

#Tabla productos, Ingrese 10 productos
#y su respectivo stock, precio, su categoría, proveedor y color

CREATE TABLE producto (
	id_producto int not null auto_increment,
    stock int not null,
    precio int not null,
    categoria_producto varchar (50),
    id_proveedor int,
    color varchar(50),
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_proveedor,categoria_producto) 
    REFERENCES proveedores (id_proveedor, categoria_producto) on update cascade);
              
INSERT INTO producto (stock, precio, categoria_producto, id_proveedor, color) VALUES
(1000,100000,'Televisores',1,'Rojo'),
(1000,200000,'Televisores',1,'Negro'),
(1000,300000,'Televisores',1,'Azul'),
(500,100000,'Televisores',3,'Gris'),
(500,200000,'Televisores',3,'Verde'),
(500,300000,'Televisores',3,'Lila'),
(100,100000,'Telefonia',4,'Rojo'),
(5000,50000,'Audifonos',5,'Rojo'),
(6000,100000,'Parlantes',2,'Amarillo'),
(8000,150000,'Parlantes',2,'Naranja');

#1 Cuál es la categoría de productos que más se repite.

SELECT MAX(categoria_producto) FROM producto;

#2 Cuáles son los productos con mayor stock

SELECT categoria_producto, stock
FROM producto
WHERE stock = (SELECT MAX(stock) FROM producto);

#3  Qué color de producto es más común en nuestra tienda.

SELECT color, count(*) cantidad FROM producto
group by color;

With ProductoColor as(Select color, count(*) cantidad from producto
group by color)
Select color as Color_Favorito, max(cantidad) as Total_Favorito from ProductoColor;

#4 Cual o cuales son los proveedores con menor stock de productos.

SELECT p.razon_social, a.id_proveedor, a.categoria_producto, a.stock
FROM producto AS a
INNER JOIN proveedores AS p
ON		   p.id_proveedor = a.id_proveedor
WHERE stock = (SELECT MIN(stock) FROM producto);

#5 Por último: Cambien categoría de productos más popular por ‘Electrónica y computación’.
# Se hace en cascada ya que tabla proveedor y producto tienen el mismo campo de categoria de producto
SET SQL_SAFE_UPDATES = 0;

UPDATE proveedores SET categoria_producto= 'Electrónica y computación'
WHERE categoria_producto = 'Televisores';

SELECT * FROM producto;
SELECT * FROM proveedores;
