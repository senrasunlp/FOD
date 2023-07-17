program parcial20181ro;
type
    acceso = record
           ano:integer;
           mes:integer;
           dia:integer;
           idUsuario:string[50];
           duracion:integer;
    end;

    archivo = file of acceso;

var
   arch:archivo;

procedure corteControl(var arch:archivo);
var
   tiempoDia,tiempoMes,tiempoano,tiempoUsuario,anoBuscado:integer;
   reg,aux:acceso;
begin
   reset(arch);
   write('Ingrese ano a informar:');
   readln(anoBuscado);
   read(arch,reg);
   while (reg.ano <> anoBuscado) and (not eof(arch)) do
         read(arch,reg);
   if (not eof(arch))then begin
      tiempoano:=0;
      writeln('ano:--',reg.ano);
      while (not eof(arch)) and (reg.ano = anoBuscado) do begin
            write('   ');
            writeln('Mes:--',reg.mes);
            tiempoMes:=0;
            aux:=reg;
            while (reg.ano <> anoBuscado) and (reg.mes = aux.mes) do begin
                  write('      ');
                  writeln('Dia:--',reg.dia);
                  tiempoDia:=0;
                  while (reg.ano = anoBuscado) and (reg.mes = aux.mes) and (reg.dia = aux.dia) do begin
                        tiempoUsuario:=0;
                        while (reg.ano = anoBuscado) and (reg.mes = aux.mes) and (reg.dia = aux.dia) and (reg.idUsuario = aux.idUsuario) do begin
                              tiempoUsuario:=tiempoUsuario+reg.duracion;
                              read(arch,reg);
                        end;
                        write('         ');
                        writeln('idUsuario ',reg.idUsuario,' Tiempo total de acceso en el dia ',reg.dia,' mes ',reg.mes);
                        writeln(tiempoUsuario);
                        tiempoDia:=tiempoDia+tiempoUsuario;
                  end;
                  write('      ');
                  writeln('Tiempo total de acceso en el dia ',reg.dia,' mes ',reg.mes);
                  writeln(tiempoDia);
                  tiempoMes:=tiempoMes+tiempoDia;
            end;
            writeln('Tiempo total de acceso mes ',reg.mes);
            writeln(tiempoMes);
            tiempoano:=tiempoano+tiempoMes;
      end;
      writeln('Tiempo total de acceso ano ');
      writeln(tiempoano);
   end
   else
       writeln('ano no encontrado');
   close(arch);
end;

begin
   assign(arch,'parcial20181ro');
   corteControl(arch);

end.
