-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-11-24 15:57:18 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE CLIENTE 
    ( 
     id_persona    VARCHAR2 (5)  NOT NULL , 
     id_cliente    VARCHAR2 (5)  NOT NULL , 
     tip_cli       VARCHAR2 (100)  NOT NULL , 
     razon_soc_cli VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PKv1 UNIQUE ( id_cliente ) ;

CREATE TABLE PAGO 
    ( 
     id_pago            VARCHAR2 (5)  NOT NULL , 
     id_cont            VARCHAR2 (5)  NOT NULL , 
     monto_pago         VARCHAR2 (20)  NOT NULL , 
     fec_pago           DATE  NOT NULL , 
     metodo_pago        VARCHAR2 (100)  NOT NULL , 
     estado_pago        VARCHAR2 (100)  NOT NULL , 
     CLIENTE_id_cliente VARCHAR2 (5)  NOT NULL 
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_PK PRIMARY KEY ( id_pago ) ;

CREATE TABLE PERSONA 
    ( 
     id_persona    VARCHAR2 (5)  NOT NULL , 
     run_per       VARCHAR2 (12)  NOT NULL , 
     pnombre_per   VARCHAR2 (100)  NOT NULL , 
     snombre_per   VARCHAR2 (100)  NOT NULL , 
     papellido_per VARCHAR2 (100)  NOT NULL , 
     sapellido_per VARCHAR2 (100)  NOT NULL , 
     fecha_nac_per DATE  NOT NULL , 
     email_per     VARCHAR2 (100)  NOT NULL , 
     tel_persona   VARCHAR2 (12)  NOT NULL , 
     ant_per       BLOB  NOT NULL 
    ) 
;

COMMENT ON COLUMN PERSONA.ant_per IS 'antecedentes persona' 
;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE PROFESOR 
    ( 
     id_persona   VARCHAR2 (5)  NOT NULL , 
     id_profesor  VARCHAR2 (5)  NOT NULL , 
     latitud_act  VARCHAR2 (100)  NOT NULL , 
     longitud_act VARCHAR2 (100)  NOT NULL , 
     ult_act_ubi  VARCHAR2 (100)  NOT NULL , 
     id_vc        VARCHAR2 (5) 
    ) 
;

ALTER TABLE PROFESOR 
    ADD CONSTRAINT PROFESOR_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE PROFESOR 
    ADD CONSTRAINT PROFESOR_PKv1 UNIQUE ( id_profesor ) ;

CREATE TABLE TITULO 
    ( 
     id_titulo            VARCHAR2 (5)  NOT NULL , 
     men_titulo           VARCHAR2 (150)  NOT NULL , 
     cas_est              VARCHAR2 (150)  NOT NULL , 
     anio_titu            BLOB  NOT NULL , 
     cert_titu            BLOB  NOT NULL , 
     PROFESOR_id_profesor VARCHAR2 (5)  NOT NULL 
    ) 
;

COMMENT ON COLUMN TITULO.id_titulo IS 'casa estudio' 
;

COMMENT ON COLUMN TITULO.men_titulo IS 'mencion titulo' 
;

COMMENT ON COLUMN TITULO.cas_est IS 'casa estudio' 
;

ALTER TABLE TITULO 
    ADD CONSTRAINT TITULO_PK PRIMARY KEY ( id_titulo ) ;

CREATE TABLE USUARIO 
    ( 
     id_persona   VARCHAR2 (5)  NOT NULL , 
     id_usuario   VARCHAR2 (5)  NOT NULL , 
     pass_usu     VARCHAR2 (100)  NOT NULL , 
     fecha_reg    DATE  NOT NULL , 
     tipo_usu     VARCHAR2 (100)  NOT NULL , 
     img_usu      BLOB  NOT NULL , 
     latitud_act  VARCHAR2 (100)  NOT NULL , 
     longitud_act VARCHAR2 (100)  NOT NULL , 
     ult_act_ubi  VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PKv1 UNIQUE ( id_usuario ) ;

CREATE TABLE VERIFICACION_CUENTA 
    ( 
     id_vc                VARCHAR2 (5)  NOT NULL , 
     certifi_inha_seg     BLOB  NOT NULL , 
     est_verificacion     VARCHAR2 (100)  NOT NULL , 
     fec_est_verificacion DATE  NOT NULL , 
     PROFESOR_id_profesor VARCHAR2 (5) , 
     fecha_validacion     DATE , 
     vigencia_validacion  VARCHAR2 (100) 
    ) 
;

ALTER TABLE VERIFICACION_CUENTA 
    ADD CHECK ( ( PROFESOR_id_profesor IS NULL AND fecha_validacion IS NULL AND vigencia_validacion IS NULL) OR ( PROFESOR_id_profesor IS NOT NULL AND vigencia_validacion IS NOT NULL) ) 
;

ALTER TABLE VERIFICACION_CUENTA 
    ADD CONSTRAINT VERIFICACION_CUENTA_PK PRIMARY KEY ( id_vc ) ;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PERSONA_FK FOREIGN KEY 
    ( 
     id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_CLIENTE_FK FOREIGN KEY 
    ( 
     CLIENTE_id_cliente
    ) 
    REFERENCES CLIENTE 
    ( 
     id_cliente
    ) 
;

ALTER TABLE PROFESOR 
    ADD CONSTRAINT PROFESOR_PERSONA_FK FOREIGN KEY 
    ( 
     id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;

ALTER TABLE TITULO 
    ADD CONSTRAINT TITULO_PROFESOR_FK FOREIGN KEY 
    ( 
     PROFESOR_id_profesor
    ) 
    REFERENCES PROFESOR 
    ( 
     id_profesor
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PERSONA_FK FOREIGN KEY 
    ( 
     id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;

ALTER TABLE VERIFICACION_CUENTA 
    ADD CONSTRAINT VERIF_CUEN_PROF_FK FOREIGN KEY 
    ( 
     PROFESOR_id_profesor
    ) 
    REFERENCES PROFESOR 
    ( 
     id_profesor
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                             0
-- ALTER TABLE                             17
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
