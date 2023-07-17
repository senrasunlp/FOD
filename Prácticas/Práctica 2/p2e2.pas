program p2e2;

const
     valor_alto = 9999;

type
    alumno = record
           cod:integer;
           apellido:string[20];
           nombre:string[20];
           materiasCursadas:integer;
           materiasAprobadas:integer;
    end;
    detMateria = record
           cod:integer;
           aprobada:integer; //archivo de texto no deja utilizar variables booleanas
    end;

    arch_alumno = file of alumno;
    arch_detMateria = file of detMateria;

var

   mae:arch_alumno;
   det:arch_detMateria;
   opc:char;
   fin:boolean;

   procedure cargarMaestro(var mae:arch_alumno);
   var
      cargaAlumnos:Text;
      regAlumno:alumno;
   begin
        reset(cargaAlumnos);
        rewrite(mae);
        while (not eof(cargaAlumnos)) do begin
              with regAlumno do readln(cargaAlumnos,cod,materiasCursadas,materiasAprobadas,apellido);
              readln(cargaAlumnos,regAlumno.nombre);
              write(mae,regAlumno);
        end;
        close(mae);
        close(cargaAlumnos);
   end;

   procedure cargarDetalle(var det:arch_detMateria);
   var
      cargaMaterias:Text;
      regMateria:detMateria;
   begin
        reset(cargaMaterias);
        rewrite(det);
        while (not eof(cargaMaterias)) do begin
              with regMateria do readln(cargaMaterias,cod,aprobada);
              write(det,regMateria);
        end;
        close(det);
        close(cargaMaterias);
   end;

   procedure generarReporteAlumnos (var mae:arch_alumno);
   var
      alumnosExp:Text;
      regAlumno: alumno;
   begin
        reset(mae);
        assign(alumnosExp,'reporteAlumnos.txt');
        rewrite(alumnosExp);
        while (not eof(mae)) do begin
              read(mae,regAlumno);
              with regAlumno do writeln(alumnosExp,cod,materiasCursadas,materiasAprobadas,apellido);
              writeln(alumnosExp,regAlumno.nombre);
        end;
        close(alumnosExp);
        close(mae);
   end;

   procedure generarReporteDetalle (var det:arch_detMateria);
   var
      materiasExp:Text;
      regMateria: detMateria;
   begin
        assign(materiasExp,'reporteDetalle.txt');
        rewrite(materiasExp);
        reset(det);
        while (not eof(det)) do begin
              read(det,regMateria);
              with regMateria do writeln(materiasExp,cod,aprobada);
        end;
        close(materiasExp);
        close(det);
   end;

   procedure leer(var arch:arch_detMateria; var regMateria:detMateria);
   begin
        if (not eof(arch)) then
           read(arch,regMateria)
        else
            regMateria.cod:= valor_alto;
   end;

   procedure actualizarMaestro(var mae:arch_alumno;var det:arch_detMateria);
   var
      regd:detMateria;regm:alumno;
   begin
        reset(mae);
        reset(det);
        leer(det,regd);
        read(mae,regm);
        while (regd.cod <> valor_alto) do begin
              while (regm.cod <> regd.cod) do
                    read(mae,regm);
              while (regm.cod = regd.cod) do begin
                    if(regd.aprobada = 1) then
                          regm.materiasAprobadas:= regm.materiasAprobadas + 1
                    else
                          regm.materiasCursadas:= regm.materiasCursadas + 1;
                    leer(det,regd);
              end;
              seek(mae, filepos(mae)-1);
              write(mae,regm);
              read(mae,regm);
        end;
        close(mae);
        close(det);
   end;

   procedure cuatroCursadas (var mae:arch_alumno);
   var
      cuatroCursadas:Text;
      regAlumno:alumno;
   begin
        assign(cuatroCursadas, 'cuatroCursadas.txt');
        rewrite(cuatroCursadas);
        reset(mae);
        while (not eof(mae)) do begin
              read(mae,regAlumno);
              if(regAlumno.materiasCursadas>4) then begin
                    with regAlumno do writeln(cuatroCursadas,cod,materiasCursadas,materiasAprobadas,apellido);
                    writeln(cuatroCursadas,regAlumno.nombre);
              end;
        end;
        close(cuatroCursadas);
        close(mae);
   end;

begin
   assign(mae,'maeP2E2');
   assign(det,'detP2E2');
   fin:= false;
   while (fin = false) do begin
         writeln('-------MENU-------');
         writeln('a) Cargar archivo maestro.');
         writeln('b) Cargar archivo detalle.');
         writeln('c) Generar reporte de alumnos.');
         writeln('d) Generar reporte de detalles.');
         writeln('e) actualizar archivo maestro.');
         writeln('f) Generar archivo de alumnos con mas de 4 materias cursadas.');
         readln(opc);
         case opc of
              'a':cargarMaestro(mae);
              'b':cargarDetalle(det);
              'c':generarReporteAlumnos(mae);
              'd':generarReporteDetalle (det);
              'e':actualizarMaestro(mae,det);
              'f':cuatroCursadas(mae);
              '0':fin:=true;
         else
             writeln('Ingrese una opcion valida.');
         end;
   end;
end.
