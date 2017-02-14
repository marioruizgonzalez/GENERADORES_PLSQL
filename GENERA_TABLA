CREATE OR REPLACE PROCEDURE GENERA_TABLA (PV_NOMBRE_TABLA VARCHAR2 )
IS

  /***************************************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                                            *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD COMPLETAR LA ESTRUCTURA DE LAS TABLAS *
  *               ACORDE CON LAS PRECONDICIONES ESTANDARIZADAS POR BITACORAS                                     *
  ***************************************************************************************************************/

CODIGO VARCHAR2(32767);
CODIGO2 VARCHAR2(32767);
CODIGO3 VARCHAR2(32767);
CREA VARCHAR2(32767):= 'CREATE TABLE ';
BORRADO VARCHAR2(100):= 'DROP TABLE ';
INSERTA VARCHAR2(32767):= 'INSERT INTO ';
SELECION VARCHAR(32767):= 'SELECT * FROM ';
CONTADOR NUMBER:= 1;
TOTAL NUMBER:= 1;
LON NUMBER(19);

BEGIN

  SELECT LENGTH(PV_NOMBRE_TABLA)
  INTO LON
  FROM DUAL;

  SELECT COUNT(COLUMN_NAME)
  INTO TOTAL
  FROM ALL_TAB_COLUMNS
  WHERE TABLE_NAME = PV_NOMBRE_TABLA;

  BORRADO:= BORRADO || PV_NOMBRE_TABLA || ';'|| CHR(13);

  FOR I IN (SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION FROM ALL_TAB_COLUMNS
            WHERE TABLE_NAME = PV_NOMBRE_TABLA)
            LOOP

                  IF CONTADOR = 1 THEN
                    CODIGO:= CODIGO ||'CODIGO_'||SUBSTR(PV_NOMBRE_TABLA,10,(LON))||' '||I.DATA_TYPE||'('||CASE WHEN (I.DATA_TYPE LIKE 'NUMBER') THEN I.DATA_PRECISION ELSE I.DATA_LENGTH END ||'),'||CHR(13);
                    CODIGO2:= CODIGO2 ||'CODIGO_'||SUBSTR(PV_NOMBRE_TABLA,10,(LON))||','||CHR(13);
                    CODIGO3:= CODIGO3 ||I.COLUMN_NAME||','||CHR(13);
                  END IF;

                  IF CONTADOR = TOTAL THEN
                    CODIGO:= CODIGO ||I.COLUMN_NAME||' '||I.DATA_TYPE||'('||CASE WHEN (I.DATA_TYPE LIKE 'NUMBER') THEN I.DATA_PRECISION ELSE I.DATA_LENGTH END ||'),'||CHR(13);
                    CODIGO2:= CODIGO2 ||I.COLUMN_NAME||CHR(13);
                    CODIGO3:= CODIGO3 ||I.COLUMN_NAME||CHR(13);
                  END IF ;

                  IF CONTADOR > 1 AND CONTADOR < TOTAL THEN
                    CODIGO:= CODIGO ||I.COLUMN_NAME||' '||I.DATA_TYPE||'('||CASE WHEN (I.DATA_TYPE LIKE 'NUMBER') THEN I.DATA_PRECISION ELSE I.DATA_LENGTH END ||'),'||CHR(13);
                    CODIGO2:= CODIGO2 ||I.COLUMN_NAME||','||CHR(13);
                    CODIGO3:= CODIGO3 ||I.COLUMN_NAME||','||CHR(13);
                  END IF;
                  CONTADOR:=CONTADOR+1;
            END LOOP;


            CREA:= CREA ||PV_NOMBRE_TABLA||'2'||CHR(13)||
            '('||CHR(13)||
            'CODIGO_EMPRESA NUMBER(19),'||CHR(13)||
            CODIGO||CHR(13)||
            'ESTATUS            VARCHAR2(100) DEFAULT ''A'',
             ADICIONADO_POR     VARCHAR2(100),
             FECHA_ADICION      DATE,
             MODIFICADO_POR     VARCHAR2(100),
             FECHA_MODIFICACION DATE,
             PROGRAMA           VARCHAR2(100)
             );';



            INSERTA:= INSERTA || PV_NOMBRE_TABLA ||'2'||' '|| CHR(13)||
                                 '( CODIGO_EMPRESA,'|| CHR(13)||
                                 CODIGO2||CHR(13)||
                                 ')'|| CHR(13)||
                                 'SELECT 1,'|| CHR(13)||
                                 CODIGO3||
                                 'FROM '|| PV_NOMBRE_TABLA ||';'|| CHR(13);

            DBMS_OUTPUT.PUT_LINE(CREA||CHR(13));

            DBMS_OUTPUT.PUT_LINE(INSERTA|| CHR(13));

            DBMS_OUTPUT.PUT_LINE(SELECION||PV_NOMBRE_TABLA||'2'|| CHR(13));

            DBMS_OUTPUT.PUT_LINE(BORRADO|| CHR(13));

            DBMS_OUTPUT.PUT_LINE('ALTER TABLE '||PV_NOMBRE_TABLA ||'2 RENAME TO '||PV_NOMBRE_TABLA|| CHR(13));

  END;
/
