-- =====================================================================
-- EFT Semana 9 - PRY2204 Modelamiento de Bases de Datos
-- Caso ANFP - Asociacion Nacional de Futbol Profesional
-- Usuario / conexion: PRY2204_S9
-- =====================================================================


-- =====================================================================
-- LIMPIEZA INICIAL
-- Borra las tablas y la secuencia si ya existen, para poder ejecutar
-- este script completo las veces que sea necesario (si no existen,
-- no hace nada y no genera error).
-- =====================================================================

BEGIN
    FOR r IN ( SELECT table_name
               FROM   user_tables
               WHERE  table_name IN ( 'REGION',
                             'ESTADO_CIVIL',
                             'PUESTO',
                             'ASOCIACION',
                             'ESCUELA_FUTBOL',
                             'CLUB_FUTBOL',
                             'IDIOMA',
                             'NACIONALIDAD',
                             'COMUNA',
                             'TRABAJADOR',
                             'JUGADOR',
                             'PERSONAL_PLANTA',
                             'JUGADOR_CLUB',
                             'JUGADOR_IDIOMA',
                             'JUGADOR_NACIONALIDAD' ) )
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || r.table_name || ' CASCADE CONSTRAINTS PURGE';
    END LOOP;

    FOR s IN ( SELECT sequence_name
               FROM   user_sequences
               WHERE  sequence_name = 'SEQ_CLUB_FUTBOL' )
    LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/


-- =====================================================================
-- FASE 3: CREACION DE TABLAS Y RESTRICCIONES
-- Cada tabla se crea junto con sus restricciones (clave primaria,
-- clave foranea, unica y validacion), en orden de dependencia:
-- primero las tablas sin claves foraneas.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Tabla REGION
-- ---------------------------------------------------------------------
CREATE TABLE REGION
    (
     id_region     NUMBER (2)    NOT NULL,
     nombre_region VARCHAR2 (50) NOT NULL
    );

ALTER TABLE REGION
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region );


-- ---------------------------------------------------------------------
-- Tabla ESTADO_CIVIL
-- ---------------------------------------------------------------------
CREATE TABLE ESTADO_CIVIL
    (
     id_estado_civil          NUMBER (2)    NOT NULL,
     descripcion_estado_civil VARCHAR2 (20) NOT NULL
    );

ALTER TABLE ESTADO_CIVIL
    ADD CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY ( id_estado_civil );


-- ---------------------------------------------------------------------
-- Tabla PUESTO
-- ---------------------------------------------------------------------
CREATE TABLE PUESTO
    (
     id_puesto          NUMBER (2)    NOT NULL,
     descripcion_puesto VARCHAR2 (30) NOT NULL
    );

ALTER TABLE PUESTO
    ADD CONSTRAINT PUESTO_PK PRIMARY KEY ( id_puesto );


-- ---------------------------------------------------------------------
-- Tabla ASOCIACION
-- ---------------------------------------------------------------------
CREATE TABLE ASOCIACION
    (
     id_asociacion             NUMBER (3)    NOT NULL,
     nombre_asociacion         VARCHAR2 (60) NOT NULL,
     fecha_creacion_asociacion DATE          NOT NULL,
     tipo_asociacion           CHAR (1)      NOT NULL
    );

ALTER TABLE ASOCIACION
    ADD CONSTRAINT ASOCIACION_PK PRIMARY KEY ( id_asociacion );

-- La fecha de creacion debe ser igual o posterior al 31-12-1980
ALTER TABLE ASOCIACION
    ADD CONSTRAINT ASOCIACION_fecha_CK
    CHECK ( fecha_creacion_asociacion >= DATE '1980-12-31' );

-- Tipo de asociacion: P = profesional, A = amateur
ALTER TABLE ASOCIACION
    ADD CONSTRAINT ASOCIACION_tipo_CK
    CHECK ( tipo_asociacion IN ( 'P', 'A' ) );


-- ---------------------------------------------------------------------
-- Tabla ESCUELA_FUTBOL
-- ---------------------------------------------------------------------
CREATE TABLE ESCUELA_FUTBOL
    (
     id_escuela        NUMBER (4)    NOT NULL,
     nombre_escuela    VARCHAR2 (60) NOT NULL,
     capacidad_escuela NUMBER (5)    NOT NULL,
     fecha_fundacion   DATE          NOT NULL
    );

ALTER TABLE ESCUELA_FUTBOL
    ADD CONSTRAINT ESCUELA_FUTBOL_PK PRIMARY KEY ( id_escuela );


-- ---------------------------------------------------------------------
-- Tabla CLUB_FUTBOL
-- ---------------------------------------------------------------------
CREATE TABLE CLUB_FUTBOL
    (
     id_club         NUMBER (4)    NOT NULL,
     nombre_club     VARCHAR2 (50) NOT NULL,
     patrimonio_club NUMBER (12)   NOT NULL,
     ubicacion_calle VARCHAR2 (60) NOT NULL,
     tipo_club       VARCHAR2 (15) DEFAULT 'Profesional' NOT NULL
    );

ALTER TABLE CLUB_FUTBOL
    ADD CONSTRAINT CLUB_FUTBOL_PK PRIMARY KEY ( id_club );

-- El nombre del club debe ser unico
ALTER TABLE CLUB_FUTBOL
    ADD CONSTRAINT CLUB_FUTBOL_nombre_club_UN UNIQUE ( nombre_club );

ALTER TABLE CLUB_FUTBOL
    ADD CONSTRAINT CLUB_FUTBOL_tipo_club_CK
    CHECK ( tipo_club IN ( 'Profesional', 'Amateur' ) );

-- Secuencia para el codigo de CLUB_FUTBOL: comienza en 703 y sube de 4 en 4
CREATE SEQUENCE SEQ_CLUB_FUTBOL
    START WITH 703
    INCREMENT BY 4
    NOCACHE
    NOCYCLE;


-- ---------------------------------------------------------------------
-- Tabla IDIOMA
-- ---------------------------------------------------------------------
CREATE TABLE IDIOMA
    (
     id_idioma     NUMBER (3)    NOT NULL,
     nombre_idioma VARCHAR2 (30) NOT NULL
    );

ALTER TABLE IDIOMA
    ADD CONSTRAINT IDIOMA_PK PRIMARY KEY ( id_idioma );


-- ---------------------------------------------------------------------
-- Tabla NACIONALIDAD
-- ---------------------------------------------------------------------
-- La clave primaria se genera con IDENTITY: comienza en 210 y sube de 2 en 2
CREATE TABLE NACIONALIDAD
    (
     id_nacion                NUMBER (3) GENERATED ALWAYS AS IDENTITY ( START WITH 210 INCREMENT BY 2 ) NOT NULL,
     descripcion_nacionalidad VARCHAR2 (30) NOT NULL
    );

ALTER TABLE NACIONALIDAD
    ADD CONSTRAINT NACIONALIDAD_PK PRIMARY KEY ( id_nacion );


-- ---------------------------------------------------------------------
-- Tabla COMUNA
-- ---------------------------------------------------------------------
CREATE TABLE COMUNA
    (
     id_comuna        NUMBER (4)    NOT NULL,
     nombre_comuna    VARCHAR2 (50) NOT NULL,
     REGION_id_region NUMBER (2)    NOT NULL
    );

ALTER TABLE COMUNA
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna );

ALTER TABLE COMUNA
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY ( REGION_id_region )
    REFERENCES REGION ( id_region );


-- ---------------------------------------------------------------------
-- Tabla TRABAJADOR
-- ---------------------------------------------------------------------
CREATE TABLE TRABAJADOR
    (
     id_inscripcion               NUMBER (9)    NOT NULL,
     rut                          NUMBER (9)    NOT NULL,
     dv_rut                       CHAR (1)      NOT NULL,
     nombres_trabajador           VARCHAR2 (60) NOT NULL,
     apellidos_trabajador         VARCHAR2 (60) NOT NULL,
     sueldo_base                  NUMBER (9)    NOT NULL,
     fecha_nacimiento             DATE          NOT NULL,
     genero                       CHAR (1)      NOT NULL,
     telefono_movil               VARCHAR2 (15) NOT NULL,
     direccion                    VARCHAR2 (80) NOT NULL,
     COMUNA_id_comuna             NUMBER (4)    NOT NULL,
     ESTADO_CIVIL_id_estado_civil NUMBER (2)    NOT NULL
    );

ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_PK PRIMARY KEY ( id_inscripcion );

ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_COMUNA_FK FOREIGN KEY ( COMUNA_id_comuna )
    REFERENCES COMUNA ( id_comuna );

ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_ESTADO_CIVIL_FK FOREIGN KEY ( ESTADO_CIVIL_id_estado_civil )
    REFERENCES ESTADO_CIVIL ( id_estado_civil );

-- El RUT no puede repetirse
ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_rut_UN UNIQUE ( rut );

ALTER TABLE TRABAJADOR
    ADD CONSTRAINT TRABAJADOR_genero_CK
    CHECK ( genero IN ( 'M', 'F' ) );


-- ---------------------------------------------------------------------
-- Tabla JUGADOR (subtipo de TRABAJADOR)
-- ---------------------------------------------------------------------
CREATE TABLE JUGADOR
    (
     id_inscripcion            NUMBER (9)  NOT NULL,
     monto_total_premios       NUMBER (10) DEFAULT 0 NOT NULL,
     anio_egreso_amateur       NUMBER (4),
     PUESTO_id_puesto          NUMBER (2)  NOT NULL,
     ASOCIACION_id_asociacion  NUMBER (3)  NOT NULL,
     ESCUELA_FUTBOL_id_escuela NUMBER (4)
    );

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_PK PRIMARY KEY ( id_inscripcion );

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_TRABAJADOR_FK FOREIGN KEY ( id_inscripcion )
    REFERENCES TRABAJADOR ( id_inscripcion );

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_PUESTO_FK FOREIGN KEY ( PUESTO_id_puesto )
    REFERENCES PUESTO ( id_puesto );

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_ASOCIACION_FK FOREIGN KEY ( ASOCIACION_id_asociacion )
    REFERENCES ASOCIACION ( id_asociacion );

ALTER TABLE JUGADOR
    ADD CONSTRAINT JUGADOR_ESCUELA_FUTBOL_FK FOREIGN KEY ( ESCUELA_FUTBOL_id_escuela )
    REFERENCES ESCUELA_FUTBOL ( id_escuela );


-- ---------------------------------------------------------------------
-- Tabla PERSONAL_PLANTA (subtipo de TRABAJADOR)
-- ---------------------------------------------------------------------
CREATE TABLE PERSONAL_PLANTA
    (
     id_inscripcion   NUMBER (9) NOT NULL,
     horas_trabajadas NUMBER (4) DEFAULT 0,
     valor_hora_extra NUMBER (7)
    );

ALTER TABLE PERSONAL_PLANTA
    ADD CONSTRAINT PERSONAL_PLANTA_PK PRIMARY KEY ( id_inscripcion );

ALTER TABLE PERSONAL_PLANTA
    ADD CONSTRAINT PERSONAL_PLANTA_TRABAJADOR_FK FOREIGN KEY ( id_inscripcion )
    REFERENCES TRABAJADOR ( id_inscripcion );


-- ---------------------------------------------------------------------
-- Tabla JUGADOR_CLUB (intermedia)
-- ---------------------------------------------------------------------
CREATE TABLE JUGADOR_CLUB
    (
     fecha_incorporacion_club DATE       NOT NULL,
     fecha_fin_contrato       DATE,
     JUGADOR_id_inscripcion   NUMBER (9) NOT NULL,
     CLUB_FUTBOL_id_club      NUMBER (4) NOT NULL
    );

ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_PK
    PRIMARY KEY ( fecha_incorporacion_club, JUGADOR_id_inscripcion, CLUB_FUTBOL_id_club );

ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_JUGADOR_FK FOREIGN KEY ( JUGADOR_id_inscripcion )
    REFERENCES JUGADOR ( id_inscripcion );

ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_CLUB_FUTBOL_FK FOREIGN KEY ( CLUB_FUTBOL_id_club )
    REFERENCES CLUB_FUTBOL ( id_club );

-- El contrato no puede terminar antes de la incorporacion al club
ALTER TABLE JUGADOR_CLUB
    ADD CONSTRAINT JUGADOR_CLUB_fechas_CK
    CHECK ( fecha_fin_contrato IS NULL OR fecha_fin_contrato >= fecha_incorporacion_club );


-- ---------------------------------------------------------------------
-- Tabla JUGADOR_IDIOMA (intermedia)
-- ---------------------------------------------------------------------
CREATE TABLE JUGADOR_IDIOMA
    (
     nivel_dominio          VARCHAR2 (20) NOT NULL,
     JUGADOR_id_inscripcion NUMBER (9)    NOT NULL,
     IDIOMA_id_idioma       NUMBER (3)    NOT NULL
    );

ALTER TABLE JUGADOR_IDIOMA
    ADD CONSTRAINT JUGADOR_IDIOMA_PK PRIMARY KEY ( JUGADOR_id_inscripcion, IDIOMA_id_idioma );

ALTER TABLE JUGADOR_IDIOMA
    ADD CONSTRAINT JUGADOR_IDIOMA_JUGADOR_FK FOREIGN KEY ( JUGADOR_id_inscripcion )
    REFERENCES JUGADOR ( id_inscripcion );

ALTER TABLE JUGADOR_IDIOMA
    ADD CONSTRAINT JUGADOR_IDIOMA_IDIOMA_FK FOREIGN KEY ( IDIOMA_id_idioma )
    REFERENCES IDIOMA ( id_idioma );


-- ---------------------------------------------------------------------
-- Tabla JUGADOR_NACIONALIDAD (intermedia)
-- ---------------------------------------------------------------------
CREATE TABLE JUGADOR_NACIONALIDAD
    (
     JUGADOR_id_inscripcion NUMBER (9) NOT NULL,
     NACIONALIDAD_id_nacion NUMBER (3) NOT NULL
    );

ALTER TABLE JUGADOR_NACIONALIDAD
    ADD CONSTRAINT JUGADOR_NACIONALIDAD_PK PRIMARY KEY ( JUGADOR_id_inscripcion, NACIONALIDAD_id_nacion );

ALTER TABLE JUGADOR_NACIONALIDAD
    ADD CONSTRAINT JUGADOR_NACION_JUGADOR_FK FOREIGN KEY ( JUGADOR_id_inscripcion )
    REFERENCES JUGADOR ( id_inscripcion );

ALTER TABLE JUGADOR_NACIONALIDAD
    ADD CONSTRAINT JUGADOR_NACION_NACION_FK FOREIGN KEY ( NACIONALIDAD_id_nacion )
    REFERENCES NACIONALIDAD ( id_nacion );



-- =====================================================================
-- FASE 3: POBLAMIENTO DE TABLAS (en orden de dependencia)
-- REGION -> COMUNA -> ASOCIACION -> NACIONALIDAD -> CLUB_FUTBOL
-- =====================================================================

-- ---------------------------------------------------------------------
-- REGION
-- Se agregan las regiones 8 y 16 porque COMUNA las referencia
-- (Concepcion y Chillan) y no venian en los datos de la Figura 2.
-- ---------------------------------------------------------------------

INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 1,  'ARICA Y PARINACOTA Y TARAPACA' );
INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 2,  'ANTOFAGASTA' );
INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 3,  'ATACAMA Y COQUIMBO' );
INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 5,  'VALPARAISO' );
INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 8,  'BIOBIO' );
INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 13, 'METROPOLITANA' );
INSERT INTO REGION ( id_region, nombre_region ) VALUES ( 16, 'ÑUBLE' );

-- ---------------------------------------------------------------------
-- COMUNA
-- ---------------------------------------------------------------------

INSERT INTO COMUNA ( id_comuna, nombre_comuna, REGION_id_region ) VALUES ( 101, 'Santiago',    13 );
INSERT INTO COMUNA ( id_comuna, nombre_comuna, REGION_id_region ) VALUES ( 102, 'Valparaíso',   5 );
INSERT INTO COMUNA ( id_comuna, nombre_comuna, REGION_id_region ) VALUES ( 103, 'Concepción',   8 );
INSERT INTO COMUNA ( id_comuna, nombre_comuna, REGION_id_region ) VALUES ( 104, 'Antofagasta',  2 );
INSERT INTO COMUNA ( id_comuna, nombre_comuna, REGION_id_region ) VALUES ( 105, 'Chillán',     16 );

-- ---------------------------------------------------------------------
-- ASOCIACION
-- ---------------------------------------------------------------------

INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 25, 'Asociación de Fútbol de Santiago',    TO_DATE( '15-05-2001', 'DD-MM-YYYY' ), 'P' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 26, 'Asociación Nacional de Fútbol Amateur', TO_DATE( '10-03-1998', 'DD-MM-YYYY' ), 'A' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 27, 'Asociación de Fútbol de Valparaíso',  TO_DATE( '21-07-1987', 'DD-MM-YYYY' ), 'P' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 28, 'Asociación de Fútbol de Concepción',  TO_DATE( '30-11-1995', 'DD-MM-YYYY' ), 'A' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 29, 'Asociación de Fútbol de Antofagasta', TO_DATE( '25-06-2003', 'DD-MM-YYYY' ), 'P' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 30, 'Asociación de Fútbol de Temuco',      TO_DATE( '12-01-2010', 'DD-MM-YYYY' ), 'A' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 31, 'Asociación de Fútbol de Rancagua',    TO_DATE( '08-09-1999', 'DD-MM-YYYY' ), 'P' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 32, 'Asociación de Fútbol de Puerto Montt', TO_DATE( '20-04-2005', 'DD-MM-YYYY' ), 'A' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 33, 'Asociación de Fútbol de La Serena',   TO_DATE( '14-08-2012', 'DD-MM-YYYY' ), 'P' );
INSERT INTO ASOCIACION ( id_asociacion, nombre_asociacion, fecha_creacion_asociacion, tipo_asociacion )
    VALUES ( 34, 'Asociación de Fútbol de Chillán',     TO_DATE( '01-12-2018', 'DD-MM-YYYY' ), 'A' );

-- ---------------------------------------------------------------------
-- NACIONALIDAD
-- id_nacion es IDENTITY (GENERATED ALWAYS): no se indica en el INSERT.
-- Se generan 210, 212, 214, 216 y 218.
-- ---------------------------------------------------------------------

INSERT INTO NACIONALIDAD ( descripcion_nacionalidad ) VALUES ( 'Chilena' );
INSERT INTO NACIONALIDAD ( descripcion_nacionalidad ) VALUES ( 'Argentina' );
INSERT INTO NACIONALIDAD ( descripcion_nacionalidad ) VALUES ( 'Peruana' );
INSERT INTO NACIONALIDAD ( descripcion_nacionalidad ) VALUES ( 'Boliviana' );
INSERT INTO NACIONALIDAD ( descripcion_nacionalidad ) VALUES ( 'Brasileña' );

-- ---------------------------------------------------------------------
-- CLUB_FUTBOL
-- id_club se obtiene de la secuencia SEQ_CLUB_FUTBOL: 703, 707, 711, 715 y 719.
-- ---------------------------------------------------------------------

INSERT INTO CLUB_FUTBOL ( id_club, nombre_club, patrimonio_club, ubicacion_calle, tipo_club )
    VALUES ( SEQ_CLUB_FUTBOL.NEXTVAL, 'Colo-Colo',            500000000, 'Av. Marathon 5300',                'Profesional' );
INSERT INTO CLUB_FUTBOL ( id_club, nombre_club, patrimonio_club, ubicacion_calle, tipo_club )
    VALUES ( SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parrón 0931',               'Profesional' );
INSERT INTO CLUB_FUTBOL ( id_club, nombre_club, patrimonio_club, ubicacion_calle, tipo_club )
    VALUES ( SEQ_CLUB_FUTBOL.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606',            'Profesional' );
INSERT INTO CLUB_FUTBOL ( id_club, nombre_club, patrimonio_club, ubicacion_calle, tipo_club )
    VALUES ( SEQ_CLUB_FUTBOL.NEXTVAL, 'Huachipato',           220000000, 'Avenida Desiderio García 909',     'Profesional' );
INSERT INTO CLUB_FUTBOL ( id_club, nombre_club, patrimonio_club, ubicacion_calle, tipo_club )
    VALUES ( SEQ_CLUB_FUTBOL.NEXTVAL, 'Ñublense',             170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional' );

COMMIT;

-- ============================================================
-- VERIFICACION DEL POBLAMIENTO DE LAS TABLAS
-- ============================================================

SELECT * FROM REGION ORDER BY id_region;

SELECT * FROM COMUNA ORDER BY id_comuna;

SELECT * FROM ASOCIACION ORDER BY id_asociacion;

SELECT * FROM NACIONALIDAD ORDER BY id_nacion;

SELECT * FROM CLUB_FUTBOL ORDER BY id_club;


-- =====================================================================
-- FASE 4: RECUPERACION DE DATOS
-- =====================================================================

-- ---------------------------------------------------------------------
-- Informe 1: Asociaciones de futbol profesional
-- Tipo profesional (P), creadas despues del anio 2000,
-- ordenadas de forma descendente por fecha de creacion.
-- ---------------------------------------------------------------------

SELECT 'ID:' || id_asociacion || ' * ' || nombre_asociacion       AS "ASOCIACION",
       TO_CHAR( fecha_creacion_asociacion, 'DD-MM-YYYY' )         AS "CREADA",
       tipo_asociacion                                            AS "TIPO"
FROM   ASOCIACION
WHERE  tipo_asociacion = 'P'
AND    EXTRACT( YEAR FROM fecha_creacion_asociacion ) > 2000
ORDER BY fecha_creacion_asociacion DESC;

-- ---------------------------------------------------------------------
-- Informe 2: Patrimonio de clubes de futbol
-- Patrimonio en pesos y en dolares (tipo de cambio $955 por dolar).
-- Nombre con la letra a, patrimonio superior a $200.000.000,
-- tipo profesional, ordenado de forma descendente por codigo de club.
-- ---------------------------------------------------------------------

SELECT id_club                  AS "CLUB",
       nombre_club              AS "NOMBRE CLUB",
       patrimonio_club          AS "PATRIMONIO EN PESOS",
       patrimonio_club / 955    AS "PATRIMONIO EN DOLARES"
FROM   CLUB_FUTBOL
WHERE  LOWER( nombre_club ) LIKE '%a%'
AND    patrimonio_club > 200000000
AND    tipo_club = 'Profesional'
ORDER BY id_club DESC;
