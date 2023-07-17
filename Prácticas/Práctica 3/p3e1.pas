program p3e1;

{
Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.
}
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
   empleadosT,noDniT:Text;
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
   var
      e:empleado;
   begin
        rewrite(empleados);
        leer(e);
        while (e.apellido <>'') do begin
              write(empleados,e);
              leer(e);
        end;
        close(empleados);
   end;

   procedure imprimirEmpleado(e:empleado);
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
      e:empleado;
   begin
        reset(empleados);
        writeln('Ingresar nombre o apellido de la persona buscada: ');
        readln(cadena);
        while (not eof(empleados)) do begin
               read(empleados,e);
               if (cadena = e.nombre) or (cadena = e.apellido) then
                  imprimirEmpleado(e);
        end;
        close(empleados);
   end;

   procedure imprimirEmpleados (var empleados:arch_empleados);
   var
      e:empleado;
   begin
        reset(empleados);
        while (not eof(empleados)) do begin
               read(empleados,e);
               writeln(e.apellido,' ',e.nombre,' ID:',e.id,' edad:',e.edad,' DNI:',e.dni);
        end;
        close(empleados);
   end;

   procedure imprimirAntiguos( var empleados:arch_empleados);
   var
      e:empleado;
   begin
        reset(empleados);
        while (not eof(empleados)) do begin
              read(empleados,e);
              if (e.edad > 60) then
                 imprimirEmpleado(e)
        end;
        close(empleados);
   end;
   procedure agregarEmpleado (var empleados:arch_empleados; e:empleado);
   begin
        seek(empleados,filesize(empleados));
        write(empleados,e);
   end;

   procedure agregarEmpleados (var empleados:arch_empleados);
   var
      e:empleado;
      fin:integer;
   begin
        reset(empleados);
        repeat
              leer(e);
              agregarEmpleado(empleados,e);
              writeln('Desea seguir ingresando empleados? 1/0');
              readln(fin);
        until
             fin = 0;
        close(empleados);
   end;


   procedure modificarEdadEmpleados(var empleados: arch_empleados);
   var
      idBuscado:integer;
      fin:integer;
      e:empleado;
   begin
        reset(empleados);
        repeat
              writeln('Ingrese el id del empleado cuya edad desea modificar: ');
              readln(idBuscado);
              if not eof(empleados) then
                read(empleados,e);
              while ((not eof(empleados)) and (e.id <> idBuscado)) do
                    read(empleados,e);
              if (e.id = idBuscado) then begin
                 writeln('Ingresa la nueva edad del empleado ',e.apellido,' ',e.nombre,' :');
                 readln(e.edad);
                 seek(empleados,filepos(empleados)-1);
                 write(empleados,e);
              end;
              seek(empleados,0);
              writeln('Desea seguir ingresando empleados? 1/0');
              readln(fin);
        until
              fin = 0;
        close(empleados);
   end;

   procedure bajaEmpleados(var empleados: arch_empleados);
   var
      idBuscado:integer;
      posAux,fin:integer;
      e,ultimoEmpleado:empleado;
   begin
        reset(empleados);
        repeat
              writeln('Ingrese el id del empleado que desea borrar: ');
              readln(idBuscado);
              if not eof(empleados) then
                read(empleados,e);
              while ((not eof(empleados)) and (e.id <> idBuscado)) do
                    read(empleados,e);
              if (e.id = idBuscado) then begin
                    posAux:=filepos(empleados)-1;
                    seek(empleados, filesize(empleados)-1);
                    read(empleados,ultimoEmpleado);
                    seek(empleados,posAux);
                    write(empleados,ultimoEmpleado);
                    seek(empleados, filesize(empleados)-1);
                    truncate(empleados);
                    writeln('Fue borrado con exito el empleado');
              end
                else
                    writeln('El empleado ingresado no existe');
              seek(empleados,0);
              writeln('Desea borrar otro empleado? 1/0');
              readln(fin);
        until
              fin = 0;
        close(empleados);
   end;

   procedure exportarEmpleados(var empleados:arch_empleados;var archExp:Text);
   var
      e:empleado;
   begin
        reset(empleados);
        rewrite(archExp);
        while (not eof(empleados)) do begin
              read(empleados,e);
              With e do writeln(archExp,id,' ',edad,' ', dni,' ',apellido);
              writeln(archExp,e.nombre);
        end;
        close(empleados);
        close(archExp);
   end;

   procedure exportarEmpleadosNoDni(var empleados:arch_empleados;var noDniT:Text);
   var
      e:empleado;
   begin
        reset(empleados);
        rewrite(noDniT);
        while (not eof(empleados)) do begin
              read(empleados,e);
              if (e.dni = 0) then begin
                 With e do writeln(noDniT,id,' ',edad,' ', dni,' ',apellido);
                 writeln(noDniT,e.nombre);
              end;
        end;
        close(empleados);
        close(noDniT);
   end;

begin
    assign(empleados,arch_logico);
    assign(empleadosT,'empleados.txt');
    assign(noDniT,'faltaDNI.txt');
    opc:=999;
    while (opc <>0) do begin
          writeln();
          writeln('-------------MENU PRINCIPAL-------------');
          writeln('--[1] -> Crear archivo nuevo de empleados');
          writeln('--[2] -> Abrir archivo existente');
          writeln('--[0] -> Salir del Programa');
          readln(opc);
          case (opc) of
               1:crearEmpleados(empleados);
               2:begin
                      writeln();
                      writeln('-------------MENU CONSULTAS-------------');
                      writeln('--[1] -> Imprimir empleados con determinado nombre/apellido.');
                      writeln('--[2] -> Imprimir todos los empleados.');
                      writeln('--[3] -> Imprimir empleados mayores a 60.');
                      writeln('--[4] -> Agregar uno o mas empleados nuevos.');
                      writeln('--[5] -> Modificar la edad de uno o mas empleados.');
                      writeln('--[6] -> Generar archivo de texto.');
                      writeln('--[7] -> Generar archivo de texto de empleados con DNI en 0.');
                      writeln('--[8] -> Borrar uno o mas empleados nuevos.');
                      writeln('--[0] -> Salir del Programa.');
                      readln(opc);
                      case (opc) of
                           1:imprimirBuscados(empleados);
                           2:imprimirEmpleados(empleados);
                           3:imprimirAntiguos(empleados);
                           4:agregarEmpleados(empleados);
                           5:modificarEdadEmpleados(empleados);
                           6:exportarEmpleados(empleados,empleadosT);
                           7:exportarEmpleadosNoDni(empleados,noDniT);
                           8:bajaEmpleados(empleados);
                      else
                          writeln('Ingrese una opcion valida.');
                      end;
                end;
          else
              writeln('Ingrese una opcion valida.');
          end;
    end;

end.
