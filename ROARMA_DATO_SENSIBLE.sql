--=================================================================================
-- 1. CREACIÓN DE TABLAS - LEY 21.719 (BASE DE DATOS SENSIBLE)
--=================================================================================

CREATE TABLE PERSONA_SENSIBLE 
    ( 
     id_persona    VARCHAR2 (5)   NOT NULL , 
     run_per       VARCHAR2 (12)  NOT NULL , 
     pnombre_per   VARCHAR2 (100) NOT NULL , 
     snombre_per   VARCHAR2 (100) NOT NULL , 
     papellido_per VARCHAR2 (100) NOT NULL , 
     sapellido_per VARCHAR2 (100) NOT NULL , 
     fecha_nac_per DATE           NOT NULL , 
     email_per     VARCHAR2 (100) NOT NULL , 
     tel_persona   VARCHAR2 (12)  NOT NULL , 
     ant_per       BLOB           NOT NULL 
    ) ;

COMMENT ON COLUMN PERSONA_SENSIBLE.ant_per IS 'antecedentes persona' ;

ALTER TABLE PERSONA_SENSIBLE 
    ADD CONSTRAINT PERSONA_SENSIBLE_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE CLIENTE_SENSIBLE 
    ( 
     id_persona    VARCHAR2 (5)   NOT NULL , 
     id_cliente    VARCHAR2 (5)   NOT NULL , 
     tip_cli       VARCHAR2 (100) NOT NULL , 
     razon_soc_cli VARCHAR2 (100) NOT NULL 
    ) ;

ALTER TABLE CLIENTE_SENSIBLE 
    ADD CONSTRAINT CLIENTE_SENS_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE CLIENTE_SENSIBLE 
    ADD CONSTRAINT CLIENTE_SENS_UK UNIQUE ( id_cliente ) ;

CREATE TABLE PAGO_SENSIBLE 
    ( 
     id_pago            VARCHAR2 (5)   NOT NULL , 
     id_cont            VARCHAR2 (5)   NOT NULL , 
     monto_pago         VARCHAR2 (20)  NOT NULL , 
     fec_pago           DATE           NOT NULL , 
     metodo_pago        VARCHAR2 (100) NOT NULL , 
     estado_pago        VARCHAR2 (100) NOT NULL , 
     CLIENTE_id_cliente VARCHAR2 (5)   NOT NULL 
    ) ;

ALTER TABLE PAGO_SENSIBLE 
    ADD CONSTRAINT PAGO_SENS_PK PRIMARY KEY ( id_pago ) ;

CREATE TABLE PROFESOR_SENSIBLE 
    ( 
     id_persona   VARCHAR2 (5)   NOT NULL , 
     id_profesor  VARCHAR2 (5)   NOT NULL , 
     latitud_act  VARCHAR2 (100) NOT NULL , 
     longitud_act VARCHAR2 (100) NOT NULL , 
     ult_act_ubi  VARCHAR2 (100) NOT NULL , 
     id_vc        VARCHAR2 (5) 
    ) ;

ALTER TABLE PROFESOR_SENSIBLE 
    ADD CONSTRAINT PROFESOR_SENSIBLE_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE PROFESOR_SENSIBLE 
    ADD CONSTRAINT PROFESOR_SENSIBLE_UK UNIQUE ( id_profesor ) ;

CREATE TABLE TITULO_SENSIBLE 
    ( 
     id_titulo            VARCHAR2 (5)   NOT NULL , 
     men_titulo           VARCHAR2 (150) NOT NULL , 
     cas_est              VARCHAR2 (150) NOT NULL , 
     anio_titu            NUMBER (4)     NOT NULL , 
     cert_titu            BLOB           NOT NULL , 
     PROFESOR_id_profesor VARCHAR2 (5)   NOT NULL 
    ) ;

COMMENT ON COLUMN TITULO_SENSIBLE.men_titulo IS 'mencion titulo' ;
COMMENT ON COLUMN TITULO_SENSIBLE.cas_est IS 'casa estudio' ;

ALTER TABLE TITULO_SENSIBLE 
    ADD CONSTRAINT TITULO_SENSIBLE_PK PRIMARY KEY ( id_titulo ) ;

CREATE TABLE USUARIO_SENSIBLE 
    ( 
     id_persona   VARCHAR2 (5)   NOT NULL , 
     id_usuario   VARCHAR2 (5)   NOT NULL , 
     pass_usu     VARCHAR2 (100) NOT NULL , 
     fecha_reg    DATE           NOT NULL , 
     tipo_usu     VARCHAR2 (100) NOT NULL , 
     img_usu      BLOB           NOT NULL , 
     latitud_act  VARCHAR2 (100) NOT NULL , 
     longitud_act VARCHAR2 (100) NOT NULL , 
     ult_act_ubi  VARCHAR2 (100) NOT NULL 
    ) ;

ALTER TABLE USUARIO_SENSIBLE 
    ADD CONSTRAINT USUARIO_SENSIBLE_PK PRIMARY KEY ( id_persona ) ;

ALTER TABLE USUARIO_SENSIBLE 
    ADD CONSTRAINT USUARIO_SENSIBLE_UK UNIQUE ( id_usuario ) ;

CREATE TABLE VER_CUENTA_SENSIBLE 
    ( 
     id_vc                VARCHAR2 (5)   NOT NULL , 
     certifi_inha_seg     BLOB           NOT NULL , 
     est_verificacion     VARCHAR2 (100) NOT NULL , 
     fec_est_verificacion DATE           NOT NULL , 
     PROFESOR_id_profesor VARCHAR2 (5) , 
     fecha_validacion     DATE , 
     vigencia_validacion  VARCHAR2 (100) 
    ) ;

ALTER TABLE VER_CUENTA_SENSIBLE 
    ADD CONSTRAINT VER_CUENTA_SENS_CK CHECK ( 
        ( PROFESOR_id_profesor IS NULL AND fecha_validacion IS NULL AND vigencia_validacion IS NULL ) 
        OR 
        ( PROFESOR_id_profesor IS NOT NULL AND vigencia_validacion IS NOT NULL ) 
    ) ;

ALTER TABLE VER_CUENTA_SENSIBLE 
    ADD CONSTRAINT VER_CUENTA_SENSIBLE_PK PRIMARY KEY ( id_vc ) ;

--=================================================================================
-- CLAVES FORÁNEAS (FOREIGN KEYS) - BASE DE DATOS SENSIBLE
--=================================================================================

ALTER TABLE CLIENTE_SENSIBLE 
    ADD CONSTRAINT CLIENTE_SENS_PERSONA_FK FOREIGN KEY ( id_persona ) 
    REFERENCES PERSONA_SENSIBLE ( id_persona ) ;

ALTER TABLE PAGO_SENSIBLE 
    ADD CONSTRAINT PAGO_SENS_CLIENTE_FK FOREIGN KEY ( CLIENTE_id_cliente ) 
    REFERENCES CLIENTE_SENSIBLE ( id_cliente ) ;

ALTER TABLE PROFESOR_SENSIBLE 
    ADD CONSTRAINT PROFESOR_SENS_PERSONA_FK FOREIGN KEY ( id_persona ) 
    REFERENCES PERSONA_SENSIBLE ( id_persona ) ;

ALTER TABLE TITULO_SENSIBLE 
    ADD CONSTRAINT TITULO_SENS_PROFESOR_FK FOREIGN KEY ( PROFESOR_id_profesor ) 
    REFERENCES PROFESOR_SENSIBLE ( id_profesor ) ;

ALTER TABLE USUARIO_SENSIBLE 
    ADD CONSTRAINT USUARIO_SENS_PERSONA_FK FOREIGN KEY ( id_persona ) 
    REFERENCES PERSONA_SENSIBLE ( id_persona ) ;

ALTER TABLE VER_CUENTA_SENSIBLE 
    ADD CONSTRAINT VERIF_CUEN_SENS_PROF_FK FOREIGN KEY ( PROFESOR_id_profesor ) 
    REFERENCES PROFESOR_SENSIBLE ( id_profesor ) ;