program p1e3a;

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
   regEmpleado:empleado;
   c:char;

procedure leer(var e:empleado);
begin
     writeln('--Ingresando nuevo empleado--');
     writeln('Ingresar apellido: ');
     readln(e.apellido);
     if (e.apellido <>'**') then begin
        writeln('Ingresar nombre: ');
        readln(e.nombre);
        writeln('Ingresar id: ');
        readln(e.id);
        writeln('Ingresar edad: ');
        readln(e.edad);
        writeln('Ingresar dni: ');
        readln(e.dni);
     end;
end;

procedure imprimirEmpleado (e:Empleado);
begin
     writeln('Nombre: ',e.nombre);
     writeln('Apellido: ',e.apellido);
     writeln('ID: ',e.id);
     writeln('Edad: ',e.edad);
     writeln('e.dni: ',e.dni);
     writeln('caracter: ',c)
end;

begin
   assign(empleados,arch_logico);
   rewrite(empleados);
   leer(regEmpleado);
   while (regEmpleado.apellido <>'') do begin
         imprimirEmpleado(regEmpleado);
         write(empleados,regEmpleado);
         leer(regEmpleado);
   end;
   close(empleados);
end.
