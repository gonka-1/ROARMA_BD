---------------------------------------------------------------------------------
-- CREACIÓN DE TABLA DE RESUMEN
---------------------------------------------------------------------------------

CREATE TABLE RESUMEN_GESTION_ROARMA(
    ID_RESUMEN          NUMBER(10)          PRIMARY KEY,
    ID_CLI              VARCHAR2(10)        NOT NULL,
    RUN_CLI             VARCHAR2(13)        NOT NULL,
    NOMBRE_CLI          VARCHAR2(100)       NOT NULL,
    TIPO_CLI            VARCHAR2(20)        NOT NULL,
    TOTAL_PAGADO        NUMBER(12)          NOT NULL,
    ID_PROF             VARCHAR2(15)        NOT NULL,
    PROMEDIO_RESENA     NUMBER(3,2)         NOT NULL,
    TITULO_PROFESOR     VARCHAR2(20)        NOT NULL,
    FECHA_PROCESO       DATE DEFAULT SYSDATE
);

---------------------------------------------------------------------------------
-- CONSULTA PARA CURSOR
---------------------------------------------------------------------------------

--TABLAS A TRABAJAR 
SELECT * FROM PERSONA;
SELECT * FROM CLIENTE;
SELECT * FROM CONTRATO;

-- CONSULTA:

 SELECT 
    CLI.RUN_PER AS RUN_CLIENTE,
    PER.PNOMBRE_PER ||' '|| PER.PAPELLIDO_PER AS NOMBRE_CLIENTE,
    CLI.ID_CLI AS ID_CLIENTE,
    CON.ID_CONT AS ID_CONTRATO,
    CON.PROFESOR_RUN_PRO AS ID_PROF
FROM CLIENTE CLI  JOIN PERSONA PER 
    ON (CLI.RUN_PER = PER.RUN_PER)
    JOIN CONTRATO CON 
    ON (CLI.ID_CLI = CON.CLIENTE_ID_CLI);