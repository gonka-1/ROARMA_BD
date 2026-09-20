--------------------------------------------------
-- SCRIPT DDL - PROYECTO ROARMA
--------------------------------------------------

-- 1. PAIS
CREATE TABLE PAIS (
  id_pais VARCHAR2(5) NOT NULL,
  nombre_pais VARCHAR2(100) NOT NULL
);
ALTER TABLE PAIS ADD CONSTRAINT PAIS_PK PRIMARY KEY (id_pais);

-- 2. REGION
CREATE TABLE REGION (
  id_region VARCHAR2(5) NOT NULL,
  nombre_region VARCHAR2(100) NOT NULL,
  PAIS_id_pais VARCHAR2(5) NOT NULL
);
ALTER TABLE REGION ADD CONSTRAINT REGION_PK PRIMARY KEY (id_region);

-- 3. CIUDAD
CREATE TABLE CIUDAD (
  id_ciudad VARCHAR2(5) NOT NULL,
  nom_ciu VARCHAR2(100) NOT NULL,
  REGION_id_region VARCHAR2(5) NOT NULL,
  CIUDAD_ID NUMBER NOT NULL
);
ALTER TABLE CIUDAD ADD CONSTRAINT CIUDAD_PK PRIMARY KEY (CIUDAD_ID);
ALTER TABLE CIUDAD ADD CONSTRAINT CIUDAD_id_ciudad_UN UNIQUE (id_ciudad);

-- 4. DISPONIBILIDAD (se elimina columna duplicada run_pro; se mantiene PROFESOR_run_pro, que tiene la FK real)
CREATE TABLE DISPONIBILIDAD (
  id_dis VARCHAR2(10) NOT NULL,
  fec_dis DATE NOT NULL,
  hor_ini DATE NOT NULL,
  hor_ter DATE NOT NULL,
  est_dis VARCHAR2(20),
  modalidad VARCHAR2(15) NOT NULL,
  latitud VARCHAR2(10) NOT NULL,
  longitud VARCHAR2(10) NOT NULL,
  direccion VARCHAR2(150) NOT NULL,
  rad_cob_km VARCHAR2(150) NOT NULL,
  PROFESOR_run_pro VARCHAR2(13) NOT NULL
);
COMMENT ON COLUMN DISPONIBILIDAD.est_dis IS 'estado disponibilidad';
COMMENT ON COLUMN DISPONIBILIDAD.rad_cob_km IS 'radio cobertura kilometro';
ALTER TABLE DISPONIBILIDAD ADD CONSTRAINT DISPONIBILIDAD_PK PRIMARY KEY (id_dis);

-- 5. COMUNA
CREATE TABLE COMUNA (
  id_comuna VARCHAR2(5) NOT NULL,
  nombre_comuna VARCHAR2(100) NOT NULL,
  DISPONIBILIDAD_id_dis VARCHAR2(10),
  CIUDAD_CIUDAD_ID NUMBER NOT NULL
);
ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna);

-- 6. RESENA
CREATE TABLE RESENA (
  rese_id VARCHAR2(5) NOT NULL,
  id_cont VARCHAR2(5) NOT NULL,
  califi_rese FLOAT(2) NOT NULL,
  comen_rese VARCHAR2(280) NOT NULL
);
COMMENT ON COLUMN RESENA.comen_rese IS 'comentario resena';
ALTER TABLE RESENA ADD CONSTRAINT RESENA_PK PRIMARY KEY (rese_id);

-- 7. SOLICITUD (id_dis corregido a VARCHAR2(10) para calzar con DISPONIBILIDAD; run_usu_1 renombrado a USUARIO_run_per)
CREATE TABLE SOLICITUD (
  soli_id VARCHAR2(5) NOT NULL,
  USUARIO_run_per VARCHAR2(13) NOT NULL,
  id_dis VARCHAR2(10) NOT NULL,
  est_soli VARCHAR2(20) NOT NULL,
  fec_soli DATE NOT NULL
);
ALTER TABLE SOLICITUD ADD CONSTRAINT SOLICITUD_PK PRIMARY KEY (soli_id);

-- 8. PERSONA (se eliminan soli_id e id_msj: sin FK y redundantes con USUARIO y MENSAJE)
CREATE TABLE PERSONA (
  run_per VARCHAR2(13) NOT NULL,
  pnombre_per VARCHAR2(100) NOT NULL,
  snombre_per VARCHAR2(100),
  papellido_per VARCHAR2(100) NOT NULL,
  sapellido_per VARCHAR2(100),
  fec_nac_per DATE NOT NULL,
  email_per VARCHAR2(150) NOT NULL,
  tel_per VARCHAR2(12) NOT NULL,
  ant_per BLOB NOT NULL,
  COMUNA_id_comuna VARCHAR2(5) NOT NULL,
  RESENA_rese_id VARCHAR2(5)
);
COMMENT ON COLUMN PERSONA.ant_per IS 'antecedentes persona';
ALTER TABLE PERSONA ADD CONSTRAINT PERSONA_PK PRIMARY KEY (run_per);

-- 9. PROFESOR
CREATE TABLE PROFESOR (
  run_per VARCHAR2(13) NOT NULL,
  run_pro VARCHAR2(13) NOT NULL,
  bio_pro VARCHAR2(200) NOT NULL,
  latitud_act VARCHAR2(10) NOT NULL,
  longitud_act VARCHAR2(10) NOT NULL,
  ult_act_ubi DATE NOT NULL,
  cal_pro_pro FLOAT(2)
);
COMMENT ON COLUMN PROFESOR.bio_pro IS 'biografía profesor';
COMMENT ON COLUMN PROFESOR.latitud_act IS 'latitud actual';
COMMENT ON COLUMN PROFESOR.longitud_act IS 'longitud actual';
COMMENT ON COLUMN PROFESOR.cal_pro_pro IS 'calificacion promedio profesor';
ALTER TABLE PROFESOR ADD CONSTRAINT PROFESOR_PK PRIMARY KEY (run_per);
ALTER TABLE PROFESOR ADD CONSTRAINT PROFESOR_PKv1 UNIQUE (run_pro);

-- 10. CLIENTE (se elimina run_usu: sin FK, sin uso)
CREATE TABLE CLIENTE (
  run_per VARCHAR2(13) NOT NULL,
  id_cli VARCHAR2(5) NOT NULL,
  tip_cli VARCHAR2(100) NOT NULL,
  razon_soc_cli VARCHAR2(150) NOT NULL
);
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_PK PRIMARY KEY (run_per);
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_PKv1 UNIQUE (id_cli);

-- 11. USUARIO (se elimina rese_id: redundante con PERSONA_RESENA_FK)
CREATE TABLE USUARIO (
  run_per VARCHAR2(13) NOT NULL,
  id_usu VARCHAR2(5) NOT NULL,
  pass_usu VARCHAR2(100) NOT NULL,
  fec_reg DATE NOT NULL,
  tip_usu VARCHAR2(30) NOT NULL,
  latitud_act VARCHAR2(100) NOT NULL,
  longitud_act VARCHAR2(100) NOT NULL,
  ult_act_ubi VARCHAR2(100) NOT NULL,
  img_usu BLOB NOT NULL,
  SOLICITUD_soli_id VARCHAR2(5),
  CLIENTE_id_cli VARCHAR2(5) NOT NULL
);
COMMENT ON COLUMN USUARIO.ult_act_ubi IS 'ultima ubicación ';
ALTER TABLE USUARIO ADD CONSTRAINT USUARIO_PK PRIMARY KEY (run_per);
ALTER TABLE USUARIO ADD CONSTRAINT USUARIO_PKv1 UNIQUE (id_usu);

-- 12. CLASE
CREATE TABLE CLASE (
  id_clas VARCHAR2(5) NOT NULL,
  nom_clas VARCHAR2(100) NOT NULL,
  hora_ini DATE NOT NULL,
  hora_ter DATE NOT NULL,
  fec_clas DATE NOT NULL,
  ra_clas VARCHAR2(150) NOT NULL,
  PROFESOR_run_pro VARCHAR2(13) NOT NULL,
  CLASE_ID NUMBER NOT NULL
);
COMMENT ON COLUMN CLASE.ra_clas IS 'Resultado de aprendizaje';
ALTER TABLE CLASE ADD CONSTRAINT CLASE_PK PRIMARY KEY (CLASE_ID);

-- 13. MENSAJE (se elimina run_usu: redundante con PERSONA_run_per)
CREATE TABLE MENSAJE (
  id_msj VARCHAR2(5) NOT NULL,
  id_conv VARCHAR2(5) NOT NULL,
  cont_msj VARCHAR2(280) NOT NULL,
  fec_hora_msj DATE NOT NULL,
  PERSONA_run_per VARCHAR2(13) NOT NULL
);
ALTER TABLE MENSAJE ADD CONSTRAINT MENSAJE_PK PRIMARY KEY (id_msj);

-- 14. CONVERSACION
CREATE TABLE CONVERSACION (
  id_conv VARCHAR2(5) NOT NULL,
  fech_ini DATE NOT NULL,
  MENSAJE_id_msj VARCHAR2(5) NOT NULL
);
ALTER TABLE CONVERSACION ADD CONSTRAINT CONVERSACION_PK PRIMARY KEY (id_conv);

-- 15. PAGO (se elimina id_cont: duplicado de CONTRATO_id_cont)
CREATE TABLE PAGO (
  id_pago VARCHAR2(5) NOT NULL,
  monto_pago VARCHAR2(20) NOT NULL,
  fec_pago DATE NOT NULL,
  metodo_pago VARCHAR2(15) NOT NULL,
  estado_pago VARCHAR2(20) NOT NULL,
  CONTRATO_id_cont VARCHAR2(5) NOT NULL,
  CLIENTE_id_cli VARCHAR2(5) NOT NULL
);
ALTER TABLE PAGO ADD CONSTRAINT PAGO_PK PRIMARY KEY (id_pago);

-- 16. CONTRATO 
CREATE TABLE CONTRATO (
  id_cont VARCHAR2(5) NOT NULL,
  monto_acor VARCHAR2(20) NOT NULL,
  duracion_cont VARCHAR2(10) NOT NULL,
  estado_cont VARCHAR2(20) NOT NULL,
  fec_acue_cont DATE NOT NULL,
  SOLICITUD_soli_id VARCHAR2(5) NOT NULL,
  PAGO_id_pago VARCHAR2(5) NOT NULL,
  CLIENTE_id_cli VARCHAR2(5) NOT NULL,
  PROFESOR_run_pro VARCHAR2(13) NOT NULL
);
ALTER TABLE CONTRATO ADD CONSTRAINT CONTRATO_PK PRIMARY KEY (id_cont);

-- 17. ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
  id_esp VARCHAR2(5) NOT NULL,
  nom_esp VARCHAR2(150) NOT NULL,
  anio_exp_esp VARCHAR2(20) NOT NULL
);
COMMENT ON COLUMN ESPECIALIDAD.id_esp IS 'especialidad';
ALTER TABLE ESPECIALIDAD ADD CONSTRAINT ESPECIALIDAD_PK PRIMARY KEY (id_esp);

-- 18. VALOR_HORA (se elimina run_pro: la relación PROFESOR-VALOR_HORA ya es N:M vía Detallar)
CREATE TABLE VALOR_HORA (
  id_valor_hora VARCHAR2(5) NOT NULL,
  tar_hor VARCHAR2(20) NOT NULL,
  VALOR_HORA_ID NUMBER NOT NULL
);
ALTER TABLE VALOR_HORA ADD CONSTRAINT VALOR_HORA_PK PRIMARY KEY (VALOR_HORA_ID);
ALTER TABLE VALOR_HORA ADD CONSTRAINT VALOR_HORA_id_valor_hora_UN UNIQUE (id_valor_hora);

-- 19. TITULO (se elimina run_pro: duplicado de PROFESOR_run_pro)
CREATE TABLE TITULO (
  id_titu VARCHAR2(5) NOT NULL,
  men_titu VARCHAR2(150) NOT NULL,
  cas_est VARCHAR2(150) NOT NULL,
  anio_titu DATE NOT NULL,
  cer_titu BLOB,
  PROFESOR_run_pro VARCHAR2(13) NOT NULL
);
COMMENT ON COLUMN TITULO.men_titu IS 'mención titulo';
COMMENT ON COLUMN TITULO.cas_est IS 'casa de estudio';
COMMENT ON COLUMN TITULO.cer_titu IS 'certificado titulo';
ALTER TABLE TITULO ADD CONSTRAINT TITULO_PK PRIMARY KEY (id_titu);

-- 20. VERIFICACION_CUENTA (run_pro ahora es la FK obligatoria al profesor dueño de la verificación;
--     PROFESOR_run_pro queda solo para el bloque opcional de validación, junto a fecha_validacion/vigencia_validacion)
CREATE TABLE VERIFICACION_CUENTA (
  id_seg VARCHAR2(5) NOT NULL,
  certifi_inha_seg BLOB NOT NULL,
  run_pro VARCHAR2(13) NOT NULL,
  est_verificacion VARCHAR2(30) NOT NULL,
  fec_est_ver DATE NOT NULL,
  PROFESOR_run_pro VARCHAR2(13),
  fecha_validacion DATE,
  vigencia_validacion NUMBER(2)
);
ALTER TABLE VERIFICACION_CUENTA ADD CHECK ( ( PROFESOR_run_pro IS NULL AND fecha_validacion IS NULL AND vigencia_validacion IS NULL) OR ( PROFESOR_run_pro IS NOT NULL AND fecha_validacion IS NOT NULL AND vigencia_validacion IS NOT NULL) );
ALTER TABLE VERIFICACION_CUENTA ADD CONSTRAINT VERIF_CUENTA_PK PRIMARY KEY (id_seg);

--------------------------------------------------
-- TABLAS DE RELACIÓN MUCHOS A MUCHOS
--------------------------------------------------

CREATE TABLE CURSAR (
  CLASE_CLASE_ID NUMBER NOT NULL,
  USUARIO_run_per VARCHAR2(13) NOT NULL
);
ALTER TABLE CURSAR ADD CONSTRAINT CURSAR_PK PRIMARY KEY (CLASE_CLASE_ID, USUARIO_run_per);

CREATE TABLE Detallar (
  PROFESOR_run_per VARCHAR2(13) NOT NULL,
  VALOR_HORA_VALOR_HORA_ID NUMBER NOT NULL
);
ALTER TABLE Detallar ADD CONSTRAINT Detallar_PK PRIMARY KEY (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID);

CREATE TABLE INSCRIBIR (
  PROFESOR_run_per VARCHAR2(13) NOT NULL,
  ESPECIALIDAD_id_esp VARCHAR2(5) NOT NULL
);
ALTER TABLE INSCRIBIR ADD CONSTRAINT INSCRIBIR_PK PRIMARY KEY (PROFESOR_run_per, ESPECIALIDAD_id_esp);

--------------------------------------------------
-- RESTRICCIONES DE CLAVES FORÁNEAS (FOREIGN KEYS)
--------------------------------------------------

ALTER TABLE REGION ADD CONSTRAINT REGION_PAIS_FK FOREIGN KEY (PAIS_id_pais) REFERENCES PAIS (id_pais);

ALTER TABLE CIUDAD ADD CONSTRAINT CIUDAD_REGION_FK FOREIGN KEY (REGION_id_region) REFERENCES REGION (id_region);

ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_CIUDAD_FK FOREIGN KEY (CIUDAD_CIUDAD_ID) REFERENCES CIUDAD (CIUDAD_ID);
ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_DISPONIBILIDAD_FK FOREIGN KEY (DISPONIBILIDAD_id_dis) REFERENCES DISPONIBILIDAD (id_dis);

ALTER TABLE PERSONA ADD CONSTRAINT PERSONA_COMUNA_FK FOREIGN KEY (COMUNA_id_comuna) REFERENCES COMUNA (id_comuna);
ALTER TABLE PERSONA ADD CONSTRAINT PERSONA_RESENA_FK FOREIGN KEY (RESENA_rese_id) REFERENCES RESENA (rese_id);

ALTER TABLE PROFESOR ADD CONSTRAINT PROFESOR_PERSONA_FK FOREIGN KEY (run_per) REFERENCES PERSONA (run_per);

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_PERSONA_FK FOREIGN KEY (run_per) REFERENCES PERSONA (run_per);

ALTER TABLE USUARIO ADD CONSTRAINT USUARIO_PERSONA_FK FOREIGN KEY (run_per) REFERENCES PERSONA (run_per);
ALTER TABLE USUARIO ADD CONSTRAINT USUARIO_CLIENTE_FK FOREIGN KEY (CLIENTE_id_cli) REFERENCES CLIENTE (id_cli);
ALTER TABLE USUARIO ADD CONSTRAINT USUARIO_SOLICITUD_FK FOREIGN KEY (SOLICITUD_soli_id) REFERENCES SOLICITUD (soli_id);

ALTER TABLE SOLICITUD ADD CONSTRAINT SOLICITUD_USUARIO_FK FOREIGN KEY (USUARIO_run_per) REFERENCES USUARIO (run_per);
ALTER TABLE SOLICITUD ADD CONSTRAINT SOLICITUD_DISPONIBILIDAD_FK FOREIGN KEY (id_dis) REFERENCES DISPONIBILIDAD (id_dis);

ALTER TABLE DISPONIBILIDAD ADD CONSTRAINT DISPONIBILIDAD_PROFESOR_FK FOREIGN KEY (PROFESOR_run_pro) REFERENCES PROFESOR (run_pro);

ALTER TABLE CLASE ADD CONSTRAINT CLASE_PROFESOR_FK FOREIGN KEY (PROFESOR_run_pro) REFERENCES PROFESOR (run_pro);

ALTER TABLE MENSAJE ADD CONSTRAINT MENSAJE_PERSONA_FK FOREIGN KEY (PERSONA_run_per) REFERENCES PERSONA (run_per);

ALTER TABLE CONVERSACION ADD CONSTRAINT CONVERSACION_MENSAJE_FK FOREIGN KEY (MENSAJE_id_msj) REFERENCES MENSAJE (id_msj);

ALTER TABLE RESENA ADD CONSTRAINT RESENA_CONTRATO_FK FOREIGN KEY (id_cont) REFERENCES CONTRATO (id_cont);

ALTER TABLE PAGO ADD CONSTRAINT PAGO_CLIENTE_FK FOREIGN KEY (CLIENTE_id_cli) REFERENCES CLIENTE (id_cli);
ALTER TABLE PAGO ADD CONSTRAINT PAGO_CONTRATO_FK FOREIGN KEY (CONTRATO_id_cont) REFERENCES CONTRATO (id_cont);

ALTER TABLE CONTRATO ADD CONSTRAINT CONTRATO_CLIENTE_FK FOREIGN KEY (CLIENTE_id_cli) REFERENCES CLIENTE (id_cli);
ALTER TABLE CONTRATO ADD CONSTRAINT CONTRATO_PROFESOR_FK FOREIGN KEY (PROFESOR_run_pro) REFERENCES PROFESOR (run_pro);
ALTER TABLE CONTRATO ADD CONSTRAINT CONTRATO_SOLICITUD_FK FOREIGN KEY (SOLICITUD_soli_id) REFERENCES SOLICITUD (soli_id);
ALTER TABLE CONTRATO ADD CONSTRAINT CONTRATO_PAGO_FK FOREIGN KEY (PAGO_id_pago) REFERENCES PAGO (id_pago);

ALTER TABLE TITULO ADD CONSTRAINT TITULO_PROFESOR_FK FOREIGN KEY (PROFESOR_run_pro) REFERENCES PROFESOR (run_pro);

ALTER TABLE VERIFICACION_CUENTA ADD CONSTRAINT VERIF_CUENTA_PROFESOR_FK FOREIGN KEY (run_pro) REFERENCES PROFESOR (run_pro);

ALTER TABLE CURSAR ADD CONSTRAINT CURSAR_CLASE_FK FOREIGN KEY (CLASE_CLASE_ID) REFERENCES CLASE (CLASE_ID);
ALTER TABLE CURSAR ADD CONSTRAINT CURSAR_USUARIO_FK FOREIGN KEY (USUARIO_run_per) REFERENCES USUARIO (run_per);

ALTER TABLE Detallar ADD CONSTRAINT Detallar_PROFESOR_FK FOREIGN KEY (PROFESOR_run_per) REFERENCES PROFESOR (run_per);
ALTER TABLE Detallar ADD CONSTRAINT Detallar_VALOR_HORA_FK FOREIGN KEY (VALOR_HORA_VALOR_HORA_ID) REFERENCES VALOR_HORA (VALOR_HORA_ID);

ALTER TABLE INSCRIBIR ADD CONSTRAINT INSCRIBIR_ESPECIALIDAD_FK FOREIGN KEY (ESPECIALIDAD_id_esp) REFERENCES ESPECIALIDAD (id_esp);
ALTER TABLE INSCRIBIR ADD CONSTRAINT INSCRIBIR_PROFESOR_FK FOREIGN KEY (PROFESOR_run_per) REFERENCES PROFESOR (run_per);

--------------------------------------------------
-- SECUENCIAS Y TRIGGERS PARA AUTOINCREMENTALES
--------------------------------------------------

CREATE SEQUENCE CIUDAD_CIUDAD_ID_SEQ START WITH 1 NOCACHE ORDER;
CREATE OR REPLACE TRIGGER CIUDAD_CIUDAD_ID_TRG
BEFORE INSERT ON CIUDAD FOR EACH ROW
WHEN (NEW.CIUDAD_ID IS NULL)
BEGIN
  :NEW.CIUDAD_ID := CIUDAD_CIUDAD_ID_SEQ.NEXTVAL;
END;
/

CREATE SEQUENCE CLASE_CLASE_ID_SEQ START WITH 1 NOCACHE ORDER;
CREATE OR REPLACE TRIGGER CLASE_CLASE_ID_TRG
BEFORE INSERT ON CLASE FOR EACH ROW
WHEN (NEW.CLASE_ID IS NULL)
BEGIN
  :NEW.CLASE_ID := CLASE_CLASE_ID_SEQ.NEXTVAL;
END;
/

CREATE SEQUENCE VALOR_HORA_VALOR_HORA_ID_SEQ START WITH 1 NOCACHE ORDER;
CREATE OR REPLACE TRIGGER VALOR_HORA_VALOR_HORA_ID_TRG
BEFORE INSERT ON VALOR_HORA FOR EACH ROW
WHEN (NEW.VALOR_HORA_ID IS NULL)
BEGIN
  :NEW.VALOR_HORA_ID := VALOR_HORA_VALOR_HORA_ID_SEQ.NEXTVAL;
END;
/

--------------------------------------------------
-- INSERCIONES DE TABLAS:
--------------------------------------------------

INSERT INTO PAIS (id_pais, nombre_pais) VALUES ('CL', 'Chile');

INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R01', 'Region de Arica y Parinacota', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R02', 'Region de Tarapaca', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R03', 'Region de Antofagasta', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R04', 'Region de Atacama', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R05', 'Region de Coquimbo', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R06', 'Region de Valparaiso', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R07', 'Region Metropolitana de Santiago', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R08', 'Region del Libertador General Bernardo OHiggins', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R09', 'Region del Maule', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R10', 'Region de Nuble', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R11', 'Region del Biobio', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R12', 'Region de la Araucania', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R13', 'Region de Los Rios', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R14', 'Region de Los Lagos', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R15', 'Region de Aysen del General Carlos Ibanez del Campo', 'CL');
INSERT INTO REGION (id_region, nombre_region, PAIS_id_pais) VALUES ('R16', 'Region de Magallanes y de la Antartica Chilena', 'CL');

INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C001', 'Arica', 'R01');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C002', 'Putre', 'R01');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C003', 'Iquique', 'R02');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C004', 'Alto Hospicio', 'R02');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C005', 'Antofagasta', 'R03');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C006', 'Calama', 'R03');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C007', 'Tocopilla', 'R03');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C008', 'Copiapo', 'R04');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C009', 'Vallenar', 'R04');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C010', 'La Serena', 'R05');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C011', 'Coquimbo', 'R05');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C012', 'Ovalle', 'R05');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C013', 'Valparaiso', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C014', 'Vina del Mar', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C015', 'San Antonio', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C016', 'Quillota', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C017', 'San Felipe', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C018', 'Los Andes', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C019', 'Quilpue', 'R06');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C020', 'Santiago', 'R07');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C021', 'Rancagua', 'R08');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C022', 'San Fernando', 'R08');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C023', 'Rengo', 'R08');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C024', 'Talca', 'R09');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C025', 'Curico', 'R09');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C026', 'Linares', 'R09');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C027', 'Cauquenes', 'R09');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C028', 'Chillan', 'R10');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C029', 'San Carlos', 'R10');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C030', 'Concepcion', 'R11');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C031', 'Los Angeles', 'R11');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C032', 'Talcahuano', 'R11');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C033', 'Coronel', 'R11');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C034', 'Lota', 'R11');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C035', 'Tome', 'R11');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C036', 'Temuco', 'R12');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C037', 'Angol', 'R12');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C038', 'Victoria', 'R12');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C039', 'Villarrica', 'R12');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C040', 'Valdivia', 'R13');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C041', 'La Union', 'R13');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C042', 'Panguipulli', 'R13');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C043', 'Puerto Montt', 'R14');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C044', 'Osorno', 'R14');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C045', 'Castro', 'R14');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C046', 'Ancud', 'R14');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C047', 'Coyhaique', 'R15');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C048', 'Puerto Aysen', 'R15');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C049', 'Punta Arenas', 'R16');
INSERT INTO CIUDAD (id_ciudad, nom_ciu, REGION_id_region) VALUES ('C050', 'Puerto Natales', 'R16');

INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM01', 'Santiago', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM02', 'Providencia', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM03', 'Las Condes', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM04', 'Nunoa', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM05', 'Puente Alto', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM06', 'Maipu', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM07', 'La Florida', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM08', 'San Bernardo', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM09', 'Vitacura', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM10', 'La Reina', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C020'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM11', 'Valparaiso', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C013'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM12', 'Vina del Mar', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C014'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM13', 'Concepcion', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C030'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM14', 'San Pedro de la Paz', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C030'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM15', 'Talcahuano', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C032'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM16', 'Temuco', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C036'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM17', 'La Serena', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C010'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM18', 'Coquimbo', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C011'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM19', 'Antofagasta', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C005'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM20', 'Puerto Montt', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C043'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM21', 'Rancagua', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C021'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM22', 'Talca', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C024'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM23', 'Chillan', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C028'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM24', 'Iquique', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C003'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM25', 'Alto Hospicio', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C004'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM26', 'Punta Arenas', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C049'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM27', 'Valdivia', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C040'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM28', 'Copiapo', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C008'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM29', 'Arica', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C001'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM30', 'Calama', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C006'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM31', 'Los Angeles', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C031'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM32', 'Osorno', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C044'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM33', 'Curico', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C025'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM34', 'Linares', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C026'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM35', 'Angol', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C037'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM36', 'San Fernando', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C022'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM37', 'Coyhaique', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C047'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM38', 'Castro', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C045'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM39', 'Quillota', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C016'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM40', 'San Felipe', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C017'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM41', 'Los Andes', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C018'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM42', 'San Antonio', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C015'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM43', 'Villarrica', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C039'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM44', 'Victoria', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C038'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM45', 'La Union', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C041'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM46', 'Ancud', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C046'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM47', 'Puerto Natales', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C050'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM48', 'Vallenar', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C009'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM49', 'Ovalle', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C012'));
INSERT INTO COMUNA (id_comuna, nombre_comuna, CIUDAD_CIUDAD_ID) VALUES ('COM50', 'San Carlos', (SELECT CIUDAD_ID FROM CIUDAD WHERE id_ciudad = 'C029'));

INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.009.181-1', 'Jose', 'Alberto', 'Gonzalez', 'Munoz', TO_DATE('1985-03-12','YYYY-MM-DD'), 'jose.gonzalez@correo.com', '910000001', EMPTY_BLOB(), 'COM01');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.009.362-2', 'Maria', 'Fernanda', 'Munoz', 'Rojas', TO_DATE('1990-07-24','YYYY-MM-DD'), 'maria.munoz@correo.com', '910000002', EMPTY_BLOB(), 'COM02');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.009.543-3', 'Juan', 'Carlos', 'Rojas', 'Diaz', TO_DATE('1978-11-02','YYYY-MM-DD'), 'juan.rojas@correo.com', '910000003', EMPTY_BLOB(), 'COM03');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.009.724-4', 'Carolina', 'Andrea', 'Diaz', 'Perez', TO_DATE('1995-01-30','YYYY-MM-DD'), 'carolina.diaz@correo.com', '910000004', EMPTY_BLOB(), 'COM04');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.009.905-5', 'Francisca', 'Javiera', 'Perez', 'Soto', TO_DATE('1988-05-19','YYYY-MM-DD'), 'francisca.perez@correo.com', '910000005', EMPTY_BLOB(), 'COM05');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.010.086-6', 'Camila', 'Antonia', 'Soto', 'Silva', TO_DATE('1999-09-08','YYYY-MM-DD'), 'camila.soto@correo.com', '910000006', EMPTY_BLOB(), 'COM06');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.010.267-7', 'Matias', 'Ignacio', 'Silva', 'Contreras', TO_DATE('1992-12-15','YYYY-MM-DD'), 'matias.silva@correo.com', '910000007', EMPTY_BLOB(), 'COM07');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.010.448-8', 'Sebastian', 'Andres', 'Contreras', 'Sepulveda', TO_DATE('1983-04-27','YYYY-MM-DD'), 'sebastian.contreras@correo.com', '910000008', EMPTY_BLOB(), 'COM08');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.010.629-9', 'Nicolas', 'Eduardo', 'Sepulveda', 'Morales', TO_DATE('1997-06-11','YYYY-MM-DD'), 'nicolas.sepulveda@correo.com', '910000009', EMPTY_BLOB(), 'COM09');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.010.810-K', 'Ignacio', 'Tomas', 'Morales', 'Rodriguez', TO_DATE('1980-08-05','YYYY-MM-DD'), 'ignacio.morales@correo.com', '910000010', EMPTY_BLOB(), 'COM10');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.010.991-1', 'Valentina', 'Isidora', 'Rodriguez', 'Lopez', TO_DATE('1994-02-17','YYYY-MM-DD'), 'valentina.rodriguez@correo.com', '910000011', EMPTY_BLOB(), 'COM11');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.011.172-2', 'Javiera', 'Constanza', 'Lopez', 'Fuentes', TO_DATE('1991-10-22','YYYY-MM-DD'), 'javiera.lopez@correo.com', '910000012', EMPTY_BLOB(), 'COM12');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.011.353-3', 'Antonia', 'Belen', 'Fuentes', 'Hernandez', TO_DATE('1986-07-03','YYYY-MM-DD'), 'antonia.fuentes@correo.com', '910000013', EMPTY_BLOB(), 'COM13');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.011.534-4', 'Constanza', 'Paz', 'Hernandez', 'Torres', TO_DATE('1998-03-29','YYYY-MM-DD'), 'constanza.hernandez@correo.com', '910000014', EMPTY_BLOB(), 'COM14');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.011.715-5', 'Fernanda', 'Ines', 'Torres', 'Araya', TO_DATE('1982-09-14','YYYY-MM-DD'), 'fernanda.torres@correo.com', '910000015', EMPTY_BLOB(), 'COM15');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.011.896-6', 'Catalina', 'Soledad', 'Araya', 'Flores', TO_DATE('1996-11-08','YYYY-MM-DD'), 'catalina.araya@correo.com', '910000016', EMPTY_BLOB(), 'COM16');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.012.077-7', 'Diego', 'Alonso', 'Flores', 'Espinoza', TO_DATE('1993-01-25','YYYY-MM-DD'), 'diego.flores@correo.com', '910000017', EMPTY_BLOB(), 'COM17');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.012.258-8', 'Cristobal', 'Ignacio', 'Espinoza', 'Valenzuela', TO_DATE('1979-06-30','YYYY-MM-DD'), 'cristobal.espinoza@correo.com', '910000018', EMPTY_BLOB(), 'COM18');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.012.439-9', 'Rodrigo', 'Alexis', 'Valenzuela', 'Castillo', TO_DATE('2000-04-04','YYYY-MM-DD'), 'rodrigo.valenzuela@correo.com', '910000019', EMPTY_BLOB(), 'COM19');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.012.620-K', 'Andres', 'Felipe', 'Castillo', 'Reyes', TO_DATE('1987-08-19','YYYY-MM-DD'), 'andres.castillo@correo.com', '910000020', EMPTY_BLOB(), 'COM20');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.012.801-1', 'Felipe', 'Antonio', 'Reyes', 'Gutierrez', TO_DATE('1984-12-01','YYYY-MM-DD'), 'felipe.reyes@correo.com', '910000021', EMPTY_BLOB(), 'COM21');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.012.982-2', 'Gonzalo', 'Esteban', 'Gutierrez', 'Alvarez', TO_DATE('1990-02-27','YYYY-MM-DD'), 'gonzalo.gutierrez@correo.com', '910000022', EMPTY_BLOB(), 'COM22');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.013.163-3', 'Pablo', 'Nicolas', 'Alvarez', 'Vasquez', TO_DATE('1976-05-16','YYYY-MM-DD'), 'pablo.alvarez@correo.com', '910000023', EMPTY_BLOB(), 'COM23');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.013.344-4', 'Ricardo', 'Andres', 'Vasquez', 'Ramirez', TO_DATE('1989-10-09','YYYY-MM-DD'), 'ricardo.vasquez@correo.com', '910000024', EMPTY_BLOB(), 'COM24');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.013.525-5', 'Eduardo', 'Jose', 'Ramirez', 'Tapia', TO_DATE('1994-07-21','YYYY-MM-DD'), 'eduardo.ramirez@correo.com', '910000025', EMPTY_BLOB(), 'COM25');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.013.706-6', 'Manuel', 'Alejandro', 'Tapia', 'Vergara', TO_DATE('1981-03-13','YYYY-MM-DD'), 'manuel.tapia@correo.com', '910000026', EMPTY_BLOB(), 'COM26');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.013.887-7', 'Francisco', 'Javier', 'Vergara', 'Carrasco', TO_DATE('1997-09-06','YYYY-MM-DD'), 'francisco.vergara@correo.com', '910000027', EMPTY_BLOB(), 'COM27');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.014.068-8', 'Alejandro', 'Ismael', 'Carrasco', 'Bravo', TO_DATE('1975-11-28','YYYY-MM-DD'), 'alejandro.carrasco@correo.com', '910000028', EMPTY_BLOB(), 'COM28');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.014.249-9', 'Daniela', 'Alejandra', 'Bravo', 'Sanchez', TO_DATE('1992-04-17','YYYY-MM-DD'), 'daniela.bravo@correo.com', '910000029', EMPTY_BLOB(), 'COM29');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.014.430-K', 'Paula', 'Ximena', 'Sanchez', 'Vera', TO_DATE('1985-01-10','YYYY-MM-DD'), 'paula.sanchez@correo.com', '910000030', EMPTY_BLOB(), 'COM30');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.014.611-1', 'Carla', 'Beatriz', 'Vera', 'Molina', TO_DATE('1999-06-23','YYYY-MM-DD'), 'carla.vera@correo.com', '910000031', EMPTY_BLOB(), 'COM31');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.014.792-2', 'Monica', 'Loreto', 'Molina', 'Sandoval', TO_DATE('1978-08-02','YYYY-MM-DD'), 'monica.molina@correo.com', '910000032', EMPTY_BLOB(), 'COM32');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.014.973-3', 'Veronica', 'Elena', 'Sandoval', 'Aguilera', TO_DATE('1988-12-19','YYYY-MM-DD'), 'veronica.sandoval@correo.com', '910000033', EMPTY_BLOB(), 'COM33');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.015.154-4', 'Patricia', 'Isabel', 'Aguilera', 'Salazar', TO_DATE('1983-05-31','YYYY-MM-DD'), 'patricia.aguilera@correo.com', '910000034', EMPTY_BLOB(), 'COM34');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.015.335-5', 'Claudia', 'Marcela', 'Salazar', 'Cortes', TO_DATE('1996-02-14','YYYY-MM-DD'), 'claudia.salazar@correo.com', '910000035', EMPTY_BLOB(), 'COM35');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.015.516-6', 'Marcela', 'Andrea', 'Cortes', 'Vidal', TO_DATE('1991-07-07','YYYY-MM-DD'), 'marcela.cortes@correo.com', '910000036', EMPTY_BLOB(), 'COM36');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.015.697-7', 'Pamela', 'Soledad', 'Vidal', 'Riquelme', TO_DATE('1980-10-26','YYYY-MM-DD'), 'pamela.vidal@correo.com', '910000037', EMPTY_BLOB(), 'COM37');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.015.878-8', 'Loreto', 'Fernanda', 'Riquelme', 'Mora', TO_DATE('1994-09-15','YYYY-MM-DD'), 'loreto.riquelme@correo.com', '910000038', EMPTY_BLOB(), 'COM38');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.016.059-9', 'Ximena', 'Paz', 'Mora', 'Pizarro', TO_DATE('1977-03-20','YYYY-MM-DD'), 'ximena.mora@correo.com', '910000039', EMPTY_BLOB(), 'COM39');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.016.240-K', 'Alejandra', 'Ines', 'Pizarro', 'Ortiz', TO_DATE('1993-11-11','YYYY-MM-DD'), 'alejandra.pizarro@correo.com', '910000040', EMPTY_BLOB(), 'COM40');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.016.421-1', 'Gabriela', 'Antonia', 'Ortiz', 'Fernandez', TO_DATE('1986-06-04','YYYY-MM-DD'), 'gabriela.ortiz@correo.com', '910000041', EMPTY_BLOB(), 'COM41');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.016.602-2', 'Isidora', 'Camila', 'Fernandez', 'Guzman', TO_DATE('1998-08-28','YYYY-MM-DD'), 'isidora.fernandez@correo.com', '910000042', EMPTY_BLOB(), 'COM42');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.016.783-3', 'Martina', 'Sofia', 'Guzman', 'Campos', TO_DATE('1982-01-09','YYYY-MM-DD'), 'martina.guzman@correo.com', '910000043', EMPTY_BLOB(), 'COM43');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.016.964-4', 'Emilia', 'Josefa', 'Campos', 'Cabrera', TO_DATE('1990-05-24','YYYY-MM-DD'), 'emilia.campos@correo.com', '910000044', EMPTY_BLOB(), 'COM44');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.017.145-5', 'Amanda', 'Trinidad', 'Cabrera', 'Roman', TO_DATE('1974-12-12','YYYY-MM-DD'), 'amanda.cabrera@correo.com', '910000045', EMPTY_BLOB(), 'COM45');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.017.326-6', 'Renata', 'Valentina', 'Roman', 'Leiva', TO_DATE('1995-04-06','YYYY-MM-DD'), 'renata.roman@correo.com', '910000046', EMPTY_BLOB(), 'COM46');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.017.507-7', 'Agustin', 'Vicente', 'Leiva', 'Jara', TO_DATE('1987-10-18','YYYY-MM-DD'), 'agustin.leiva@correo.com', '910000047', EMPTY_BLOB(), 'COM47');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.017.688-8', 'Tomas', 'Ignacio', 'Jara', 'Barrera', TO_DATE('2001-02-02','YYYY-MM-DD'), 'tomas.jara@correo.com', '910000048', EMPTY_BLOB(), 'COM48');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.017.869-9', 'Vicente', 'Maximiliano', 'Barrera', 'Ulloa', TO_DATE('1984-09-27','YYYY-MM-DD'), 'vicente.barrera@correo.com', '910000049', EMPTY_BLOB(), 'COM49');
INSERT INTO PERSONA (run_per, pnombre_per, snombre_per, papellido_per, sapellido_per, fec_nac_per, email_per, tel_per, ant_per, COMUNA_id_comuna) VALUES ('10.018.050-K', 'Benjamin', 'Joaquin', 'Ulloa', 'Bustos', TO_DATE('1979-07-15','YYYY-MM-DD'), 'benjamin.ulloa@correo.com', '910000050', EMPTY_BLOB(), 'COM50');

INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.009.181-1', 'PRO00001', 'Profesor de Matematicas con experiencia en ensenanza escolar y preuniversitaria.', '-33.4489', '-70.6693', TO_DATE('2025-01-15','YYYY-MM-DD'), 4.8);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.009.362-2', 'PRO00002', 'Profesora de Fisica, enfocada en preparacion PAES y reforzamiento escolar.', '-33.4269', '-70.6083', TO_DATE('2025-01-16','YYYY-MM-DD'), 4.6);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.009.543-3', 'PRO00003', 'Profesor de Quimica con enfoque en laboratorio y experimentos practicos.', '-33.4089', '-70.5661', TO_DATE('2025-01-17','YYYY-MM-DD'), 4.3);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.009.724-4', 'PRO00004', 'Profesora de Ingles, certificacion internacional y clases conversacionales.', '-33.4560', '-70.5987', TO_DATE('2025-01-18','YYYY-MM-DD'), 4.9);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.009.905-5', 'PRO00005', 'Profesora de Historia y Ciencias Sociales, especialista en ensayo argumentativo.', '-33.6109', '-70.5755', TO_DATE('2025-01-19','YYYY-MM-DD'), 4.2);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.010.086-6', 'PRO00006', 'Profesora de Lenguaje y Comunicacion, apoyo en comprension lectora.', '-33.5106', '-70.7570', TO_DATE('2025-01-20','YYYY-MM-DD'), 4.7);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.010.267-7', 'PRO00007', 'Profesor de Biologia, orientado a preparacion de examenes de admision.', '-33.5241', '-70.5979', TO_DATE('2025-01-21','YYYY-MM-DD'), 4.4);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.010.448-8', 'PRO00008', 'Profesor de Programacion, clases de Python y logica computacional.', '-33.5928', '-70.7048', TO_DATE('2025-01-22','YYYY-MM-DD'), 5.0);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.010.629-9', 'PRO00009', 'Profesor de Musica, especialista en guitarra y teoria musical.', '-33.3891', '-70.5730', TO_DATE('2025-01-23','YYYY-MM-DD'), 4.1);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.010.810-K', 'PRO00010', 'Profesor de Educacion Fisica y preparador de acondicionamiento general.', '-33.4436', '-70.5354', TO_DATE('2025-01-24','YYYY-MM-DD'), 4.5);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.010.991-1', 'PRO00011', 'Profesora de Artes Visuales, clases de dibujo y pintura para todas las edades.', '-33.0472', '-71.6127', TO_DATE('2025-01-25','YYYY-MM-DD'), 4.6);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.011.172-2', 'PRO00012', 'Profesora de Filosofia, enfocada en pensamiento critico y argumentacion.', '-33.0245', '-71.5518', TO_DATE('2025-01-26','YYYY-MM-DD'), 4.0);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.011.353-3', 'PRO00013', 'Profesora de Economia, apoyo en cursos de ensenanza media y universitarios.', '-36.8201', '-73.0444', TO_DATE('2025-01-27','YYYY-MM-DD'), 4.3);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.011.534-4', 'PRO00014', 'Profesora de Contabilidad, especialista en primeros anos de carrera.', '-36.8383', '-73.1108', TO_DATE('2025-01-28','YYYY-MM-DD'), 4.7);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.011.715-5', 'PRO00015', 'Profesora de Estadistica aplicada a ingenieria y ciencias sociales.', '-36.7249', '-73.1169', TO_DATE('2025-01-29','YYYY-MM-DD'), 4.8);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.011.896-6', 'PRO00016', 'Profesora de Calculo I y II, metodologia paso a paso para universitarios.', '-38.7359', '-72.5904', TO_DATE('2025-01-30','YYYY-MM-DD'), 4.9);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.012.077-7', 'PRO00017', 'Profesor de Algebra y preparacion para pruebas de admision universitaria.', '-29.9027', '-71.2519', TO_DATE('2025-02-01','YYYY-MM-DD'), 4.2);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.012.258-8', 'PRO00018', 'Profesor de Geografia, especialista en cartografia y geopolitica.', '-29.9533', '-71.3436', TO_DATE('2025-02-02','YYYY-MM-DD'), 3.9);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.012.439-9', 'PRO00019', 'Profesor de Robotica educativa, clases con Arduino y programacion basica.', '-23.6509', '-70.3975', TO_DATE('2025-02-03','YYYY-MM-DD'), 4.6);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.012.620-K', 'PRO00020', 'Profesor de Diseno Grafico, especialista en herramientas digitales.', '-41.4693', '-72.9424', TO_DATE('2025-02-04','YYYY-MM-DD'), 4.4);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.012.801-1', 'PRO00021', 'Profesora de Marketing Digital, orientada a estudiantes de negocios.', '-34.1708', '-70.7444', TO_DATE('2025-02-05','YYYY-MM-DD'), 4.5);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.012.982-2', 'PRO00022', 'Profesor de Ciencias Naturales, enfoque practico y experimental.', '-35.4264', '-71.6554', TO_DATE('2025-02-06','YYYY-MM-DD'), 4.1);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.013.163-3', 'PRO00023', 'Profesor de Literatura, especialista en analisis de obras y ensayo.', '-36.6066', '-72.1034', TO_DATE('2025-02-07','YYYY-MM-DD'), 4.3);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.013.344-4', 'PRO00024', 'Profesor de Derecho, apoyo en primeros anos de la carrera de leyes.', '-20.2141', '-70.1522', TO_DATE('2025-02-08','YYYY-MM-DD'), 4.7);
INSERT INTO PROFESOR (run_per, run_pro, bio_pro, latitud_act, longitud_act, ult_act_ubi, cal_pro_pro) VALUES ('10.013.525-5', 'PRO00025', 'Profesora de Enfermeria Basica, apoyo en tecnicas y fundamentos clinicos.', '-20.2727', '-70.1000', TO_DATE('2025-02-09','YYYY-MM-DD'), 4.8);

INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.013.706-6', 'CLI01', 'Particular', 'Particular - Manuel Tapia');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.013.887-7', 'CLI02', 'Particular', 'Particular - Francisco Vergara');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.014.068-8', 'CLI03', 'Particular', 'Particular - Alejandro Carrasco');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.014.249-9', 'CLI04', 'Particular', 'Particular - Daniela Bravo');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.014.430-K', 'CLI05', 'Empresa', 'Sanchez Capacitaciones Ltda');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.014.611-1', 'CLI06', 'Particular', 'Particular - Carla Vera');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.014.792-2', 'CLI07', 'Particular', 'Particular - Monica Molina');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.014.973-3', 'CLI08', 'Particular', 'Particular - Veronica Sandoval');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.015.154-4', 'CLI09', 'Particular', 'Particular - Patricia Aguilera');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.015.335-5', 'CLI10', 'Empresa', 'Salazar Educacion SpA');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.015.516-6', 'CLI11', 'Particular', 'Particular - Marcela Cortes');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.015.697-7', 'CLI12', 'Particular', 'Particular - Pamela Vidal');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.015.878-8', 'CLI13', 'Particular', 'Particular - Loreto Riquelme');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.016.059-9', 'CLI14', 'Particular', 'Particular - Ximena Mora');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.016.240-K', 'CLI15', 'Empresa', 'Pizarro Consultores Ltda');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.016.421-1', 'CLI16', 'Particular', 'Particular - Gabriela Ortiz');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.016.602-2', 'CLI17', 'Particular', 'Particular - Isidora Fernandez');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.016.783-3', 'CLI18', 'Particular', 'Particular - Martina Guzman');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.016.964-4', 'CLI19', 'Particular', 'Particular - Emilia Campos');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.017.145-5', 'CLI20', 'Empresa', 'Cabrera Formacion SpA');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.017.326-6', 'CLI21', 'Particular', 'Particular - Renata Roman');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.017.507-7', 'CLI22', 'Particular', 'Particular - Agustin Leiva');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.017.688-8', 'CLI23', 'Particular', 'Particular - Tomas Jara');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.017.869-9', 'CLI24', 'Particular', 'Particular - Vicente Barrera');
INSERT INTO CLIENTE (run_per, id_cli, tip_cli, razon_soc_cli) VALUES ('10.018.050-K', 'CLI25', 'Empresa', 'Ulloa Capacitaciones Ltda');

INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.013.706-6', 'USR01', 'pass_cli01_2024', TO_DATE('2024-03-05','YYYY-MM-DD'), 'Cliente', '-37.4697', '-72.3527', '2025-02-10 14:30:00', EMPTY_BLOB(), 'CLI01');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.013.887-7', 'USR02', 'pass_cli02_2024', TO_DATE('2024-03-12','YYYY-MM-DD'), 'Cliente', '-37.4697', '-72.3527', '2025-02-10 09:15:00', EMPTY_BLOB(), 'CLI02');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.014.068-8', 'USR03', 'pass_cli03_2024', TO_DATE('2024-04-01','YYYY-MM-DD'), 'Cliente', '-37.4697', '-72.3527', '2025-02-11 11:00:00', EMPTY_BLOB(), 'CLI03');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.014.249-9', 'USR04', 'pass_cli04_2024', TO_DATE('2024-04-18','YYYY-MM-DD'), 'Cliente', '-37.4697', '-72.3527', '2025-02-11 16:45:00', EMPTY_BLOB(), 'CLI04');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.014.430-K', 'USR05', 'pass_cli05_2024', TO_DATE('2024-05-02','YYYY-MM-DD'), 'Cliente', '-34.9828', '-71.2394', '2025-02-12 08:20:00', EMPTY_BLOB(), 'CLI05');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.014.611-1', 'USR06', 'pass_cli06_2024', TO_DATE('2024-05-20','YYYY-MM-DD'), 'Cliente', '-35.8480', '-71.5935', '2025-02-12 13:10:00', EMPTY_BLOB(), 'CLI06');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.014.792-2', 'USR07', 'pass_cli07_2024', TO_DATE('2024-06-03','YYYY-MM-DD'), 'Cliente', '-37.7975', '-72.7150', '2025-02-13 10:05:00', EMPTY_BLOB(), 'CLI07');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.014.973-3', 'USR08', 'pass_cli08_2024', TO_DATE('2024-06-21','YYYY-MM-DD'), 'Cliente', '-34.5850', '-70.9880', '2025-02-13 17:30:00', EMPTY_BLOB(), 'CLI08');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.015.154-4', 'USR09', 'pass_cli09_2024', TO_DATE('2024-07-09','YYYY-MM-DD'), 'Cliente', '-45.5752', '-72.0662', '2025-02-14 09:50:00', EMPTY_BLOB(), 'CLI09');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.015.335-5', 'USR10', 'pass_cli10_2024', TO_DATE('2024-07-27','YYYY-MM-DD'), 'Cliente', '-42.4820', '-73.7620', '2025-02-14 15:15:00', EMPTY_BLOB(), 'CLI10');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.015.516-6', 'USR11', 'pass_cli11_2024', TO_DATE('2024-08-14','YYYY-MM-DD'), 'Cliente', '-32.8823', '-71.2500', '2025-02-15 12:40:00', EMPTY_BLOB(), 'CLI11');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.015.697-7', 'USR12', 'pass_cli12_2024', TO_DATE('2024-09-01','YYYY-MM-DD'), 'Cliente', '-32.7500', '-70.7167', '2025-02-15 18:00:00', EMPTY_BLOB(), 'CLI12');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.015.878-8', 'USR13', 'pass_cli13_2024', TO_DATE('2024-09-19','YYYY-MM-DD'), 'Cliente', '-32.8333', '-70.5975', '2025-02-16 07:25:00', EMPTY_BLOB(), 'CLI13');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.016.059-9', 'USR14', 'pass_cli14_2024', TO_DATE('2024-10-06','YYYY-MM-DD'), 'Cliente', '-33.5928', '-71.6064', '2025-02-16 14:10:00', EMPTY_BLOB(), 'CLI14');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.016.240-K', 'USR15', 'pass_cli15_2024', TO_DATE('2024-10-24','YYYY-MM-DD'), 'Cliente', '-39.2827', '-72.2296', '2025-02-17 10:55:00', EMPTY_BLOB(), 'CLI15');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.016.421-1', 'USR16', 'pass_cli16_2024', TO_DATE('2024-11-11','YYYY-MM-DD'), 'Cliente', '-38.2350', '-72.3350', '2025-02-17 16:20:00', EMPTY_BLOB(), 'CLI16');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.016.602-2', 'USR17', 'pass_cli17_2024', TO_DATE('2024-11-29','YYYY-MM-DD'), 'Cliente', '-40.2934', '-73.0839', '2025-02-18 08:35:00', EMPTY_BLOB(), 'CLI17');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.016.783-3', 'USR18', 'pass_cli18_2024', TO_DATE('2024-12-16','YYYY-MM-DD'), 'Cliente', '-41.8697', '-73.8203', '2025-02-18 13:05:00', EMPTY_BLOB(), 'CLI18');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.016.964-4', 'USR19', 'pass_cli19_2024', TO_DATE('2025-01-03','YYYY-MM-DD'), 'Cliente', '-51.7236', '-72.4875', '2025-02-19 09:45:00', EMPTY_BLOB(), 'CLI19');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.017.145-5', 'USR20', 'pass_cli20_2024', TO_DATE('2025-01-20','YYYY-MM-DD'), 'Cliente', '-28.5708', '-70.7581', '2025-02-19 15:30:00', EMPTY_BLOB(), 'CLI20');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.017.326-6', 'USR21', 'pass_cli21_2024', TO_DATE('2025-02-07','YYYY-MM-DD'), 'Cliente', '-30.6006', '-71.2000', '2025-02-20 11:00:00', EMPTY_BLOB(), 'CLI21');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.017.507-7', 'USR22', 'pass_cli22_2024', TO_DATE('2025-02-14','YYYY-MM-DD'), 'Cliente', '-36.4249', '-71.9583', '2025-02-20 17:15:00', EMPTY_BLOB(), 'CLI22');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.017.688-8', 'USR23', 'pass_cli23_2024', TO_DATE('2025-02-21','YYYY-MM-DD'), 'Cliente', '-53.1638', '-70.9171', '2025-02-21 09:00:00', EMPTY_BLOB(), 'CLI23');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.017.869-9', 'USR24', 'pass_cli24_2024', TO_DATE('2025-03-01','YYYY-MM-DD'), 'Cliente', '-39.8142', '-73.2459', '2025-02-21 14:40:00', EMPTY_BLOB(), 'CLI24');
INSERT INTO USUARIO (run_per, id_usu, pass_usu, fec_reg, tip_usu, latitud_act, longitud_act, ult_act_ubi, img_usu, CLIENTE_id_cli) VALUES ('10.018.050-K', 'USR25', 'pass_cli25_2024', TO_DATE('2025-03-15','YYYY-MM-DD'), 'Cliente', '-27.3668', '-70.3323', '2025-02-22 10:20:00', EMPTY_BLOB(), 'CLI25');

INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS001', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.4489', '-70.6693', 'Av. Libertador 100, Santiago', 'No aplica', 'PRO00001');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS002', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.4489', '-70.6693', 'Av. Libertador 100, Santiago', '10', 'PRO00001');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS003', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.4269', '-70.6083', 'Calle Los Alamos 200, Providencia', 'No aplica', 'PRO00002');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS004', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.4269', '-70.6083', 'Calle Los Alamos 200, Providencia', '10', 'PRO00002');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS005', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.4089', '-70.5661', 'Av. Apoquindo 300, Las Condes', 'No aplica', 'PRO00003');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS006', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.4089', '-70.5661', 'Av. Apoquindo 300, Las Condes', '10', 'PRO00003');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS007', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.4560', '-70.5987', 'Calle Irarrazaval 400, Nunoa', 'No aplica', 'PRO00004');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS008', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.4560', '-70.5987', 'Calle Irarrazaval 400, Nunoa', '10', 'PRO00004');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS009', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.6109', '-70.5755', 'Av. Concha y Toro 500, Puente Alto', 'No aplica', 'PRO00005');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS010', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.6109', '-70.5755', 'Av. Concha y Toro 500, Puente Alto', '10', 'PRO00005');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS011', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.5106', '-70.7570', 'Av. Pajaritos 600, Maipu', 'No aplica', 'PRO00006');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS012', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.5106', '-70.7570', 'Av. Pajaritos 600, Maipu', '10', 'PRO00006');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS013', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.5241', '-70.5979', 'Av. Vicuna Mackenna 700, La Florida', 'No aplica', 'PRO00007');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS014', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.5241', '-70.5979', 'Av. Vicuna Mackenna 700, La Florida', '10', 'PRO00007');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS015', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.5928', '-70.7048', 'Calle Eyzaguirre 800, San Bernardo', 'No aplica', 'PRO00008');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS016', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.5928', '-70.7048', 'Calle Eyzaguirre 800, San Bernardo', '10', 'PRO00008');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS017', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.3891', '-70.5730', 'Av. Vitacura 900, Vitacura', 'No aplica', 'PRO00009');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS018', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.3891', '-70.5730', 'Av. Vitacura 900, Vitacura', '10', 'PRO00009');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS019', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.4436', '-70.5354', 'Av. Ossa 1000, La Reina', 'No aplica', 'PRO00010');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS020', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.4436', '-70.5354', 'Av. Ossa 1000, La Reina', '10', 'PRO00010');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS021', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.0472', '-71.6127', 'Calle Condell 1100, Valparaiso', 'No aplica', 'PRO00011');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS022', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.0472', '-71.6127', 'Calle Condell 1100, Valparaiso', '10', 'PRO00011');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS023', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-33.0245', '-71.5518', 'Av. San Martin 1200, Vina del Mar', 'No aplica', 'PRO00012');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS024', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-33.0245', '-71.5518', 'Av. San Martin 1200, Vina del Mar', '10', 'PRO00012');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS025', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-36.8201', '-73.0444', 'Calle Barros Arana 1300, Concepcion', 'No aplica', 'PRO00013');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS026', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-36.8201', '-73.0444', 'Calle Barros Arana 1300, Concepcion', '10', 'PRO00013');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS027', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-36.8383', '-73.1108', 'Av. Michimalonco 1400, San Pedro de la Paz', 'No aplica', 'PRO00014');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS028', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-36.8383', '-73.1108', 'Av. Michimalonco 1400, San Pedro de la Paz', '10', 'PRO00014');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS029', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-36.7249', '-73.1169', 'Av. Colon 1500, Talcahuano', 'No aplica', 'PRO00015');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS030', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-36.7249', '-73.1169', 'Av. Colon 1500, Talcahuano', '10', 'PRO00015');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS031', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-38.7359', '-72.5904', 'Av. Alemania 1600, Temuco', 'No aplica', 'PRO00016');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS032', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-38.7359', '-72.5904', 'Av. Alemania 1600, Temuco', '10', 'PRO00016');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS033', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-29.9027', '-71.2519', 'Av. Francisco de Aguirre 1700, La Serena', 'No aplica', 'PRO00017');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS034', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-29.9027', '-71.2519', 'Av. Francisco de Aguirre 1700, La Serena', '10', 'PRO00017');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS035', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-29.9533', '-71.3436', 'Av. Costanera 1800, Coquimbo', 'No aplica', 'PRO00018');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS036', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-29.9533', '-71.3436', 'Av. Costanera 1800, Coquimbo', '10', 'PRO00018');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS037', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-23.6509', '-70.3975', 'Av. Grecia 1900, Antofagasta', 'No aplica', 'PRO00019');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS038', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-23.6509', '-70.3975', 'Av. Grecia 1900, Antofagasta', '10', 'PRO00019');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS039', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-41.4693', '-72.9424', 'Av. Angelmo 2000, Puerto Montt', 'No aplica', 'PRO00020');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS040', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-41.4693', '-72.9424', 'Av. Angelmo 2000, Puerto Montt', '10', 'PRO00020');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS041', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-34.1708', '-70.7444', 'Av. Cachapoal 2100, Rancagua', 'No aplica', 'PRO00021');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS042', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-34.1708', '-70.7444', 'Av. Cachapoal 2100, Rancagua', '10', 'PRO00021');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS043', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-35.4264', '-71.6554', 'Av. San Miguel 2200, Talca', 'No aplica', 'PRO00022');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS044', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-35.4264', '-71.6554', 'Av. San Miguel 2200, Talca', '10', 'PRO00022');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS045', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-36.6066', '-72.1034', 'Av. Argentina 2300, Chillan', 'No aplica', 'PRO00023');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS046', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-36.6066', '-72.1034', 'Av. Argentina 2300, Chillan', '10', 'PRO00023');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS047', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-20.2141', '-70.1522', 'Av. Baquedano 2400, Iquique', 'No aplica', 'PRO00024');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS048', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-20.2141', '-70.1522', 'Av. Baquedano 2400, Iquique', '10', 'PRO00024');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS049', TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-03 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-03 11:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Online', '-20.2727', '-70.1000', 'Av. Circunvalacion 2500, Alto Hospicio', 'No aplica', 'PRO00025');
INSERT INTO DISPONIBILIDAD (id_dis, fec_dis, hor_ini, hor_ter, est_dis, modalidad, latitud, longitud, direccion, rad_cob_km, PROFESOR_run_pro) VALUES ('DIS050', TO_DATE('2025-03-05','YYYY-MM-DD'), TO_DATE('2025-03-05 15:00','YYYY-MM-DD HH24:MI'), TO_DATE('2025-03-05 17:00','YYYY-MM-DD HH24:MI'), 'Disponible', 'Presencial', '-20.2727', '-70.1000', 'Av. Circunvalacion 2500, Alto Hospicio', '10', 'PRO00025');

--ALTERAR LA TABLA CONTRATO PARA QUE EL id_pago PUEDA SER NULL POR DEPENDENCIA CIRCULAR
ALTER TABLE CONTRATO MODIFY (PAGO_id_pago NULL);

INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL01', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR01'), 'DIS001', 'Pendiente', TO_DATE('2025-03-01','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL02', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR01'), 'DIS002', 'Aceptada', TO_DATE('2025-03-01','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL03', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR02'), 'DIS003', 'Pendiente', TO_DATE('2025-03-02','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL04', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR02'), 'DIS004', 'Rechazada', TO_DATE('2025-03-02','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL05', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR03'), 'DIS005', 'Aceptada', TO_DATE('2025-03-03','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL06', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR03'), 'DIS006', 'Pendiente', TO_DATE('2025-03-03','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL07', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR04'), 'DIS007', 'Pendiente', TO_DATE('2025-03-04','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL08', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR04'), 'DIS008', 'Aceptada', TO_DATE('2025-03-04','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL09', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR05'), 'DIS009', 'Aceptada', TO_DATE('2025-03-05','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL10', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR05'), 'DIS010', 'Rechazada', TO_DATE('2025-03-05','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL11', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR06'), 'DIS011', 'Pendiente', TO_DATE('2025-03-06','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL12', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR06'), 'DIS012', 'Aceptada', TO_DATE('2025-03-06','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL13', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR07'), 'DIS013', 'Pendiente', TO_DATE('2025-03-07','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL14', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR07'), 'DIS014', 'Rechazada', TO_DATE('2025-03-07','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL15', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR08'), 'DIS015', 'Aceptada', TO_DATE('2025-03-08','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL16', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR08'), 'DIS016', 'Pendiente', TO_DATE('2025-03-08','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL17', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR09'), 'DIS017', 'Pendiente', TO_DATE('2025-03-09','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL18', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR09'), 'DIS018', 'Aceptada', TO_DATE('2025-03-09','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL19', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR10'), 'DIS019', 'Rechazada', TO_DATE('2025-03-10','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL20', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR10'), 'DIS020', 'Pendiente', TO_DATE('2025-03-10','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL21', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR11'), 'DIS021', 'Aceptada', TO_DATE('2025-03-11','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL22', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR11'), 'DIS022', 'Pendiente', TO_DATE('2025-03-11','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL23', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR12'), 'DIS023', 'Pendiente', TO_DATE('2025-03-12','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL24', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR12'), 'DIS024', 'Rechazada', TO_DATE('2025-03-12','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL25', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR13'), 'DIS025', 'Aceptada', TO_DATE('2025-03-13','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL26', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR13'), 'DIS026', 'Pendiente', TO_DATE('2025-03-13','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL27', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR14'), 'DIS027', 'Pendiente', TO_DATE('2025-03-14','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL28', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR14'), 'DIS028', 'Aceptada', TO_DATE('2025-03-14','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL29', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR15'), 'DIS029', 'Rechazada', TO_DATE('2025-03-15','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL30', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR15'), 'DIS030', 'Pendiente', TO_DATE('2025-03-15','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL31', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR16'), 'DIS031', 'Aceptada', TO_DATE('2025-03-16','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL32', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR16'), 'DIS032', 'Pendiente', TO_DATE('2025-03-16','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL33', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR17'), 'DIS033', 'Pendiente', TO_DATE('2025-03-17','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL34', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR17'), 'DIS034', 'Rechazada', TO_DATE('2025-03-17','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL35', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR18'), 'DIS035', 'Aceptada', TO_DATE('2025-03-18','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL36', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR18'), 'DIS036', 'Pendiente', TO_DATE('2025-03-18','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL37', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR19'), 'DIS037', 'Pendiente', TO_DATE('2025-03-19','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL38', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR19'), 'DIS038', 'Aceptada', TO_DATE('2025-03-19','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL39', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR20'), 'DIS039', 'Rechazada', TO_DATE('2025-03-20','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL40', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR20'), 'DIS040', 'Pendiente', TO_DATE('2025-03-20','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL41', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR21'), 'DIS041', 'Aceptada', TO_DATE('2025-03-21','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL42', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR21'), 'DIS042', 'Pendiente', TO_DATE('2025-03-21','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL43', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR22'), 'DIS043', 'Pendiente', TO_DATE('2025-03-22','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL44', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR22'), 'DIS044', 'Rechazada', TO_DATE('2025-03-22','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL45', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR23'), 'DIS045', 'Aceptada', TO_DATE('2025-03-23','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL46', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR23'), 'DIS046', 'Pendiente', TO_DATE('2025-03-23','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL47', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR24'), 'DIS047', 'Pendiente', TO_DATE('2025-03-24','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL48', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR24'), 'DIS048', 'Aceptada', TO_DATE('2025-03-24','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL49', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR25'), 'DIS049', 'Rechazada', TO_DATE('2025-03-25','YYYY-MM-DD'));
INSERT INTO SOLICITUD (soli_id, USUARIO_run_per, id_dis, est_soli, fec_soli) VALUES ('SOL50', (SELECT run_per FROM USUARIO WHERE id_usu = 'USR25'), 'DIS050', 'Pendiente', TO_DATE('2025-03-25','YYYY-MM-DD'));

INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA01', 'Matemáticas Básicas: Álgebra Lineal', TO_DATE('09:00', 'HH24:MI'), TO_DATE('10:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Comprender operaciones con matrices y vectores.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'), 1);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA02', 'Cálculo Diferencial e Integral', TO_DATE('11:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Aplicar derivadas en la resolución de problemas.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'), 2);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA03', 'Física General: Mecánica Clásica', TO_DATE('14:00', 'HH24:MI'), TO_DATE('15:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Resolver ecuaciones de movimiento dinámico.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'), 3);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA04', 'Electromagnetismo Aplicado', TO_DATE('16:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Analizar circuitos eléctricos y campos magnéticos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'), 4);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA05', 'Química Orgánica y Enlaces', TO_DATE('08:30', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Identificar estructuras de compuestos orgánicos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'), 5);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA06', 'Bioquímica Fundamental', TO_DATE('10:30', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Comprender procesos metabólicos moleculares.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'), 6);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA07', 'Programación en Python desde Cero', TO_DATE('15:00', 'HH24:MI'), TO_DATE('16:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Escribir scripts estructurados y algoritmos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'), 7);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA08', 'Estructuras de Datos Avanzadas', TO_DATE('17:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Implementar árboles, grafos y tablas hash.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'), 8);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA09', 'Bases de Datos Relacionales y SQL', TO_DATE('09:30', 'HH24:MI'), TO_DATE('11:00', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Diseñar modelos ER y consultas SQL complejas.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'), 9);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA10', 'Administración de Oracle Database', TO_DATE('11:30', 'HH24:MI'), TO_DATE('13:00', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Gestionar seguridad, backups y triggers en PL/SQL.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'), 10);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA11', 'Inglés Básico A1: Conversación', TO_DATE('14:00', 'HH24:MI'), TO_DATE('15:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Establecer diálogos sencillos de interacción cotidiana.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'), 11);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA12', 'Inglés Intermedio B2: Business English', TO_DATE('16:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Redactar correos corporativos y realizar presentaciones.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'), 12);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA13', 'Historia de Chile: Siglo XX', TO_DATE('10:00', 'HH24:MI'), TO_DATE('11:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Analizar los procesos sociales y políticos contemporáneos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'), 13);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA14', 'Historia Universal: Revolución Industrial', TO_DATE('12:00', 'HH24:MI'), TO_DATE('13:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Explicar las transformaciones económicas globales.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'), 14);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA15', 'Literatura Hispanoamericana', TO_DATE('15:00', 'HH24:MI'), TO_DATE('16:30', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Interpretar textos de autores latinoamericanos clave.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'), 15);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA16', 'Redacción Creativa y Ortografía', TO_DATE('17:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Aplicar reglas gramaticales y técnicas de escritura.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'), 16);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA17', 'Contabilidad Financiera', TO_DATE('09:00', 'HH24:MI'), TO_DATE('10:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Elaborar estados financieros y balances generales.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'), 17);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA18', 'Finanzas Corporativas y Presupuesto', TO_DATE('11:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Evaluar flujos de caja e indicadores de inversión.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'), 18);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA19', 'Marketing Digital y SEO', TO_DATE('14:00', 'HH24:MI'), TO_DATE('15:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Diseñar campañas publicitarias y posicionamiento web.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'), 19);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA20', 'Gestión de Redes Sociales', TO_DATE('16:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Crear estrategias de contenidos y analítica digital.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'), 20);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA21', 'Diseño Gráfico con Photoshop', TO_DATE('08:30', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Dominar herramientas de retoque y composición digital.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'), 21);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA22', 'Ilustración Vectorial con Illustrator', TO_DATE('10:30', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Crear logotipos, vectores e imagotipos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'), 22);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA23', 'Teoría Musical y Solfeo', TO_DATE('15:00', 'HH24:MI'), TO_DATE('16:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Leer partituras y comprender armonía básica.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'), 23);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA24', 'Iniciación al Piano y Teclado', TO_DATE('17:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Ejecutar escalas y acordes mayores y menores.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'), 24);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA25', 'Guitarra Acústica Inicial', TO_DATE('09:00', 'HH24:MI'), TO_DATE('10:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Tocar ritmos básicos y acompañamientos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'), 25);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA26', 'Técnica de Guitarra Eléctrica', TO_DATE('11:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Desarrollar solos, tapping y arpegios rápidos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'), 26);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA27', 'Acondicionamiento Físico y Fitness', TO_DATE('08:00', 'HH24:MI'), TO_DATE('09:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Diseñar rutinas de entrenamiento funcional.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'), 27);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA28', 'Entrenamiento de Fuerza y Calistenia', TO_DATE('10:00', 'HH24:MI'), TO_DATE('11:30', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Ejecutar movimientos con peso corporal eficientemente.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'), 28);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA29', 'Yoga para Principiantes', TO_DATE('18:00', 'HH24:MI'), TO_DATE('19:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Practicar asanas básicas y técnicas de respiración.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'), 29);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA30', 'Mindfulness y Meditación Guiada', TO_DATE('19:30', 'HH24:MI'), TO_DATE('21:00', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Desarrollar herramientas para manejo de estrés.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'), 30);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA31', 'Psicología General y Conducta', TO_DATE('14:00', 'HH24:MI'), TO_DATE('15:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Comprender conceptos clave del comportamiento humano.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'), 31);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA32', 'Introducción al Psicoanálisis', TO_DATE('16:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Analizar constructos sobre el inconsciente y desarrollo.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'), 32);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA33', 'Derecho Constitucional', TO_DATE('09:00', 'HH24:MI'), TO_DATE('10:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Analizar la estructura del Estado y garantías fundamentales.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'), 33);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA34', 'Derecho Laboral para PyMEs', TO_DATE('11:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Aplicar la normativa vigente sobre contratos y finiquitos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'), 34);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA35', 'Fotografía Digital y Composición', TO_DATE('15:00', 'HH24:MI'), TO_DATE('16:30', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Manejar la exposición, encuadre e iluminación en cámara.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'), 35);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA36', 'Edición Fotográfica en Lightroom', TO_DATE('17:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Revelar archivos RAW y corrección de color.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'), 36);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA37', 'Nutrición Humana y Dietética', TO_DATE('08:30', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Calcular requerimientos calóricos y macronutrientes.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'), 37);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA38', 'Planificación de Dietas Deportivas', TO_DATE('10:30', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Diseñar pautas nutricionales para alto rendimiento.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'), 38);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA39', 'Desarrollo Web Frontend (HTML/CSS)', TO_DATE('14:00', 'HH24:MI'), TO_DATE('15:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Construir maquetas e interfaces web responsivas.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'), 39);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA40', 'JavaScript Moderno y React', TO_DATE('16:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Desarrollar aplicaciones dinámicas basadas en componentes.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'), 40);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA41', 'Francés Esencial A1', TO_DATE('09:00', 'HH24:MI'), TO_DATE('10:30', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Aprender gramática básica y vocabulario cotidiano.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'), 41);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA42', 'Pronunciación y Fonética Francesa', TO_DATE('11:00', 'HH24:MI'), TO_DATE('12:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Mejorar articulación y comprensión auditiva.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'), 42);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA43', 'Estadística Descriptiva con R', TO_DATE('15:00', 'HH24:MI'), TO_DATE('16:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Procesar conjuntos de datos y gráficos descriptivos.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'), 43);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA44', 'Inferencia Estadística e Hipótesis', TO_DATE('17:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Validar pruebas p-valor y modelos de regresión.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'), 44);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA45', 'Taller de Teatro e Improvisación', TO_DATE('18:00', 'HH24:MI'), TO_DATE('19:30', 'HH24:MI'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Desarrollar expresión corporal y voz en escena.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'), 45);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA46', 'Oratoria y Hablar en Público', TO_DATE('19:30', 'HH24:MI'), TO_DATE('21:00', 'HH24:MI'), TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Superar el miedo escénico y persuadir audiencias.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'), 46);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA47', 'Ciberseguridad y Hacking Ético', TO_DATE('10:00', 'HH24:MI'), TO_DATE('11:30', 'HH24:MI'), TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Identificar vulnerabilidades y asegurar redes informáticas.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'), 47);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA48', 'Criptografía y Seguridad de Datos', TO_DATE('12:00', 'HH24:MI'), TO_DATE('13:30', 'HH24:MI'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Aplicar algoritmos de cifrado simétrico y asimétrico.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'), 48);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA49', 'Astronomía General y Cosmología', TO_DATE('16:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Comprender la evolución estelar y el universo observable.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'), 49);
INSERT INTO CLASE (id_clas, nom_clas, hora_ini, hora_ter, fec_clas, ra_clas, PROFESOR_run_pro, CLASE_ID) VALUES ('CLA50', 'Astrofísica de Sistema Solar', TO_DATE('18:00', 'HH24:MI'), TO_DATE('19:30', 'HH24:MI'), TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Analizar la dinámica planetaria y física atmosférica.', (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'), 50);

INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (1, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR01'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (2, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR01'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (3, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR02'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (4, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR02'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (5, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR03'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (6, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR03'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (7, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR04'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (8, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR04'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (9, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR05'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (10, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR05'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (11, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR06'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (12, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR06'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (13, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR07'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (14, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR07'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (15, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR08'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (16, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR08'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (17, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR09'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (18, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR09'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (19, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR10'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (20, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR10'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (21, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR11'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (22, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR11'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (23, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR12'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (24, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR12'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (25, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR13'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (26, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR13'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (27, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR14'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (28, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR14'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (29, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR15'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (30, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR15'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (31, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR16'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (32, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR16'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (33, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR17'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (34, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR17'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (35, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR18'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (36, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR18'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (37, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR19'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (38, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR19'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (39, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR20'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (40, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR20'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (41, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR21'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (42, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR21'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (43, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR22'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (44, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR22'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (45, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR23'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (46, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR23'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (47, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR24'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (48, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR24'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (49, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR25'));
INSERT INTO CURSAR (CLASE_CLASE_ID, USUARIO_run_per) VALUES (50, (SELECT run_per FROM USUARIO WHERE id_usu = 'USR25'));

INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP01', 'Álgebra Lineal y Geometría', '5 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP02', 'Cálculo Multivariable', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP03', 'Física Cuántica y Mecánica', '10 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP04', 'Electromagnetismo Avanzado', '6 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP05', 'Química Orgánica Sintética', '4 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP06', 'Bioquímica Estructural', '7 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP07', 'Desarrollo de Software en Python', '9 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP08', 'Algoritmos y Estructuras de Datos', '12 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP09', 'Modelado de Bases de Datos SQL', '11 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP10', 'Administración de Servidores Oracle', '15 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP11', 'Enseñanza del Idioma Inglés A1-C2', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP12', 'Inglés de Negocios Corporativo', '6 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP13', 'Historia Social de Chile', '14 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP14', 'Historia de la Revolución Industrial', '10 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP15', 'Narrativa Hispanoamericana', '7 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP16', 'Redacción Técnica y Ortografía', '5 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP17', 'Contabilidad Financiera e IFRS', '13 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP18', 'Evaluación de Proyectos Financieros', '9 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP19', 'Estrategias de Marketing Digital', '6 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP20', 'Social Media Management', '4 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP21', 'Diseño de Identidad Visual', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP22', 'Ilustración Digital Vectorial', '5 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP23', 'Teoría Armónica y Solfeo', '16 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP24', 'Interpretación en Piano Clásico', '12 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP25', 'Guitarra Acústica Contemporánea', '10 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP26', 'Técnicas de Guitarra Eléctrica', '9 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP27', 'Entrenamiento Funcional y HIIT', '7 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP28', 'Calistenia y Biomecánica', '5 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP29', 'Hatha Yoga y Flexibilidad', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP30', 'Técnicas de Respiración y Meditación', '6 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP31', 'Psicología Cognitivo-Conductual', '11 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP32', 'Teoría Psicoanalítica', '13 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP33', 'Derecho Constitucional Chileno', '15 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP34', 'Legislación Laboral', '10 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP35', 'Fotografía de Retrato y Paisaje', '7 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP36', 'Postproducción Digital en Lightroom', '6 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP37', 'Nutrición Clínica y Deportiva', '9 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP38', 'Cálculo de Requerimientos Nutricionales', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP39', 'Arquitectura Web Frontend', '7 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP40', 'Desarrollo en React y JavaScript JS', '5 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP41', 'Lengua Francófona Fundamental', '11 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP42', 'Fonética Francesa', '9 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP43', 'Análisis Estadístico en Lenguaje R', '6 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP44', 'Modelos Econométricos', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP45', 'Técnicas Dramáticas e Improvisación', '14 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP46', 'Comunicación Efectiva y Oratoria', '10 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP47', 'Seguridad de Redes e Infraestructura', '12 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP48', 'Criptografía Aplicada', '8 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP49', 'Cosmología Física', '15 años');
INSERT INTO ESPECIALIDAD (id_esp, nom_esp, anio_exp_esp) VALUES ('ESP50', 'Física del Sistema Solar', '11 años');

INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00001'), 'ESP01');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00001'), 'ESP02');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00002'), 'ESP03');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00002'), 'ESP04');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00003'), 'ESP05');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00003'), 'ESP06');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00004'), 'ESP07');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00004'), 'ESP08');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00005'), 'ESP09');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00005'), 'ESP10');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00006'), 'ESP11');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00006'), 'ESP12');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00007'), 'ESP13');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00007'), 'ESP14');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00008'), 'ESP15');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00008'), 'ESP16');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00009'), 'ESP17');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00009'), 'ESP18');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00010'), 'ESP19');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00010'), 'ESP20');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00011'), 'ESP21');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00011'), 'ESP22');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00012'), 'ESP23');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00012'), 'ESP24');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00013'), 'ESP25');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00013'), 'ESP26');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00014'), 'ESP27');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00014'), 'ESP28');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00015'), 'ESP29');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00015'), 'ESP30');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00016'), 'ESP31');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00016'), 'ESP32');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00017'), 'ESP33');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00017'), 'ESP34');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00018'), 'ESP35');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00018'), 'ESP36');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00019'), 'ESP37');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00019'), 'ESP38');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00020'), 'ESP39');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00020'), 'ESP40');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00021'), 'ESP41');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00021'), 'ESP42');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00022'), 'ESP43');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00022'), 'ESP44');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00023'), 'ESP45');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00023'), 'ESP46');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00024'), 'ESP47');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00024'), 'ESP48');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00025'), 'ESP49');
INSERT INTO INSCRIBIR (PROFESOR_run_per, ESPECIALIDAD_id_esp) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00025'), 'ESP50');

INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH001', '$15.000 CLP', 1);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH002', '$18.000 CLP', 2);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH003', '$20.000 CLP', 3);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH004', '$25.000 CLP', 4);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH005', '$12.000 CLP', 5);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH006', '$16.000 CLP', 6);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH007', '$22.000 CLP', 7);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH008', '$30.000 CLP', 8);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH009', '$14.000 CLP', 9);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH010', '$19.000 CLP', 10);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH011', '$13.000 CLP', 11);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH012', '$17.000 CLP', 12);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH013', '$21.000 CLP', 13);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH014', '$28.000 CLP', 14);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH015', '$15.500 CLP', 15);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH016', '$24.000 CLP', 16);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH017', '$18.500 CLP', 17);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH018', '$26.000 CLP', 18);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH019', '$12.500 CLP', 19);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH020', '$20.500 CLP', 20);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH021', '$14.500 CLP', 21);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH022', '$23.000 CLP', 22);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH023', '$16.500 CLP', 23);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH024', '$27.000 CLP', 24);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH025', '$11.000 CLP', 25);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH026', '$17.500 CLP', 26);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH027', '$22.500 CLP', 27);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH028', '$32.000 CLP', 28);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH029', '$13.500 CLP', 29);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH030', '$19.500 CLP', 30);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH031', '$15.000 CLP', 31);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH032', '$21.500 CLP', 32);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH033', '$29.000 CLP', 33);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH034', '$35.000 CLP', 34);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH035', '$16.000 CLP', 35);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH036', '$23.500 CLP', 36);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH037', '$17.000 CLP', 37);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH038', '$25.500 CLP', 38);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH039', '$14.000 CLP', 39);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH040', '$26.500 CLP', 40);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH041', '$12.000 CLP', 41);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH042', '$18.000 CLP', 42);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH043', '$20.000 CLP', 43);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH044', '$28.500 CLP', 44);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH045', '$15.000 CLP', 45);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH046', '$22.000 CLP', 46);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH047', '$24.500 CLP', 47);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH048', '$31.000 CLP', 48);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH049', '$19.000 CLP', 49);
INSERT INTO VALOR_HORA (id_valor_hora, tar_hor, VALOR_HORA_ID) VALUES ('VH050', '$27.500 CLP', 50);

INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00001'), 1);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00001'), 2);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00002'), 3);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00002'), 4);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00003'), 5);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00003'), 6);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00004'), 7);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00004'), 8);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00005'), 9);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00005'), 10);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00006'), 11);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00006'), 12);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00007'), 13);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00007'), 14);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00008'), 15);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00008'), 16);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00009'), 17);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00009'), 18);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00010'), 19);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00010'), 20);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00011'), 21);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00011'), 22);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00012'), 23);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00012'), 24);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00013'), 25);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00013'), 26);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00014'), 27);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00014'), 28);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00015'), 29);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00015'), 30);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00016'), 31);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00016'), 32);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00017'), 33);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00017'), 34);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00018'), 35);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00018'), 36);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00019'), 37);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00019'), 38);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00020'), 39);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00020'), 40);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00021'), 41);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00021'), 42);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00022'), 43);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00022'), 44);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00023'), 45);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00023'), 46);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00024'), 47);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00024'), 48);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00025'), 49);
INSERT INTO Detallar (PROFESOR_run_per, VALOR_HORA_VALOR_HORA_ID) VALUES ((SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00025'), 50);

INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT01', 'Licenciatura en Ciencias de la Ingeniería', 'Universidad de Chile', TO_DATE('2015-12-15','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT02', 'Magíster en Ciencias Exactas', 'Pontificia Universidad Católica de Chile', TO_DATE('2018-06-20','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT03', 'Licenciatura en Física Aplicada', 'Universidad de Concepción', TO_DATE('2014-11-10','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT04', 'Doctorado en Ciencias con Mención en Física', 'Universidad Técnica Federico Santa María', TO_DATE('2019-01-15','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT05', 'Licenciatura en Química General', 'Universidad de Santiago de Chile', TO_DATE('2016-12-05','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT06', 'Magíster en Química Analítica', 'Universidad de Chile', TO_DATE('2020-07-22','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT07', 'Ingeniería Civil en Informática', 'Universidad de Talca', TO_DATE('2013-11-30','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT08', 'Magíster en Ingeniería de Software', 'Pontificia Universidad Católica de Chile', TO_DATE('2017-05-18','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT09', 'Ingeniería en Ejecución en Computación', 'Universidad de Valparaíso', TO_DATE('2012-12-10','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT10', 'Diplomado en Gestión de Bases de Datos Oracle', 'Universidad de Chile', TO_DATE('2015-08-14','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT11', 'Pedagogía en Inglés', 'Universidad Metropolitana de Ciencias de la Educación', TO_DATE('2014-12-18','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT12', 'Licenciatura en Lingüística Aplicada', 'Universidad de Concepción', TO_DATE('2018-04-10','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT13', 'Pedagogía en Historia y Geografía', 'Universidad Austral de Chile', TO_DATE('2011-11-25','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT14', 'Magíster en Historia Contemporánea', 'Universidad de Chile', TO_DATE('2016-09-12','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT15', 'Licenciatura en Letras Hispánicas', 'Pontificia Universidad Católica de Chile', TO_DATE('2015-12-03','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT16', 'Magíster en Literatura Latinoamericana', 'Universidad Diego Portales', TO_DATE('2019-06-28','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT17', 'Contador Auditor', 'Universidad de Santiago de Chile', TO_DATE('2010-12-20','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT18', 'Magíster en Planificación Tributaria', 'Universidad Adolfo Ibáñez', TO_DATE('2015-03-15','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT19', 'Ingeniería Comercial en Marketing', 'Universidad Diego Portales', TO_DATE('2016-11-18','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT20', 'Diplomado en Marketing Estratégico Digital', 'Universidad de Chile', TO_DATE('2019-10-05','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT21', 'Licenciatura en Diseño Gráfico', 'Universidad del Desarrollo', TO_DATE('2013-12-12','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT22', 'Postítulo en Ilustración Digital', 'Pontificia Universidad Católica de Chile', TO_DATE('2017-08-20','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT23', 'Licenciatura en Artes Musicales', 'Universidad de Chile', TO_DATE('2009-12-15','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT24', 'Magíster en Interpretación Instrumental', 'Conservatorio Nacional de Música', TO_DATE('2014-05-11','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT25', 'Pedagogía en Educación Musical', 'Universidad Mayor', TO_DATE('2012-11-22','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT26', 'Diplomado en Arreglos de Música Popular', 'Projazz Instituto Profesional', TO_DATE('2016-07-09','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT27', 'Licenciatura en Ciencias de la Actividad Física', 'Universidad de Playa Ancha', TO_DATE('2015-12-19','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT28', 'Magíster en Fisiología del Ejercicio', 'Universidad Finis Terrae', TO_DATE('2019-09-30','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT29', 'Instructor de Yoga Certificado', 'Escuela Internacional de Yoga', TO_DATE('2016-04-12','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT30', 'Diplomado en Terapia Holística', 'Universidad de Santiago de Chile', TO_DATE('2018-11-05','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT31', 'Psicología Clínica', 'Universidad de La Serena', TO_DATE('2011-12-14','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT32', 'Magíster en Psicología Clínica Adultos', 'Universidad de Chile', TO_DATE('2016-06-25','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT33', 'Licenciatura en Ciencias Jurídicas y Sociales', 'Universidad de Valparaíso', TO_DATE('2008-11-28','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT34', 'Magíster en Derecho Público', 'Pontificia Universidad Católica de Valparaíso', TO_DATE('2013-05-19','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT35', 'Licenciatura en Fotografía Artística', 'ARCOS Instituto Profesional', TO_DATE('2014-12-02','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT36', 'Diplomado en Edición Fotográfica', 'Universidad de Chile', TO_DATE('2017-10-11','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT37', 'Nutrición y Dietética', 'Universidad de la Frontera', TO_DATE('2013-12-16','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT38', 'Magíster en Nutrición Deportiva', 'Universidad Mayor', TO_DATE('2018-08-24','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT39', 'Ingeniería en Desarrollo de Software', 'Duoc UC', TO_DATE('2015-11-20','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT40', 'Diplomado en Desarrollo Web Frontend', 'Universidad Central de Chile', TO_DATE('2018-03-17','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT41', 'Licenciatura en Lengua y Literatura Francesa', 'Universidad de Chile', TO_DATE('2012-12-08','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT42', 'Magíster en Traducción e Interpretación', 'Pontificia Universidad Católica de Chile', TO_DATE('2017-06-14','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT43', 'Licenciatura en Estadística', 'Universidad de Valparaíso', TO_DATE('2014-11-27','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT44', 'Magíster en Bioestadística', 'Universidad de Chile', TO_DATE('2019-02-18','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT45', 'Licenciatura en Artes Escénicas', 'Universidad Finis Terrae', TO_DATE('2009-12-11','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT46', 'Diplomado en Pedagogía Teatral', 'Pontificia Universidad Católica de Chile', TO_DATE('2014-07-29','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT47', 'Ingeniería en Telecomunicaciones y Redes', 'INACAP', TO_DATE('2011-11-15','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT48', 'Magíster en Ciberseguridad', 'Universidad de Chile', TO_DATE('2016-10-23','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT49', 'Licenciatura en Astronomía', 'Universidad de Concepción', TO_DATE('2010-12-19','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'));
INSERT INTO TITULO (id_titu, men_titu, cas_est, anio_titu, cer_titu, PROFESOR_run_pro) VALUES ('TIT50', 'Doctorado en Astrofísica', 'Pontificia Universidad Católica de Chile', TO_DATE('2015-05-30','YYYY-MM-DD'), EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'));

INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG01', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'), 'Aprobada', TO_DATE('2024-01-10','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'), TO_DATE('2024-01-15','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG02', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'), 'En Revision', TO_DATE('2024-02-01','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG03', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'), 'Aprobada', TO_DATE('2024-01-11','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'), TO_DATE('2024-01-16','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG04', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'), 'En Revision', TO_DATE('2024-02-02','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG05', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'), 'Aprobada', TO_DATE('2024-01-12','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'), TO_DATE('2024-01-17','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG06', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'), 'En Revision', TO_DATE('2024-02-03','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG07', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'), 'Aprobada', TO_DATE('2024-01-13','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'), TO_DATE('2024-01-18','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG08', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'), 'En Revision', TO_DATE('2024-02-04','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG09', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'), 'Aprobada', TO_DATE('2024-01-14','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'), TO_DATE('2024-01-19','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG10', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'), 'En Revision', TO_DATE('2024-02-05','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG11', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'), 'Aprobada', TO_DATE('2024-01-15','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'), TO_DATE('2024-01-20','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG12', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'), 'En Revision', TO_DATE('2024-02-06','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG13', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'), 'Aprobada', TO_DATE('2024-01-16','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'), TO_DATE('2024-01-21','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG14', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'), 'En Revision', TO_DATE('2024-02-07','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG15', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'), 'Aprobada', TO_DATE('2024-01-17','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'), TO_DATE('2024-01-22','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG16', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'), 'En Revision', TO_DATE('2024-02-08','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG17', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'), 'Aprobada', TO_DATE('2024-01-18','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'), TO_DATE('2024-01-23','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG18', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'), 'En Revision', TO_DATE('2024-02-09','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG19', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'), 'Aprobada', TO_DATE('2024-01-19','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'), TO_DATE('2024-01-24','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG20', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'), 'En Revision', TO_DATE('2024-02-10','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG21', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'), 'Aprobada', TO_DATE('2024-01-20','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'), TO_DATE('2024-01-25','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG22', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'), 'En Revision', TO_DATE('2024-02-11','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG23', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'), 'Aprobada', TO_DATE('2024-01-21','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'), TO_DATE('2024-01-26','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG24', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'), 'En Revision', TO_DATE('2024-02-12','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG25', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'), 'Aprobada', TO_DATE('2024-01-22','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'), TO_DATE('2024-01-27','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG26', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'), 'En Revision', TO_DATE('2024-02-13','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG27', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'), 'Aprobada', TO_DATE('2024-01-23','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'), TO_DATE('2024-01-28','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG28', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'), 'En Revision', TO_DATE('2024-02-14','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG29', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'), 'Aprobada', TO_DATE('2024-01-24','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'), TO_DATE('2024-01-29','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG30', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'), 'En Revision', TO_DATE('2024-02-15','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG31', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'), 'Aprobada', TO_DATE('2024-01-25','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'), TO_DATE('2024-01-30','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG32', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'), 'En Revision', TO_DATE('2024-02-16','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG33', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'), 'Aprobada', TO_DATE('2024-01-26','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'), TO_DATE('2024-01-31','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG34', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'), 'En Revision', TO_DATE('2024-02-17','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG35', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'), 'Aprobada', TO_DATE('2024-01-27','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'), TO_DATE('2024-02-01','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG36', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'), 'En Revision', TO_DATE('2024-02-18','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG37', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'), 'Aprobada', TO_DATE('2024-01-28','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'), TO_DATE('2024-02-02','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG38', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'), 'En Revision', TO_DATE('2024-02-19','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG39', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'), 'Aprobada', TO_DATE('2024-01-29','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'), TO_DATE('2024-02-03','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG40', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'), 'En Revision', TO_DATE('2024-02-20','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG41', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'), 'Aprobada', TO_DATE('2024-01-30','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'), TO_DATE('2024-02-04','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG42', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'), 'En Revision', TO_DATE('2024-02-21','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG43', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'), 'Aprobada', TO_DATE('2024-01-31','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'), TO_DATE('2024-02-05','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG44', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'), 'En Revision', TO_DATE('2024-02-22','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG45', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'), 'Aprobada', TO_DATE('2024-02-01','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'), TO_DATE('2024-02-06','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG46', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'), 'En Revision', TO_DATE('2024-02-23','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG47', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'), 'Aprobada', TO_DATE('2024-02-02','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'), TO_DATE('2024-02-07','YYYY-MM-DD'), 24);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG48', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'), 'En Revision', TO_DATE('2024-02-24','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG49', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'), 'Aprobada', TO_DATE('2024-02-03','YYYY-MM-DD'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'), TO_DATE('2024-02-08','YYYY-MM-DD'), 12);
INSERT INTO VERIFICACION_CUENTA (id_seg, certifi_inha_seg, run_pro, est_verificacion, fec_est_ver, PROFESOR_run_pro, fecha_validacion, vigencia_validacion) VALUES ('SEG50', EMPTY_BLOB(), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'), 'En Revision', TO_DATE('2024-02-25','YYYY-MM-DD'), NULL, NULL, NULL);

INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS001', 'CV001', 'Hola profesor, quisiera consultar por la disponibilidad para la clase de álgebra.', TO_DATE('2025-03-01 09:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR01'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS002', 'CV001', 'Hola, claro que sí. Revisa los horarios publicados en mi perfil.', TO_DATE('2025-03-01 09:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00001'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS003', 'CV002', 'Buenas tardes, tengo una duda sobre el material de física.', TO_DATE('2025-03-02 10:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR02'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS004', 'CV002', 'Buenas tardes. Dime exactamente en qué ejercicio necesitas ayuda.', TO_DATE('2025-03-02 10:20:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00002'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS005', 'CV003', 'Hola, ¿las clases de química incluyen laboratorio virtual?', TO_DATE('2025-03-03 11:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR03'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS006', 'CV003', 'Así es, incluye simulación de reacciones químicas.', TO_DATE('2025-03-03 11:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00003'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS007', 'CV004', 'Profesor, ¿cuándo inician las clases de Python?', TO_DATE('2025-03-04 14:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR04'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS008', 'CV004', 'Iniciamos el próximo lunes en el horario acordado.', TO_DATE('2025-03-04 14:10:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00004'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS009', 'CV005', 'Estimado, ¿me podría enviar el temario de SQL?', TO_DATE('2025-03-05 15:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR05'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS010', 'CV005', 'Por supuesto, adjunto el PDF con los módulos.', TO_DATE('2025-03-05 15:25:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00005'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS011', 'CV006', 'Hi teacher, is this class fully in English?', TO_DATE('2025-03-06 09:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR06'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS012', 'CV006', 'Yes, 100% immersion method.', TO_DATE('2025-03-06 09:45:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00006'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS013', 'CV007', 'Hola, ¿las lecturas de historia están disponibles en la plataforma?', TO_DATE('2025-03-07 16:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR07'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS014', 'CV007', 'Sí, las puedes descargar directamente del repositorio.', TO_DATE('2025-03-07 16:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00007'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS015', 'CV008', 'Profesor, me gustaría mejorar mi redacción académica.', TO_DATE('2025-03-08 10:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR08'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS016', 'CV008', 'Excelente, trabajaremos con ejercicios prácticos semana a semana.', TO_DATE('2025-03-08 10:50:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00008'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS017', 'CV009', '¿Realiza asesorías para balances contables de pequeñas empresas?', TO_DATE('2025-03-09 12:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR09'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS018', 'CV009', 'Sí, doy apoyo tanto teórico como práctico enfocado en PyMEs.', TO_DATE('2025-03-09 12:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00009'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS019', 'CV010', 'Buenas, me interesa el curso de Marketing Digital.', TO_DATE('2025-03-10 13:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR10'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS020', 'CV010', 'Genial, abarcamos desde Meta Ads hasta posicionamiento SEO.', TO_DATE('2025-03-10 13:20:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00010'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS021', 'CV011', '¿Se necesita tableta digitalizadora para la clase de Illustrator?', TO_DATE('2025-03-11 15:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR11'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS022', 'CV011', 'No es obligatorio, con mouse y teclado podemos avanzar bastante.', TO_DATE('2025-03-11 15:50:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00011'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS023', 'CV012', 'Profesor, ¿enseña a leer partituras desde cero?', TO_DATE('2025-03-12 17:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR12'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS024', 'CV012', 'Totalmente, no requieres conocimientos previos.', TO_DATE('2025-03-12 17:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00012'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS025', 'CV013', '¿Qué tipo de guitarra recomienda para comenzar?', TO_DATE('2025-03-13 18:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR13'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS026', 'CV013', 'Para empezar te sugiero una guitarra acústica con cuerdas de nylon.', TO_DATE('2025-03-13 18:25:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00013'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS027', 'CV014', 'Buenas tardes, ¿las rutinas son adaptadas según condición física?', TO_DATE('2025-03-14 08:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR14'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS028', 'CV014', 'Sí, realizamos una evaluación inicial antes de comenzar.', TO_DATE('2025-03-14 08:50:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00014'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS029', 'CV015', 'Namasté, ¿qué elementos necesito para la primera clase de yoga?', TO_DATE('2025-03-15 09:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR15'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS030', 'CV015', 'Sólo un mat o mat de yoga y ropa cómoda.', TO_DATE('2025-03-15 09:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00015'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS031', 'CV016', 'Hola, quisiera información sobre las sesiones de psicología.', TO_DATE('2025-03-16 11:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR16'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS032', 'CV016', 'Hola, con gusto te comparto la metodología de las sesiones.', TO_DATE('2025-03-16 11:20:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00016'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS033', 'CV017', 'Estimado profesor, ¿su clase aborda legislación laboral actualizada?', TO_DATE('2025-03-17 14:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR17'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS034', 'CV017', 'Efectivamente, revisamos las últimas reformas del código del trabajo.', TO_DATE('2025-03-17 14:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00017'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS035', 'CV018', '¿Las clases de fotografía son presenciales o en línea?', TO_DATE('2025-03-18 16:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR18'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS036', 'CV018', 'Tengo ambas modalidades según la fecha disponible.', TO_DATE('2025-03-18 16:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00018'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS037', 'CV019', 'Hola, necesito una pauta nutricional enfocado en deporte.', TO_DATE('2025-03-19 10:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR19'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS038', 'CV019', 'Perfecto, coordinemos la primera consulta para anamnesis.', TO_DATE('2025-03-19 10:20:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00019'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS039', 'CV020', 'Profesor, ¿enseña React con JavaScript o TypeScript?', TO_DATE('2025-03-20 12:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR20'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS040', 'CV020', 'Iniciamos con JavaScript moderno y luego introducimos TypeScript.', TO_DATE('2025-03-20 12:35:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00020'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS041', 'CV021', 'Bonjour, je voudrais apprendre el francés desde cero.', TO_DATE('2025-03-21 15:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR21'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS042', 'CV021', 'Bonjour! Très bien, podemos agendar tu primera lección A1.', TO_DATE('2025-03-21 15:20:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00021'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS043', 'CV022', '¿Se requiere instalar RStudio previamente a la clase?', TO_DATE('2025-03-22 17:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR22'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS044', 'CV022', 'Sí, te enviaré una guía rápida de instalación por correo.', TO_DATE('2025-03-22 17:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00022'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS045', 'CV023', 'Hola, ¿las clases de oratoria ayudan para perder el pánico escénico?', TO_DATE('2025-03-23 18:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR23'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS046', 'CV023', 'Cien por ciento, aplicamos técnicas progresivas de confianza.', TO_DATE('2025-03-23 18:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00023'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS047', 'CV024', 'Buenas noches, ¿el taller de ciberseguridad incluye prácticas en labs?', TO_DATE('2025-03-24 20:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR24'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS048', 'CV024', 'Así es, trabajamos con entornos virtuales seguros.', TO_DATE('2025-03-24 20:15:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00024'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS049', 'CV025', 'Hola, ¿se necesitan conocimientos de matemática avanzada para astronomía?', TO_DATE('2025-03-25 11:00:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM USUARIO WHERE id_usu = 'USR25'));
INSERT INTO MENSAJE (id_msj, id_conv, cont_msj, fec_hora_msj, PERSONA_run_per) VALUES ('MS050', 'CV025', 'No te preocupes, el curso es divulgativo y conceptual.', TO_DATE('2025-03-25 11:30:00','YYYY-MM-DD HH24:MI:SS'), (SELECT run_per FROM PROFESOR WHERE run_pro = 'PRO00025'));

INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV001', TO_DATE('2025-03-01 09:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS001');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV002', TO_DATE('2025-03-02 10:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS003');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV003', TO_DATE('2025-03-03 11:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS005');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV004', TO_DATE('2025-03-04 14:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS007');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV005', TO_DATE('2025-03-05 15:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS009');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV006', TO_DATE('2025-03-06 09:30:00','YYYY-MM-DD HH24:MI:SS'), 'MS011');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV007', TO_DATE('2025-03-07 16:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS013');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV008', TO_DATE('2025-03-08 10:30:00','YYYY-MM-DD HH24:MI:SS'), 'MS015');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV009', TO_DATE('2025-03-09 12:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS017');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV010', TO_DATE('2025-03-10 13:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS019');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV011', TO_DATE('2025-03-11 15:30:00','YYYY-MM-DD HH24:MI:SS'), 'MS021');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV012', TO_DATE('2025-03-12 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS023');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV013', TO_DATE('2025-03-13 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS025');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV014', TO_DATE('2025-03-14 08:30:00','YYYY-MM-DD HH24:MI:SS'), 'MS027');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV015', TO_DATE('2025-03-15 09:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS029');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV016', TO_DATE('2025-03-16 11:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS031');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV017', TO_DATE('2025-03-17 14:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS033');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV018', TO_DATE('2025-03-18 16:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS035');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV019', TO_DATE('2025-03-19 10:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS037');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV020', TO_DATE('2025-03-20 12:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS039');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV021', TO_DATE('2025-03-21 15:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS041');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV022', TO_DATE('2025-03-22 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS043');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV023', TO_DATE('2025-03-23 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS045');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV024', TO_DATE('2025-03-24 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS047');
INSERT INTO CONVERSACION (id_conv, fech_ini, MENSAJE_id_msj) VALUES ('CV025', TO_DATE('2025-03-25 11:00:00','YYYY-MM-DD HH24:MI:SS'), 'MS049');

INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT001', '$30.000', '2 horas', 'Vigente', TO_DATE('2025-03-02','YYYY-MM-DD'), 'SOL01', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI01'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT002', '$36.000', '2 horas', 'Finalizado', TO_DATE('2025-03-02','YYYY-MM-DD'), 'SOL02', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI01'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00001'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT003', '$40.000', '2 horas', 'Vigente', TO_DATE('2025-03-03','YYYY-MM-DD'), 'SOL03', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI02'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT004', '$50.000', '2 horas', 'Finalizado', TO_DATE('2025-03-03','YYYY-MM-DD'), 'SOL04', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI02'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00002'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT005', '$24.000', '2 horas', 'Vigente', TO_DATE('2025-03-04','YYYY-MM-DD'), 'SOL05', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI03'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT006', '$32.000', '2 horas', 'Finalizado', TO_DATE('2025-03-04','YYYY-MM-DD'), 'SOL06', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI03'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00003'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT007', '$44.000', '2 horas', 'Vigente', TO_DATE('2025-03-05','YYYY-MM-DD'), 'SOL07', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI04'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT008', '$60.000', '2 horas', 'Finalizado', TO_DATE('2025-03-05','YYYY-MM-DD'), 'SOL08', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI04'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00004'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT009', '$28.000', '2 horas', 'Vigente', TO_DATE('2025-03-06','YYYY-MM-DD'), 'SOL09', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI05'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT010', '$38.000', '2 horas', 'Finalizado', TO_DATE('2025-03-06','YYYY-MM-DD'), 'SOL10', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI05'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00005'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT011', '$26.000', '2 horas', 'Vigente', TO_DATE('2025-03-07','YYYY-MM-DD'), 'SOL11', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI06'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT012', '$34.000', '2 horas', 'Finalizado', TO_DATE('2025-03-07','YYYY-MM-DD'), 'SOL12', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI06'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00006'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT013', '$42.000', '2 horas', 'Vigente', TO_DATE('2025-03-08','YYYY-MM-DD'), 'SOL13', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI07'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT014', '$56.000', '2 horas', 'Finalizado', TO_DATE('2025-03-08','YYYY-MM-DD'), 'SOL14', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI07'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00007'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT015', '$31.000', '2 horas', 'Vigente', TO_DATE('2025-03-09','YYYY-MM-DD'), 'SOL15', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI08'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT016', '$48.000', '2 horas', 'Finalizado', TO_DATE('2025-03-09','YYYY-MM-DD'), 'SOL16', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI08'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00008'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT017', '$37.000', '2 horas', 'Vigente', TO_DATE('2025-03-10','YYYY-MM-DD'), 'SOL17', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI09'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT018', '$52.000', '2 horas', 'Finalizado', TO_DATE('2025-03-10','YYYY-MM-DD'), 'SOL18', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI09'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00009'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT019', '$25.000', '2 horas', 'Vigente', TO_DATE('2025-03-11','YYYY-MM-DD'), 'SOL19', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI10'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT020', '$41.000', '2 horas', 'Finalizado', TO_DATE('2025-03-11','YYYY-MM-DD'), 'SOL20', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI10'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00010'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT021', '$29.000', '2 horas', 'Vigente', TO_DATE('2025-03-12','YYYY-MM-DD'), 'SOL21', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI11'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT022', '$46.000', '2 horas', 'Finalizado', TO_DATE('2025-03-12','YYYY-MM-DD'), 'SOL22', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI11'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00011'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT023', '$33.000', '2 horas', 'Vigente', TO_DATE('2025-03-13','YYYY-MM-DD'), 'SOL23', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI12'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT024', '$54.000', '2 horas', 'Finalizado', TO_DATE('2025-03-13','YYYY-MM-DD'), 'SOL24', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI12'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00012'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT025', '$22.000', '2 horas', 'Vigente', TO_DATE('2025-03-14','YYYY-MM-DD'), 'SOL25', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI13'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT026', '$35.000', '2 horas', 'Finalizado', TO_DATE('2025-03-14','YYYY-MM-DD'), 'SOL26', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI13'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00013'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT027', '$45.000', '2 horas', 'Vigente', TO_DATE('2025-03-15','YYYY-MM-DD'), 'SOL27', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI14'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT028', '$64.000', '2 horas', 'Finalizado', TO_DATE('2025-03-15','YYYY-MM-DD'), 'SOL28', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI14'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00014'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT029', '$27.000', '2 horas', 'Vigente', TO_DATE('2025-03-16','YYYY-MM-DD'), 'SOL29', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI15'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT030', '$39.000', '2 horas', 'Finalizado', TO_DATE('2025-03-16','YYYY-MM-DD'), 'SOL30', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI15'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00015'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT031', '$30.000', '2 horas', 'Vigente', TO_DATE('2025-03-17','YYYY-MM-DD'), 'SOL31', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI16'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT032', '$43.000', '2 horas', 'Finalizado', TO_DATE('2025-03-17','YYYY-MM-DD'), 'SOL32', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI16'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00016'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT033', '$58.000', '2 horas', 'Vigente', TO_DATE('2025-03-18','YYYY-MM-DD'), 'SOL33', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI17'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT034', '$70.000', '2 horas', 'Finalizado', TO_DATE('2025-03-18','YYYY-MM-DD'), 'SOL34', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI17'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00017'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT035', '$32.000', '2 horas', 'Vigente', TO_DATE('2025-03-19','YYYY-MM-DD'), 'SOL35', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI18'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT036', '$47.000', '2 horas', 'Finalizado', TO_DATE('2025-03-19','YYYY-MM-DD'), 'SOL36', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI18'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00018'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT037', '$34.000', '2 horas', 'Vigente', TO_DATE('2025-03-20','YYYY-MM-DD'), 'SOL37', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI19'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT038', '$51.000', '2 horas', 'Finalizado', TO_DATE('2025-03-20','YYYY-MM-DD'), 'SOL38', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI19'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00019'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT039', '$28.000', '2 horas', 'Vigente', TO_DATE('2025-03-21','YYYY-MM-DD'), 'SOL39', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI20'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT040', '$53.000', '2 horas', 'Finalizado', TO_DATE('2025-03-21','YYYY-MM-DD'), 'SOL40', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI20'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00020'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT041', '$24.000', '2 horas', 'Vigente', TO_DATE('2025-03-22','YYYY-MM-DD'), 'SOL41', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI21'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT042', '$36.000', '2 horas', 'Finalizado', TO_DATE('2025-03-22','YYYY-MM-DD'), 'SOL42', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI21'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00021'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT043', '$40.000', '2 horas', 'Vigente', TO_DATE('2025-03-23','YYYY-MM-DD'), 'SOL43', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI22'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT044', '$57.000', '2 horas', 'Finalizado', TO_DATE('2025-03-23','YYYY-MM-DD'), 'SOL44', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI22'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00022'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT045', '$30.000', '2 horas', 'Vigente', TO_DATE('2025-03-24','YYYY-MM-DD'), 'SOL45', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI23'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT046', '$44.000', '2 horas', 'Finalizado', TO_DATE('2025-03-24','YYYY-MM-DD'), 'SOL46', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI23'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00023'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT047', '$49.000', '2 horas', 'Vigente', TO_DATE('2025-03-25','YYYY-MM-DD'), 'SOL47', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI24'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT048', '$62.000', '2 horas', 'Finalizado', TO_DATE('2025-03-25','YYYY-MM-DD'), 'SOL48', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI24'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00024'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT049', '$38.000', '2 horas', 'Vigente', TO_DATE('2025-03-26','YYYY-MM-DD'), 'SOL49', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI25'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'));
INSERT INTO CONTRATO (id_cont, monto_acor, duracion_cont, estado_cont, fec_acue_cont, SOLICITUD_soli_id, PAGO_id_pago, CLIENTE_id_cli, PROFESOR_run_pro) VALUES ('CT050', '$55.000', '2 horas', 'Finalizado', TO_DATE('2025-03-26','YYYY-MM-DD'), 'SOL50', NULL, (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI25'), (SELECT run_pro FROM PROFESOR WHERE run_pro = 'PRO00025'));

INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG001', '$30.000', TO_DATE('2025-03-02','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT001', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI01'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG002', '$36.000', TO_DATE('2025-03-02','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT002', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI01'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG003', '$40.000', TO_DATE('2025-03-03','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT003', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI02'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG004', '$50.000', TO_DATE('2025-03-03','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT004', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI02'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG005', '$24.000', TO_DATE('2025-03-04','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT005', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI03'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG006', '$32.000', TO_DATE('2025-03-04','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT006', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI03'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG007', '$44.000', TO_DATE('2025-03-05','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT007', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI04'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG008', '$60.000', TO_DATE('2025-03-05','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT008', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI04'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG009', '$28.000', TO_DATE('2025-03-06','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT009', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI05'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG010', '$38.000', TO_DATE('2025-03-06','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT010', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI05'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG011', '$26.000', TO_DATE('2025-03-07','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT011', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI06'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG012', '$34.000', TO_DATE('2025-03-07','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT012', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI06'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG013', '$42.000', TO_DATE('2025-03-08','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT013', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI07'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG014', '$56.000', TO_DATE('2025-03-08','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT014', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI07'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG015', '$31.000', TO_DATE('2025-03-09','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT015', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI08'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG016', '$48.000', TO_DATE('2025-03-09','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT016', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI08'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG017', '$37.000', TO_DATE('2025-03-10','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT017', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI09'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG018', '$52.000', TO_DATE('2025-03-10','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT018', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI09'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG019', '$25.000', TO_DATE('2025-03-11','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT019', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI10'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG020', '$41.000', TO_DATE('2025-03-11','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT020', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI10'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG021', '$29.000', TO_DATE('2025-03-12','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT021', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI11'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG022', '$46.000', TO_DATE('2025-03-12','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT022', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI11'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG023', '$33.000', TO_DATE('2025-03-13','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT023', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI12'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG024', '$54.000', TO_DATE('2025-03-13','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT024', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI12'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG025', '$22.000', TO_DATE('2025-03-14','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT025', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI13'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG026', '$35.000', TO_DATE('2025-03-14','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT026', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI13'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG027', '$45.000', TO_DATE('2025-03-15','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT027', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI14'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG028', '$64.000', TO_DATE('2025-03-15','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT028', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI14'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG029', '$27.000', TO_DATE('2025-03-16','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT029', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI15'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG030', '$39.000', TO_DATE('2025-03-16','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT030', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI15'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG031', '$30.000', TO_DATE('2025-03-17','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT031', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI16'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG032', '$43.000', TO_DATE('2025-03-17','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT032', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI16'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG033', '$58.000', TO_DATE('2025-03-18','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT033', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI17'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG034', '$70.000', TO_DATE('2025-03-18','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT034', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI17'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG035', '$32.000', TO_DATE('2025-03-19','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT035', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI18'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG036', '$47.000', TO_DATE('2025-03-19','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT036', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI18'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG037', '$34.000', TO_DATE('2025-03-20','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT037', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI19'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG038', '$51.000', TO_DATE('2025-03-20','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT038', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI19'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG039', '$28.000', TO_DATE('2025-03-21','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT039', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI20'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG040', '$53.000', TO_DATE('2025-03-21','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT040', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI20'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG041', '$24.000', TO_DATE('2025-03-22','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT041', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI21'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG042', '$36.000', TO_DATE('2025-03-22','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT042', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI21'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG043', '$40.000', TO_DATE('2025-03-23','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT043', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI22'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG044', '$57.000', TO_DATE('2025-03-23','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT044', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI22'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG045', '$30.000', TO_DATE('2025-03-24','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT045', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI23'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG046', '$44.000', TO_DATE('2025-03-24','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT046', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI23'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG047', '$49.000', TO_DATE('2025-03-25','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT047', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI24'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG048', '$62.000', TO_DATE('2025-03-25','YYYY-MM-DD'), 'Transferencia', 'Pagado', 'CT048', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI24'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG049', '$38.000', TO_DATE('2025-03-26','YYYY-MM-DD'), 'Debito', 'Pagado', 'CT049', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI25'));
INSERT INTO PAGO (id_pago, monto_pago, fec_pago, metodo_pago, estado_pago, CONTRATO_id_cont, CLIENTE_id_cli) VALUES ('PG050', '$55.000', TO_DATE('2025-03-26','YYYY-MM-DD'), 'Credito', 'Pagado', 'CT050', (SELECT id_cli FROM CLIENTE WHERE id_cli = 'CLI25'));

UPDATE CONTRATO SET PAGO_id_pago = 'PG001' WHERE id_cont = 'CT001';
UPDATE CONTRATO SET PAGO_id_pago = 'PG002' WHERE id_cont = 'CT002';
UPDATE CONTRATO SET PAGO_id_pago = 'PG003' WHERE id_cont = 'CT003';
UPDATE CONTRATO SET PAGO_id_pago = 'PG004' WHERE id_cont = 'CT004';
UPDATE CONTRATO SET PAGO_id_pago = 'PG005' WHERE id_cont = 'CT005';
UPDATE CONTRATO SET PAGO_id_pago = 'PG006' WHERE id_cont = 'CT006';
UPDATE CONTRATO SET PAGO_id_pago = 'PG007' WHERE id_cont = 'CT007';
UPDATE CONTRATO SET PAGO_id_pago = 'PG008' WHERE id_cont = 'CT008';
UPDATE CONTRATO SET PAGO_id_pago = 'PG009' WHERE id_cont = 'CT009';
UPDATE CONTRATO SET PAGO_id_pago = 'PG010' WHERE id_cont = 'CT010';
UPDATE CONTRATO SET PAGO_id_pago = 'PG011' WHERE id_cont = 'CT011';
UPDATE CONTRATO SET PAGO_id_pago = 'PG012' WHERE id_cont = 'CT012';
UPDATE CONTRATO SET PAGO_id_pago = 'PG013' WHERE id_cont = 'CT013';
UPDATE CONTRATO SET PAGO_id_pago = 'PG014' WHERE id_cont = 'CT014';
UPDATE CONTRATO SET PAGO_id_pago = 'PG015' WHERE id_cont = 'CT015';
UPDATE CONTRATO SET PAGO_id_pago = 'PG016' WHERE id_cont = 'CT016';
UPDATE CONTRATO SET PAGO_id_pago = 'PG017' WHERE id_cont = 'CT017';
UPDATE CONTRATO SET PAGO_id_pago = 'PG018' WHERE id_cont = 'CT018';
UPDATE CONTRATO SET PAGO_id_pago = 'PG019' WHERE id_cont = 'CT019';
UPDATE CONTRATO SET PAGO_id_pago = 'PG020' WHERE id_cont = 'CT020';
UPDATE CONTRATO SET PAGO_id_pago = 'PG021' WHERE id_cont = 'CT021';
UPDATE CONTRATO SET PAGO_id_pago = 'PG022' WHERE id_cont = 'CT022';
UPDATE CONTRATO SET PAGO_id_pago = 'PG023' WHERE id_cont = 'CT023';
UPDATE CONTRATO SET PAGO_id_pago = 'PG024' WHERE id_cont = 'CT024';
UPDATE CONTRATO SET PAGO_id_pago = 'PG025' WHERE id_cont = 'CT025';
UPDATE CONTRATO SET PAGO_id_pago = 'PG026' WHERE id_cont = 'CT026';
UPDATE CONTRATO SET PAGO_id_pago = 'PG027' WHERE id_cont = 'CT027';
UPDATE CONTRATO SET PAGO_id_pago = 'PG028' WHERE id_cont = 'CT028';
UPDATE CONTRATO SET PAGO_id_pago = 'PG029' WHERE id_cont = 'CT029';
UPDATE CONTRATO SET PAGO_id_pago = 'PG030' WHERE id_cont = 'CT030';
UPDATE CONTRATO SET PAGO_id_pago = 'PG031' WHERE id_cont = 'CT031';
UPDATE CONTRATO SET PAGO_id_pago = 'PG032' WHERE id_cont = 'CT032';
UPDATE CONTRATO SET PAGO_id_pago = 'PG033' WHERE id_cont = 'CT033';
UPDATE CONTRATO SET PAGO_id_pago = 'PG034' WHERE id_cont = 'CT034';
UPDATE CONTRATO SET PAGO_id_pago = 'PG035' WHERE id_cont = 'CT035';
UPDATE CONTRATO SET PAGO_id_pago = 'PG036' WHERE id_cont = 'CT036';
UPDATE CONTRATO SET PAGO_id_pago = 'PG037' WHERE id_cont = 'CT037';
UPDATE CONTRATO SET PAGO_id_pago = 'PG038' WHERE id_cont = 'CT038';
UPDATE CONTRATO SET PAGO_id_pago = 'PG039' WHERE id_cont = 'CT039';
UPDATE CONTRATO SET PAGO_id_pago = 'PG040' WHERE id_cont = 'CT040';
UPDATE CONTRATO SET PAGO_id_pago = 'PG041' WHERE id_cont = 'CT041';
UPDATE CONTRATO SET PAGO_id_pago = 'PG042' WHERE id_cont = 'CT042';
UPDATE CONTRATO SET PAGO_id_pago = 'PG043' WHERE id_cont = 'CT043';
UPDATE CONTRATO SET PAGO_id_pago = 'PG044' WHERE id_cont = 'CT044';
UPDATE CONTRATO SET PAGO_id_pago = 'PG045' WHERE id_cont = 'CT045';
UPDATE CONTRATO SET PAGO_id_pago = 'PG046' WHERE id_cont = 'CT046';
UPDATE CONTRATO SET PAGO_id_pago = 'PG047' WHERE id_cont = 'CT047';
UPDATE CONTRATO SET PAGO_id_pago = 'PG048' WHERE id_cont = 'CT048';
UPDATE CONTRATO SET PAGO_id_pago = 'PG049' WHERE id_cont = 'CT049';
UPDATE CONTRATO SET PAGO_id_pago = 'PG050' WHERE id_cont = 'CT050';

INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS001', 'CT001', 5.0, 'Excelente profesor, domina totalmente la materia de álgebra.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS002', 'CT002', 4.5, 'Muy clara la explicación y buenos ejercicios resueltos.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS003', 'CT003', 4.8, 'Gran metodología pedagógica en clases de física.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS004', 'CT004', 5.0, 'Superó totalmente mis expectativas, muy recomendado.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS005', 'CT005', 4.2, 'Puntual y con buen material didáctico.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS006', 'CT006', 4.7, 'Explica los conceptos difíciles de forma sencilla.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS007', 'CT007', 5.0, 'Excelente docente de programación, aprendí muchísimo.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS008', 'CT008', 4.9, 'Clases bien estructuradas y con muchos ejemplos prácticos.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS009', 'CT009', 4.6, 'Muy paciente al resolver dudas complejas sobre SQL.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS010', 'CT010', 5.0, 'Dominio avanzado en administración Oracle.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS011', 'CT011', 4.4, 'Clases dinámicas y fluidas en inglés.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS012', 'CT012', 4.8, 'Me ayudó a soltar la fluidez en conversaciones corporativas.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS013', 'CT013', 4.9, 'Muy apasionado por la historia de Chile, excelente clase.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS014', 'CT014', 5.0, 'Contenidos completos y muy bien contextualizados.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS015', 'CT015', 4.3, 'Buenas correcciones en los ensayos de literatura.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS016', 'CT016', 4.7, 'Atento a los detalles ortográficos y estilísticos.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS017', 'CT017', 5.0, 'Claridad absoluta en conceptos financieros y contables.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS018', 'CT018', 4.8, 'Gran apoyo para la preparación del presupuesto de mi PyME.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS019', 'CT019', 4.5, 'Estrategias muy actualizadas de marketing digital.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS020', 'CT020', 4.9, 'Aprendí a configurar campañas efectivas en redes.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS021', 'CT021', 5.0, 'Súper didáctico enseñando Photoshop desde cero.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS022', 'CT022', 4.7, 'Buenos trucos y atajos para trabajar en Illustrator.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS023', 'CT023', 4.6, 'Me quitó el miedo a leer partituras musicales.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS024', 'CT024', 5.0, 'Gran virtuosismo y paciencia en las clases de piano.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS025', 'CT025', 4.8, 'Clases de guitarra muy entretenidas y personalizadas.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS026', 'CT026', 4.9, 'Excelente técnica de punteo y solos en guitarra eléctrica.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS027', 'CT027', 4.5, 'Rutinas exigentes pero adaptadas a mi nivel físico.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS028', 'CT028', 5.0, 'Motivador constante en cada sesión de calistenia.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS029', 'CT029', 4.7, 'Ambiente muy relajante y postura bien guiada en yoga.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS030', 'CT030', 4.9, 'Las sesiones de meditación guiada son de gran ayuda.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS031', 'CT031', 4.8, 'Empático y muy profesional en el área de psicología.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS032', 'CT032', 5.0, 'Profundo conocimiento en teoría y consulta clínica.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS033', 'CT033', 4.6, 'Explicaciones jurídicas claras con casos reales.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS034', 'CT034', 4.9, 'Asesoría clave en la comprensión del código del trabajo.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS035', 'CT035', 5.0, 'Enseña el manejo de la luz y exposición de forma impecable.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS036', 'CT036', 4.8, 'Gran dominio en edición fotográfica digital.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS037', 'CT037', 4.7, 'Pautas nutricionales realistas y fáciles de seguir.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS038', 'CT038', 5.0, 'Resultados notables en mi rendimiento deportivo.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS039', 'CT039', 4.9, 'Excelente para comprender maquetación y CSS responsivo.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS040', 'CT040', 5.0, 'Profesor top en el ecosistema React y JS.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS041', 'CT041', 4.5, 'Muy buena pronunciación y paciencia con el francés.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS042', 'CT042', 4.8, 'Ejercicios fonéticos muy útiles para hablar con soltura.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS043', 'CT043', 4.6, 'Explicación detallada de código en lenguaje R.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS044', 'CT044', 4.9, 'Dominio riguroso en pruebas de hipótesis y estadística.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS045', 'CT045', 5.0, 'Clases de teatro dinámicas, divertidas y liberadoras.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS046', 'CT046', 4.8, 'Técnicas efectivas para la expresión corporal y oratoria.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS047', 'CT047', 5.0, 'Laboratorios de ciberseguridad muy realistas y retadores.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS048', 'CT048', 4.9, 'Atento a resolver fallos de configuración en las prácticas.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS049', 'CT049', 4.7, 'Explicaciones apasionantes sobre el universo y cosmología.');
INSERT INTO RESENA (rese_id, id_cont, califi_rese, comen_rese) VALUES ('RS050', 'CT050', 5.0, 'Un lujo de clase sobre física de sistemas planetarios.');

