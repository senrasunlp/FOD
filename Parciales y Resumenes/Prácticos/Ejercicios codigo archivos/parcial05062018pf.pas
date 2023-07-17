program examenPrimeraFecha05062018;

const
     valoralto = 9999;
type

    acceso = record
           ano:integer;
           mes:integer;
           dia:integer;
           idUsuario:integer;
           tiempoAcceso:real;
    end;

    accesos = file of acceso;

    procedure leer (var arch:accesos; var reg:acceso);
    begin
         if not eof(arch) then
            read(arch,reg)
         else
            reg.ano := valoralto;
    end;

var
   arch:accesos;

   procedure buscarAno(var arch:accesos; var reg:acceso);
   var
      anoBuscado:integer;
   begin
      writeln('Ingrese el ano buscado: ');
      read(anoBuscado);
      if not eof(arch) then
         leer(arch,reg);
      while (not eof(arch) and (reg.ano <> valoralto)) do
         leer(arch,reg);
   end;

   procedure presentarInforme (var arch:accesos);
   var
      reg:acceso;
      anoAnterior,mesAnterior,diaAnterior,usuarioAnterior:integer;
      totalUsuario, totalDia, totalMes, totalAno:real;
   begin
        reset(arch);
        buscarAno(arch,reg);
        if not eof(arch) then begin
           writeln('Ano:',reg.ano);
           anoAnterior:= reg.ano;
           totalAno := 0;
           while (reg.ano = anoAnterior) do begin
                 writeln('  Mes:',reg.mes);
                 mesAnterior := reg.mes;
                 totalMes := 0;
                 while ((reg.ano = anoAnterior) and (reg.mes = mesAnterior)) do begin
                       writeln('    Dia:',reg.mes);
                       diaAnterior := reg.dia;
                       totalDia := 0;
                       while ((reg.ano = anoAnterior) and (reg.mes = mesAnterior) and (reg.dia = diaAnterior)) do begin
                             usuarioAnterior := reg.idUsuario;
                             totalUsuario := 0;
                             while ((reg.ano = anoAnterior) and (reg.mes = mesAnterior) and (reg.dia = diaAnterior) and (reg.idUsuario = usuarioAnterior)) do begin
                                   totalUsuario := totalUsuario + reg.tiempoAcceso;
                                   leer(arch,reg);
                             end;
                             writeln('      idUsuario ',usuarioAnterior,' Tiempo Total de acceso en el dia ',diaAnterior,' mes ',mesAnterior);
                             totalDia := totalDia + totalUsuario;
                       end;
                       writeln('Tiempo Total de acceso en el dia ',diaAnterior,' mes ',mesAnterior,': ',totalDia);
                       totalMes:= totalMes + totalDia;
                 end;
                 writeln('Tiempo Total de acceso mes ',mesAnterior,': ',totalMes);
                 totalAno:= totalAno + totalMes;
           end;
           writeln('Tiempo Total de acceso ano ',anoAnterior,': ',totalAno);
        end else
            writeln('El ano ingresado no es valido.');
        close(arch);
   end;

begin
   assign(arch,'archParcial05062018pf');
   presentarInforme(arch);

end.
