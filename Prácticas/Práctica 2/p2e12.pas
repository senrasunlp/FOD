program p2e12;

const
    valoralto = '9999';

type

    vuelo = record
        destino:string[30];
        fecha:string[8];
        horaSalida:real;
        cantAsientosDisponibles:integer;
    end;

    detVuelo = record
        destino:string[30];
        fecha:string[8];
        horaSalida:real;
        cantAsientosComprados:integer;
    end;

    vuelos = file of vuelo;

    detVuelos = file of detVuelo;


    procedure leer (var arch:detVuelos; var dato:detVUelo);
    begin
        if not eof(arch) then
            read(arch,dato)
        else
            dato.destino := valoralto;
    end;

    procedure minimo (var det1,det2:detVuelos; var regd1,regd2,min:detVuelo);
    begin
        if (regd1.destino < regd2.destino) then begin
            min := regd1;
            leer(det1,regd1);
        end
            else if (regd1.destino > regd2.destino) then begin
                min:= regd2;
                leer(det2,regd2);
            end
                else if (regd1.fecha < regd2.fecha) then begin
                    min := regd1;
                    leer(det1,regd1);
                end
                    else if (regd1.fecha > regd2.fecha) then begin
                        min:= regd2;
                        leer(det2,regd2);
                    end
                        else if (regd1.horaSalida < regd2.horaSalida) then begin
                            min := regd1;
                            leer(det1,regd1);
                        end
                            else begin
                                min:= regd2;
                                leer(det2,regd2);
                            end;
    end;

    procedure actualizarMaestroyListar (var mae:vuelos; var det1,det2:detVuelos);
    var
        regm:vuelo;regd1,regd2,min:detVuelo;
        totalAsientosComprados,cantMin:integer;
    begin
        writeln('Ingrese la cantidad minima de los asientos disponibles: ');
        readln(cantMin);
        reset(mae);
        reset(det1);
        reset(det2);
        leer(det1,regd1);
        leer(det2,regd2);
        minimo(det1,det2,regd1,regd2,min);
        writeln('VUELOS CON CANTIDAD MINIMA DE PASAJES DISPONIBLES: ');
        while (not eof(mae)) do begin
            read(mae,regm);
            if ((min.destino = regm.destino) and (min.fecha = regm.fecha) and (min.horaSalida = regm.horaSalida)) then begin
                totalAsientosComprados := 0;
                while ((min.destino = regm.destino) and (min.fecha = regm.fecha) and (min.horaSalida = regm.horaSalida)) do begin
                    totalAsientosComprados := totalAsientosComprados + min.cantAsientosComprados;
                    minimo(det1,det2,regd1,regd2,min);
                end;
                regm.cantAsientosDisponibles := regm.cantAsientosDisponibles - totalAsientosComprados;
                seek(mae,filepos(mae)-1);
                write(mae,regm);
            end;
            if (regm.cantAsientosDisponibles >= cantMin) then
                writeln('Destino:',regm.destino,' fecha:',regm.fecha,'Hora de Salida:',regm.horaSalida);
        end;
        close(mae);
        close(det1);
        close(det2);
    end;
var
    mae:vuelos; det1,det2:detVuelos;

{
Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus próximos vuelos.
En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la cantidad de asientos disponibles.

La empresa recibe todos los días dos archivos detalles para actualizar el archivo maestro.
En dichos archivos se tiene destino, fecha, hora de salida y cantidad de asientos comprados.

Se sabe que los archivos están ordenados por destino más fecha y hora de salida,
y que en los detalles pueden venir 0, 1 ó más registros por cada uno del maestro.
Se pide realizar los módulos necesarios para:

g. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje sin asiento disponible.
h. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que tengan menos de una cantidad específica de asientos disponibles.
La misma debe ser ingresada por teclado.

NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

begin
    assign(mae,'maeVuelosP2E12');
    assign(det1,'det1VuelosP2E12');
    assign(det2,'det2VuelosP2E12');
    actualizarMaestroyListar(mae,det1,det2);

end.
