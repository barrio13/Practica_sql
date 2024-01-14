CREATE TABLE bootcamp (
    bootcamp_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE alumno (
    alumno_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    bootcamp_id INT,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id)
);
ALTER TABLE alumno
ADD CONSTRAINT unique_email UNIQUE (email);

CREATE TABLE profesor (
    profesor_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE modulo (
    modulo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    horas INT
);

CREATE TABLE boot_mod (
    boot_mod_id SERIAL PRIMARY KEY,
    bootcamp_id INT,
    modulo_id INT,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id),
    FOREIGN KEY (modulo_id) REFERENCES modulo(modulo_id),
   UNIQUE (bootcamp_id, modulo_id)
);

CREATE TABLE prof_mod (
    prof_mod_id SERIAL PRIMARY KEY,
    profesor_id INT,
    modulo_id INT,
    FOREIGN KEY (profesor_id) REFERENCES profesor(profesor_id),
    FOREIGN KEY (modulo_id) REFERENCES modulo(modulo_id),
   UNIQUE (profesor_id, modulo_id)
);


INSERT INTO profesor (nombre, apellido, email, telefono)
VALUES 
    ('Juan Luis', 'Garcia', 'jlgarcia@gmail.com', 1112223333),
    ('Pedro', 'Lopez', 'plopez@gmail.com', 4445556666),
    ('Alonso', 'Fernandez', 'afernandez@gmail.com', 7778889999),
    ('Mario', 'Corral', 'mcorral@gmail.com', 2223334444);

INSERT INTO bootcamp (nombre)
VALUES 
    ('Big Data'),
    ('Inteligencia Artificial'),
    ('Ciberseguridad'),
    ('Marketing Digital');
    
INSERT INTO alumno (nombre, apellido, email, telefono,bootcamp_id)
VALUES 
    ('Juan', 'PÃ©rez', 'juan.perez@gmail.com', 1234567890,1),
    ('MarÃ­a', 'GÃ³mez', 'maria.gomez@gmail.com', 9876543210,1),
    ('Carlos', 'LÃ³pez', 'carlos.lopez@gmail.com', 1112223333,3),
    ('Ana', 'MartÃ­nez', 'ana.martinez@gmail.com', 5556667777,2),
    ('Pedro', 'SÃ¡nchez', 'pedro.sanchez@gmail.com', 9998887777,2),
    ('Laura', 'RodrÃ­guez', 'laura.rodriguez@gmail.com', 4443332222,4),
    ('Sergio', 'HernÃ¡ndez', 'sergio.hernandez@gmail.com', 7778889999,1),
    ('Isabel', 'DÃ­az', 'isabel.diaz@gmail.com', 2221110000,4),
    ('Daniel', 'GarcÃ­a', 'daniel.garcia@gmail.com', 3334445555,3),
    ('Elena', 'FernÃ¡ndez', 'elena.fernandez@gmail.com', 6665554444,2);

INSERT INTO modulo (nombre, horas)
VALUES 
    ('Python', 12),
    ('SQL',18),
    ('MatemÃ¡ticas',12),
    ('ProgramaciÃ³n 101', 8),
    ('Docker', 12),
    ('Spark',10);

INSERT INTO boot_mod (bootcamp_id, modulo_id)
VALUES 
    (1,2),
    (1,3),
    (2,6),
    (2,5),
    (3,3),
    (3,4),
    (4,2),
    (4,1);
    
INSERT INTO prof_mod (profesor_id, modulo_id)
VALUES 
    (2,2),
    (2,3),
    (1,6),
    (1,5),
    (4,3),
    (4,4),
    (3,2),
    (3,1);