program p2e9;

const
    valoralto = '9999';

type

    provincia = record
        nombreProvincia:string[30];
        cantAlfabetizados:integer;
        cantEncuestados:integer;
    end;

    provincias = file of provincia;

    localidad = record
        nombreProvincia:string[30];
        codLocalidad:integer;
        cantAlfabetizados:integer;
        cantEncuestados:integer;
    end;

    localidades = file of localidad;

{
A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un archivo que contiene los siguientes datos:
nombre de provincia, cantidad de personas alfabetizadas y total de encuestados.

Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados.
Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.
}

    procedure leer(var arch:localidades; var dato:localidad);
    begin
        if not eof(arch) then
            read(arch,dato)
        else
            dato.nombreProvincia := valoralto;
    end;

    procedure minimo (var det1,det2:localidades; var min,regd1,regd2:localidad);
    begin
        if (regd1.nombreProvincia <= regd2.nombreProvincia) then begin
            min := regd1;
            leer(det1,regd1);
        end
            else begin
                min := regd2;
                leer(det2,regd2);
            end;
    end;

    procedure actualizarMaestro (var mae:provincias; var det1,det2:localidades);
    var
        regm:provincia;
        min,regd1,regd2:localidad;
    begin
        reset(mae);
        reset(det1);
        reset(det2);
        leer(det1,regd1);
        leer(det2,regd2);
        minimo(det1,det2,min,regd1,regd2);
        read(mae,regm);
        while (min.nombreProvincia <> valoralto) do begin
            while (regm.nombreProvincia <> min.nombreProvincia) do
                read(mae,regm);
            while (regm.nombreProvincia = min.nombreProvincia) do begin
                regm.cantAlfabetizados := regm.cantAlfabetizados + min.cantAlfabetizados;
                regm.cantEncuestados := regm.cantEncuestados + min.cantEncuestados;
                minimo(det1,det2,min,regd1,regd2);
            end;
            seek(mae,filepos(mae)-1);
            write(mae,regm);
        end;
        close(mae);
        close(det1);
        close(det2);
    end;

var
    mae:provincias; det1,det2:localidades;
begin
    assign(mae,'maeProvinciasP2E9');
    assign(det1,'det1LocalidadesP2E9');
    assign(det2,'det2LocalidadesP2E9');
    actualizarMaestro(mae,det1,det2);
end.
