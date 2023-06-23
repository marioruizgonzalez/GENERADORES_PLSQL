select distinct campo3 from ejemplo;

select count(campo3)from ejemplo;

update ejemplo set campo3 = null 


select campo3, count(campo1) 
from ejemplo 
group by campo3



--****************

declare

v_valida_tabla number;--valida que la tabal no este vacio
v_registros_totales number;--almacena cuantos registros hay en tabla
v_cantidad_de_envios number;--almacena calculo de paginacion
v_contador number :=1; 

begin

    begin
    
    select count(1)
    into v_valida_tabla
    from ejemplo;
    
    exception
        when others then 
        
        dbms_output.put_line(sqlcode || sqlerrm || dbms_utility.format_error_backtrace);
    end;


    if v_valida_tabla <> 0 or v_valida_tabla <> null then 
        v_registros_totales := v_valida_tabla;
        v_cantidad_de_envios := ceil(v_registros_totales/500);
        
        FOR i IN 1 ..v_cantidad_de_envios
        loop
            update ejemplo
            set campo3 = 'C'||i
            WHERE campo3 is null
            and CAMPO1 IN 
            (
            select CAMPO1 from ejemplo 
            where rownum < 501
            and campo3 is null
            );
       end loop;
    end if;
end;

