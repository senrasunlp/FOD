program p2e7;

const
    valoralto = 9999;

type

    mesaElectoral = record
        codProvincia:integer;
        codLocalidad:integer;
        numMesa:integer;
        cantVotos:integer;
    end;

    mesasElectorales = file of mesaElectoral;

    procedure leer(var arch:mesasElectorales;var dato:mesaElectoral);
    begin
        if not eof(arch) then
            read(arch,dato)
        else
            dato.codProvincia:= valoralto;
    end;
var
    arch:mesasElectorales;
    reg,aux:mesaElectoral;
    totalLocalidad,totalProvincia,totalGeneral:integer;

begin
    assign(arch,'archVotosP2E7');
    reset(arch);
    leer(arch,reg);
    totalGeneral:=0;
    while (reg.codProvincia <> valoralto) do begin
        aux.codProvincia := reg.codProvincia;
        totalProvincia:=0;
        writeln('Codigo de Provincia: ',reg.codProvincia);
        writeln('Codigo de Localidad              Total de votos');
        while (reg.codProvincia = aux.codProvincia) do begin
            totalLocalidad:=0;
            aux.codLocalidad := reg.codLocalidad;
            while ((reg.codProvincia = aux.codProvincia) and (reg.codLocalidad = aux.codLocalidad)) do begin
                totalLocalidad:=totalLocalidad + reg.cantVotos;
                leer(arch,reg);
            end;
            writeln(reg.codLocalidad,'              ',totalLocalidad);
            totalProvincia := totalProvincia + totalLocalidad;
        end;
        writeln('Total de Votos Provincia: ',totalProvincia);
        totalGeneral := totalGeneral + totalProvincia;
    end;
    writeln('Total General de Votos: ',totalGeneral);
    close(arch);

end.
