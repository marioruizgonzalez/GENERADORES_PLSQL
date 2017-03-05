CREATE OR REPLACE PROCEDURE GENERADOR_DE_TRIGGERS_RES
IS

 /******************************************************************************************
  * AUTOR       : Mario Ruíz González                                                      *
  * DESCRIPCION : El actual Procedimiento Almacenado, tiene como finalidad                 *
  *               ubicar las que cumplan con el prefijo indicado y generar                 *
  *               un Script de ejecucion para generar un Trigger a la tabla                *
  *               que cumple con la funcion de Bitacora, para llevar un control de cambios *
  ******************************************************************************************/

      --VARIABLES
      LN_TABLAS_AFECTADAS NUMBER(19);
      LV_CODIGO_FINAL VARCHAR2(32767);
BEGIN
      SELECT COUNT(1)
      INTO LN_TABLAS_AFECTADAS
      FROM ALL_TABLES
      WHERE SUBSTR(UPPER(TABLE_NAME),1,4)LIKE UPPER('FICE');

      DBMS_OUTPUT.PUT_LINE('Se realizara la creacion del trigger, sobre '||LN_TABLAS_AFECTADAS||' Tablas');

      --COMIENZA LA CREACION DE TRIGGER POR TABLA
      FOR DATO IN (SELECT DISTINCT TABLE_NAME FROM ALL_TABLES WHERE SUBSTR(UPPER(TABLE_NAME),1,4)LIKE UPPER('FICE'))
      LOOP
      LV_CODIGO_FINAL:='CREATE OR REPLACE TRIGGER FICE_TGR_'||SUBSTR(DATO.TABLE_NAME,10,14)||CHR(13)||
                       'before insert or update on '||DATO.TABLE_NAME||CHR(13)||
                       'for each row'||CHR(13)||
                       'declare'||CHR(13)||
                       'lv_usuario '||DATO.TABLE_NAME||'.ADICIONADO_POR%type;'||CHR(13)||
                       'lv_prog '||DATO.TABLE_NAME||'.programa%type;'||CHR(13)||
                       'ld_ultimamod '||DATO.TABLE_NAME||'.Fecha_Adicion%type;'||CHR(13)||
                      'begin'||CHR(13)||
                        'fice_pkg_bit_institucional.fice_p_firma_electronica(pv_usuario => lv_usuario,'||CHR(13)||
                                                                   'pv_prog => lv_prog,'||CHR(13)||
                                                                   'pd_ultimamod => ld_ultimamod);'||CHR(13)||
                        'IF INSERTING THEN'||CHR(13)||
                          ':new.adicionado_por := lv_usuario;'||CHR(13)||
                          ':new.fecha_adicion := ld_ultimamod;'||CHR(13)||
                        'elsIF UPDATING THEN'||CHR(13)||
                          ':new.modificado_por := lv_usuario;'||CHR(13)||
                          ':new.fecha_modificacion := ld_ultimamod;'||CHR(13)||
                        'END IF;'||CHR(13)||
                        ':new.programa := lv_prog;'||CHR(13)||
                        CHR(13)||
                      'end FICE_TGR_'||SUBSTR(DATO.TABLE_NAME,10,14)||';';

      DBMS_OUTPUT.PUT_LINE(LV_CODIGO_FINAL||CHR(13));


      END LOOP;

END;
/
