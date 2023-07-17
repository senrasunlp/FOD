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

procedure leer(var e:empleado);
begin
     writeln('--Ingresando nuevo empleado--');
     writeln('Ingresar apellido: ');
     readln(e.apellido);
     if (e.apellido <>'**') then begin
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


begin
   assign(empleados,arch_logico);
   rewrite(empleados);
   leer(regEmpleado);
   while (regEmpleado.apellido <>'**') do begin
         write(empleados,regEmpleado);
         leer(regEmpleado);
   end;
   close(empleados);
end.
