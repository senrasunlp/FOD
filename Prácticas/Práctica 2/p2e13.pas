program p2e13;

const
    N = 10;
    valoralto = 9999;
type

    alumno = record
        dni_alumno:integer;
        cod_carrera:integer;
        monto_total_pagado:real;
    end;

    pago = record
        dni_alumno:integer;
        cod_carrera:integer;
        monto_cuota:real;
    end;

    pagos = file of pago;
    alumnos = file of alumno;

    sucursales = array [1..N] of pagos;

    vPagos = array[1..N] of pago;

    procedure leer(var archivo:pagos; var dato:pago);
    begin
        if not eof(archivo) then
            read(archivo,dato)
        else
            dato.dni_alumno := valoralto;
    end;

    procedure minimo (var detalles:sucursales; var min:pago; var vRegd:vPagos);
    var
        i,aux:integer;
    begin
        aux := 1;
        min := vRegd[aux];
        for i:= 2 to N do begin
            if (vRegd[i].dni_alumno < min.dni_alumno) then begin
                min := vRegd[i];
                aux := i;
            end
                else if ((vRegd[i].dni_alumno = min.dni_alumno) and (vRegd[i].cod_carrera = min.cod_carrera)) then begin
                    min := vRegd[i];
                    aux := i;
                end;
        end;
        leer(detalles[aux],vRegd[aux]);
    end;

    procedure actualizarMaestro(var mae:alumnos; var detalles:sucursales);
    var
        min:pago;vRegd:vPagos;
        regm:alumno;
        i:integer;
    begin
        reset(mae);
        for i:=1 to N do
            reset(detalles[i]);
            leer(detalles[i],vRegd[i]);
        minimo(detalles,min,vRegd);
        read(mae,regm);
        while (min.dni_alumno <> valoralto) do begin
            while ((min.dni_alumno <> regm.dni_alumno) and (regm.cod_carrera <> min.cod_carrera))  do
                read(mae,regm);
            while ((min.dni_alumno = regm.dni_alumno) and (regm.cod_carrera = min.cod_carrera))  do begin
                regm.monto_total_pagado := regm.monto_total_pagado + min.monto_cuota;
                minimo(detalles,min,vRegd);
            end;
            seek(mae,filepos(mae)-1);
            write(mae,regm);
        end;
        close(mae);
        for i:=1 to N do
            close(detalles[i]);
    end;

    procedure alumnosMorosos(var mae:alumnos);
    var
        morososTxt:Text;
        regm:alumno;
    begin
        assign(morososTxt,'morososP2E13.txt');
        rewrite(morososTxt);
        reset(mae);
        while (not eof(mae)) do begin
            read(mae,regm);
            if (regm.monto_total_pagado = 0) then
                with regm do writeln(morososTxt,dni_alumno,' ',cod_carrera,' alumno moroso');
        end;
        close(mae);
        close(morososTxt);
    end;
{
En la facultad de Ciencias Jurídicas existe un sistema a través del cual los alumnos del
posgrado tienen la posibilidad de pagar las carreras en RapiPago. Cuando el alumno se
inscribe a una carrera, se le imprime una chequera con seis códigos de barra para que pague
las seis cuotas correspondientes. Existe un archivo que guarda la siguiente información de los
alumnos inscriptos: dni_alumno, codigo_carrera y monto_total_pagado.

Todos los días RapiPago manda N archivos con información de los pagos realizados por los
alumnos en las N sucursales. Cada sucursal puede registrar cero, uno o más pagos y un
alumno puede pagar más de una cuota el mismo día. Los archivos que manda RapiPago tienen
la siguiente información: dni_alumno, codigo_carrera, monto_cuota.

a) Se debe realizar un procedimiento que dado el archivo con información de los alumnos
inscriptos y los N archivos que envía RapiPago, actualice la información de lo que ha pagado
cada alumno hasta el momento en cada carrera inscripto.

b) Realice otro procedimiento que reciba el archivo con información de los alumnos inscriptos y
genere un archivo de texto con los alumnos que aún no han pagado nada en las carreras que
están inscriptos. El archivo de texto debe contener la siguiente información:
dni_alumno, código_carrera y la leyenda “alumno moroso”.
La organización de la información del archivo de texto debe ser tal de poder utilizarla en una futura importación de datos
realizando la cantidad mínima de lecturas .

Precondiciones :
- Cada alumno puede estar inscripto en una o varias carreras.
- Todos los archivos están ordenados, primero por dni_alumno y luego por codigo_carrera.
- En los archivos que envía RapiPago hay información de pagos de alumnos que si o si existen
en el archivo de inscriptos.
Nota: Para ambos incisos debe definir todas las estructuras de datos utilizadas.
}

var
    mae:alumnos;
    detalles:sucursales;
    i:integer;
    aux:string;
begin
    assign(mae,'maeAlumnosP2E13');
    for i := 1 to N do begin
        Str(i,aux);
        aux := concat('det',aux,'PagosP2E13');
        assign(detalles[i],aux);
    end;
    actualizarMaestro(mae,detalles);
    alumnosMorosos(mae);

end.
