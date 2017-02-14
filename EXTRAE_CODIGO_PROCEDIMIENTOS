CREATE OR REPLACE PROCEDURE EXTRAE_CODIGO_PROCEDIMIENTOS
IS

  /*********************************************************************************************************************
  * AUTOR       : MARIO RUÍZ GONZÁLEZ                                                                                  *
  * DESCRIPCION : EL ACTUAL PROCEDIMIENTO ALMACENADO, TIENE COMO FINALIDAD EXTRAER EL CODIGO TODOS LOS PROCEDIMIENTOS  *
  *               ALMACENADOS EN LA BASE DE DATOS, RELACIONADOS CON LA APLICACION                                      *
  **********************************************************************************************************************/

BEGIN
  FOR I IN (SELECT TEXT
            FROM ALL_SOURCE
            WHERE TYPE = 'PROCEDURE'
            AND OWNER = 'SIFICE')
     LOOP
     DBMS_OUTPUT.PUT_LINE(I.TEXT);
     END LOOP;
END;
/
