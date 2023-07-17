program p2e8;

const
    valoralto ='9999';

type
    empleado = record
        departamento:string[30];
        division:integer;
        idEmpleado:integer;
        categoria:integer;
        horasExtras:integer;
    end;

    array15 = array [1..15] of real;

    empleados = file of empleado;



    procedure cargarBonus(var v:array15);
    var
        carga:Text;
        categ:integer;
        valorHora:real;
    begin
        assign(carga,'cargaBonusCategoriaP2E8.txt');
        reset(carga);
        while (not eof(carga)) do begin
            readln(categ);
            readln(valorHora);
            v[categ] := valorHora;
        end;
        close(carga);
    end;

    procedure leer (var arch:empleados; var dato:empleado);
    begin
        if not eof(arch) then
            read(arch,dato)
        else
            dato.departamento:= valoralto;
    end;

var
    arch:empleados;
    bonusXcategoria:array15;
    reg,aux:empleado;
    horasDepartamento,horasDivision,horasEmpleado:real;
    totalDepartamento, totalDivision:real;
begin
    assign(arch,'archEmpleadosP2E8');
    reset(arch);
    cargarBonus(bonusXcategoria);
    leer(arch,reg);
    while (reg.departamento <> valoralto) do begin
        aux.departamento := reg.departamento;
        horasDepartamento := 0;
        totalDepartamento := 0;
        writeln('Departamento: ',reg.departamento);
        while (aux.departamento = reg.departamento) do begin
            aux.division := reg.division;
            horasDivision := 0;
            totalDivision := 0;
            writeln('Division: ',reg.division);
            while ((aux.departamento = reg.departamento) and (aux.division = reg.division)) do begin
                aux.idEmpleado := reg.idEmpleado;
                horasEmpleado := 0;
                writeln('Número de Empleado     Total de Hs.    Importe a cobrar');
                while ((aux.departamento = reg.departamento) and (aux.division = reg.division) and (aux.idEmpleado = reg.idEmpleado)) do begin
                    horasEmpleado:= horasEmpleado + reg.horasExtras;
                    leer(arch,reg);
                end;
                totalDivision := totalDivision + horasEmpleado*bonusXcategoria[aux.categoria];
                horasDivision := horasDivision + horasEmpleado;
                writeln(reg.idEmpleado,'            ',horasEmpleado,'           ',horasEmpleado*bonusXcategoria[aux.categoria]);
            end;
            totalDepartamento := totalDepartamento + totalDivision;
            horasDepartamento := horasDepartamento + horasDivision;
            writeln('Total de horas división: ',horasDivision);
            writeln('Monto Total por división: ',totalDivision);
        end;
        writeln('Total de horas Departamento: ',horasDepartamento);
        writeln('Monto Total por Departamentoón: ',totalDepartamento);
    end;
    close(arch);

end.
