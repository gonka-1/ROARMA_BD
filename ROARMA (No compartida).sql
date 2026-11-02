---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-- FUNCION 1: Promedio de calificaciones de un profesor
CREATE OR REPLACE FUNCTION FN_PROMEDIO_RESENA(
    VFN_ID_PROF IN VARCHAR2
) RETURN NUMBER IS
    VFN_PROMEDIO NUMBER(3,2) := 0;
BEGIN  
    SELECT NVL(AVG(RE.CALIFI_RESE), 0)
    INTO VFN_PROMEDIO
    FROM RESENA RE
    JOIN CONTRATO CON ON (RE.ID_CONT = CON.ID_CONT)
    WHERE CON.PROFESOR_RUN_PRO = VFN_ID_PROF;
    
    RETURN VFN_PROMEDIO;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END FN_PROMEDIO_RESENA;
/

-- FUNCION 2: Validar título registrado 
CREATE OR REPLACE FUNCTION FN_VALIDAR_TITULO(
    VFN_ID_PROF IN VARCHAR2
) RETURN VARCHAR2 IS 
    VFN_COUNT NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO VFN_COUNT
    FROM TITULO
    WHERE PROFESOR_RUN_PRO = VFN_ID_PROF;
    
    IF VFN_COUNT > 0 THEN
        RETURN 'CON TITULO';
    ELSE 
        RETURN 'SIN TITULO';
    END IF;
EXCEPTION
    WHEN OTHERS THEN 
        RETURN 'SIN TITULO';
END FN_VALIDAR_TITULO;
/

-- FUNCION 3: Validar si existe un usuario registrado en el sistema
CREATE OR REPLACE FUNCTION FN_VALIDAR_USUARIO_EXISTE (
    VFN_ID_USU IN VARCHAR2
) RETURN VARCHAR2 IS
    VFN_COUNT NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO VFN_COUNT
    FROM USUARIO
    WHERE id_usu = VFN_ID_USU;

    IF VFN_COUNT > 0 THEN
        RETURN 'ACTIVO';
    ELSE
        RETURN 'INACTIVO';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR';
END FN_VALIDAR_USUARIO_EXISTE;
/

---------------------------------------------------------------------------------
-- PROCEDIMIENTOS
---------------------------------------------------------------------------------

-- PROCEDIMIENTO 1: Registrar o actualizar contrato
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_CONTRATO(
    P_ID_CONT      IN VARCHAR2,
    P_FECHA        IN DATE,
    P_ID_CLI       IN VARCHAR2,
    P_RUN_PRO      IN VARCHAR2,
    P_MONTO_ACOR   IN VARCHAR2 DEFAULT '0',
    P_DURACION     IN VARCHAR2 DEFAULT '1 MES',
    P_ESTADO       IN VARCHAR2 DEFAULT 'ACTIVO',
    P_SOLICITUD_ID IN VARCHAR2 DEFAULT 'SOL01'
) IS 
BEGIN 
    INSERT INTO CONTRATO(
        ID_CONT, 
        FEC_ACUE_CONT, 
        CLIENTE_ID_CLI, 
        PROFESOR_RUN_PRO,
        MONTO_ACOR,
        DURACION_CONT,
        ESTADO_CONT,
        SOLICITUD_SOLI_ID
    ) VALUES (
        P_ID_CONT, 
        P_FECHA, 
        P_ID_CLI, 
        P_RUN_PRO,
        P_MONTO_ACOR,
        P_DURACION,
        P_ESTADO,
        P_SOLICITUD_ID
    );
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE CONTRATO
        SET FEC_ACUE_CONT     = P_FECHA,
            CLIENTE_ID_CLI    = P_ID_CLI,
            PROFESOR_RUN_PRO  = P_RUN_PRO,
            MONTO_ACOR        = P_MONTO_ACOR,
            DURACION_CONT     = P_DURACION,
            ESTADO_CONT       = P_ESTADO,
            SOLICITUD_SOLI_ID = P_SOLICITUD_ID
        WHERE ID_CONT = P_ID_CONT;
        COMMIT;
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Error al registrar contrato: ' || SQLERRM);
END PR_REGISTRAR_CONTRATO;
/

-- PROCEDIMIENTO 2: Registrar pago de un contrato
CREATE OR REPLACE PROCEDURE PR_REGISTRAR_PAGO(
    P_ID_PAGO     IN VARCHAR2,
    P_MONTO       IN NUMBER,
    P_FECHA       IN DATE,
    P_ID_CONT     IN VARCHAR2,
    P_METODO_PAGO IN VARCHAR2 DEFAULT 'EFECTIVO',
    P_ESTADO_PAGO IN VARCHAR2 DEFAULT 'PAGADO',
    P_ID_CLI      IN VARCHAR2 DEFAULT 'CLI01'
) IS
BEGIN
    IF P_MONTO <= 0 THEN 
        RAISE_APPLICATION_ERROR(-20002, 'El monto del pago debe ser mayor a cero.');
    END IF;
    
    INSERT INTO PAGO(
        ID_PAGO, 
        MONTO_PAGO, 
        FEC_PAGO, 
        METODO_PAGO,
        ESTADO_PAGO,
        CONTRATO_ID_CONT,
        CLIENTE_ID_CLI
    ) VALUES (
        P_ID_PAGO, 
        TO_CHAR(P_MONTO), 
        P_FECHA, 
        P_METODO_PAGO,
        P_ESTADO_PAGO,
        P_ID_CONT,
        P_ID_CLI
    );
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        RAISE;
END PR_REGISTRAR_PAGO;
/

-- PROCEDIMIENTO 3: Insertar registro de procedimientos en tabla resumen
CREATE OR REPLACE PROCEDURE P_INSERTAR_RESUMEN_ROARMA(
    P_ID_RESUMEN        IN NUMBER,
    P_ID_CLI            IN VARCHAR2,
    P_RUN_CLI           IN VARCHAR2,
    P_NOMBRE_CLI        IN VARCHAR2,
    P_TIPO_CLI          IN VARCHAR2,
    P_TOTAL_PAGADO      IN NUMBER,
    P_RUN_PROF          IN VARCHAR2,
    P_PROMEDIO_RESENA   IN NUMBER,
    P_TITULO_PROFESOR   IN VARCHAR2
) IS 
BEGIN 
    INSERT INTO RESUMEN_GESTION_ROARMA(
        ID_RESUMEN,
        ID_CLI,
        RUN_CLI,
        NOMBRE_CLI,
        TIPO_CLI,
        TOTAL_PAGADO,
        ID_PROF,
        PROMEDIO_RESENA,
        TITULO_PROFESOR,
        FECHA_PROCESO
    ) VALUES (
        P_ID_RESUMEN,        
        P_ID_CLI,          
        P_RUN_CLI,         
        P_NOMBRE_CLI,        
        P_TIPO_CLI,          
        P_TOTAL_PAGADO,      
        P_RUN_PROF,          
        P_PROMEDIO_RESENA,   
        P_TITULO_PROFESOR,
        SYSDATE
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error al insertar en resumen: ' || SQLERRM);
END P_INSERTAR_RESUMEN_ROARMA;
/
---------------------------------------------------------------------------------
-- BLOQUE ANÓNIMO PRINCIPAL
---------------------------------------------------------------------------------
ALTER SESSION DISABLE PARALLEL QUERY;

SET SERVEROUTPUT ON;

DECLARE 
    TYPE REC_RESUMEN IS RECORD (
        VR_ID_RESUMEN      RESUMEN_GESTION_ROARMA.ID_RESUMEN%TYPE,
        VR_ID_CLI          RESUMEN_GESTION_ROARMA.ID_CLI%TYPE,
        VR_RUN_CLI         RESUMEN_GESTION_ROARMA.RUN_CLI%TYPE,
        VR_NOMBRE_CLI      RESUMEN_GESTION_ROARMA.NOMBRE_CLI%TYPE,
        VR_TIPO_CLI        RESUMEN_GESTION_ROARMA.TIPO_CLI%TYPE,
        VR_TOTAL_PAGADO    RESUMEN_GESTION_ROARMA.TOTAL_PAGADO%TYPE,
        VR_ID_PROF         RESUMEN_GESTION_ROARMA.ID_PROF%TYPE,
        VR_PROMEDIO_RESENA RESUMEN_GESTION_ROARMA.PROMEDIO_RESENA%TYPE,
        VR_TITULO_PROFESOR RESUMEN_GESTION_ROARMA.TITULO_PROFESOR%TYPE
    );
    
    OBJ_REC_RESUMEN REC_RESUMEN;
    
    CURSOR C_GESTION IS
        SELECT 
            CLI.RUN_PER AS RUN_CLIENTE,
            PER.PNOMBRE_PER ||' '|| PER.PAPELLIDO_PER AS NOMBRE_CLIENTE,
            CLI.ID_CLI AS ID_CLIENTE,
            CON.ID_CONT AS ID_CONTRATO,
            CON.PROFESOR_RUN_PRO AS ID_PROF
        FROM CLIENTE CLI 
        JOIN PERSONA PER ON (CLI.RUN_PER = PER.RUN_PER)
        JOIN CONTRATO CON ON (CLI.ID_CLI = CON.CLIENTE_ID_CLI); 
            
    V_ID_RESUMEN       NUMBER := 0;
    V_CONT_PROCESADOS  NUMBER := 0;
    V_CONT_ERRORES     NUMBER := 0;
    V_SUMA_PAGADO      NUMBER := 0;
    V_PROMEDIO_PAGADO  NUMBER := 0;

BEGIN
    -- Limpieza previa de la tabla de destino
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_GESTION_ROARMA';

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' ROARMA SCHEMA - RESUMEN DE GESTION CONSOLIDADO');
    DBMS_OUTPUT.PUT_LINE(' FECHA DE PROCESO: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');
    
    FOR i IN C_GESTION LOOP
        BEGIN
            V_ID_RESUMEN                  := V_ID_RESUMEN + 1;
            OBJ_REC_RESUMEN.VR_ID_RESUMEN := V_ID_RESUMEN;
            OBJ_REC_RESUMEN.VR_ID_CLI     := NVL(i.ID_CLIENTE, 'N/A');
            OBJ_REC_RESUMEN.VR_RUN_CLI    := i.RUN_CLIENTE;
            OBJ_REC_RESUMEN.VR_NOMBRE_CLI := i.NOMBRE_CLIENTE;
            OBJ_REC_RESUMEN.VR_TIPO_CLI   := 'REGULAR';
            OBJ_REC_RESUMEN.VR_ID_PROF    := NVL(i.ID_PROF, 'N/A');
        
            IF i.ID_PROF IS NOT NULL AND i.ID_PROF <> 'N/A' THEN
                OBJ_REC_RESUMEN.VR_PROMEDIO_RESENA := FN_PROMEDIO_RESENA(i.ID_PROF);
                OBJ_REC_RESUMEN.VR_TITULO_PROFESOR := FN_VALIDAR_TITULO(i.ID_PROF);
            ELSE
                OBJ_REC_RESUMEN.VR_PROMEDIO_RESENA := 0;
                OBJ_REC_RESUMEN.VR_TITULO_PROFESOR := 'SIN PROFESOR';
            END IF;

            SELECT NVL(SUM(TO_NUMBER(REGEXP_REPLACE(MONTO_PAGO, '[^0-9]', ''))), 0)
            INTO OBJ_REC_RESUMEN.VR_TOTAL_PAGADO
            FROM PAGO
            WHERE CONTRATO_ID_CONT = i.ID_CONTRATO;

            -- Inserción de la fila consolidada en la tabla resumen
            P_INSERTAR_RESUMEN_ROARMA(
                P_ID_RESUMEN      => OBJ_REC_RESUMEN.VR_ID_RESUMEN,
                P_ID_CLI          => OBJ_REC_RESUMEN.VR_ID_CLI,
                P_RUN_CLI         => OBJ_REC_RESUMEN.VR_RUN_CLI,
                P_NOMBRE_CLI      => OBJ_REC_RESUMEN.VR_NOMBRE_CLI,
                P_TIPO_CLI        => OBJ_REC_RESUMEN.VR_TIPO_CLI,
                P_TOTAL_PAGADO    => OBJ_REC_RESUMEN.VR_TOTAL_PAGADO,
                P_RUN_PROF        => OBJ_REC_RESUMEN.VR_ID_PROF,
                P_PROMEDIO_RESENA => OBJ_REC_RESUMEN.VR_PROMEDIO_RESENA,
                P_TITULO_PROFESOR => OBJ_REC_RESUMEN.VR_TITULO_PROFESOR
            );
        
            COMMIT;
        
            -- Registro de estadísticas globales
            V_CONT_PROCESADOS := V_CONT_PROCESADOS + 1;
            V_SUMA_PAGADO     := V_SUMA_PAGADO + OBJ_REC_RESUMEN.VR_TOTAL_PAGADO;
        
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('INFORME DE PROCESO ITERACION : ' || OBJ_REC_RESUMEN.VR_ID_RESUMEN);
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('ID CLIENTE                : ' || OBJ_REC_RESUMEN.VR_ID_CLI);
            DBMS_OUTPUT.PUT_LINE('RUN CLIENTE               : ' || OBJ_REC_RESUMEN.VR_RUN_CLI);
            DBMS_OUTPUT.PUT_LINE('NOMBRE CLIENTE            : ' || OBJ_REC_RESUMEN.VR_NOMBRE_CLI);
            DBMS_OUTPUT.PUT_LINE('ID PROFESOR               : ' || OBJ_REC_RESUMEN.VR_ID_PROF);
            DBMS_OUTPUT.PUT_LINE('ESTADO TITULO PROFESOR    : ' || OBJ_REC_RESUMEN.VR_TITULO_PROFESOR);
            DBMS_OUTPUT.PUT_LINE('PROMEDIO RESENAS          : ' || TO_CHAR(OBJ_REC_RESUMEN.VR_PROMEDIO_RESENA, '0.00'));
            DBMS_OUTPUT.PUT_LINE('TOTAL PAGADO              : ' || TO_CHAR(OBJ_REC_RESUMEN.VR_TOTAL_PAGADO, '$999G999G999'));

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                V_CONT_ERRORES := V_CONT_ERRORES + 1;
                DBMS_OUTPUT.PUT_LINE('ERROR CLIENTE: ' || i.RUN_CLIENTE || ': ID_RESUMEN DUPLICADO.');
            WHEN OTHERS THEN
                V_CONT_ERRORES := V_CONT_ERRORES + 1;
                DBMS_OUTPUT.PUT_LINE('ERROR CLIENTE: ' || i.RUN_CLIENTE);
                DBMS_OUTPUT.PUT_LINE('ERROR SISTEMA: ' || SQLERRM);
        END;
    END LOOP;
    
    -- Cálculo del promedio ponderado final
    IF V_CONT_PROCESADOS > 0 THEN
        V_PROMEDIO_PAGADO := ROUND(V_SUMA_PAGADO / V_CONT_PROCESADOS);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('===============================================================');
    DBMS_OUTPUT.PUT_LINE('REPORTE DE PROCESO GENERAL');
    DBMS_OUTPUT.PUT_LINE('===============================================================');
    DBMS_OUTPUT.PUT_LINE('REGISTROS PROCESADOS  : ' || V_CONT_PROCESADOS);
    DBMS_OUTPUT.PUT_LINE('REGISTROS CON ERROR   : ' || V_CONT_ERRORES);
    DBMS_OUTPUT.PUT_LINE('SUMA TOTAL PAGADOS    : ' || TO_CHAR(V_SUMA_PAGADO, '$999G999G999G999'));
    DBMS_OUTPUT.PUT_LINE('PROMEDIO POR REGISTRO : ' || TO_CHAR(V_PROMEDIO_PAGADO, '$999G999G999G999'));
    DBMS_OUTPUT.PUT_LINE('PROCESO FINALIZADO CON ÉXITO.');
END;
/



