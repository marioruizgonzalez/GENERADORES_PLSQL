CREATE OR REPLACE PROCEDURE GENERA_PROCEDURE(PV_NOMBRE_TABLA VARCHAR2, PV_PAQUETE VARCHAR2) IS

  /**********************************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                                       *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD GENERAR EL SCRIPT                *
  *               DE UN ABC(ALTAS, BAJAS, CAMBIOS) DE UNA TABLA CONTEMPLANDO LAS BITACORAS                  *
  ***********************************************************************************************************/


  NUMERO_COLUMNAS NUMBER := 0;
  NUMERO_CODIGOS NUMBER := 0;
  NUMERO_COLUMNAS_SN NUMBER := 0;
  CONTADOR        NUMBER := 1;
  CODIGO_UPDATE   VARCHAR2(32767) := 'UPDATE ' || PV_NOMBRE_TABLA || chr(13) || 'SET ';
  CODIGO_INSERT   VARCHAR2(32767):= 'INSERT INTO '|| PV_NOMBRE_TABLA || '( '|| CHR(13);
  CODIGO_CONSULTA VARCHAR2(32767):= 'SELECT ';
  PARAMETROS VARCHAR2(32767);
  CODIGO_PROCEDURE VARCHAR2(32767);

BEGIN

--*******************************************SELECT*************************************
  SELECT COUNT(*)
    INTO NUMERO_COLUMNAS
    FROM ALL_TAB_COLUMNS
   WHERE TABLE_NAME = PV_NOMBRE_TABLA
   --AND SUBSTR(COLUMN_NAME, 1, 6) NOT LIKE 'CODIGO'
                          AND COLUMN_NAME NOT IN
                              ('ADICIONADO_POR',
                               'FECHA_ADICION',
                               'MODIFICADO_POR',
                               'FECHA_MODIFICACION',
                               'PROGRAMA');
                               
   SELECT COUNT(*)
    INTO NUMERO_COLUMNAS_SN
    FROM ALL_TAB_COLUMNS
   WHERE TABLE_NAME = PV_NOMBRE_TABLA
   AND SUBSTR(COLUMN_NAME, 1, 6) NOT LIKE 'CODIGO'
                          AND COLUMN_NAME NOT IN
                              ('ADICIONADO_POR',
                               'FECHA_ADICION',
                               'MODIFICADO_POR',
                               'FECHA_MODIFICACION',
                               'PROGRAMA');
                               
    SELECT COUNT(*)
    INTO NUMERO_CODIGOS
    FROM ALL_TAB_COLUMNS
   WHERE TABLE_NAME = PV_NOMBRE_TABLA
   AND SUBSTR(COLUMN_NAME, 1, 6) LIKE 'CODIGO'
                          AND COLUMN_NAME NOT IN
                              ('ADICIONADO_POR',
                               'FECHA_ADICION',
                               'MODIFICADO_POR',
                               'FECHA_MODIFICACION',
                               'PROGRAMA');
  BEGIN
          FOR NOMBRE_TABLA IN (SELECT COLUMN_NAME, DATA_TYPE
                                 FROM ALL_TAB_COLUMNS
                                WHERE TABLE_NAME = PV_NOMBRE_TABLA
                                  --AND SUBSTR(COLUMN_NAME, 1, 6) NOT LIKE 'CODIGO'
                                  AND COLUMN_NAME NOT IN
                                      ('ADICIONADO_POR',
                                       'FECHA_ADICION',
                                       'MODIFICADO_POR',
                                       'FECHA_MODIFICACION',
                                       'PROGRAMA')
                                ORDER BY 'C' ASC) LOOP
            
          
            IF CONTADOR = NUMERO_COLUMNAS THEN
              
              CODIGO_CONSULTA := CODIGO_CONSULTA || NOMBRE_TABLA.COLUMN_NAME || CHR(13)||
                               'FROM '|| PV_NOMBRE_TABLA;
                               
            END IF;
            
            
             IF CONTADOR < NUMERO_COLUMNAS THEN
              
              CODIGO_CONSULTA := CODIGO_CONSULTA || NOMBRE_TABLA.COLUMN_NAME ||','|| chr(13);
              CONTADOR      := CONTADOR + 1;

            END IF;
            
          END LOOP;
  END;
  
  --DBMS_OUTPUT.PUT_LINE(CODIGO_CONSULTA|| CHR(13));
  
  --*******************************************SELECT*************************************
  
  --*******************************************UPDATE*************************************
  BEGIN
  CONTADOR:= 1;
  FOR NOMBRE_TABLA1 IN (SELECT COLUMN_NAME, DATA_TYPE
                         FROM ALL_TAB_COLUMNS
                        WHERE TABLE_NAME = PV_NOMBRE_TABLA
                          AND SUBSTR(COLUMN_NAME, 1, 6) NOT LIKE 'CODIGO'
                          AND COLUMN_NAME NOT IN
                              ('ADICIONADO_POR',
                               'FECHA_ADICION',
                               'MODIFICADO_POR',
                               'FECHA_MODIFICACION',
                               'PROGRAMA')
                        ORDER BY 'C' ASC) LOOP
    
    
   
  
    IF CONTADOR = NUMERO_COLUMNAS_SN THEN
      
      CODIGO_UPDATE := CODIGO_UPDATE || NOMBRE_TABLA1.COLUMN_NAME || ' = ' ||
                       CASE WHEN NOMBRE_TABLA1.DATA_TYPE = UPPER('VARCHAR2') THEN 'PV_' ELSE 
                       CASE WHEN NOMBRE_TABLA1.DATA_TYPE = UPPER('NUMBER') THEN 'PN_' ELSE 
                       CASE WHEN NOMBRE_TABLA1.DATA_TYPE = UPPER('DATE') THEN 'PD_' END END END || NOMBRE_TABLA1.COLUMN_NAME || chr(13)||
                       'WHERE ';
                       
                       CONTADOR:= 1;
                       
                       FOR dATOWHERE IN (SELECT COLUMN_NAME
                         FROM ALL_TAB_COLUMNS
                        WHERE TABLE_NAME = PV_NOMBRE_TABLA
                          AND SUBSTR(COLUMN_NAME, 1, 6) LIKE 'CODIGO'
                          AND COLUMN_NAME NOT IN
                              ('ADICIONADO_POR',
                               'FECHA_ADICION',
                               'MODIFICADO_POR',
                               'FECHA_MODIFICACION',
                               'PROGRAMA')
                               ORDER BY 'C' ASC
                        ) 
                         LOOP
                         
                         IF CONTADOR = NUMERO_CODIGOS THEN 
                         
                         CODIGO_UPDATE := CODIGO_UPDATE || dATOWHERE.COLUMN_NAME||' = '||'PN_'||dATOWHERE.COLUMN_NAME||';';
                         CONTADOR:= NUMERO_COLUMNAS_SN;
                         END IF; 
                         
                         IF CONTADOR < NUMERO_CODIGOS THEN 
                         CODIGO_UPDATE := CODIGO_UPDATE || dATOWHERE.COLUMN_NAME||' = '||'PN_'||dATOWHERE.COLUMN_NAME||chr(13)||
                                                        'AND ';
                         CONTADOR      := CONTADOR + 1;
                         END IF;
                         
                         
                         
                         END LOOP;
      
    END IF;
    
    
     IF CONTADOR < NUMERO_COLUMNAS_SN THEN
      
      CODIGO_UPDATE := CODIGO_UPDATE || NOMBRE_TABLA1.COLUMN_NAME || ' = ' ||
                       CASE WHEN NOMBRE_TABLA1.DATA_TYPE = UPPER('VARCHAR2') THEN 'PV_' ELSE 
                       CASE WHEN NOMBRE_TABLA1.DATA_TYPE = UPPER('NUMBER') THEN 'PN_' ELSE 
                       CASE WHEN NOMBRE_TABLA1.DATA_TYPE = UPPER('DATE') THEN 'PD_' END END END || NOMBRE_TABLA1.COLUMN_NAME ||','|| chr(13);
      CONTADOR      := CONTADOR + 1;

    END IF;
    
  END LOOP;
  END;
  --DBMS_OUTPUT.PUT_LINE(CODIGO_UPDATE|| CHR(13));
  
  --*******************************************UPDATE*************************************
  
  --*******************************************INSERT*************************************
  BEGIN
          CONTADOR:= 1;
          FOR NOMBRE_TABLA2 IN (SELECT COLUMN_NAME, DATA_TYPE
                                 FROM ALL_TAB_COLUMNS
                                WHERE TABLE_NAME = PV_NOMBRE_TABLA
                                  --AND SUBSTR(COLUMN_NAME, 1, 6) NOT LIKE 'CODIGO'
                                  AND COLUMN_NAME NOT IN
                                      ('ADICIONADO_POR',
                                       'FECHA_ADICION',
                                       'MODIFICADO_POR',
                                       'FECHA_MODIFICACION',
                                       'PROGRAMA')
                                ORDER BY 'C' ASC) LOOP

          
            IF CONTADOR = NUMERO_COLUMNAS_SN THEN
              
              CODIGO_INSERT := CODIGO_INSERT || NOMBRE_TABLA2.COLUMN_NAME || CHR(13) || ')' || CHR(13) || 'VALUES'||CHR(13)||'('||CHR(13);
             
                               CONTADOR:= 1;
                               FOR dATOVALUES1 IN (SELECT COLUMN_NAME, DATA_TYPE
                                 FROM ALL_TAB_COLUMNS
                                WHERE TABLE_NAME = PV_NOMBRE_TABLA
                                  --AND SUBSTR(COLUMN_NAME, 1, 6) NOT LIKE 'CODIGO'
                                  AND COLUMN_NAME NOT IN
                                      ('ADICIONADO_POR',
                                       'FECHA_ADICION',
                                       'MODIFICADO_POR',
                                       'FECHA_MODIFICACION',
                                       'PROGRAMA')
                                       ORDER BY 'C' ASC
                                ) 
                                 LOOP
                                 
                                     IF CONTADOR = NUMERO_COLUMNAS_SN THEN 
                                     CODIGO_INSERT := CODIGO_INSERT  || CASE WHEN dATOVALUES1.DATA_TYPE = UPPER('VARCHAR2') THEN 'PV_' ELSE 
                                                                         CASE WHEN dATOVALUES1.DATA_TYPE = UPPER('NUMBER') THEN 'PN_' ELSE 
                                                                         CASE WHEN dATOVALUES1.DATA_TYPE = UPPER('DATE') THEN 'PD_' END END END || 
                                                                         dATOVALUES1.Column_Name||CHR(13)||');';
                                     
                                     CONTADOR:= NUMERO_COLUMNAS_SN+1;
                                     END IF; 
                                     
                                     IF CONTADOR < NUMERO_COLUMNAS_SN THEN 
                                     
                                                                         
                                                                         
                                      CODIGO_INSERT := CODIGO_INSERT  || CASE WHEN dATOVALUES1.DATA_TYPE = UPPER('VARCHAR2') THEN 'PV_' ELSE 
                                                                         CASE WHEN dATOVALUES1.DATA_TYPE = UPPER('NUMBER') THEN 'PN_' ELSE 
                                                                         CASE WHEN dATOVALUES1.DATA_TYPE = UPPER('DATE') THEN 'PD_' END END END || 
                                                                         dATOVALUES1.Column_Name||','||CHR(13);
                                     CONTADOR      := CONTADOR + 1;
                                 END IF;
                                 
                                 
                                 END LOOP;
              
            END IF;
            
            
             IF CONTADOR < NUMERO_COLUMNAS_SN THEN
              
              CODIGO_INSERT := CODIGO_INSERT || NOMBRE_TABLA2.COLUMN_NAME || ', ' || chr(13);

            END IF;
            
            CONTADOR      := CONTADOR + 1;
            
          END LOOP;
  END;
  --DBMS_OUTPUT.PUT_LINE(CODIGO_INSERT|| CHR(13));
  
  --*******************************************INSERT*************************************
  
  --************************************* PARAMETROS ********************************
  BEGIN  
        FOR NOMBRE_TABLA3 IN (SELECT COLUMN_NAME, DATA_TYPE
                               FROM ALL_TAB_COLUMNS
                               WHERE TABLE_NAME = PV_NOMBRE_TABLA
                                AND COLUMN_NAME NOT IN
                                    ('ADICIONADO_POR',
                                     'FECHA_ADICION',
                                     'MODIFICADO_POR',
                                     'FECHA_MODIFICACION',
                                     'PROGRAMA')
                              ORDER BY 'C' ASC) LOOP
          
        
            
            PARAMETROS := PARAMETROS || CASE WHEN NOMBRE_TABLA3.DATA_TYPE = UPPER('VARCHAR2') THEN 'PV_' ELSE 
                                           CASE WHEN NOMBRE_TABLA3.DATA_TYPE = UPPER('NUMBER') THEN 'PN_' ELSE 
                                           CASE WHEN NOMBRE_TABLA3.DATA_TYPE = UPPER('DATE') THEN 'PD_' END END END || 
                                           NOMBRE_TABLA3.Column_Name ||' IN '|| PV_NOMBRE_TABLA ||'.'||NOMBRE_TABLA3.Column_Name|| '%TYPE,' ||CHR(13);
            
            CONTADOR      := CONTADOR + 1;

          
        END LOOP;
  END;
  --DBMS_OUTPUT.PUT_LINE(PARAMETROS|| CHR(13));
  
  --************************************* PARAMETROS ********************************
  
  --***************************** CODIGO COMPLETO ***********************************
  
  
  BEGIN
          CODIGO_PROCEDURE:= ' CREATE OR REPLACE PROCEDURE FICE_P_'||SUBSTR(PV_NOMBRE_TABLA, 10, 18)||'( --PARAMETROS DE PROCESO'||CHR(13)||
                                           ' PN_EMPRESA              IN FICE_OPE_LINEASREPORTO.CODIGO_EMPRESA%TYPE,'|| CHR(13)||
                                           ' PD_FECHA                IN FICE_OPE_LINEASREPORTO.FECHA_ADICION%TYPE, '|| CHR(13)||
                                           PARAMETROS||CHR(13)||
                                           ' --PARAMETROS DE CONSULTA'|| CHR(13)||
                                           ' PV_ACCION    IN VARCHAR2,'|| CHR(13)||
                                           ' PV_CONSULTA  OUT SYS_REFCURSOR,'|| CHR(13)||
                                           ' PV_CONDICION IN VARCHAR2,'|| CHR(13)||
                                           ' --PARAMETROS DE CONTROL DE BITACORA Y ERRORES'|| CHR(13)||
                                           ' PV_TIPO_APP       IN FICE_BITACORA_SIFICE.TIPO_APP%TYPE,'|| CHR(13)||
                                           ' PN_CLAVE_BITACORA IN OUT FICE_BITACORA_SIFICE.CLAVE_BITACORA%TYPE,'|| CHR(13)||
                                           ' PV_PRODUCTO       IN FICE_BITACORA_SIFICE.PRODUCTO%TYPE,'|| CHR(13)|| 
                                           ' PV_CLAVE_MENSAJE  IN FICE_BITACORA_MENSAJE.CLAVE_MENSAJE%TYPE,'|| CHR(13)|| 
                                           ' PV_ORA_ERROR      IN FICE_BITACORA_MENSAJE.USUARIO%TYPE,'|| CHR(13)||
                                           ' PV_MENSAJE        IN FICE_BITACORA_MENSAJE.DESC_MENSAJE%TYPE,'|| CHR(13)||
                                           ' PV_USUARIO        IN OUT FICE_BITACORA_MENSAJE.USUARIO%TYPE,'|| CHR(13)||
                                           ' PB_ERROR          IN OUT FICE_BITACORA_MENSAJE.USUARIO%TYPE'|| CHR(13)||
                                           '                                    '|| CHR(13)||
                                           ' ) IS'|| CHR(13)||
            ' LV_QUERY VARCHAR2(2000);'|| CHR(13)||
            ' --*****SE ADICIONAN ESTAS VARIABLES LOCALES PARA EL MANEJO DE ERRORES*****************************'|| CHR(13)||
            ' LV_PROGRAMA       FICE_BITACORA_SIFICE.PROGRAMA%TYPE := '' '||PV_PAQUETE||'.FICE_P_'||SUBSTR(PV_NOMBRE_TABLA, 10, 18)||' '';'|| CHR(13)||
            ' LV_MENSAJE        FICE_BITACORA_MENSAJE.DESC_MENSAJE%TYPE := PV_MENSAJE;'|| CHR(13)||
            ' LV_ORA_ERROR      VARCHAR2(5) := PV_ORA_ERROR;'|| CHR(13)||
            ' LV_SALTO          VARCHAR2(10) := ''<BR>'';'|| CHR(13)||
            ' LN_NUMERO_ERRORES NUMBER(4) := 0;'|| CHR(13)||
            ' --PIVOTES'|| CHR(13)||
            ' LN_MAX_REG NUMBER(19);'|| CHR(13)||
            ' --EXCEPCIONES DE USUARIO'|| CHR(13)||
            ' LE_OPERACION_FUERA_HORARIO EXCEPTION;'|| CHR(13)||
          '                               '|| CHR(13)||
          ' BEGIN                          '|| CHR(13)||
          '                               '|| CHR(13)||
            ' PB_ERROR := ''FALSE'';       '|| CHR(13)||
            '             '|| CHR(13)||
            ' BEGIN'|| CHR(13)||
              ' PB_ERROR := FICE_PKG_UTILERIAS.FICE_F_VERIFICA_HORARIO(PN_EMPRESA => PN_EMPRESA,'|| CHR(13)||
              '                                                       PB_ERROR   => PB_ERROR);'|| CHR(13)||
              ' IF TRIM(PB_ERROR) = ''TRUE'' THEN'|| CHR(13)||
                ' RAISE LE_OPERACION_FUERA_HORARIO;'|| CHR(13)|| 
                ' GOTO FIN_PROGRAMA;'|| CHR(13)||
              ' END IF;'|| CHR(13)||
            ' EXCEPTION'|| CHR(13)||
              ' WHEN LE_OPERACION_FUERA_HORARIO THEN'|| CHR(13)||
                ' LN_NUMERO_ERRORES := LN_NUMERO_ERRORES + 1;'|| CHR(13)||
                ' LV_MENSAJE        := pv_producto || ''|'';'|| CHR(13)||
                ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA,'|| CHR(13)||
                                                      ' PD_FECHA          => PD_FECHA,'|| CHR(13)||
                                                      ' PV_TIPO_APP       => PV_TIPO_APP,'||  CHR(13)||
                                                      ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA,'|| CHR(13)||
                                                      ' PV_PRODUCTO       => PV_PRODUCTO,'|| CHR(13)||
                                                      ' PV_PROGRAMA       => LV_PROGRAMA,'|| CHR(13)||
                                                      ' PV_CLAVE_MENSAJE  => ''80018'', --Se intento manipular fuera de horario %. '|| CHR(13)||
                                                      ' PV_ORA_ERROR      => LV_ORA_ERROR,'|| CHR(13)||
                                                      ' PV_MENSAJE        => LV_MENSAJE,'|| CHR(13)||
                                                      ' PV_USUARIO        => PV_USUARIO,'|| CHR(13)||
                                                      ' PB_ERROR          => PB_ERROR);'|| CHR(13)||
                ' PB_ERROR := ''TRUE'';'|| CHR(13)||
            ' END;'|| CHR(13)||
            '     '|| CHR(13)||
            ' SELECT NVL(MAX(CODIGO_'||SUBSTR(PV_NOMBRE_TABLA, 10, 18)||') + 1, 1)'|| CHR(13)||
            ' INTO LN_MAX_REG'|| CHR(13)||
            ' FROM '||PV_NOMBRE_TABLA||'; '|| CHR(13)||
            '                                                  '|| CHR(13)||
            ' LV_MENSAJE := ''de Unidades de Medida |'' ||
                                                   TO_CHAR(PD_FECHA, ''DD-MM-YYYY'') ||
                                                   ''| FECHA - HORA INICIO '' ||
                                                   TO_CHAR(PD_FECHA,
                                                           ''DD-MM-YYYY HH:MI:SS''); '|| CHR(13)||
            '                                                           '||
            ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA, '|| CHR(13)||
                                                  ' PD_FECHA          => PD_FECHA, '|| CHR(13)||
                                                  ' PV_TIPO_APP       => PV_TIPO_APP, '|| CHR(13)||
                                                  ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA, '|| CHR(13)||
                                                  ' PV_PRODUCTO       => PV_PRODUCTO, '|| CHR(13)||
                                                  ' PV_PROGRAMA       => LV_PROGRAMA, '|| CHR(13)||
                                                  ' PV_CLAVE_MENSAJE  => ''80000'', --Inicia proceso %, para la fecha %. '|| CHR(13)||
                                                  ' PV_ORA_ERROR      => LV_ORA_ERROR, '|| CHR(13)||
                                                  ' PV_MENSAJE        => LV_MENSAJE, '|| CHR(13)||
                                                  ' PV_USUARIO        => PV_USUARIO, '|| CHR(13)||
                                                  ' PB_ERROR          => PB_ERROR); '|| CHR(13)||
                                                  '                                 '|| CHR(13)||
           ' IF PV_ACCION = ''CONSULTA'' THEN '|| CHR(13)||
           '                                  '|| CHR(13)||
           '             '|| CHR(13)||
           '   LV_QUERY := '''||CODIGO_CONSULTA||  CHR(13)||
                          ' WHERE CODIGO_EMPRESA = ''|| PN_EMPRESA;'  || CHR(13)||
                          

            '             '|| CHR(13)||
                ' BEGIN '|| CHR(13)||
                '             '|| CHR(13)||
                  ' LV_QUERY := LV_QUERY || '' ORDER BY CODIGO_'||SUBSTR(PV_NOMBRE_TABLA, 10, 18)||''';  '|| CHR(13)||
                  ' OPEN PV_CONSULTA FOR LV_QUERY; '|| CHR(13)||
                  ' EXCEPTION '|| CHR(13)||
                  ' WHEN OTHERS THEN '|| CHR(13)||
                  ' LV_MENSAJE := ''La consulta no se pudo realizar '' ||' || CHR(13)||
                                ' dbms_utility.format_error_backtrace || lv_salto || '|| CHR(13)||
                                ' LV_QUERY; '|| CHR(13)||
                  ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA, '|| CHR(13)||
                                                        ' PD_FECHA          => PD_FECHA, '|| CHR(13)||
                                                        ' PV_TIPO_APP       => PV_TIPO_APP, '|| CHR(13)||
                                                        ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA, '|| CHR(13)||
                                                        ' PV_PRODUCTO       => PV_PRODUCTO, '|| CHR(13)||
                                                        ' PV_PROGRAMA       => LV_PROGRAMA, '|| CHR(13)||
                                                        ' PV_CLAVE_MENSAJE  => PV_CLAVE_MENSAJE, '|| CHR(13)||
                                                        ' PV_ORA_ERROR      => LV_ORA_ERROR, '|| CHR(13)||
                                                        ' PV_MENSAJE        => LV_MENSAJE, '|| CHR(13)||
                                                        ' PV_USUARIO        => PV_USUARIO, '|| CHR(13)||
                                                        ' PB_ERROR          => PB_ERROR); '|| CHR(13)||
                ' END; '|| CHR(13)||
            '                                      '|| CHR(13)||
            ' ELSIF PV_ACCION = ''CONSULTA2'' THEN '|| CHR(13)||
            '                                      '|| CHR(13)||
            '   LV_QUERY := '''||CODIGO_CONSULTA||  CHR(13)||
                          ' WHERE CODIGO_EMPRESA = ''|| PN_EMPRESA;'  || CHR(13)||


             '             '|| CHR(13)||
                ' BEGIN '|| CHR(13)||
                '             '|| CHR(13)||
                  ' LV_QUERY := LV_QUERY || '' ORDER BY CODIGO_'||SUBSTR(PV_NOMBRE_TABLA, 10, 18)||''';  '|| CHR(13)||
                  ' OPEN PV_CONSULTA FOR LV_QUERY; '|| CHR(13)||
                  ' EXCEPTION '|| CHR(13)||
                  ' WHEN OTHERS THEN '|| CHR(13)||
                  ' LV_MENSAJE := ''La consulta no se pudo realizar '' ||' || CHR(13)||
                                ' dbms_utility.format_error_backtrace || lv_salto || '|| CHR(13)||
                                ' LV_QUERY; '|| CHR(13)||
                  ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA, '|| CHR(13)||
                                                        ' PD_FECHA          => PD_FECHA, '|| CHR(13)||
                                                        ' PV_TIPO_APP       => PV_TIPO_APP, '|| CHR(13)||
                                                        ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA, '|| CHR(13)||
                                                        ' PV_PRODUCTO       => PV_PRODUCTO, '|| CHR(13)||
                                                        ' PV_PROGRAMA       => LV_PROGRAMA, '|| CHR(13)||
                                                        ' PV_CLAVE_MENSAJE  => PV_CLAVE_MENSAJE, '|| CHR(13)||
                                                        ' PV_ORA_ERROR      => LV_ORA_ERROR, '|| CHR(13)||
                                                        ' PV_MENSAJE        => LV_MENSAJE, '|| CHR(13)||
                                                        ' PV_USUARIO        => PV_USUARIO, '|| CHR(13)||
                                                        ' PB_ERROR          => PB_ERROR); '|| CHR(13)||
                ' END; '|| CHR(13)||
            '     '|| CHR(13)||
           ' ELSIF PV_ACCION = ''ALTA'' THEN '|| CHR(13)||
           '             '|| CHR(13)||
              ' BEGIN '|| CHR(13)||
              '             '|| CHR(13)||
                   CODIGO_INSERT || CHR(13)||
                   '             '|| CHR(13)||
                   '  '|| CHR(13)||
              ' EXCEPTION '|| CHR(13)||
                ' WHEN OTHERS THEN '|| CHR(13)||
                  '  LV_MENSAJE        := '''||PV_NOMBRE_TABLA|| '  |'' ||
                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ''.'' || SQLERRM; '|| CHR(13)||
                  ' LN_NUMERO_ERRORES := LN_NUMERO_ERRORES + 1; '|| CHR(13)||
                  '   '|| CHR(13)||
                  ' --******************************ENVIO DE VARIABLES A LA PAQUETE DE BITACORA*********************'|| CHR(13)||
                  '                                                    '|| CHR(13)||
                  ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA, '|| CHR(13)||
                                                        ' PD_FECHA          => PD_FECHA, '|| CHR(13)||
                                                        ' PV_TIPO_APP       => PV_TIPO_APP, '|| CHR(13)||
                                                        ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA, '|| CHR(13)||
                                                        ' PV_PRODUCTO       => PV_PRODUCTO, '|| CHR(13)||
                                                        ' PV_PROGRAMA       => LV_PROGRAMA, '|| CHR(13)||
                                                        ' PV_CLAVE_MENSAJE  => ''80007'', --Error al insertar registro en % numero de linea %.  '|| CHR(13)||
                                                        ' PV_ORA_ERROR      => LV_ORA_ERROR, '||  CHR(13)||
                                                        ' PV_MENSAJE        => LV_MENSAJE, '|| CHR(13)||
                                                        ' PV_USUARIO        => PV_USUARIO, '|| CHR(13)||
                                                        ' PB_ERROR          => PB_ERROR); '|| CHR(13)||
              ' END; '|| CHR(13)||
              '             '|| CHR(13)||
            ' ELSIF PV_ACCION = ''ESTATUS'' THEN '|| CHR(13)||
            '             '|| CHR(13)||
              ' BEGIN '|| CHR(13)||
              '             '|| CHR(13)||
                CODIGO_UPDATE || CHR(13)||
                '             '|| CHR(13)||
              ' EXCEPTION '|| CHR(13)||
                ' WHEN OTHERS THEN '|| CHR(13)||
                   '  LV_MENSAJE        := '''||PV_NOMBRE_TABLA|| '  |'' ||
                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ''.'' || SQLERRM; '|| CHR(13)||
                  ' LN_NUMERO_ERRORES := LN_NUMERO_ERRORES + 1; ' ||  CHR(13)||
                  '                                          ' || CHR(13)||
                  ' --******************************ENVIO DE VARIABLES A LA PAQUETE DE BITACORA********************* '|| CHR(13)||
                  '                                                    ' || CHR(13)||
                  ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA, ' || CHR(13)||
                                                        ' PD_FECHA          => PD_FECHA, ' || CHR(13)||
                                                        ' PV_TIPO_APP       => PV_TIPO_APP, ' || CHR(13)||
                                                        ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA, ' || CHR(13)||
                                                        ' PV_PRODUCTO       => PV_PRODUCTO, ' || CHR(13)||
                                                        ' PV_PROGRAMA       => LV_PROGRAMA, ' || CHR(13)||
                                                        ' PV_CLAVE_MENSAJE  => ''80017'', --Error al actualizar registro en % numero de linea %. ' || CHR(13)||
                                                        ' PV_ORA_ERROR      => LV_ORA_ERROR, ' || CHR(13)||
                                                        ' PV_MENSAJE        => LV_MENSAJE,' || CHR(13)||
                                                        ' PV_USUARIO        => PV_USUARIO, ' || CHR(13)||
                                                        ' PB_ERROR          => PB_ERROR); ' || CHR(13)||
              ' END;                                    ' || CHR(13)||
              '             '|| CHR(13)||
            ' ELSIF PV_ACCION = ''CAMBIO''  THEN          ' || CHR(13)||
            '                 ' || CHR(13)||
             '  BEGIN '|| CHR(13)||
             '             '|| CHR(13)||
                CODIGO_UPDATE|| CHR(13)||
                '             '|| CHR(13)||
              ' EXCEPTION ' || CHR(13)||
                ' WHEN OTHERS THEN ' || CHR(13)||
                  '  LV_MENSAJE        := '''||PV_NOMBRE_TABLA|| '  |'' ||
                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ''.'' || SQLERRM; '|| CHR(13)||
                  ' LN_NUMERO_ERRORES := LN_NUMERO_ERRORES + 1;  ' || CHR(13)||
                  '  ' ||CHR(13)||
                  ' --******************************ENVIO DE VARIABLES A LA PAQUETE DE BITACORA*********************  ' ||CHR(13)||
                  '   ' ||CHR(13)||
                  ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA,  ' ||CHR(13)||
                                                        ' PD_FECHA          => PD_FECHA,  ' ||CHR(13)||
                                                        ' PV_TIPO_APP       => PV_TIPO_APP,  ' ||CHR(13)||
                                                        ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA,  ' ||CHR(13)||
                                                        ' PV_PRODUCTO       => PV_PRODUCTO,  ' ||CHR(13)||
                                                        ' PV_PROGRAMA       => LV_PROGRAMA,  ' ||CHR(13)||
                                                        ' PV_CLAVE_MENSAJE  => ''80017'', --Error al actualizar registro en % numero de linea %.   ' ||CHR(13)||
                                                        ' PV_ORA_ERROR      => LV_ORA_ERROR, ' ||CHR(13)||
                                                        ' PV_MENSAJE        => LV_MENSAJE, ' ||CHR(13)||
                                                        ' PV_USUARIO        => PV_USUARIO, ' ||CHR(13)||
                                                        ' PB_ERROR          => PB_ERROR);  ' ||CHR(13)||
              ' END;  ' ||CHR(13)||
              '    ' ||CHR(13)||
            ' END IF; ' ||CHR(13)||
            '             '|| CHR(13)||
            ' <<FIN_PROGRAMA>> ' ||CHR(13)||
            '             '|| CHR(13)||
            ' IF LN_NUMERO_ERRORES > 0 THEN ' ||CHR(13)||
              ' LV_MENSAJE := '' de mantenimiento de '' || PV_PRODUCTO || ''|'' ||CHR(13)||
                            TO_CHAR(PD_FECHA, ''DD-MM-YYYY'') || ''|'';  ' ||CHR(13)||
              ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA,  ' ||CHR(13)||
                                                    ' PD_FECHA          => PD_FECHA,  ' ||CHR(13)||
                                                    ' PV_TIPO_APP       => PV_TIPO_APP,  ' ||CHR(13)||
                                                    ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA,  ' ||CHR(13)||
                                                    ' PV_PRODUCTO       => PV_PRODUCTO,   ' ||CHR(13)||
                                                    ' PV_PROGRAMA       => LV_PROGRAMA,  ' ||CHR(13)||
                                                    ' PV_CLAVE_MENSAJE  => ''80002'', --Finalizo proceso  %, para la fecha %, con errores.  ' || CHR(13)||
                                                    ' PV_ORA_ERROR      => LV_ORA_ERROR, ' || CHR(13)||
                                                    ' PV_MENSAJE        => LV_MENSAJE, ' ||CHR(13)||
                                                    ' PV_USUARIO        => PV_USUARIO, ' ||CHR(13)||
                                                    ' PB_ERROR          => PB_ERROR); ' ||CHR(13)||
              ' ROLLBACK;  ' ||CHR(13)||CHR(13)||
              ' PB_ERROR := ''TRUE''; ' ||CHR(13)||
           '  ELSE  ' ||CHR(13)||
              ' LV_MENSAJE := '' de mantenimiento de '' || PV_PRODUCTO || ''|'' ||
                            TO_CHAR(PD_FECHA, ''DD-MM-YYYY'') || ''|'';  ' ||CHR(13)||
              ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA,  ' ||CHR(13)||
                                                    ' PD_FECHA          => PD_FECHA,  ' ||CHR(13)||
                                                    ' PV_TIPO_APP       => PV_TIPO_APP,  ' ||CHR(13)||
                                                    ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA,  ' ||CHR(13)||
                                                    ' PV_PRODUCTO       => PV_PRODUCTO,  ' ||CHR(13)||
                                                    ' PV_PROGRAMA       => LV_PROGRAMA,  ' ||CHR(13)||
                                                    ' PV_CLAVE_MENSAJE  => ''80001'', --Finalizo proceso  %, para la fecha %, con exito.  ' || CHR(13)||
                                                    ' PV_ORA_ERROR      => LV_ORA_ERROR, ' ||CHR(13)||
                                                    ' PV_MENSAJE        => LV_MENSAJE,  ' ||CHR(13)||
                                                    ' PV_USUARIO        => PV_USUARIO,  ' ||CHR(13)||
                                                    ' PB_ERROR          => PB_ERROR);  ' ||CHR(13)||
              ' COMMIT;  ' ||CHR(13)||
              ' PB_ERROR := ''FALSE'';  ' ||CHR(13)||
           '  END IF;  ' ||CHR(13)||
              '   ' ||CHR(13)||
          ' EXCEPTION  ' ||CHR(13)||
            '   ' ||CHR(13)||
            ' WHEN OTHERS THEN  ' ||CHR(13)||
              ' DBMS_OUTPUT.PUT_LINE(LN_NUMERO_ERRORES || '' - '' || PN_CLAVE_BITACORA);  ' ||CHR(13)||
              ' LV_MENSAJE := '' de mantenimiento de '' || PV_PRODUCTO || ''|'' || 
                             TO_CHAR(PD_FECHA, ''DD-MM-YYYY'') || ''| Error general '' ||
                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ''. '' || SQLERRM;  ' ||CHR(13)||
              ' FICE_PKG_BIT_PROCESOS.FICE_P_BITACORA(PN_EMPRESA        => PN_EMPRESA, ' ||CHR(13)||
                                                    ' PD_FECHA          => PD_FECHA, ' ||CHR(13)||
                                                    ' PV_TIPO_APP       => PV_TIPO_APP,' ||CHR(13)||
                                                    ' PN_CLAVE_BITACORA => PN_CLAVE_BITACORA, ' ||CHR(13)||
                                                    ' PV_PRODUCTO       => PV_PRODUCTO, ' ||CHR(13)||
                                                    ' PV_PROGRAMA       => LV_PROGRAMA, ' ||CHR(13)||
                                                    ' PV_CLAVE_MENSAJE  => ''80002'', --Finalizo proceso  %, para la fecha %, con errores. ' ||CHR(13)||
                                                    ' PV_ORA_ERROR      => LV_ORA_ERROR,' ||CHR(13)||
                                                    ' PV_MENSAJE        => LV_MENSAJE,' ||CHR(13)||
                                                    ' PV_USUARIO        => PV_USUARIO,' ||CHR(13)||
                                                    ' PB_ERROR          => PB_ERROR);' ||CHR(13)||
              ' PB_ERROR := ''TRUE''; ' ||CHR(13)||
          ' END FICE_P_'||SUBSTR(PV_NOMBRE_TABLA, 10, 18)||'; ';
  END;
  DBMS_OUTPUT.PUT_LINE(CODIGO_PROCEDURE|| CHR(13));
  
  --***************************** CODIGO COMPLETO ************************************/
 
END;
/
