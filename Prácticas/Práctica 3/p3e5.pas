program p3e5;

uses    crt;
type

    tTitulo = String[50];

    tArchRevistas = file of tTitulo ;

{
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 implica que no hay registros borrados y N indica que el próximo registro a
reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:
Abre el archivo y agrega el título de la revista, recibido como
parámetro manteniendo la política descripta anteriormente

b. Liste el contenido del archivo omitiendo las revistas eliminados. Modifique lo que
considere necesario para obtener el listado.


NOTA:
Val(string_origen, int_destino, posicion_error)

Le pasás la cadena a convertir en el primer parámetro,te devolverá la representación numérica en el segundo parámetro.
El tercero es la posición de la cadena donde se encontró algo que no es un número y que por lo tanto no puede convertir.
De esta manera si posicion_error vale 0 quiere decir que el texto pudo ser convertido a entero (pascal indexa desde 1 casi siempre)
y por lo tanto en int_destino tendrás su representación correcta.
}

procedure agregar( var a:tArchRevistas ; titulo:tTitulo);
var
    cabecera,nuevaCabecera:tTitulo;
    NRR,posError:integer;

begin
    reset(a);
    read(a,cabecera);
    Val(cabecera,NRR,posError);
    if (posError = 0) then begin
        if (NRR = 0) then begin
            seek(a,filesize(a));
            write(a,titulo);
        end
            else begin
                seek(a,NRR);
                read(a,nuevaCabecera);
                seek(a,filepos(a)-1);
                write(a,titulo);
                seek(a,0);
                write(a,nuevaCabecera);
            end;
    end
        else writeln('Error en el registro cabecera.');
    close(a);
end;

procedure nuevoTitulo (var a:tArchRevistas);
var
    t:tTitulo;
begin
    writeln();
    writeln('Ingresar nuevo titulo: ');
    readln(t);
    agregar(a,t);
end;

procedure eliminar (var a:tArchRevistas; tituloBorrar:tTitulo);
var
    reg,cabecera:tTitulo;
    NRR,posError,nuevoNRR:integer;
begin
    reset(a);
    if not eof(a) then begin
        read(a,cabecera);
        reg := cabecera;
        while ((not eof(a)) and (reg <> tituloBorrar)) do
            read(a,reg);
        if (reg = tituloBorrar) then begin //Encuentro el titulo a borrar
            Val(cabecera,NRR,posError);
            nuevoNRR:=filepos(a)-1; //guardo la posicion nueva a la que apuntara la cabecera
            if (NRR <> 0) then begin  //Si hay ya un registro apuntado por la cabecera..
                seek(a,nuevoNRR);
                write(a,cabecera); //Voy al registro a borrar, y escribo ahi el registro apuntado anteriormente por la cabecera,
            end;                   //ya que la cabecera tendra que apuntar ahora al ultimo registro borrado (se hace en las siguientes lineas)
            seek(a,0);
            Str(nuevoNRR,cabecera); //Pone en la cabecera la posicion del ultimo registro borrado
            write(a,cabecera);
            writeln('Se borro exitosamente el titulo.');
        end
            else writeln('El titulo ingresado a borrar no es valido.');
    end
        else writeln('No hay ningun titulo cargado.');
    close(a);
end;

    procedure borrarTitulo (var a:tArchRevistas);
    var
        titulo_a_borrar:tTitulo;
    begin
        writeln();
        writeln('Ingresar el titulo a borrar: ');
        readln(titulo_a_borrar);
        eliminar(a,titulo_a_borrar);
    end;

    procedure listarTitulos(var a:tArchRevistas);
    var
        t:tTitulo;
        NRR,posError:integer;
    begin
        reset(a);
        while (not eof(a)) do begin
            read(a,t);
            Val(t,NRR,posError);
            if (posError <> 0) then
                writeln('Titulo: ',t);
        end;
        close(a);
        readln();
    end;

    procedure inicializarCabecera(var a:tArchRevistas);
    var
        cabecera:tTitulo;
    begin
        rewrite(a);
        cabecera := '0';
        write(a,cabecera);
        close(a);
    end;
var
    a:tArchRevistas;
    opc:integer;

begin
    assign(a,'archRevistasP3E4');
    inicializarCabecera(a);
    repeat
        writeln('------MENU REVISTA------');
        writeln('1)-> Agregar un titulo');
        writeln('2)-> Borrar un titulo');
        writeln('3)-> Listar todos los titulos');
        writeln('0)-> Finalizar programa.');
        readln(opc);
        case opc of
            1:nuevoTitulo(a);
            2:borrarTitulo(a);
            3:listarTitulos(a);
            0:writeln('Programa finalizado.');
        else
            writeln('Ingrese una opcion valida.');
        end;
        clrscr;
    until
        opc = 0;

end.
