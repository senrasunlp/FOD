program p1e6;

const
    arch_logico = 'archElectrodomesticos';

type
    electrodomestico = record
        cod:integer;
        precio:real;
        stockmin:integer;
        stockact:integer;
        nombre:string[20];
        desc:string[50];
    end;

    arch_electrodomesticos = file of electrodomestico;

var
   arch:arch_electrodomesticos;
   archT,archT2,archT3:Text;
   opc:integer;

   procedure listarElectrodomesticosPocoStock(var arch:arch_electrodomesticos);
   var
      e:electrodomestico;
   begin
        reset(arch);
        while (not eof(arch)) do begin
              read(arch,e);
              if(e.stockact<e.stockmin) then begin
                    writeln();
                    writeln('Producto: ',e.nombre);
                    writeln('Codigo: ',e.cod);
                    writeln('Precio: $',e.precio:0:2);
                    writeln('Stock minimo: ',e.stockmin);
                    writeln('Stock actual: ',e.stockact);
                    writeln('Descripcion: ',e.desc);
               end;
        end;
        close(arch);
   end;

   procedure listarElectrodomesticosBuscados(var arch:arch_electrodomesticos);
   var
      cadena:string;
      e:electrodomestico;
   begin
        reset(arch);
        writeln('Ingrese la palabra clave buscada: ');
        readln(cadena);
        while (not eof(arch)) do begin
              read(arch,e);
              if((pos(e.desc,cadena)<> 0)) then begin
                    writeln();
                    writeln('Producto: ',e.nombre);
                    writeln('Codigo: ',e.cod);
                    writeln('Precio: $',e.precio:0:2);
                    writeln('Stock minimo: ',e.stockmin);
                    writeln('Stock actual: ',e.stockact);
                    writeln('Descripcion: ',e.desc);
              end;
        end;
        close(arch);
   end;

   procedure listarElectrodomesticos(var arch:arch_electrodomesticos);
   var
      e:electrodomestico;
   begin
        reset(arch);
        while (not eof(arch)) do begin
              read(arch,e);
              writeln();
              writeln('Producto: ',e.nombre);
              writeln('Codigo: ',e.cod);
              writeln('Precio: $',e.precio:0:1);
              writeln('Stock minimo: ',e.stockmin);
              writeln('Stock actual: ',e.stockact);
              writeln('Descripcion: ',e.desc);
        end;
        close(arch);
   end;

   procedure crearBinario(var arch:arch_electrodomesticos; var archT:Text);
   var
      e:electrodomestico;
   begin
        reset(archT);
        rewrite(arch);
        while (not eof(archT)) do begin
              with e do readln(archT,cod, precio, stockmin, stockact);
              readln(archT,e.nombre);
              readln(archT,e.desc);
              write(arch,e);
        end;
        close(archT);
        close(arch);
   end;

   procedure nuevoElectrodomestico(var e:electrodomestico);
   begin
       writeln('---Ingresando nuevo electrodomestico---');
       writeln('Ingresar nombre producto: ');
       readln(e.nombre);
       writeln('Ingresar codigo: ');
       readln(e.cod);
       writeln('Ingresar precio: ');
       readln(e.precio);
       writeln('Ingresar stock minimo: ');
       readln(e.stockmin);
       writeln('Ingresar stock actual: ');
       readln(e.stockact);
       writeln('Ingresar descripcion: ');
       readln(e.desc);
    end;

    procedure crearCarga (var archT: Text);
   var
      e:electrodomestico;
      fin:integer;
   begin
        rewrite(archT);
        repeat
              nuevoElectrodomestico(e);
              with e do writeln(archT,cod,' ',precio,' ',stockmin,' ',stockact);
              writeln(archT,e.nombre);
              writeln(archT,e.desc);
              writeln('Desea seguir agregando electrodomesticos? 1/0.');
              readln(fin);
        until
             fin = 0;
        close(archT);
   end;



   procedure agregarElectrodomesticos (var arch:arch_electrodomesticos);
   var
      e:electrodomestico;
      fin:integer;
   begin
        reset(arch);
        repeat
              nuevoElectrodomestico(e);
              seek(arch,filesize(arch));
              write(arch,e);
              writeln('Desea seguir agregando electrodomesticos? 1/0.');
              readln(fin);
        until
             fin = 0;
        close(arch);
   end;

   procedure modificarStockDeElectrodomestico(var arch:arch_electrodomesticos);
   var
      codBuscado:integer;
      e:electrodomestico;
   begin
        reset(arch);
        writeln('Ingrese el codigo del electrodomestico a modificar: ');
        readln(codBuscado);
        e.cod:= -999;
        while ((not eof(arch)) and (codBuscado<> e.cod)) do
              read(arch,e);
        if (codBuscado = e.cod) then begin
              writeln('Ingrese el nuevo stock: ');
              readln(e.stockact);
              seek(arch,filepos(arch)-1);
              write(arch,e);
        end;
        close(arch);
   end;

   procedure exportarElectrodomesticosSinStock(var arch:arch_electrodomesticos; var archT3:Text);
   var
       e:electrodomestico;
   begin
        reset(arch);
        rewrite(archT3);
        while (not eof(arch)) do begin
              read(arch,e);
              if (e.stockact = 0) then begin
                 with e do writeln(archT3,cod,' ',precio,' ',stockmin,' ',stockact,' ',nombre);
                 writeln(archT3,e.desc);
              end;
        end;
        close(arch);
        close(archT3);
   end;

   procedure exportarElectroText(var arch:arch_electrodomesticos; var archT2:Text);
   var
      e:electrodomestico;
   begin
        reset(arch);
        rewrite(archT2);
        while (not eof(arch)) do begin
              read(arch,e);
              with e do writeln(archT2,cod,' ',precio,' ',stockmin,' ',stockact,' ',nombre);
              writeln(archT2,e.desc);
        end;
        close(arch);
        close(archT2);
   end;

begin
   assign(arch,arch_logico);
   assign(archT,'carga.txt');
   assign(archT2,'electro.txt');
   assign(archT3,'SinStock.txt');
   opc:=999;
   repeat
         writeln();
         writeln('--------------MENU--------------');
         writeln('[1]--> Cargar archivo binario.');
         writeln('[2]--> Cargar archivo texto carga.');
         writeln('[3]--> Operaciones con archivo binario.');
         writeln('[0]--> Salir del programa.');
         readln(opc);
         case opc of
              1:crearBinario(arch,archT);
              2:crearCarga(archT);
              3:begin
                     repeat
                           writeln();
                           writeln('--------------MENU--------------');
                           writeln('[1]--> Listar electrodomesticos con stock menor al permitido.');
                           writeln('[2]--> Listar electrodomesticos con ciertas palabras.');
                           writeln('[3]--> Generar  archivo electro.txt.');
                           writeln('[4]--> Agregar nuevos electrodomesticos.');
                           writeln('[5]--> Modificar stock de un electrodomestico.');
                           writeln('[6]--> Generar  archivo SinStock.txt.');
                           writeln('[7]--> Listar electrodomesticos.');
                           writeln('[0]--> Salir del programa.');
                           readln(opc);
                           case opc of
                                1:listarElectrodomesticosPocoStock(arch);
                                2:listarElectrodomesticosBuscados(arch);
                                3:exportarElectroText(arch,archT2);
                                4:agregarElectrodomesticos(arch);
                                5:modificarStockDeElectrodomestico(arch);
                                6:exportarElectrodomesticosSinStock(arch,archT3);
                                7:listarElectrodomesticos(arch);
                           else
                               writeln('Ingrese una opcion valida.');
                           end;
                     until
                          opc = 0;
              end;
         else
             writeln('Ingrese una opcion valida.');
         end;
   until
        opc = 0;
end.
