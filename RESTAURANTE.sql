CREATE TABLE CLIENTE(
	id INT PRIMARY KEY,
	nombre VARCHAR(25),
	correo VARCHAR(50),
	direccion VARCHAR(50)
);

CREATE TABLE RESTAURANTE(
	id INT PRIMARY KEY,
	nombre VARCHAR(25),
	direccion VARCHAR(25)
);

CREATE TABLE INGREDIENTE(
	id INT PRIMARY KEY,
	nombre VARCHAR(25)
);

CREATE TABLE MENU(
	id INT PRIMARY KEY,
	nombre VARCHAR(25),
	estacion VARCHAR(25)
);

CREATE TABLE POSTRE(
	id INT PRIMARY KEY,
	nombre VARCHAR(25),
	precio FLOAT
);

CREATE TABLE PLATO(
	id INT PRIMARY KEY,
	nombre VARCHAR(25),
	precio FLOAT,
	id_menu INT
);

CREATE TABLE PLATOXINGREDIENTE(
	id_ingrediente INT NOT NULL,
	id_plato INT NOT NULL
);

CREATE TABLE FACTURA(
	id INT PRIMARY KEY,
	fecha DATE,
	id_cliente INT,
	id_restaurante INT
);

CREATE TABLE DETALLE_PLATO(
	id_factura INT NOT NULL,
	id_plato INT NOT NULL
);

CREATE TABLE DETALLE_POSTRE(
	id_factura INT NOT NULL,
	id_postre INT NOT NULL
);
GO

ALTER TABLE PLATO ADD FOREIGN KEY (id_menu) REFERENCES MENU(id);
ALTER TABLE PLATOXINGREDIENTE ADD PRIMARY KEY(id_ingrediente, id_plato);
ALTER TABLE PLATOXINGREDIENTE ADD FOREIGN KEY (id_ingrediente) REFERENCES INGREDIENTE(id);
ALTER TABLE PLATOXINGREDIENTE ADD FOREIGN KEY (id_plato) REFERENCES PLATO(id);
ALTER TABLE FACTURA ADD FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id);
ALTER TABLE FACTURA ADD FOREIGN KEY (id_restaurante) REFERENCES RESTAURANTE(id);
ALTER TABLE DETALLE_PLATO ADD PRIMARY KEY(id_factura, id_plato);
ALTER TABLE DETALLE_PLATO ADD FOREIGN KEY (id_factura) REFERENCES FACTURA(id);
ALTER TABLE DETALLE_PLATO ADD FOREIGN KEY (id_plato) REFERENCES PLATO(id);
ALTER TABLE DETALLE_POSTRE ADD PRIMARY KEY(id_factura, id_postre);
ALTER TABLE DETALLE_POSTRE ADD FOREIGN KEY (id_factura) REFERENCES FACTURA(id);
ALTER TABLE DETALLE_POSTRE ADD FOREIGN KEY (id_postre) REFERENCES POSTRE(id);
GO

INSERT INTO CLIENTE VALUES(1,'Lacy Villarreal','adipiscing.Mauris.molestie@ipsumSuspendisse.com','756-7144 Magna Road');
INSERT INTO CLIENTE VALUES(2,'Uriah Vasquez','in@enimdiam.com','473-9038 Tellus Street');
INSERT INTO CLIENTE VALUES(3,'Clementine Clarke','erat.semper@quisurnaNunc.com','6792 Etiam Rd.');
INSERT INTO CLIENTE VALUES(4,'Amal Rose','a.feugiat@nibh.org','188 Ullamcorper, Avenue');
INSERT INTO CLIENTE VALUES(5,'Rebecca Good','enim.non.nisi@ettristiquepellentesque.edu','P.O. Box 771, 5130 Dictum Avenue');
INSERT INTO CLIENTE VALUES(6,'Alexis Sparks','amet.ornare.lectus@magnaSuspendisse.edu','6439 Lobortis, Av.');
INSERT INTO CLIENTE VALUES(7,'James Brown','pede.et@eget.edu','P.O. Box 211, 8467 Ipsum. Street');
INSERT INTO CLIENTE VALUES(8,'Neville Spears','est.ac.mattis@dapibusligula.org','943-9816 Congue. Av.');
INSERT INTO CLIENTE VALUES(9,'Maia Kidd','varius.Nam@Aeneaneget.co.uk','1225 Sed Rd.');
INSERT INTO CLIENTE VALUES(10,'Caldwell Webster','lectus.rutrum@lectuspede.edu','P.O. Box 467, 717 Fringilla Road');
INSERT INTO CLIENTE VALUES(11,'Emery Rodgers','consequat.auctor.nunc@vehicula.co.uk','P.O. Box 245, 3374 Nulla. St.');
INSERT INTO CLIENTE VALUES(12,'Iliana Hughes','sit@molestie.co.uk','P.O. Box 912, 5172 Eu Avenue');
INSERT INTO CLIENTE VALUES(13,'Flavia Michael','ultricies.ornare.elit@magnaUttincidunt.ca','Ap #324-6325 Lacinia Rd.');
INSERT INTO CLIENTE VALUES(14,'Kareem Colon','interdum.Sed@ipsumnonarcu.co.uk','4859 Pretium Rd.');
INSERT INTO CLIENTE VALUES(15,'Jena Holder','tempor.lorem.eget@dictumeu.co.uk','399 Vivamus Rd.');
INSERT INTO CLIENTE VALUES(16,'Mallory Barrett','purus.Nullam.scelerisque@nonmassanon.com','P.O. Box 943, 3608 Amet St.');
INSERT INTO CLIENTE VALUES(17,'Kevyn Thornton','ut.erat@vulputate.edu','434-355 Arcu St.');
INSERT INTO CLIENTE VALUES(18,'Palmer Noble','eu@enim.ca','Ap #312-7714 In Rd.');
INSERT INTO CLIENTE VALUES(19,'Lysandra Barker','id@neceleifend.com','2969 Ad Rd.');
INSERT INTO CLIENTE VALUES(20,'Scott Cooley','commodo.ipsum.Suspendisse@faucibus.net','545 Volutpat St.');

INSERT INTO RESTAURANTE VALUES(1,'mauris','7501 Semper. St.');
INSERT INTO RESTAURANTE VALUES(2,'conubia','5499 At, Ave');
INSERT INTO RESTAURANTE VALUES(3,'dolor sit amet,','1831 Blandit Ave');
INSERT INTO RESTAURANTE VALUES(4,'Aliquam gravida mauris','998-6670 Ac, Avenue');
INSERT INTO RESTAURANTE VALUES(5,'id nunc interdum','P.O. Box 534, 6971');

INSERT INTO INGREDIENTE VALUES(1,'amet,');
INSERT INTO INGREDIENTE VALUES(2,'Duis elementum,');
INSERT INTO INGREDIENTE VALUES(3,'non dui');
INSERT INTO INGREDIENTE VALUES(4,'consectetuer adipiscing.');
INSERT INTO INGREDIENTE VALUES(5,'Fusce aliquet');
INSERT INTO INGREDIENTE VALUES(6,'enim,');
INSERT INTO INGREDIENTE VALUES(7,'laoreet, libero et');
INSERT INTO INGREDIENTE VALUES(8,'In ornare sagittis');
INSERT INTO INGREDIENTE VALUES(9,'diam. Sed diam');
INSERT INTO INGREDIENTE VALUES(10,'Nullam scelerisque neque');
INSERT INTO INGREDIENTE VALUES(11,'felis');
INSERT INTO INGREDIENTE VALUES(12,'eu lacus.');
INSERT INTO INGREDIENTE VALUES(13,'mauris.');
INSERT INTO INGREDIENTE VALUES(14,'ac mattis');
INSERT INTO INGREDIENTE VALUES(15,'posuere vulputate.');

INSERT INTO MENU VALUES(1,'non,','primavera');
INSERT INTO MENU VALUES(2,'posuere cubilia','otoño');
INSERT INTO MENU VALUES(3,'sed','verano');
INSERT INTO MENU VALUES(4,'egestas','invierno');

INSERT INTO POSTRE VALUES(1,'et',3.15);
INSERT INTO POSTRE VALUES(2,'sem, vitae aliquam',10.44);
INSERT INTO POSTRE VALUES(3,'dolor.',3.42);
INSERT INTO POSTRE VALUES(4,'pede. Cum sociis',5.35);
INSERT INTO POSTRE VALUES(5,'habitant morbi',9.04);
INSERT INTO POSTRE VALUES(6,'venenatis vel,',5.66);
INSERT INTO POSTRE VALUES(7,'lacinia mattis.',14.60);
INSERT INTO POSTRE VALUES(8,'dignissim tempor',4.67);
INSERT INTO POSTRE VALUES(9,'venenatis',4.71);
INSERT INTO POSTRE VALUES(10,'nibh',5.56);

INSERT INTO PLATO VALUES(1,'libero dui',4.41,1);
INSERT INTO PLATO VALUES(2,'non quam.',9.77,1);
INSERT INTO PLATO VALUES(3,'neque.',8.14,1);
INSERT INTO PLATO VALUES(4,'pede blandit',4.37,1);
INSERT INTO PLATO VALUES(5,'nulla at',9.04,1);
INSERT INTO PLATO VALUES(6,'dui,',12.20,2);
INSERT INTO PLATO VALUES(7,'quam quis diam.',10.52,2);
INSERT INTO PLATO VALUES(8,'elementum, lorem ut',7.43,2);
INSERT INTO PLATO VALUES(9,'Sed malesuada augue',8.63,2);
INSERT INTO PLATO VALUES(10,'ridiculus',3.44,2);
INSERT INTO PLATO VALUES(11,'risus',5.31,3);
INSERT INTO PLATO VALUES(12,'Quisque libero',6.63,3);
INSERT INTO PLATO VALUES(13,'enim, gravida sit',15.59,3);
INSERT INTO PLATO VALUES(14,'quis, tristique',9.76,3);
INSERT INTO PLATO VALUES(15,'arcu.',7.36,3);
INSERT INTO PLATO VALUES(16,'Nunc ullamcorper,',5.69,4);
INSERT INTO PLATO VALUES(17,'Curae; Phasellus',7.17,4);
INSERT INTO PLATO VALUES(18,'massa. Mauris',13.58,4);
INSERT INTO PLATO VALUES(19,'feugiat lobortis',8.56,4);
INSERT INTO PLATO VALUES(20,'aliquet.',8.04,4);

INSERT INTO PLATOXINGREDIENTE VALUES(8,1);
INSERT INTO PLATOXINGREDIENTE VALUES(12,15);
INSERT INTO PLATOXINGREDIENTE VALUES(2,2);
INSERT INTO PLATOXINGREDIENTE VALUES(1,8);
INSERT INTO PLATOXINGREDIENTE VALUES(11,1);
INSERT INTO PLATOXINGREDIENTE VALUES(1,1);
INSERT INTO PLATOXINGREDIENTE VALUES(9,17);
INSERT INTO PLATOXINGREDIENTE VALUES(10,1);
INSERT INTO PLATOXINGREDIENTE VALUES(2,7);
INSERT INTO PLATOXINGREDIENTE VALUES(7,6);
INSERT INTO PLATOXINGREDIENTE VALUES(13,1);
INSERT INTO PLATOXINGREDIENTE VALUES(12,18);
INSERT INTO PLATOXINGREDIENTE VALUES(1,19);
INSERT INTO PLATOXINGREDIENTE VALUES(5,9);
INSERT INTO PLATOXINGREDIENTE VALUES(5,17);
INSERT INTO PLATOXINGREDIENTE VALUES(13,12);
INSERT INTO PLATOXINGREDIENTE VALUES(3,9);
INSERT INTO PLATOXINGREDIENTE VALUES(14,15);
INSERT INTO PLATOXINGREDIENTE VALUES(6,3);
INSERT INTO PLATOXINGREDIENTE VALUES(11,5);
INSERT INTO PLATOXINGREDIENTE VALUES(14,11);
INSERT INTO PLATOXINGREDIENTE VALUES(2,19);
INSERT INTO PLATOXINGREDIENTE VALUES(7,19);
INSERT INTO PLATOXINGREDIENTE VALUES(8,2);
INSERT INTO PLATOXINGREDIENTE VALUES(3,15);
INSERT INTO PLATOXINGREDIENTE VALUES(1,11);
INSERT INTO PLATOXINGREDIENTE VALUES(11,4);
INSERT INTO PLATOXINGREDIENTE VALUES(9,9);
INSERT INTO PLATOXINGREDIENTE VALUES(1,4);
INSERT INTO PLATOXINGREDIENTE VALUES(6,15);
INSERT INTO PLATOXINGREDIENTE VALUES(12,5);
INSERT INTO PLATOXINGREDIENTE VALUES(2,9);
INSERT INTO PLATOXINGREDIENTE VALUES(13,5);
INSERT INTO PLATOXINGREDIENTE VALUES(9,8);
INSERT INTO PLATOXINGREDIENTE VALUES(7,15);
INSERT INTO PLATOXINGREDIENTE VALUES(15,13);
INSERT INTO PLATOXINGREDIENTE VALUES(1,16);
INSERT INTO PLATOXINGREDIENTE VALUES(10,18);
INSERT INTO PLATOXINGREDIENTE VALUES(2,18);
INSERT INTO PLATOXINGREDIENTE VALUES(3,8);
INSERT INTO PLATOXINGREDIENTE VALUES(3,1);
INSERT INTO PLATOXINGREDIENTE VALUES(11,9);
INSERT INTO PLATOXINGREDIENTE VALUES(9,18);
INSERT INTO PLATOXINGREDIENTE VALUES(2,8);
INSERT INTO PLATOXINGREDIENTE VALUES(8,19);
INSERT INTO PLATOXINGREDIENTE VALUES(7,10);
INSERT INTO PLATOXINGREDIENTE VALUES(6,12);
INSERT INTO PLATOXINGREDIENTE VALUES(12,6);
INSERT INTO PLATOXINGREDIENTE VALUES(11,2);
INSERT INTO PLATOXINGREDIENTE VALUES(10,11);
INSERT INTO PLATOXINGREDIENTE VALUES(14,14);
INSERT INTO PLATOXINGREDIENTE VALUES(7,12);
INSERT INTO PLATOXINGREDIENTE VALUES(8,11);
INSERT INTO PLATOXINGREDIENTE VALUES(13,15);
INSERT INTO PLATOXINGREDIENTE VALUES(11,20);
INSERT INTO PLATOXINGREDIENTE VALUES(10,3);
INSERT INTO PLATOXINGREDIENTE VALUES(3,11);
INSERT INTO PLATOXINGREDIENTE VALUES(9,4);
INSERT INTO PLATOXINGREDIENTE VALUES(4,7);
INSERT INTO PLATOXINGREDIENTE VALUES(5,6);
INSERT INTO PLATOXINGREDIENTE VALUES(6,19);
INSERT INTO PLATOXINGREDIENTE VALUES(8,18);
INSERT INTO PLATOXINGREDIENTE VALUES(6,20);
INSERT INTO PLATOXINGREDIENTE VALUES(5,10);
INSERT INTO PLATOXINGREDIENTE VALUES(8,20);
INSERT INTO PLATOXINGREDIENTE VALUES(15,19);
INSERT INTO PLATOXINGREDIENTE VALUES(13,16);
INSERT INTO PLATOXINGREDIENTE VALUES(9,3);
INSERT INTO PLATOXINGREDIENTE VALUES(7,2);
INSERT INTO PLATOXINGREDIENTE VALUES(2,16);
INSERT INTO PLATOXINGREDIENTE VALUES(7,18);
INSERT INTO PLATOXINGREDIENTE VALUES(11,16);
INSERT INTO PLATOXINGREDIENTE VALUES(4,15);
INSERT INTO PLATOXINGREDIENTE VALUES(6,9);
INSERT INTO PLATOXINGREDIENTE VALUES(7,20);
INSERT INTO PLATOXINGREDIENTE VALUES(9,13);
INSERT INTO PLATOXINGREDIENTE VALUES(10,10);
INSERT INTO PLATOXINGREDIENTE VALUES(13,4);
INSERT INTO PLATOXINGREDIENTE VALUES(1,14);
INSERT INTO PLATOXINGREDIENTE VALUES(10,20);
INSERT INTO PLATOXINGREDIENTE VALUES(15,20);
INSERT INTO PLATOXINGREDIENTE VALUES(4,11);
INSERT INTO PLATOXINGREDIENTE VALUES(3,4);
INSERT INTO PLATOXINGREDIENTE VALUES(4,16);
INSERT INTO PLATOXINGREDIENTE VALUES(12,9);
INSERT INTO PLATOXINGREDIENTE VALUES(15,10);
INSERT INTO PLATOXINGREDIENTE VALUES(4,20);
INSERT INTO PLATOXINGREDIENTE VALUES(13,3);
INSERT INTO PLATOXINGREDIENTE VALUES(10,9);
INSERT INTO PLATOXINGREDIENTE VALUES(13,6);
INSERT INTO PLATOXINGREDIENTE VALUES(1,15);
INSERT INTO PLATOXINGREDIENTE VALUES(12,10);
INSERT INTO PLATOXINGREDIENTE VALUES(3,12);
INSERT INTO PLATOXINGREDIENTE VALUES(10,13);
INSERT INTO PLATOXINGREDIENTE VALUES(4,5);
INSERT INTO PLATOXINGREDIENTE VALUES(1,13);
INSERT INTO PLATOXINGREDIENTE VALUES(6,16);
INSERT INTO PLATOXINGREDIENTE VALUES(1,7);
INSERT INTO PLATOXINGREDIENTE VALUES(8,12);

INSERT INTO FACTURA VALUES(1,CONVERT(DATE,'11/04/2022',103), 2,5);
INSERT INTO FACTURA VALUES(2,CONVERT(DATE,'25/06/2022',103), 10,1);
INSERT INTO FACTURA VALUES(3,CONVERT(DATE,'15/02/2022',103), 13,5);
INSERT INTO FACTURA VALUES(4,CONVERT(DATE,'31/01/2022',103), 3,2);
INSERT INTO FACTURA VALUES(5,CONVERT(DATE,'10/05/2022',103), 5,5);
INSERT INTO FACTURA VALUES(6,CONVERT(DATE,'06/01/2022',103), 3,5);
INSERT INTO FACTURA VALUES(7,CONVERT(DATE,'08/02/2022',103), 6,4);
INSERT INTO FACTURA VALUES(8,CONVERT(DATE,'26/06/2022',103), 18,2);
INSERT INTO FACTURA VALUES(9,CONVERT(DATE,'25/02/2022',103), 18,3);
INSERT INTO FACTURA VALUES(10,CONVERT(DATE,'30/06/2022',103), 9,2);
INSERT INTO FACTURA VALUES(11,CONVERT(DATE,'22/04/2022',103), 18,1);
INSERT INTO FACTURA VALUES(12,CONVERT(DATE,'30/05/2022',103), 14,2);
INSERT INTO FACTURA VALUES(13,CONVERT(DATE,'28/02/2022',103), 20,1);
INSERT INTO FACTURA VALUES(14,CONVERT(DATE,'07/02/2022',103), 18,4);
INSERT INTO FACTURA VALUES(15,CONVERT(DATE,'29/06/2022',103), 1,5);
INSERT INTO FACTURA VALUES(16,CONVERT(DATE,'12/03/2022',103), 11,4);
INSERT INTO FACTURA VALUES(17,CONVERT(DATE,'01/02/2022',103), 16,4);
INSERT INTO FACTURA VALUES(18,CONVERT(DATE,'03/03/2022',103), 8,4);
INSERT INTO FACTURA VALUES(19,CONVERT(DATE,'17/04/2022',103), 17,1);
INSERT INTO FACTURA VALUES(20,CONVERT(DATE,'07/01/2022',103), 15,1);
INSERT INTO FACTURA VALUES(21,CONVERT(DATE,'14/04/2022',103), 9,5);
INSERT INTO FACTURA VALUES(22,CONVERT(DATE,'15/05/2022',103), 1,2);
INSERT INTO FACTURA VALUES(23,CONVERT(DATE,'06/02/2022',103), 5,1);
INSERT INTO FACTURA VALUES(24,CONVERT(DATE,'26/02/2022',103), 12,2);
INSERT INTO FACTURA VALUES(25,CONVERT(DATE,'03/01/2022',103), 9,4);
INSERT INTO FACTURA VALUES(26,CONVERT(DATE,'03/02/2022',103), 15,1);
INSERT INTO FACTURA VALUES(27,CONVERT(DATE,'25/02/2022',103), 14,1);
INSERT INTO FACTURA VALUES(28,CONVERT(DATE,'11/01/2022',103), 10,3);
INSERT INTO FACTURA VALUES(29,CONVERT(DATE,'27/01/2022',103), 2,2);
INSERT INTO FACTURA VALUES(30,CONVERT(DATE,'29/06/2022',103), 3,4);


INSERT INTO DETALLE_PLATO VALUES(1,9);
INSERT INTO DETALLE_PLATO VALUES(1,8);
INSERT INTO DETALLE_PLATO VALUES(1,11);
INSERT INTO DETALLE_PLATO VALUES(1,13);
INSERT INTO DETALLE_PLATO VALUES(1,3);
INSERT INTO DETALLE_PLATO VALUES(2,9);
INSERT INTO DETALLE_PLATO VALUES(2,4);
INSERT INTO DETALLE_PLATO VALUES(2,18);
INSERT INTO DETALLE_PLATO VALUES(2,17);
INSERT INTO DETALLE_PLATO VALUES(2,20);
INSERT INTO DETALLE_PLATO VALUES(2,3);
INSERT INTO DETALLE_PLATO VALUES(2,14);
INSERT INTO DETALLE_PLATO VALUES(2,19);
INSERT INTO DETALLE_PLATO VALUES(3,9);
INSERT INTO DETALLE_PLATO VALUES(3,18);
INSERT INTO DETALLE_PLATO VALUES(3,3);
INSERT INTO DETALLE_PLATO VALUES(3,5);
INSERT INTO DETALLE_PLATO VALUES(4,1);
INSERT INTO DETALLE_PLATO VALUES(4,13);
INSERT INTO DETALLE_PLATO VALUES(4,14);
INSERT INTO DETALLE_PLATO VALUES(5,11);
INSERT INTO DETALLE_PLATO VALUES(5,10);
INSERT INTO DETALLE_PLATO VALUES(5,5);
INSERT INTO DETALLE_PLATO VALUES(5,1);
INSERT INTO DETALLE_PLATO VALUES(6,16);
INSERT INTO DETALLE_PLATO VALUES(6,8);
INSERT INTO DETALLE_PLATO VALUES(6,9);
INSERT INTO DETALLE_PLATO VALUES(6,19);
INSERT INTO DETALLE_PLATO VALUES(6,13);
INSERT INTO DETALLE_PLATO VALUES(6,1);
INSERT INTO DETALLE_PLATO VALUES(7,15);
INSERT INTO DETALLE_PLATO VALUES(7,5);
INSERT INTO DETALLE_PLATO VALUES(8,13);
INSERT INTO DETALLE_PLATO VALUES(8,11);
INSERT INTO DETALLE_PLATO VALUES(8,1);
INSERT INTO DETALLE_PLATO VALUES(8,10);
INSERT INTO DETALLE_PLATO VALUES(8,16);
INSERT INTO DETALLE_PLATO VALUES(9,10);
INSERT INTO DETALLE_PLATO VALUES(9,12);
INSERT INTO DETALLE_PLATO VALUES(9,13);
INSERT INTO DETALLE_PLATO VALUES(9,9);
INSERT INTO DETALLE_PLATO VALUES(9,6);
INSERT INTO DETALLE_PLATO VALUES(10,3);
INSERT INTO DETALLE_PLATO VALUES(10,19);
INSERT INTO DETALLE_PLATO VALUES(10,14);
INSERT INTO DETALLE_PLATO VALUES(10,10);
INSERT INTO DETALLE_PLATO VALUES(10,5);
INSERT INTO DETALLE_PLATO VALUES(11,11);
INSERT INTO DETALLE_PLATO VALUES(11,10);
INSERT INTO DETALLE_PLATO VALUES(11,14);
INSERT INTO DETALLE_PLATO VALUES(12,17);
INSERT INTO DETALLE_PLATO VALUES(12,19);
INSERT INTO DETALLE_PLATO VALUES(12,18);
INSERT INTO DETALLE_PLATO VALUES(12,16);
INSERT INTO DETALLE_PLATO VALUES(12,14);
INSERT INTO DETALLE_PLATO VALUES(13,5);
INSERT INTO DETALLE_PLATO VALUES(13,14);
INSERT INTO DETALLE_PLATO VALUES(13,4);
INSERT INTO DETALLE_PLATO VALUES(14,17);
INSERT INTO DETALLE_PLATO VALUES(14,10);
INSERT INTO DETALLE_PLATO VALUES(14,19);
INSERT INTO DETALLE_PLATO VALUES(14,12);
INSERT INTO DETALLE_PLATO VALUES(15,13);
INSERT INTO DETALLE_PLATO VALUES(15,12);
INSERT INTO DETALLE_PLATO VALUES(15,19);
INSERT INTO DETALLE_PLATO VALUES(15,9);
INSERT INTO DETALLE_PLATO VALUES(15,4);
INSERT INTO DETALLE_PLATO VALUES(16,3);
INSERT INTO DETALLE_PLATO VALUES(16,8);
INSERT INTO DETALLE_PLATO VALUES(16,17);
INSERT INTO DETALLE_PLATO VALUES(16,7);
INSERT INTO DETALLE_PLATO VALUES(17,19);
INSERT INTO DETALLE_PLATO VALUES(17,14);
INSERT INTO DETALLE_PLATO VALUES(17,1);
INSERT INTO DETALLE_PLATO VALUES(17,4);
INSERT INTO DETALLE_PLATO VALUES(17,13);
INSERT INTO DETALLE_PLATO VALUES(18,14);
INSERT INTO DETALLE_PLATO VALUES(18,3);
INSERT INTO DETALLE_PLATO VALUES(18,2);
INSERT INTO DETALLE_PLATO VALUES(18,6);
INSERT INTO DETALLE_PLATO VALUES(18,18);
INSERT INTO DETALLE_PLATO VALUES(18,9);
INSERT INTO DETALLE_PLATO VALUES(18,17);
INSERT INTO DETALLE_PLATO VALUES(19,2);
INSERT INTO DETALLE_PLATO VALUES(19,1);
INSERT INTO DETALLE_PLATO VALUES(19,6);
INSERT INTO DETALLE_PLATO VALUES(19,11);
INSERT INTO DETALLE_PLATO VALUES(19,15);
INSERT INTO DETALLE_PLATO VALUES(19,7);
INSERT INTO DETALLE_PLATO VALUES(19,13);
INSERT INTO DETALLE_PLATO VALUES(19,8);
INSERT INTO DETALLE_PLATO VALUES(20,9);
INSERT INTO DETALLE_PLATO VALUES(20,13);
INSERT INTO DETALLE_PLATO VALUES(21,18);
INSERT INTO DETALLE_PLATO VALUES(21,20);
INSERT INTO DETALLE_PLATO VALUES(21,13);
INSERT INTO DETALLE_PLATO VALUES(21,14);
INSERT INTO DETALLE_PLATO VALUES(21,2);
INSERT INTO DETALLE_PLATO VALUES(21,17);
INSERT INTO DETALLE_PLATO VALUES(21,9);
INSERT INTO DETALLE_PLATO VALUES(21,4);
INSERT INTO DETALLE_PLATO VALUES(22,7);
INSERT INTO DETALLE_PLATO VALUES(22,18);
INSERT INTO DETALLE_PLATO VALUES(22,15);
INSERT INTO DETALLE_PLATO VALUES(23,12);
INSERT INTO DETALLE_PLATO VALUES(24,20);
INSERT INTO DETALLE_PLATO VALUES(24,16);
INSERT INTO DETALLE_PLATO VALUES(24,2);
INSERT INTO DETALLE_PLATO VALUES(25,13);
INSERT INTO DETALLE_PLATO VALUES(25,5);
INSERT INTO DETALLE_PLATO VALUES(25,16);
INSERT INTO DETALLE_PLATO VALUES(25,17);
INSERT INTO DETALLE_PLATO VALUES(25,6);
INSERT INTO DETALLE_PLATO VALUES(25,18);
INSERT INTO DETALLE_PLATO VALUES(26,13);
INSERT INTO DETALLE_PLATO VALUES(26,14);
INSERT INTO DETALLE_PLATO VALUES(26,2);
INSERT INTO DETALLE_PLATO VALUES(26,12);
INSERT INTO DETALLE_PLATO VALUES(26,11);
INSERT INTO DETALLE_PLATO VALUES(27,2);
INSERT INTO DETALLE_PLATO VALUES(27,13);
INSERT INTO DETALLE_PLATO VALUES(27,4);
INSERT INTO DETALLE_PLATO VALUES(27,3);
INSERT INTO DETALLE_PLATO VALUES(27,20);
INSERT INTO DETALLE_PLATO VALUES(27,1);
INSERT INTO DETALLE_PLATO VALUES(28,12);
INSERT INTO DETALLE_PLATO VALUES(28,16);
INSERT INTO DETALLE_PLATO VALUES(28,4);
INSERT INTO DETALLE_PLATO VALUES(28,5);
INSERT INTO DETALLE_PLATO VALUES(28,20);
INSERT INTO DETALLE_PLATO VALUES(28,18);
INSERT INTO DETALLE_PLATO VALUES(28,7);
INSERT INTO DETALLE_PLATO VALUES(28,9);
INSERT INTO DETALLE_PLATO VALUES(28,6);
INSERT INTO DETALLE_PLATO VALUES(28,10);
INSERT INTO DETALLE_PLATO VALUES(28,2);
INSERT INTO DETALLE_PLATO VALUES(28,11);
INSERT INTO DETALLE_PLATO VALUES(29,2);
INSERT INTO DETALLE_PLATO VALUES(29,3);
INSERT INTO DETALLE_PLATO VALUES(29,1);
INSERT INTO DETALLE_PLATO VALUES(29,17);
INSERT INTO DETALLE_PLATO VALUES(29,7);
INSERT INTO DETALLE_PLATO VALUES(29,10);
INSERT INTO DETALLE_PLATO VALUES(30,9);
INSERT INTO DETALLE_PLATO VALUES(30,15);
INSERT INTO DETALLE_PLATO VALUES(30,17);
INSERT INTO DETALLE_PLATO VALUES(30,12);
INSERT INTO DETALLE_PLATO VALUES(30,5);
INSERT INTO DETALLE_PLATO VALUES(30,2);
INSERT INTO DETALLE_PLATO VALUES(30,20);

INSERT INTO DETALLE_POSTRE VALUES(1,9);
INSERT INTO DETALLE_POSTRE VALUES(1,5);
INSERT INTO DETALLE_POSTRE VALUES(1,7);
INSERT INTO DETALLE_POSTRE VALUES(1,10);
INSERT INTO DETALLE_POSTRE VALUES(1,1);
INSERT INTO DETALLE_POSTRE VALUES(2,8);
INSERT INTO DETALLE_POSTRE VALUES(2,2);
INSERT INTO DETALLE_POSTRE VALUES(3,3);
INSERT INTO DETALLE_POSTRE VALUES(3,2);
INSERT INTO DETALLE_POSTRE VALUES(3,5);
INSERT INTO DETALLE_POSTRE VALUES(3,1);
INSERT INTO DETALLE_POSTRE VALUES(3,4);
INSERT INTO DETALLE_POSTRE VALUES(4,8);
INSERT INTO DETALLE_POSTRE VALUES(4,10);
INSERT INTO DETALLE_POSTRE VALUES(4,3);
INSERT INTO DETALLE_POSTRE VALUES(5,4);
INSERT INTO DETALLE_POSTRE VALUES(5,6);
INSERT INTO DETALLE_POSTRE VALUES(6,7);
INSERT INTO DETALLE_POSTRE VALUES(7,10);
INSERT INTO DETALLE_POSTRE VALUES(8,9);
INSERT INTO DETALLE_POSTRE VALUES(8,3);
INSERT INTO DETALLE_POSTRE VALUES(9,6);
INSERT INTO DETALLE_POSTRE VALUES(10,3);
INSERT INTO DETALLE_POSTRE VALUES(10,6);
INSERT INTO DETALLE_POSTRE VALUES(11,4);
INSERT INTO DETALLE_POSTRE VALUES(11,8);
INSERT INTO DETALLE_POSTRE VALUES(11,9);
INSERT INTO DETALLE_POSTRE VALUES(12,4);
INSERT INTO DETALLE_POSTRE VALUES(12,3);
INSERT INTO DETALLE_POSTRE VALUES(13,1);
INSERT INTO DETALLE_POSTRE VALUES(14,6);
INSERT INTO DETALLE_POSTRE VALUES(15,4);
INSERT INTO DETALLE_POSTRE VALUES(15,9);
INSERT INTO DETALLE_POSTRE VALUES(16,10);
INSERT INTO DETALLE_POSTRE VALUES(17,1);
INSERT INTO DETALLE_POSTRE VALUES(18,7);
INSERT INTO DETALLE_POSTRE VALUES(19,2);
INSERT INTO DETALLE_POSTRE VALUES(19,6);
INSERT INTO DETALLE_POSTRE VALUES(19,10);
INSERT INTO DETALLE_POSTRE VALUES(20,9);
INSERT INTO DETALLE_POSTRE VALUES(20,5);
INSERT INTO DETALLE_POSTRE VALUES(21,3);
INSERT INTO DETALLE_POSTRE VALUES(22,4);
INSERT INTO DETALLE_POSTRE VALUES(23,2);
INSERT INTO DETALLE_POSTRE VALUES(24,2);
INSERT INTO DETALLE_POSTRE VALUES(24,3);
INSERT INTO DETALLE_POSTRE VALUES(25,10);
INSERT INTO DETALLE_POSTRE VALUES(26,10);
INSERT INTO DETALLE_POSTRE VALUES(26,5);
INSERT INTO DETALLE_POSTRE VALUES(27,4);
INSERT INTO DETALLE_POSTRE VALUES(27,10);
INSERT INTO DETALLE_POSTRE VALUES(27,6);
INSERT INTO DETALLE_POSTRE VALUES(28,10);
INSERT INTO DETALLE_POSTRE VALUES(28,5);
INSERT INTO DETALLE_POSTRE VALUES(28,1);
INSERT INTO DETALLE_POSTRE VALUES(28,4);
INSERT INTO DETALLE_POSTRE VALUES(29,1);
INSERT INTO DETALLE_POSTRE VALUES(30,3);
INSERT INTO DETALLE_POSTRE VALUES(30,4);