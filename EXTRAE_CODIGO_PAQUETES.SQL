CREATE OR REPLACE PROCEDURE EXTRAE_CODIGO_PAQUETES
IS

  /***************************************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                                            *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD EXTRAER EL CODIGO TODOS LOS PAQUETES  *
  *               ALMACENADOS EN LA BASE DE DATOS DE LA APLICACION                                               *
  ***************************************************************************************************************/

BEGIN
  FOR I IN (SELECT TEXT
            FROM ALL_SOURCE
            WHERE TYPE = 'PACKAGE'
            AND SUBSTR(NAME, 1, 4) = 'FICE')
     LOOP
     DBMS_OUTPUT.PUT_LINE(I.TEXT);
     END LOOP;
END;
/
