CREATE OR REPLACE PROCEDURE GENERA_TABLAS_RESPALDO
IS

  /***************************************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                                            *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD GENERAR LAS TABLAS PARA               *
  *               EL PROCEDIMIENTO DE RESPALDOS                                                                  *
  ***************************************************************************************************************/

CODIGO VARCHAR2(32767);
CREA VARCHAR2(32767);
CONTADOR NUMBER(19):= 1;
TOTAL NUMBER(19):= 1;
LON NUMBER(19);

BEGIN

  FOR J IN (SELECT DISTINCT TABLE_NAME FROM ALL_TAB_COLUMNS
            WHERE SUBSTR(TABLE_NAME,1,4) LIKE 'FICE'
            AND (SUBSTR(TABLE_NAME,6,3) LIKE 'ADM' OR SUBSTR(TABLE_NAME,6,3) LIKE 'CAT' OR SUBSTR(TABLE_NAME,6,3) LIKE ('OPE'))
            )

            LOOP

              SELECT LENGTH(j.table_name)
              INTO LON
              FROM DUAL;

              SELECT COUNT(COLUMN_NAME)
              INTO TOTAL
              FROM ALL_TAB_COLUMNS
              WHERE TABLE_NAME = j.table_name;

              CREA:='';
              CODIGO:='';
                    CONTADOR:=1;
                    FOR I IN (SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION FROM ALL_TAB_COLUMNS
                              WHERE UPPER(TRIM(TABLE_NAME)) LIKE UPPER(TRIM(J.TABLE_NAME))
                              ORDER BY COLUMN_ID ASC
                              )

                              LOOP
                                    IF CONTADOR = TOTAL THEN
                                       CODIGO:= CODIGO ||I.COLUMN_NAME||' '||I.DATA_TYPE||'('||CASE WHEN (I.DATA_TYPE LIKE 'NUMBER') THEN I.DATA_PRECISION ELSE I.DATA_LENGTH END ||'),'||CHR(13);
                                       CONTADOR:=0;
                                    END IF ;

                                    IF CONTADOR >= 1 AND CONTADOR < TOTAL AND CONTADOR <> 0 THEN
                                       CODIGO:= CODIGO ||I.COLUMN_NAME||' '||I.DATA_TYPE||'('||CASE WHEN (I.DATA_TYPE LIKE 'NUMBER') THEN I.DATA_PRECISION ELSE I.DATA_LENGTH END ||'),'||CHR(13);
                                    END IF;
                                    CONTADOR:=CONTADOR+1;
                              END LOOP;

                              CREA:= CREA || 'CREATE TABLE' ||' '|| j.table_name ||'_R' ||CHR(13)||
                              '('||CHR(13)||
                              CODIGO ||
                              'FECHA_RESPALDO DATE'||CHR(13)||
                              ' );'||CHR(13)||CHR(13);

              DBMS_OUTPUT.PUT_LINE(CREA);

             END LOOP;


  END;
/
