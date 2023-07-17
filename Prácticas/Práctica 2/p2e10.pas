program p2e10;

const

    valoralto = 9999;

type

    acceso = record
        ano:integer;
        mes:integer;
        dia:integer;
        idUsuario:integer;
        tiempoAcceso:integer;
    end;

    accesos = file of acceso;
{
La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de la
organización. En dicho servidor, se almacenan en un archivo todos los accesos que se realizan
al sitio.
La información que se almacena en el archivo es la siguiente: ano, mes, dia, idUsuario y tiempo
de acceso al sitio de la organización. El archivo se encuentra ordenado por los siguientes
criterios: ano, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el
ano calendario sobre el cual debe realizar el informe.

Se deberá tener en cuenta las siguientes aclaraciones:
- El ano sobre el cual realizará el informe de accesos debe leerse desde teclado.
- El ano puede no existir en el archivo, en tal caso, debe informarse en pantalla “ano no
encontrado”.
- Debe definir las estructuras de datos necesarias.
- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.
}

    procedure leer(var arch:accesos; var dato:acceso);
    begin
        if not eof(arch) then
            read(arch,dato)
        else
            dato.ano := valoralto;
    end;

    procedure reporteAccesosDeUnano(var arch:accesos);
    var
        reg,aux:acceso;
        anoBuscado:integer;
        tiempoAccesoAno,tiempoAccesoMes,tiempoAccesoDia,tiempoAccesoUsuario:integer;
    begin
        writeln('Ingrese el ano cuyos accesos desea ver: ');
        readln(anoBuscado);
        reset(arch);
        leer(arch,reg);
        while ((reg.ano <> anoBuscado) and (reg.ano <> valoralto)) do
            leer(arch,reg);
        if (reg.ano = anoBuscado) then begin
            tiempoAccesoAno := 0;
            writeln('Ano: ',anoBuscado);
            while (reg.ano = anoBuscado)  do begin
                writeln('Mes: ',reg.mes);
                aux.mes := reg.mes;
                tiempoAccesoMes := 0;
                while ((reg.ano = anoBuscado) and (reg.mes = aux.mes)) do begin
                    writeln('Día: ',reg.dia);
                    aux.dia := reg.dia;
                    tiempoAccesoDia := 0;
                    while ((reg.ano = anoBuscado) and (reg.mes = aux.mes) and (reg.dia = aux.dia)) do begin
                        aux.idUsuario := reg.idUsuario;
                        tiempoAccesoUsuario := 0;
                        while ((reg.ano = anoBuscado) and (reg.mes = aux.mes) and (reg.dia = aux.dia) and (reg.idUsuario = aux.idUsuario)) do begin
                            tiempoAccesoUsuario := tiempoAccesoUsuario + reg.tiempoAcceso;
                            leer(arch,reg);
                        end;
                        writeln('idUsuario ',reg.idUsuario,'Tiempo Total de acceso en el dia ',reg.dia,'mes ',reg.mes);
                        writeln(tiempoAccesoUsuario,' minutos');
                        tiempoAccesoDia := tiempoAccesoDia + tiempoAccesoUsuario;
                    end;
                    writeln('Tiempo Total de acceso en el dia ',reg.dia,'mes ',reg.mes);
                    writeln(tiempoAccesoDia,' minutos');
                    tiempoAccesoMes := tiempoAccesoMes + tiempoAccesoDia;
                end;
                writeln('Tiempo Total de acceso en el mes ',reg.mes);
                writeln(tiempoAccesoMes,' minutos');
                tiempoAccesoano := tiempoAccesoano + tiempoAccesoMes;
            end;
            writeln('Total tiempo de acceso ano ');
            writeln(tiempoAccesoano,' minutos');
        end
        else
            writeln('ano no encontrado.');
        close(arch);
    end;

var
    arch:accesos;
begin
    assign(arch,'maeAccesosP2E10');
    reporteAccesosDeUnano(arch);
end.
