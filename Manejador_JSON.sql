CREATE OR REPLACE PROCEDURE prueba_json is
  li_json VARCHAR2(32676) := '{"docElements":[{"elementType":"text","id":8,"${APELLIDO_PATERNO}":"0_content","x":130,"y":80,"width":330,"height":210,"content":"${NOMBRE}","eval":false,"styleId":"","bold":false,"italic":false,"underline":false,"horizontalAlignment":"left","verticalAlignment":"top","textColor":"#000000","backgroundColor":"","font":"helvetica","fontSize":12,"lineSpacing":1,"borderColor":"#000000","borderWidth":1,"borderAll":false,"borderLeft":false,"borderTop":false,"borderRight":false,"borderBottom":false,"paddingLeft":2,"paddingTop":2,"paddingRight":2,"paddingBottom":2,"printIf":"","removeEmptyElement":false,"alwaysPrintOnSamePage":true,"pattern":"","cs_condition":"","cs_styleId":"","cs_bold":false,"cs_italic":false,"cs_underline":false,"cs_horizontalAlignment":"left","cs_verticalAlignment":"top","cs_textColor":"#000000","cs_backgroundColor":"","cs_font":"helvetica","cs_fontSize":12,"cs_lineSpacing":1,"cs_borderColor":"#000000","cs_borderWidth":"1","cs_borderAll":false,"cs_borderLeft":false,"cs_borderTop":false,"cs_borderRight":false,"cs_borderBottom":false,"cs_paddingLeft":2,"cs_paddingTop":2,"cs_paddingRight":2,"cs_paddingBottom":2,"spreadsheet_hide":false,"spreadsheet_column":"","spreadsheet_colspan":"","spreadsheet_addEmptyRow":false}],"parameters":[{"id":1,"name":"page_count","type":"NUMBER","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":true,"testData":""},{"id":2,"name":"page_NUMBER","type":"NUMBER","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":true,"testData":""},{"id":3,"name":"CERTIFICADO_NUMERO_CERTIFICADO","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":4,"name":"CERTIFICADO_SUMA_ASEGURADA","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":3,"name":"PERSONA_APELLIDO_MATERNO","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":4,"name":"PERSONA_APELLIDO_PATERNO","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":5,"name":"PERSONA_CODIGO_UNICO_CLIENTE","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":6,"name":"PERSONA_CURP","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":7,"name":"PERSONA_NOMBRE","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":3,"name":"POLIZA_FIN_VIGENCIA","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":4,"name":"POLIZA_INICIO_VIGENCIA","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},{"id":5,"name":"POLIZA_NUMERO_COTIZACION","type":"string","arrayItemType":"string","eval":false,"nullable":false,"pattern":"","expression":"","showOnlyNameType":false,"testData":""},';

  ln_coincidencias NUMBER;
  ln_parametro     NUMBER;

  lv_muestra           VARCHAR2(100);
  lv_valor1            VARCHAR2(500);
  lv_tabla_apuntada    VARCHAR2(100);
  lv_campos            VARCHAR2(500);
  lv_campos_tira       VARCHAR2(500);
  lv_campos_final      VARCHAR2(500);
  lv_query_referencial VARCHAR2(500);
  lv_varcontenido      VARCHAR2(500);
  lv_varnombre         VARCHAR2(500);
  lv_valor             VARCHAR2(500);
  lv_dato              VARCHAR2(500);
  lv_recorta_valor     VARCHAR2(500);
  lv_recorta_dato      VARCHAR2(500);
  lv_json_final        VARCHAR2(32676);
  lv_json_paso         VARCHAR2(32676);
  lv_parametro_valor   VARCHAR2(500);
  lv_parametro_dato    VARCHAR2(500);
  lv_valor_remplazar   VARCHAR2(500);
  lv_dato_remplazar    VARCHAR2(500);

  lb_deja_de_colectar boolean := false;

BEGIN

  /* primera parte ln_parametro de las variables */

  BEGIN
    SELECT length(li_json) - length(REPLACE(li_json, '$'))
      INTO ln_coincidencias
      FROM dual;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM ||
                           dbms_utility.format_error_backtrace);
  END;

  --dbms_output.put_line('ln_coincidencias ' ||ln_coincidencias);

  for j in 1 .. ln_coincidencias loop
  
    begin
      select instr(li_json, '$', 1, j) into ln_parametro from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
    --dbms_output.put_line('valor de j '||j);
    --dbms_output.put_line('ln_parametro '||ln_parametro);
  
    begin
      select substr(li_json, ln_parametro, 100) into lv_muestra from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
    --dbms_output.put_line('lv_muestra ' ||lv_muestra);
  
    for i in 1 .. length(lv_muestra) loop
    
      if substr(lv_muestra, i, 1) = '}' then
        lb_deja_de_colectar := true;
      else
        if substr(lv_muestra, i, 1) = '{' or substr(lv_muestra, i, 1) = '$' then
          null;
        elsif lb_deja_de_colectar = false then
          lv_valor1 := lv_valor1 || substr(lv_muestra, i, 1);
        end if;
      end if;
    end loop;
  
    --dbms_output.put_line('valor1:' || valor1);
    begin
      insert into ice_report_sequel (campo) values (lv_valor1);
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
    lb_deja_de_colectar := false;
    lv_valor1           := '';
  end loop;

  /* Paso numero dos obtener match */

  for i in (select campo from ice_report_sequel) loop
  
    BEGIN
      SELECT distinct (tabla)
        INTO lv_tabla_apuntada
        FROM ice_report_field
       WHERE upper(relacion) = upper(i.campo);
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    BEGIN
      UPDATE ice_report_sequel
         SET tabla = lv_tabla_apuntada
       WHERE upper(campo) = upper(i.campo);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM ||
                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END;
  
  end loop;

  /*Paso tres ejecutar fetch*/

  for i in (SELECT DISTINCT tabla from ice_report_sequel) loop
    for j in (SELECT campo, relacion
                FROM ice_report_field
               WHERE tabla = i.tabla
                 AND campo in
                     (select campo
                        from ice_report_field
                       where relacion in
                             (select campo from ice_report_sequel))) loop
    
      lv_campos    := lv_campos || j.campo || '||''#''||';
      lv_varnombre := lv_varnombre || j.relacion || '#';
    end loop;
    -- dbms_output.put_line('campos '||campos);
    --dbms_output.put_line('lv_varnombre '||lv_varnombre);
  
    begin
      select substr(lv_campos, 1, length(lv_campos) - 2)
        into lv_campos_final
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    lv_query_referencial := 'select ' || lv_campos_final || ' from ' ||
                            i.tabla || ' where rownum = 1 ';
    --dbms_output.put_line(lv_query_referencial);
  
    begin
      execute immediate (lv_query_referencial)
        into lv_varcontenido;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
  end loop;

  /*Paso tres remplazar datos por variables*/

  --dbms_output.put_line(json);
  
 
  lv_json_final:=li_json;

  for i in 1 .. ln_coincidencias loop
    

  
    --select substr('DSNOMBRE#DSAPELLIDO#DSAPELLIDO1#CURP#',1, instr('DSNOMBRE#DSAPELLIDO#DSAPELLIDO1#CURP#','#',1)-1) from dual
  
    begin
      select substr(lv_varnombre, 1, instr(lv_varnombre, '#', 1))
        into lv_valor
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    begin
      select substr(lv_varcontenido, 1, instr(lv_varcontenido, '#', 1))
        into lv_dato
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    --select replace('DSNOMBRE#DSAPELLIDO#DSAPELLIDO1#CURP#', 'DSNOMBRE#', '') from dual;
  
    begin
      select replace(lv_varnombre, lv_valor, '')
        into lv_recorta_valor
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    select replace(lv_varcontenido, lv_dato, '')
      into lv_recorta_dato
      from dual;
  
    --select substr(valor,1,length(valor)-1) from dual;
  
    begin
      select substr(lv_valor, 1, length(lv_valor) - 1)
        into lv_valor_remplazar
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    begin
      select substr(lv_dato, 1, length(lv_dato) - 1)
        into lv_dato_remplazar
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    --lv_parametro_dato:= '${'||lv_dato_remplazar||'}';
    lv_parametro_valor:= '${'||lv_valor_remplazar||'}';
    begin
      select replace(lv_json_final, lv_parametro_valor, lv_dato_remplazar)
        into lv_json_final
        from dual;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                             dbms_utility.format_error_backtrace);
    END;
  
    lv_varnombre    := '';
    lv_varcontenido := '';
    lv_varnombre    := lv_recorta_valor;
    lv_varcontenido := lv_recorta_dato;
  
    --dbms_output.put_line(lv_json_final);
    
   --lv_json_paso:=lv_json_final;
  
  end loop;

  dbms_output.put_line(lv_json_final);

  begin
    delete from ice_report_sequel;
    commit;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlcode || sqlerrm ||
                           dbms_utility.format_error_backtrace);
  END;

end;
