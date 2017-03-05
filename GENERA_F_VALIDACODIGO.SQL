create or replace procedure GENERA_F_VALIDACODIGO(PV_NOMBRE_TABLA VARCHAR2) is

  /*******************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                        *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD GENERAR EL CODIGO *
  *               DE UNA FUNCION BASICA QUE CONFIRME LA EXISTE DE UN CODIGO                  *
  *               EN LA TABLA QUE SE LE INDIQUE                                              *
  *******************************************************************************************/
       
       LN_CODIGO VARCHAR2(1000):= 'FUNCTION FICE_F_VALIDA_';
       LN_VALIDA_TABLA VARCHAR(100);
       LV_NOMBREFUNCION VARCHAR2(100);
       LV_NOMCOL1 VARCHAR2(100);
       LV_TIPCOL1 VARCHAR2(100);
       LV_NOMCOL2 VARCHAR2(100);
       LV_TIPCOL2 VARCHAR2(100);

BEGIN 
  
      BEGIN
      SELECT COUNT(1)
      INTO LN_VALIDA_TABLA
      FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = PV_NOMBRE_TABLA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE LA TABLA');
      END;

            IF LN_VALIDA_TABLA != 0 THEN 
                  --**
                  SELECT CONCAT(SUBSTR(COLUMN_NAME,1,1), SUBSTR(COLUMN_NAME ,8,(SELECT LENGTH(COLUMN_NAME)FROM ALL_TAB_COLUMNS 
                                                        WHERE TABLE_NAME = 'FICE_CAT_ALMACENADORAS'
                                                        AND COLUMN_ID = 2 )))
                  INTO LV_NOMBREFUNCION
                  FROM ALL_TAB_COLUMNS 
                  WHERE TABLE_NAME = PV_NOMBRE_TABLA
                  AND COLUMN_ID = 2
                  ORDER BY COLUMN_ID ASC;
                  --**
                  LN_CODIGO:= LN_CODIGO||LV_NOMBREFUNCION;
                  
                  --**
                  SELECT COLUMN_NAME, DATA_TYPE
                  INTO LV_NOMCOL2, LV_TIPCOL1
                  FROM ALL_TAB_COLUMNS 
                  WHERE TABLE_NAME = PV_NOMBRE_TABLA
                  AND COLUMN_ID = 1
                  ORDER BY COLUMN_ID ASC;
                  --**
                  LN_CODIGO:=LN_CODIGO||'(PN_'||LV_NOMCOL2||' '||LV_TIPCOL1||', PN_';

                  
                  SELECT COLUMN_NAME,DATA_TYPE
                  INTO LV_NOMCOL2, LV_TIPCOL2
                  FROM ALL_TAB_COLUMNS 
                  WHERE TABLE_NAME = PV_NOMBRE_TABLA
                  AND COLUMN_ID = 2
                  ORDER BY COLUMN_ID ASC;
                  LN_CODIGO:=LN_CODIGO|| LV_NOMCOL2||' '||LV_TIPCOL2||')'||chr(13)||
                              'RETURN NUMBER IS'||chr(13)||
                              'LN_'||LV_NOMCOL2||' '||LV_TIPCOL2||'(2) := 0;'||chr(13)||
                              'BEGIN'||chr(13);

                  
                  
                   
                   
                    LN_CODIGO:= LN_CODIGO||'SELECT DISTINCT '||LV_NOMCOL2||chr(13)||
                        'INTO '||'LN_'||LV_NOMCOL2||chr(13)||
                        'FROM '||PV_NOMBRE_TABLA||chr(13)||
                        'WHERE '||LV_NOMCOL2||' = PN_'||LV_NOMCOL2||';'||chr(13)||
                        'RETURN(LN_'||LV_NOMCOL2||');'||chr(13)||
                        'EXCEPTION'||chr(13)||
                        'WHEN NO_DATA_FOUND THEN'||chr(13)||
                        'RETURN(LN_'||LV_NOMCOL2||');'||chr(13)||
                        'END;';
                        
                        DBMS_OUTPUT.put_line(LN_CODIGO);
                 
            END IF;
            
EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('FALLO GENERAL');
end GENERA_F_VALIDACODIGO;
/
