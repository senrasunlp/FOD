program p3e7;

type
    especie = record
        cod:integer;
        nombre:string[50];
        familia:string[50];
        descripcion:string[50];
        zona:string[50];
    end;

    especies = file of especie;

    procedure marcarEspecies(var arch:especies);
    var
        codBorrar:integer;
        reg:especie;
    begin
        reset(arch);
        writeln('Ingresar codigo a borrar:');
        readln(codBorrar);
        while (codBorrar <> 100000) do begin
            read(arch,reg);
            while (not eof(arch) and (codBorrar <> reg.cod)) do
                read(arch,reg);
            if  (codBorrar = reg.cod) then begin
                reg.cod := reg.cod*(-1);
                seek(arch,filepos(arch)-1);
                write(arch,reg);
            end
                else writeln('Codigo no valido.');
            seek(arch,0);
            writeln('Ingresar codigo a borrar:');
            readln(codBorrar);
        end;
        close(arch);
    end;

    procedure nuevaEspecie(var reg:especie;var cod:integer);
    begin
        reg.cod := cod;
        writeln('Ingrese nombre de especie:');
        readln(reg.nombre);
        {if (reg.nombre <> '') then begin
            writeln('Ingrese familia de aves:');
            readln(reg.familia);
            writeln('Ingrese descripcion:');
            readln(reg.descripcion);
            writeln('Ingrese zona geográfica:');
            readln(reg.zona);
        end;}
    end;

    procedure cargarEspecies(var arch:especies);
    var
        reg:especie;
        cod:integer;
    begin
        rewrite(arch);
        cod := 1;
        nuevaEspecie(reg,cod);
        while (reg.nombre <> '') do begin
            write(arch,reg);
            cod := cod + 1;
            nuevaEspecie(reg,cod);
        end;
        close(arch);
    end;

    procedure mostrarEspecies(var arch:especies);
    var
        reg:especie;
    begin
        reset(arch);
        while (not eof(arch)) do begin
            read(arch,reg);
            with reg do writeln(nombre,' ',cod);
        end;
        readln();
    end;

    procedure compactar(var arch:especies);
    var
        reg,aux:especie;
        cont,posBorrado:integer;
    begin
        reset(arch);
        cont := 0;
        while (not eof(arch) and (filepos(arch) < (filesize(arch)- 1 - cont))) do begin
            read(arch,reg);
            while ((not eof(arch) and (reg.cod > 0)) and (filepos(arch) < (filesize(arch)- 1 - cont)))  do
                read(arch,reg);
            if (reg.cod < 0) then begin
                posBorrado := filepos(arch)-1;
                seek(arch,filesize(arch) -1 - cont);
                read(arch,aux);
                while (aux.cod < 0) do begin
                    cont := cont + 1 ;
                    seek(arch,filesize(arch) - cont);
                    read(arch,aux);
                end;
                seek(arch,posBorrado);
                write(arch,aux);
                cont:= cont + 1;
            end;
        end;
        if (filepos(arch) = (filesize(arch)- 1 - cont)) then begin
            read(arch,reg);
            if (reg.cod < 0) then
                cont := cont + 1;
        end;
        seek(arch,filesize(arch)-cont);
        truncate(arch);
        close(arch);
    end;

{
Se cuenta con un archivo que almacena información sobre especies de aves en vía de extinción, para ello se almacena:
código, nombre de la especie, familia de ave, descripción y zona geográfica.

El archivo no está ordenado por ningún criterio.

Realice un programa que elimine especies de aves, para ello se recibe por teclado las especies a eliminar.

Deberá realizar todas las declaraciones necesarias,implementar todos los procedimientos que requiera y una alternativa para borrar los registros.

Para ello deberá implementar dos procedimientos, uno que marque los registros a borrar y posteriormente otro procedimiento que compacte el archivo,
quitando los registros marcados.
Para quitar los registros se deberá copiar el último registro del archivo en la posición del registro a borrar y
luego eliminar del archivo el último registro de forma tal de evitar registros duplicados.

Nota: Las bajas deben finalizar al recibir el código 100000
}
var
arch:especies;

begin
    assign(arch,'especiesArchP3E7');
    cargarEspecies(arch);
    mostrarEspecies(arch);
    marcarEspecies(arch);
    compactar(arch);
    mostrarEspecies(arch);
end.
