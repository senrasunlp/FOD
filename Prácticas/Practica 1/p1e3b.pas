program p1e3b;

const
     arch_logico = 'archivoEmpleadosE3';

type
    empleado = record
             id:integer;
             edad:integer;
             dni:integer;
             nombre:string[20];
             apellido:string[20];
    end;
    arch_empleados = file of empleado;

var
   empleados:arch_empleados;
   e:empleado;
   opc:integer;

   procedure leer(var e:empleado);
   begin
     writeln('--Ingresando nuevo empleado--');
     writeln('Ingresar apellido: ');
     readln(e.apellido);
     if (e.apellido <>'') then begin
        writeln('Ingresar nombre: ');
        readln(e.nombre);
        writeln('Ingresar ID: ');
        readln(e.id);
        writeln('Ingresar edad: ');
        readln(e.edad);
        writeln('Ingresar dni: ');
        readln(e.dni);
     end;
   end;

   procedure crearEmpleados(var empleados:arch_empleados);
   begin
        rewrite(empleados);
        leer(e);
        while (e.apellido <>'') do begin
              write(empleados,e);
              leer(e);
        end;
   end;

   procedure imprimirEmpleado(e:Empleado);
   begin
        writeln('Nombre: ',e.nombre);
        writeln('Apellido: ',e.apellido);
        writeln('ID: ',e.id);
        writeln('Edad: ',e.edad);
        writeln('DNI: ',e.dni);
   end;

   procedure imprimirBuscados(var empleados:arch_empleados);
   var
      cadena:string[20];
   begin
        writeln('Ingresar nombre o apellido de la persona buscada: ');
        readln(cadena);
        while (not eof(empleados)) do begin
               read(empleados,e);
               if (cadena = e.nombre) or (cadena = e.apellido) then
                  imprimirEmpleado(e);
        end;
        seek(empleados,0);
   end;

   procedure imprimirEmpleados (var empleados:arch_empleados);
   begin
        while (not eof(empleados)) do begin
               read(empleados,e);
               writeln(e.apellido,' ',e.nombre,' ID:',e.id,' edad:',e.edad,' DNI:',e.dni);
        end;
        seek(empleados,0);
   end;

   procedure imprimirAntiguos( var empleados:arch_empleados);
   begin
        while (not eof(empleados)) do begin
              read(empleados,e);
              if (e.edad > 60) then
                 imprimirEmpleado(e)
        end;
        seek(empleados,0);
   end;


begin
    assign(empleados,arch_logico);
    opc:=999;
    while (opc <>0) do begin
          writeln();
          writeln('Ingrese una opcion del 1 al 2: ');
          writeln('--[1] -> Crear archivo nuevo de empleados');
          writeln('--[2] -> Abrir archivo existente');
          writeln('--[0] -> Salir del Programa');
          readln(opc);
          case (opc) of
               1:crearEmpleados(empleados);
               2:begin
                      reset(empleados);
                      writeln();
                      writeln('Ingrese una opcion del 1 al 3: ');
                      writeln('--[1] -> Imprimir empleados con determinado nombre/apellido');
                      writeln('--[2] -> Imprimir todos los empleados');
                      writeln('--[3] -> Imprimir empleados mayores a 60');
                      writeln('--[0] -> Salir del Programa');
                      readln(opc);
                      case (opc) of
                           1:imprimirBuscados(empleados);
                           2:imprimirEmpleados(empleados);
                           3:imprimirAntiguos(empleados);
                      else
                          writeln('Ha salido del programa.');
                      end;
                      close(empleados);
                end;
          else
              writeln('Ha salido del programa.');
          end;
    end;

end.
