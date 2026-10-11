# EFT Semana 9 — Modelamiento de Bases de Datos (PRY2204)

## Caso: Asociación Nacional de Fútbol Profesional (ANFP)

Proyecto académico desarrollado para la Evaluación Final Transversal (EFT) de la asignatura **Modelamiento de Bases de Datos**, de Duoc UC.

El objetivo es diseñar e implementar una base de datos relacional para administrar información relacionada con trabajadores, jugadores, personal de planta, clubes, asociaciones, escuelas de fútbol, comunas, regiones, nacionalidades e idiomas.

## Contenido del proyecto

La solución considera las siguientes fases:

1. **Modelo Entidad-Relación Extendido (MER-E):** diseñado en Oracle SQL Developer Data Modeler, utilizando notación Barker.
2. **Modelo Relacional normalizado (MR):** transformación del modelo conceptual a tablas, con claves primarias y foráneas.
3. **Implementación física:** script SQL para crear tablas, restricciones y objetos necesarios en Oracle.
4. **Poblamiento:** inserción de datos en las tablas solicitadas por la actividad.
5. **Consultas de recuperación:** consultas SQL para generar los informes solicitados.

## Tecnologías utilizadas

- Oracle SQL Developer Data Modeler
- Oracle SQL Developer
- Oracle Database (Oracle 19c o superior / Oracle Cloud)
- SQL y PL/SQL para la implementación y administración del esquema

## Elementos principales del modelo

- `TRABAJADOR`, con los subtipos `JUGADOR` y `PERSONAL_PLANTA`.
- `CLUB_FUTBOL` y `JUGADOR_CLUB` para registrar la permanencia de jugadores en clubes.
- `ASOCIACION`, `PUESTO` y `ESCUELA_FUTBOL`.
- `REGION` y `COMUNA`.
- `NACIONALIDAD`, `IDIOMA`, `JUGADOR_NACIONALIDAD` y `JUGADOR_IDIOMA`.
- `ESTADO_CIVIL`.

## Reglas y restricciones implementadas

El script SQL contempla, entre otros elementos:

- Claves primarias (`PK`) y claves foráneas (`FK`).
- Restricciones de unicidad (`UN`) y validación (`CHECK`).
- Valores predeterminados (`DEFAULT`).
- Columna `IDENTITY` para generar los códigos de `NACIONALIDAD`, comenzando en 210 e incrementándose de 2 en 2.
- Secuencia `SEQ_CLUB_FUTBOL`, que comienza en 703 y se incrementa de 4 en 4.
- Restricción para que el nombre del club sea único.
- Validación de la fecha de creación de las asociaciones.

## Informes SQL

**Informe 1: Asociaciones de fútbol profesional**
- Selecciona asociaciones de tipo profesional (`P`) creadas después del año 2000.
- Ordena los resultados por fecha de creación descendente.

**Informe 2: Patrimonio de clubes de fútbol**
- Muestra el patrimonio en pesos chilenos y su conversión a dólares usando un tipo de cambio de $955 por dólar.
- Filtra clubes cuyo nombre contiene la letra `a`, con patrimonio superior a $200.000.000 y de tipo profesional.
- Ordena los resultados por código de club descendente.

## Archivos de entrega

Añade a este repositorio los archivos finales solicitados por la actividad:

- **Documento de respuesta** con las capturas del MER-E y del MR normalizado.
- **Archivo ZIP o RAR del diseño de Data Modeler**, incluyendo el archivo `.dmd` y su carpeta de recursos.
- **Script SQL** de implementación física y consultas.
- **Video de la presentación** o un archivo de texto con el enlace al video, según la modalidad de entrega que utilices.

Nombres de archivo sugeridos (ajústalos a los nombres reales de tus archivos):

```text
PRY2204_EFT_S9_Formato_respuesta.docx
ANFP_Modelo.zip
EFT_S9_ANFP.sql
EFT_S9_ANFP.mp4
```

## Video de presentación

Enlace: **[Agregar aquí el enlace del video]**

## Repositorio

Este repositorio contiene los productos académicos correspondientes a la EFT de la Semana 9. Antes de entregar, verifica que los archivos estén actualizados y que el enlace del video tenga permisos de visualización.

## Autora

**Consuelo Martínez**  
Estudiante de Analista Programador — Duoc UC

---

*Proyecto realizado con fines académicos.*
