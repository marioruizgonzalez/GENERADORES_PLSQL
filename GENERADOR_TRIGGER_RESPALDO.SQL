CREATE OR REPLACE PROCEDURE GENERADOR_TRIGGER_RESPALDO
IS

  /***************************************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                                            *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD GENERAR LOS TRIGGERS DE TODAS         *
  *               LAS TABLAS PARA EL PROCEDIMIENTO DE RESPALDOS                                                  *
  ***************************************************************************************************************/

      --VARIABLES
      LN_TABLAS_AFECTADAS NUMBER(19);
      LV_CODIGO_FINAL VARCHAR2(32767);
      LV_SECUENCIA VARCHAR2(32767);

      CODIGO VARCHAR2(32767);
      CODIGO2 VARCHAR2(32767);

      CREA VARCHAR2(32767);
      CONTADOR NUMBER(19):= 1;
      TOTAL NUMBER(19):= 1;
      LON NUMBER(19);


BEGIN
      SELECT COUNT(1)
      INTO LN_TABLAS_AFECTADAS
      FROM ALL_TABLES
      WHERE SUBSTR(UPPER(TABLE_NAME),1,8)LIKE UPPER('FICE_ADM')
      OR SUBSTR(UPPER(TABLE_NAME),1,8)LIKE UPPER('FICE_CAT')
      OR SUBSTR(UPPER(TABLE_NAME),1,8)LIKE UPPER('FICE_OPE');

      DBMS_OUTPUT.PUT_LINE('Se realizara la creacion del trigger, sobre '||LN_TABLAS_AFECTADAS||' Tablas'||CHR(13));

      --COMIENZA LA CREACION DE TRIGGER POR TABLA
      FOR DATO IN (SELECT DISTINCT TABLE_NAME FROM ALL_TABLES WHERE SUBSTR(UPPER(TABLE_NAME),1,8)LIKE UPPER('FICE_ADM')
                                                                 OR SUBSTR(UPPER(TABLE_NAME),1,8)LIKE UPPER('FICE_CAT')
                                                                 OR SUBSTR(UPPER(TABLE_NAME),1,8)LIKE UPPER('FICE_OPE'))
      LOOP

              SELECT LENGTH(DATO.table_name)
              INTO LON
              FROM DUAL;

              SELECT COUNT(COLUMN_NAME)
              INTO TOTAL
              FROM ALL_TAB_COLUMNS
              WHERE TABLE_NAME = DATO.table_name;

              CODIGO:='';
              CODIGO2:='';
              CONTADOR:=1;

                    FOR I IN (SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION FROM ALL_TAB_COLUMNS
                              WHERE UPPER(TRIM(TABLE_NAME)) LIKE UPPER(TRIM(DATO.TABLE_NAME))
                              ORDER BY COLUMN_ID ASC
                              )

                              LOOP
                                    IF CONTADOR = TOTAL THEN
                                       CODIGO:= CODIGO ||I.COLUMN_NAME||'),'||CHR(13);
                                       CODIGO2:= CODIGO2||':OLD.'|| I.COLUMN_NAME||','||CHR(13);
                                       CONTADOR:=0;
                                    END IF ;

                                    IF CONTADOR >= 1 AND CONTADOR < TOTAL AND CONTADOR <> 0 THEN
                                       CODIGO:= CODIGO ||I.COLUMN_NAME||'),'||CHR(13);
                                       CODIGO2:= CODIGO2 ||':OLD.'|| I.COLUMN_NAME||','||CHR(13);
                                    END IF;
                                    CONTADOR:=CONTADOR+1;
                              END LOOP;


      LV_SECUENCIA:= 'CREATE SEQUENCE FICE_SEC_'||SUBSTR(DATO.TABLE_NAME,10,14)||'_R'||CHR(13)||
      'START WITH 1000'||CHR(13)||
      'INCREMENT BY 1'||CHR(13)||
      'NOCACHE'||CHR(13)||
      'NOCYCLE;';

      LV_CODIGO_FINAL:='CREATE OR REPLACE TRIGGER FICE_TGR_'||SUBSTR(DATO.TABLE_NAME,10,14)||'_R'||CHR(13)||
                      'BEFORE UPDATE ON '||DATO.TABLE_NAME||CHR(13)||
                      'FOR EACH ROW'||CHR(13)||
                      'BEGIN'||CHR(13)||
                        'IF UPDATING THEN'||CHR(13)||
                          'INSERT INTO '||DATO.TABLE_NAME||'_R'||CHR(13)||
                              '('||CHR(13)||
                              'ID,'||CHR(13)||
                              CODIGO||
                              'FECHA_RESPALDO'||CHR(13)||
                              ')'||CHR(13)||
                              'VALUES'||CHR(13)||
                              '('||CHR(13)||
                              'FICE_SEC_'||SUBSTR(DATO.TABLE_NAME,10,14)||'_R.NEXTVAL,'||CHR(13)||
                              CODIGO2||
                              'SYSDATE'||CHR(13)||
                              ');'||CHR(13)||
                        'ELSIF  INSERTING  THEN NULL;'||CHR(13)||
                        'ELSIF  DELETING  THEN NULL;'||CHR(13)||
                        'END IF;'||CHR(13)||
                      'END;';

      DBMS_OUTPUT.PUT_LINE(LV_SECUENCIA||CHR(13));
      
      DBMS_OUTPUT.PUT_LINE(LV_CODIGO_FINAL||CHR(13));



      END LOOP;

END;
/
