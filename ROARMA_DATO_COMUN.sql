--=================================================================================
-- CREACIÓN DE TABLAS Y CONSTRAINTS (OPERACIÓN ANONIMIZADA)
--=================================================================================

CREATE TABLE CIUDAD 
    ( 
     id_ciudad        VARCHAR2 (5)   NOT NULL , 
     nom_ciu          VARCHAR2 (100) NOT NULL , 
     REGION_id_region VARCHAR2 (5)   NOT NULL 
    ) ;

ALTER TABLE CIUDAD 
    ADD CONSTRAINT CIUDAD_PK PRIMARY KEY ( id_ciudad ) ;

CREATE TABLE CLASE 
    ( 
     id_clas         VARCHAR2 (5)   NOT NULL , 
     nom_clas        VARCHAR2 (100) NOT NULL , 
     hora_ini        DATE           NOT NULL , 
     hora_ter        DATE           NOT NULL , 
     fec_clas        DATE           NOT NULL , 
     ra_clas         VARCHAR2 (150) NOT NULL , 
     PROFESOR_id_pro VARCHAR2 (5)   NOT NULL 
    ) ;

COMMENT ON COLUMN CLASE.ra_clas IS 'Resultado de aprendizaje' ;

ALTER TABLE CLASE 
    ADD CONSTRAINT CLASE_PK PRIMARY KEY ( id_clas ) ;

CREATE TABLE CLIENTE 
    ( 
     id_persona VARCHAR2 (5) NOT NULL , 
     id_cli     VARCHAR2 (5) NOT NULL , 
     id_usu     VARCHAR2 (5) NOT NULL 
    ) ;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PKv1 UNIQUE ( id_cli ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna             VARCHAR2 (5)   NOT NULL , 
     nombre_comuna         VARCHAR2 (100) NOT NULL , 
     DISPONIBILIDAD_id_dis VARCHAR2 (10)  NOT NULL , 
     CIUDAD_id_ciudad      VARCHAR2 (5)   NOT NULL 
    ) ;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna ) ;

CREATE TABLE CONTRATO 
    ( 
     id_cont           VARCHAR2 (5)  NOT NULL , 
     id_cli            VARCHAR2 (5)  NOT NULL , 
     soli_id           VARCHAR2 (5)  NOT NULL , 
     monto_acor        VARCHAR2 (20) NOT NULL , 
     duracion_cont     VARCHAR2 (10) NOT NULL , 
     estado_cont       VARCHAR2 (20) NOT NULL , 
     fec_acue_cont     DATE          NOT NULL , 
     SOLICITUD_soli_id VARCHAR2 (5)  NOT NULL , 
     PAGO_id_pago      VARCHAR2 (5) , 
     CLIENTE_id_cli    VARCHAR2 (5)  NOT NULL , 
     PROFESOR_id_pro   VARCHAR2 (5)  NOT NULL 
    ) ;

CREATE UNIQUE INDEX CONTRATO__IDX ON CONTRATO ( PAGO_id_pago ASC ) ;
CREATE UNIQUE INDEX CONTRATO__IDXv1 ON CONTRATO ( SOLICITUD_soli_id ASC ) ;

ALTER TABLE CONTRATO 
    ADD CONSTRAINT CONTRATO_PK PRIMARY KEY ( id_cont ) ;

CREATE TABLE CONVERSACION 
    ( 
     id_conv        VARCHAR2 (5) NOT NULL , 
     fech_ini       DATE         NOT NULL , 
     MENSAJE_id_msj VARCHAR2 (5) NOT NULL 
    ) ;

ALTER TABLE CONVERSACION 
    ADD CONSTRAINT CONVERSACION_PK PRIMARY KEY ( id_conv ) ;

CREATE TABLE CURSAR 
    ( 
     USUARIO_id_persona VARCHAR2 (5) NOT NULL , 
     CLASE_id_clas      VARCHAR2 (5) NOT NULL 
    ) ;

ALTER TABLE CURSAR 
    ADD CONSTRAINT CURSAR_PK PRIMARY KEY ( CLASE_id_clas, USUARIO_id_persona ) ;

CREATE TABLE Detallar 
    ( 
     PROFESOR_id_persona      VARCHAR2 (5) NOT NULL , 
     VALOR_HORA_id_valor_hora VARCHAR2 (5) NOT NULL 
    ) ;

ALTER TABLE Detallar 
    ADD CONSTRAINT Detallar_PK PRIMARY KEY ( PROFESOR_id_persona, VALOR_HORA_id_valor_hora ) ;

CREATE TABLE DISPONIBILIDAD 
    ( 
     id_dis          VARCHAR2 (10)  NOT NULL , 
     fec_dis         DATE           NOT NULL , 
     hor_ini         DATE           NOT NULL , 
     hor_ter         DATE           NOT NULL , 
     est_dis         VARCHAR2 (20) , 
     modalidad       VARCHAR2 (15)  NOT NULL , 
     rad_cob_km      VARCHAR2 (150) NOT NULL , 
     PROFESOR_id_pro VARCHAR2 (5)   NOT NULL 
    ) ;

COMMENT ON COLUMN DISPONIBILIDAD.est_dis IS 'estado disponibilidad' ;
COMMENT ON COLUMN DISPONIBILIDAD.rad_cob_km IS 'radio cobertura kilometro' ;

ALTER TABLE DISPONIBILIDAD 
    ADD CONSTRAINT DISPONIBILIDAD_PK PRIMARY KEY ( id_dis ) ;

CREATE TABLE ESPECIALIDAD 
    ( 
     id_esp       VARCHAR2 (5)   NOT NULL , 
     nom_esp      VARCHAR2 (150) NOT NULL , 
     anio_exp_esp VARCHAR2 (20)  NOT NULL 
    ) ;

COMMENT ON COLUMN ESPECIALIDAD.id_esp IS 'especialidad' ;

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT ESPECIALIDAD_PK PRIMARY KEY ( id_esp ) ;

CREATE TABLE INSCRIBIR 
    ( 
     PROFESOR_id_persona VARCHAR2 (5) NOT NULL , 
     ESPECIALIDAD_id_esp VARCHAR2 (5) NOT NULL 
    ) ;

ALTER TABLE INSCRIBIR 
    ADD CONSTRAINT INSCRIBIR_PK PRIMARY KEY ( PROFESOR_id_persona, ESPECIALIDAD_id_esp ) ;

CREATE TABLE MENSAJE 
    ( 
     id_msj             VARCHAR2 (5)   NOT NULL , 
     id_conv            VARCHAR2 (5)   NOT NULL , 
     id_usu             VARCHAR2 (5)   NOT NULL , 
     cont_msj           VARCHAR2 (280) NOT NULL , 
     fec_hora_msj       DATE           NOT NULL , 
     PERSONA_id_persona VARCHAR2 (5)   NOT NULL 
    ) ;

ALTER TABLE MENSAJE 
    ADD CONSTRAINT MENSAJE_PK PRIMARY KEY ( id_msj ) ;

CREATE TABLE PAGO 
    ( 
     id_pago          VARCHAR2 (5) NOT NULL , 
     CONTRATO_id_cont VARCHAR2 (5) NOT NULL , 
     CLIENTE_id_cli   VARCHAR2 (5) NOT NULL 
    ) ;

CREATE UNIQUE INDEX PAGO__IDX ON PAGO ( CONTRATO_id_cont ASC ) ;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_PK PRIMARY KEY ( id_pago ) ;

CREATE TABLE PAIS 
    ( 
     id_pais     VARCHAR2 (5)   NOT NULL , 
     nombre_pais VARCHAR2 (100) NOT NULL 
    ) ;

ALTER TABLE PAIS 
    ADD CONSTRAINT PAIS_PK PRIMARY KEY ( id_pais ) ;

CREATE TABLE PERSONA 
    ( 
     id_persona       VARCHAR2 (5) NOT NULL , 
     COMUNA_id_comuna VARCHAR2 (5) NOT NULL , 
     RESENA_rese_id   VARCHAR2 (5) , 
     soli_id          VARCHAR2 (5) , 
     id_msj           VARCHAR2 (5) 
    ) ;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE PROFESOR 
    ( 
     id_persona  VARCHAR2 (5) NOT NULL , 
     id_pro      VARCHAR2 (5) NOT NULL , 
     cal_pro_pro FLOAT (2) 
    ) ;

COMMENT ON COLUMN PROFESOR.cal_pro_pro IS 'calificacion promedio profesor' ;

ALTER TABLE PROFESOR 
    ADD CONSTRAINT PROFESOR_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE PROFESOR 
    ADD CONSTRAINT PROFESOR_PKv1 UNIQUE ( id_pro ) ;

CREATE TABLE REGION 
    ( 
     id_region     VARCHAR2 (5)   NOT NULL , 
     nombre_region VARCHAR2 (100) NOT NULL , 
     PAIS_id_pais  VARCHAR2 (5)   NOT NULL 
    ) ;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE RESENA 
    ( 
     rese_id     VARCHAR2 (5)   NOT NULL , 
     id_cont     VARCHAR2 (5)   NOT NULL , 
     califi_rese FLOAT (2)      NOT NULL , 
     comen_rese  VARCHAR2 (280) NOT NULL 
    ) ;

COMMENT ON COLUMN RESENA.comen_rese IS 'comentario resena' ;

ALTER TABLE RESENA 
    ADD CONSTRAINT RESENA_PK PRIMARY KEY ( rese_id ) ;

CREATE TABLE SOLICITUD 
    ( 
     soli_id  VARCHAR2 (5)  NOT NULL , 
     id_dis   VARCHAR2 (5)  NOT NULL , 
     est_soli VARCHAR2 (20) NOT NULL , 
     fec_soli DATE          NOT NULL , 
     id_usu   VARCHAR2 (5)  NOT NULL 
    ) ;

ALTER TABLE SOLICITUD 
    ADD CONSTRAINT SOLICITUD_PK PRIMARY KEY ( soli_id ) ;

CREATE TABLE TITULO 
    ( 
     id_titu         VARCHAR2 (5) NOT NULL , 
     PROFESOR_id_pro VARCHAR2 (5) NOT NULL 
    ) ;

ALTER TABLE TITULO 
    ADD CONSTRAINT TITULO_PK PRIMARY KEY ( id_titu ) ;

CREATE TABLE USUARIO 
    ( 
     id_persona         VARCHAR2 (5)           NOT NULL , 
     id_usu             VARCHAR2 (5)           NOT NULL , 
     rese_id            VARCHAR2 (5) , 
     SOLICITUD_soli_id  VARCHAR2 (5) , 
     CLIENTE_id_cli     VARCHAR2 (5) , 
     acepta_terminos    NUMBER (1) DEFAULT 1   NOT NULL , 
     fec_consentimiento DATE                   NOT NULL 
    ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_TERMINOS_CK CHECK ( acepta_terminos IN (0, 1) ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PKv1 UNIQUE ( id_usu ) ;

CREATE TABLE VALOR_HORA 
    ( 
     id_pro        VARCHAR2 (5)  NOT NULL , 
     id_valor_hora VARCHAR2 (5)  NOT NULL , 
     tar_hor       VARCHAR2 (20) NOT NULL 
    ) ;

ALTER TABLE VALOR_HORA 
    ADD CONSTRAINT VALOR_HORA_PK PRIMARY KEY ( id_valor_hora ) ;

CREATE TABLE VERIFICACION_CUENTA 
    ( 
     id_seg              VARCHAR2 (5) NOT NULL , 
     PROFESOR_id_pro     VARCHAR2 (5) , 
     fecha_validacion    DATE , 
     vigencia_validacion NUMBER (2) 
    ) ;

ALTER TABLE VERIFICACION_CUENTA 
    ADD CHECK ( ( PROFESOR_id_pro IS NULL AND fecha_validacion IS NULL AND vigencia_validacion IS NULL ) OR ( PROFESOR_id_pro IS NOT NULL AND fecha_validacion IS NOT NULL AND vigencia_validacion IS NOT NULL ) ) ;

ALTER TABLE VERIFICACION_CUENTA 
    ADD CONSTRAINT VERIFICACION_CUENTA_PK PRIMARY KEY ( id_seg ) ;

--=================================================================================
-- CLAVES FORÁNEAS (FOREIGN KEYS) - OPERACIÓN
--=================================================================================

ALTER TABLE CIUDAD 
    ADD CONSTRAINT CIUDAD_REGION_FK FOREIGN KEY ( REGION_id_region ) 
    REFERENCES REGION ( id_region ) ;

ALTER TABLE CLASE 
    ADD CONSTRAINT CLASE_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_pro ) 
    REFERENCES PROFESOR ( id_pro ) ;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PERSONA_FK FOREIGN KEY ( id_persona ) 
    REFERENCES PERSONA ( id_persona ) ;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_CIUDAD_FK FOREIGN KEY ( CIUDAD_id_ciudad ) 
    REFERENCES CIUDAD ( id_ciudad ) ;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_DISPONIBILIDAD_FK FOREIGN KEY ( DISPONIBILIDAD_id_dis ) 
    REFERENCES DISPONIBILIDAD ( id_dis ) ;

ALTER TABLE CONTRATO 
    ADD CONSTRAINT CONTRATO_CLIENTE_FK FOREIGN KEY ( CLIENTE_id_cli ) 
    REFERENCES CLIENTE ( id_cli ) ;

ALTER TABLE CONTRATO 
    ADD CONSTRAINT CONTRATO_PAGO_FK FOREIGN KEY ( PAGO_id_pago ) 
    REFERENCES PAGO ( id_pago ) ;

ALTER TABLE CONTRATO 
    ADD CONSTRAINT CONTRATO_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_pro ) 
    REFERENCES PROFESOR ( id_pro ) ;

ALTER TABLE CONTRATO 
    ADD CONSTRAINT CONTRATO_SOLICITUD_FK FOREIGN KEY ( SOLICITUD_soli_id ) 
    REFERENCES SOLICITUD ( soli_id ) ;

ALTER TABLE CONVERSACION 
    ADD CONSTRAINT CONVERSACION_MENSAJE_FK FOREIGN KEY ( MENSAJE_id_msj ) 
    REFERENCES MENSAJE ( id_msj ) ;

ALTER TABLE CURSAR 
    ADD CONSTRAINT CURSAR_CLASE_FK FOREIGN KEY ( CLASE_id_clas ) 
    REFERENCES CLASE ( id_clas ) ;

ALTER TABLE CURSAR 
    ADD CONSTRAINT CURSAR_USUARIO_FK FOREIGN KEY ( USUARIO_id_persona ) 
    REFERENCES USUARIO ( id_persona ) ;

ALTER TABLE Detallar 
    ADD CONSTRAINT Detallar_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_persona ) 
    REFERENCES PROFESOR ( id_persona ) ;

ALTER TABLE Detallar 
    ADD CONSTRAINT Detallar_VALOR_HORA_FK FOREIGN KEY ( VALOR_HORA_id_valor_hora ) 
    REFERENCES VALOR_HORA ( id_valor_hora ) ;

ALTER TABLE DISPONIBILIDAD 
    ADD CONSTRAINT DISPONIBILIDAD_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_pro ) 
    REFERENCES PROFESOR ( id_pro ) ;

ALTER TABLE INSCRIBIR 
    ADD CONSTRAINT INSCRIBIR_ESPECIALIDAD_FK FOREIGN KEY ( ESPECIALIDAD_id_esp ) 
    REFERENCES ESPECIALIDAD ( id_esp ) ;

ALTER TABLE INSCRIBIR 
    ADD CONSTRAINT INSCRIBIR_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_persona ) 
    REFERENCES PROFESOR ( id_persona ) ;

ALTER TABLE MENSAJE 
    ADD CONSTRAINT MENSAJE_PERSONA_FK FOREIGN KEY ( PERSONA_id_persona ) 
    REFERENCES PERSONA ( id_persona ) ;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_CLIENTE_FK FOREIGN KEY ( CLIENTE_id_cli ) 
    REFERENCES CLIENTE ( id_cli ) ;

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_CONTRATO_FK FOREIGN KEY ( CONTRATO_id_cont ) 
    REFERENCES CONTRATO ( id_cont ) ;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_COMUNA_FK FOREIGN KEY ( COMUNA_id_comuna ) 
    REFERENCES COMUNA ( id_comuna ) ;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_RESENA_FK FOREIGN KEY ( RESENA_rese_id ) 
    REFERENCES RESENA ( rese_id ) ;

ALTER TABLE PROFESOR 
    ADD CONSTRAINT PROFESOR_PERSONA_FK FOREIGN KEY ( id_persona ) 
    REFERENCES PERSONA ( id_persona ) ;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PAIS_FK FOREIGN KEY ( PAIS_id_pais ) 
    REFERENCES PAIS ( id_pais ) ;

ALTER TABLE TITULO 
    ADD CONSTRAINT TITULO_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_pro ) 
    REFERENCES PROFESOR ( id_pro ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_CLIENTE_FK FOREIGN KEY ( CLIENTE_id_cli ) 
    REFERENCES CLIENTE ( id_cli ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PERSONA_FK FOREIGN KEY ( id_persona ) 
    REFERENCES PERSONA ( id_persona ) ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_SOLICITUD_FK FOREIGN KEY ( SOLICITUD_soli_id ) 
    REFERENCES SOLICITUD ( soli_id ) ;

ALTER TABLE VERIFICACION_CUENTA 
    ADD CONSTRAINT VERIF_CUENTA_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_pro ) 
    REFERENCES PROFESOR ( id_pro ) ;