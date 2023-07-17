program p2e14;

const
    valoralto = '99999999';

type

    emision = record
        fecha:string[8];
        cod_seminario:integer;
        nombre_seminario:string[30];
        descripcion:string[100];
        precio:real;
        total_ejemplares:integer;
        total_ejemplares_vendidos:integer;
    end;

    emisiones = file of emision;

    ventaDiaria = record
        fecha:string[8];
        cod_seminario:integer;
        cant_ejemplares_vendidos:integer;
    end;

    ventaMensual = file of ventaDiaria;

    ventasMensuales = array [1..100] of ventaMensual;

    ventasDiarias = array[1..100] of ventaDiaria;

    procedure leer (var archivo:ventaMensual; var dato:ventaDiaria);
    begin
        if not eof(archivo) then
            read(archivo,dato)
        else
            dato.fecha := valoralto;
    end;

    procedure minimo (var detalles:ventasMensuales; var vRegd:ventasDiarias; var min:ventaDiaria);
    var
        i,aux:integer;
    begin
        aux:= 1;
        min:= vRegd[1];
        for i:=2 to 100 do begin
            if (vRegd[i].fecha < min.fecha) then begin
                min := vRegd[i];
                aux := i;
            end
                else if ((vRegd[i].fecha = min.fecha) and (vRegd[i].cod_seminario < min.cod_seminario)) then begin
                    min := vRegd[i];
                    aux := i;
                end;
        end;
        leer(detalles[aux],vRegd[aux]);
    end;

    procedure actualizarMaestro(var mae:emisiones; var detalles:ventasMensuales);
    var
        vRegd:ventasDiarias;
        min:ventaDiaria;
        regMinimo,regMaximo,regm:emision;
        i:integer;
    begin
        reset(mae);
        for i:=1 to 100 do begin
            reset(detalles[i]);
            leer(detalles[i],vRegd[i]);
        end;
        minimo(detalles,vRegd,min);
        regMinimo.total_ejemplares_vendidos := 9999;
        regMaximo.total_ejemplares_vendidos := -9999;
        while (not eof(mae)) do begin
            read(mae,regm);
            while ((min.fecha = regm.fecha) and (min.cod_seminario = regm.cod_seminario)) do begin
                regm.total_ejemplares_vendidos := regm.total_ejemplares_vendidos + min.cant_ejemplares_vendidos;
                minimo(detalles,vRegd,min);
            end;
            seek(mae,filepos(mae)-1);
            write(mae,regm);
            if (regm.total_ejemplares_vendidos >= regMaximo.total_ejemplares_vendidos) then
                regMaximo := regm;
            if (regm.total_ejemplares_vendidos <= regMinimo.total_ejemplares_vendidos) then
                regMinimo := regm;
        end;
        writeln('El seminario con mas ventas fue ',regMaximo.nombre_seminario,'del dia ',regMaximo.fecha);
        writeln('El seminario con menos ventas fue ',regMinimo.nombre_seminario,'del dia ',regMinimo.fecha);
        for i:=1 to 100 do
            close(detalles[i]);
        close(mae);

    end;
{

La editorial X, autora de diversos semanarios, posee un archivo maestro con la información correspondiente a las diferentes emisiones de los mismos.
De cada emisión se registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares y total de ejemplares vendido.

Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el país.
La información que poseen los detalles es la siguiente: fecha, código de semanario y cantidad de ejemplares vendidos.

Realice las declaraciones necesarias, la llamada al procedimiento y el procedimiento que recibe el archivo maestro
y los 100 detalles y realice la actualización del archivo maestro en función de las ventas registradas.

Además deberá informar fecha y semanario que tuvo más ventas y la misma información del semanario con menos ventas.

Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan ventas de semanarios si no hay ejemplares para hacerlo.

}
var
    i:integer;
    aux:string;
    mae:emisiones;
    detalles:ventasMensuales;

begin
    assign(mae,'maeSeminariosP2E14');
    for i:= 1 to 100 do begin
        Str(i,aux);
        aux := concat('det',aux,'ventasDiariasP2E14');
        assign(detalles[i],aux);
    end;
    actualizarMaestro(mae,detalles);
end.
