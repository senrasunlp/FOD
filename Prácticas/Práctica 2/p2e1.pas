program p2e1;

const
     valor_alto = 9999;
type
    comision = record
        cod:integer;
        monto:real;
        nombre:string[30];
    end;

    arch_comisiones = file of comision;

    {Una empresa posee un archivo con informaci�n de los ingresos percibidos por diferentes
    empleados en concepto de comisi�n, de cada uno de ellos se conoce: c�digo de empleado,
    nombre y monto de la comisi�n. La informaci�n del archivo se encuentra ordenada por
    c�digo de empleado y cada empleado puede aparecer m�s de una vez en el archivo de
    comisiones.
    Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
    consecuencia, deber� generar un nuevo archivo en el cual, cada empleado aparezca una
    �nica vez con el valor total de sus comisiones.
    NOTA: No se conoce a priori la cantidad de empleados. Adem�s, el archivo debe ser
    recorrido una �nica vez.}
var
   arch1,arch2:arch_comisiones;

   procedure leer(var archivo:arch_comisiones;var dato:comision);
   begin
	  if (not(EOF(archivo))) then
          read (archivo,dato)
      else
		  dato.cod:= valor_alto;
   end;


   procedure compactar (var arch1,arch2:arch_comisiones);
   var
      regcom,regcompacto:comision;
   begin
        reset(arch1);
        rewrite(arch2);
        leer(arch1,regcom);
        while (regcom.cod <> valor_alto) do begin
            regcompacto:= regcom;
            regcompacto.monto:= 0;
            while (regcom.cod = regcompacto.cod) do begin
                 regcompacto.monto:= regcompacto.monto + regcom.monto;
                 leer(arch1,regcom);
            end;
            write(arch2,regcompacto);
        end;
        erase(arch1);
        close(arch2);
   end;


begin
   assign(arch1,'arch_comisionesSC');
   assign(arch2,'arch_comsionesCC');
   compactar(arch1,arch2);
end.
