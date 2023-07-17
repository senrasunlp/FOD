program p3e2;

uses crt;
type

    empleado = record
        cod_empleado:integer;
        apellido_nombre:string[50];
        direccion:string[30];
        telefono:integer;
        dni:integer;
        fechaNac:string[10];
    end;

    empleados = file of empleado;

{
Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de empleados de una empresa de correo privado. Se deberá almacenar:
código de empleado, apellido y nombre, dirección, telefono, D.N.I y fecha
nacimiento. Implementar un algoritmo que, a partir del archivo de datos generado,
elimine de forma lógica todo los empleados con DNI inferior a 5.000.000.
Para ello se podrá utilizar algún carácter especial delante de algún campo String a su
elección. Ejemplo: ‘*Juan’.
}

    procedure nuevoEmpleado (var reg:empleado);
    begin
        writeln();
        writeln('-------NUEVO EMPLEADO-------');
        writeln('Ingresar codigo de empleado: ');
        readln(reg.cod_empleado);
        writeln('Ingresar apellido y nombre: ');
        readln(reg.apellido_nombre);
        writeln('Ingresar direccion: ');
        readln(reg.direccion);
        writeln('Ingresar telefono: ');
        readln(reg.telefono);
        writeln('Ingresar DNI: ');
        readln(reg.dni);
        writeln('Ingresar fecha de nacimiento: ');
        readln(reg.fechaNac);
        clrscr;
    end;

    procedure crearArchivo (var arch:empleados);
    var
        reg:empleado;
    begin
        rewrite(arch);
        nuevoEmpleado(reg);
        while (reg.cod_empleado <> 9999) do begin
            write(arch,reg);
            nuevoEmpleado(reg);
        end;
        close(arch);
    end;

    procedure borrarExEmpleados(var arch:empleados);
    var
        reg:empleado;
    begin
        reset(arch);
        while (not eof(arch)) do begin
            read(arch,reg);
            if (reg.dni < 5000000) then begin
                reg.apellido_nombre[0]:='*';
                seek(arch,filepos(arch)-1);
                write(arch,reg);
            end;
        end;
        close(arch);
    end;

var
    arch:empleados;

begin
    assign(arch,'archEmpleadosP3E2');
    crearArchivo(arch);
    borrarExEmpleados(arch);

end.
