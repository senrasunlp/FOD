program p3e3;

uses crt;
type

    novela = record
        cod:integer;
        genero:string[30];
        nombre:string[70];
        duracion:integer;
        director:string[70];
        precio:real;
   end;

   novelas = file of novela;

   procedure nuevaNovela(var reg:novela);
   begin
        writeln('----INGRESANDO NUEVA NOVELA----');
        writeln('Ingrese el nombre de la novela: ');
        readln(reg.nombre);
        if (reg.nombre <> '') then begin
            writeln('Ingrese el codigo de la novela: ');
            readln(reg.cod);
            writeln('Ingrese el genero de la novela: ');
            readln(reg.genero);
            writeln('Ingrese la duracion de la novela: ');
            readln(reg.duracion);
            writeln('Ingrese el director de la novela: ');
            readln(reg.director);
            writeln('Ingrese el precio de la novela: ');
            readln(reg.precio);
        end;
        clrscr;
   end;

   procedure crearArchivo(var arch:novelas);
   var
        reg:novela;
   begin
        rewrite(arch);
        reg.cod:=0;
        write(arch,reg);
        nuevaNovela(reg);
        while (reg.nombre <> '') do begin
            write(arch,reg);
            nuevaNovela(reg);
        end;
        close(arch);
   end;

   procedure agregarNovela(var arch:novelas);
   var
        cabecera,nuevaNov,viejaNov:novela;
        pos:integer;
   begin
        reset(arch);
        read(arch,cabecera);
        nuevaNovela(nuevaNov);
        if (cabecera.cod <0) then begin
            pos:=(-1)*cabecera.cod;
            seek(arch,pos);
            read(arch,viejaNov);
            seek(arch,filepos(arch)-1);
            write(arch,nuevaNov);
            seek(arch,0);
            write(arch,viejaNov);
        end
            else begin
                seek(arch,filesize(arch));
                write(arch,nuevaNov);
            end;
        close(arch);
   end;

   procedure modificarNovela(var arch:novelas);
   var
        opcMod,codBuscado:integer;
        reg:novela;
   begin
        reset(arch);
        writeln('Ingrese el cod de la novela a modificar: ');
        readln(codBuscado);
        read(arch,reg);
        while ((not eof(arch)) and (codBuscado <> reg.cod)) do
            read(arch,reg);
        if (codBuscado = reg.cod) then begin
            repeat
                writeln('----MODIFACION NOVELA COD:',codBuscado,'----');
                writeln('1)-> Modificar genero.');
                writeln('2)-> Modificar duracion.');
                writeln('3)-> Modificar director.');
                writeln('4)-> Modificar precio.');
                writeln('0)-> Finalizar programa.');
                readln(opcMod);
                case opcMod of
                    1:begin
                        writeln('Ingrese el nuevo genero: ');
                        readln(reg.genero);
                    end;
                    2:begin
                        writeln('Ingrese la nueva duracion: ');
                        readln(reg.duracion);
                    end;
                    3:begin
                        writeln('Ingrese el nuevo director: ');
                        readln(reg.director);
                    end;
                    4:begin
                        writeln('Ingrese el nuevo precio: ');
                        readln(reg.precio);
                    end;
                    0:writeln('Modificacion finalizada.');
                    else writeln('Ingrese una opcion valida');
                end;
            until
                opcMod = 0;
            seek(arch,filepos(arch)-1);
            write(arch,reg);
        end else writeln('No existe una novela con el codigo ingresado.');
        close(arch);
   end;

   procedure eliminarNovela(var arch:novelas);
   var
        codBuscado,ptrCabecera:integer;
        cabecera,reg:novela;
   begin
        reset(arch);
        writeln('Ingrese el cod de la novela que desea borrar: ');
        readln(codBuscado);
        read(arch,reg);
        cabecera := reg;
        while ((not eof(arch)) and (codBuscado <> reg.cod)) do
            read(arch,reg);
        if (codBuscado = reg.cod) then begin
            ptrCabecera:= filepos(arch)-1;
            seek(arch,ptrCabecera);
            write(arch,cabecera);
            cabecera.cod:= (-1)*ptrCabecera;
            seek(arch,0);
            write(arch,cabecera);
            writeln('Se borro exitosamente la novela de codigo ',codBuscado);
        end
            else writeln('El codigo de novela ingresado no es valido.');
        close(arch);
   end;

   procedure listarNovelasTxt(var arch:novelas);
   var
     expNovelas:Text;
     reg:novela;
   begin
        reset(arch);
        assign(expNovelas,'novelas.txt');
        rewrite(expNovelas);
        read(arch,reg); //saco el cabecera de la lista
        while (not eof(arch)) do begin
            read(arch,reg);
            writeln(expNovelas,reg.cod,' ',reg.duracion,' ',reg.precio,' ',reg.nombre);
            writeln(expNovelas,reg.genero);
            writeln(expNovelas,reg.director);
        end;
        writeln('Se genero el archivo novelas.txt exitosamente.');
        close(expNovelas);
        close(arch);
   end;



{
Realizar un programa que genere un archivo de novelas filmadas durante el presente año. De cada novela se registra:
código, género, nombre, duración, director y precio.

El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado.
Se utiliza la técnica de lista invertida para recuperar espacio libre en el archivo.
Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la lista.
Es decir un registro ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela,
el cual indica que no hay espacio libre dentro del archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso a.,se utiliza lista invertida para recuperación de espacio.
En particular, para el campo de ´enlace´ de la lista, se debe especificar los números de registro referenciados con signo negativo,
(utilice el código de novela como enlace).Una vez abierto el archivo, brindar operaciones para:

  i. Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el espacio libre.
  Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5,
  se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar el nuevo registro en la posición 5.
  Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.

  ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado.

  iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8,
  en el campo código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que representan la lista de espacio libre.
El archivo debe llamarse “ novelas.txt ”.

NOTA : Tanto en la creación como en la apertura el nombre del archivo debe ser proporcionado por el usuario.
}

var
    arch:novelas;
    opc:integer;
begin
    assign(arch,'archNovelasP3E3');
    repeat
        writeln('-----------MENU PRINCIPAL-----------');
        writeln('1)-> Crear archivo binario de novelas.');
        writeln('2)-> Abrir archivo.');
        writeln('3)-> Generar archivo novelas.txt.');
        writeln('0)-> Finalizar programa.');
        readln(opc);
        case opc of
            1:crearArchivo(arch);
            2:begin
                    repeat
                        writeln('-----------ARCHIVO ABIERTO-----------');
                        writeln('1)-> Agregar una novela.');
                        writeln('2)-> Modificar una novela.');
                        writeln('3)-> Eliminar una novela.');
                        writeln('9)-> Salir del archivo.');
                        readln(opc);
                        case opc of
                            1:agregarNovela(arch);
                            2:modificarNovela(arch);
                            3:eliminarNovela(arch);
                            else writeln('Opcion no valida');
                        end;
                        clrscr;
                    until
                        opc = 9;
            end;
            3:listarNovelasTxt(arch);
            else writeln('Opción no válida');
        end;
    until
        opc = 0;
end.
