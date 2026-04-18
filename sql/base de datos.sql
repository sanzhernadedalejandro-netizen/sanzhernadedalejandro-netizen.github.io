CREATE DATABASE proyectp_roll;
USE proyectp_roll;


-- TABLAS DE CATÁLOGO


CREATE TABLE razas (
    id_raza INT AUTO_INCREMENT PRIMARY KEY,
    nombre  VARCHAR(100) NOT NULL
);

CREATE TABLE clases (
    id_clase INT AUTO_INCREMENT PRIMARY KEY,
    nombre   VARCHAR(100) NOT NULL
);

CREATE TABLE trasfondos (
    id_trasfondo INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL
);

CREATE TABLE personalidad (
    id_alineamiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL
);

-- Razas
INSERT INTO razas (nombre) VALUES
('Humano'),
('Elfo del bosque'),
('Elfo alto'),
('Drow'),
('Enano de las colinas'),
('Enano de la montaña'),
('Halfling pie alegre'),
('Halfling robusto'),
('Gnomo de las rocas'),
('Gnomo del bosque'),
('Semielfo'),
('Semiorco'),
('Tiefling'),
('Dracónido'),
('Aasimar'),
('Firbolg'),
('Goliath'),
('Tabaxi'),
('Tritón'),
('Warforged');

-- Clases 
INSERT INTO clases (nombre) VALUES
('Bárbaro'),
('Bardo'),
('Clérigo'),
('Druida'),
('Guerrero'),
('Monje'),
('Paladín'),
('Explorador'),
('Pillo'),
('Hechicero'),
('Brujo'),
('Mago'),
('Artificero');

-- Trasfondos D&D 
INSERT INTO trasfondos (nombre) VALUES
('Acólito'),
('Artesano de gremio'),
('Charlatán'),
('Criminal'),
('Ermitaño'),
('Forastero'),
('Héroe del pueblo'),
('Marinero'),
('Noble'),
('Sabio'),
('Soldado'),
('Vagabundo');

-- personalidad 
INSERT INTO personalidad (nombre) VALUES
('Legal bueno'),
('Neutral bueno'),
('Caótico bueno'),
('Legal neutral'),
('Neutral'),
('Caótico neutral'),
('Legal malvado'),
('Neutral malvado'),
('Caótico malvado');


-- USUARIOS


CREATE TABLE usuario (
    idUsuario      INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    correo         VARCHAR(100) NOT NULL UNIQUE,
    estado         ENUM('activo', 'inactivo') DEFAULT 'inactivo',
    Imagen         LONGBLOB,           -- sin NOT NULL para permitir registro sin foto
    tipo_mimo      VARCHAR(100),
    tamano_bytes   BIGINT,
    contrasena     VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- PARTIDAS


CREATE TABLE partidas (
    id_partida       INT AUTO_INCREMENT PRIMARY KEY,
    nom_campana      VARCHAR(100) NOT NULL,
    descripcion      TEXT,
    numero_jugadores INT DEFAULT 0,
    max_jugadores    INT DEFAULT 6,
    estado           ENUM('en_espera', 'en_curso', 'terminada') DEFAULT 'en_espera',
    codigo_acceso    VARCHAR(20),
    fecha_creacion   DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- RELACIÓN USUARIO - PARTIDAS


CREATE TABLE usuario_partidas (
    id_usuario INT NOT NULL,
    id_partida INT NOT NULL,
    PRIMARY KEY (id_usuario, id_partida),
    FOREIGN KEY (id_usuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (id_partida) REFERENCES partidas(id_partida)
);


-- JUGADORES


CREATE TABLE jugador (
    id_jugador      INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT NOT NULL,
    id_partida      INT NOT NULL,
    tipo_jugador    ENUM('master', 'jugador') NOT NULL,
    estado_conexion ENUM('conectado', 'desconectado') DEFAULT 'desconectado',
    FOREIGN KEY (id_usuario) REFERENCES usuario(idUsuario),
    FOREIGN KEY (id_partida) REFERENCES partidas(id_partida)
);
CREATE TABLE personaje (
    id_personaje    INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,

    -- Catálogos
    id_raza         INT,
    id_clase        INT,
    subclase        VARCHAR(100),
    id_trasfondo    INT,
    id_alineamiento INT,

    -- Progresión
    nivel           INT DEFAULT 1,
    experiencia     INT DEFAULT 0,

    -- Las 6 características base 
    fuerza          INT DEFAULT 10,
    destreza        INT DEFAULT 10,
    constitucion    INT DEFAULT 10,
    inteligencia    INT DEFAULT 10,
    sabiduria       INT DEFAULT 10,
    carisma         INT DEFAULT 10,

    -- Combate
    vida_maxima       INT DEFAULT 0,
    vida_actual       INT DEFAULT 0,
    clase_armadura    INT DEFAULT 10,
    velocidad         INT DEFAULT 30,
    bonus_competencia INT DEFAULT 2,

    -- Imagen
    ImagenPJ     LONGBLOB,
    tipo_mimo    VARCHAR(100),
    tamano_bytes BIGINT,

    -- Notas
    descripcion  TEXT,
    notas        TEXT,

    id_jugador   INT NOT NULL,

    FOREIGN KEY (id_raza)         REFERENCES razas(id_raza),
    FOREIGN KEY (id_clase)        REFERENCES clases(id_clase),
    FOREIGN KEY (id_trasfondo)    REFERENCES trasfondos(id_trasfondo),
    FOREIGN KEY (id_alineamiento) REFERENCES alineamientos(id_alineamiento),
    FOREIGN KEY (id_jugador)      REFERENCES jugador(id_jugador)
);


-- INVENTARIO


CREATE TABLE inventario (
    id_objeto    INT AUTO_INCREMENT PRIMARY KEY,
    id_personaje INT NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  TEXT,
    cantidad     INT DEFAULT 1,
    peso         DECIMAL(5,2) DEFAULT 0,
    equipado     TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id_personaje) REFERENCES personaje(id_personaje)
);


-- HECHIZOS DEL PERSONAJE



CREATE TABLE hechizos_personaje (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    id_personaje  INT NOT NULL,
    nombre        VARCHAR(100) NOT NULL,
    nivel_hechizo INT DEFAULT 0,   -- 0 = truco, 1-9 = nivel del hechizo
    preparado     TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id_personaje) REFERENCES personaje(id_personaje)
);


-- HISTORIAL DE TIRADAS


CREATE TABLE tiradas (
    id_tirada    INT AUTO_INCREMENT PRIMARY KEY,
    id_partida   INT NOT NULL,
    id_jugador   INT NOT NULL,
    id_personaje INT,
    tipo_dado    ENUM('d4','d6','d8','d10','d12','d20','d100') NOT NULL,
    resultado    INT NOT NULL,
    motivo       VARCHAR(100),   -- Ataque 
    fecha        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_partida)   REFERENCES partidas(id_partida),
    FOREIGN KEY (id_jugador)   REFERENCES jugador(id_jugador),
    FOREIGN KEY (id_personaje) REFERENCES personaje(id_personaje)
);


-- CHAT / MENSAJES DE PARTIDA


CREATE TABLE mensajes (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    id_partida INT NOT NULL,
    id_jugador INT NOT NULL,
    mensaje    TEXT NOT NULL,
    tipo       ENUM('chat', 'sistema', 'tirada') DEFAULT 'chat',
    fecha      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_partida) REFERENCES partidas(id_partida),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador)
);
ALTER TABLE usuario ADD ultima_actividad DATETIME;
ALTER TABLE usuario ADD token_verificacion VARCHAR(64),ADD token_expiracion DATETIME;