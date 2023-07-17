program p1e7;

type
    novela = record
           cod:integer;
           precio:real;
           genero:string[20];
           nombre:string[20];
    end;

    arch_novelas = file of novela;
var
   carga:Text;
   arch:arch_novelas;
   opc:integer;

   procedure cargarBinario (var arch:arch_novelas; var carga:Text);
   var
      n:novela;
   begin
        reset(carga);
        rewrite(arch);
        while (not eof(carga)) do begin
              with n do readln(carga,cod,precio,genero);
              readln(carga,n.nombre);
              write(arch,n);
        end;
        close(carga);
        close(arch);
   end;

   procedure leerNovela (var n:novela);
   begin
        writeln();
        writeln('--Ingresando nueva novela--');
        writeln('Ingrese nombre: ');
        readln(n.nombre);
        writeln('Ingrese genero: ');
        readln(n.genero);
        writeln('Ingrese precio: ');
        readln(n.precio);
        writeln('Ingrese codigo: ');
        readln(n.cod);
   end;

   procedure agregarNovela (var arch:arch_novelas);
   var
      n:novela;
   begin
        reset(arch);
        leerNovela(n);
        seek(arch,filesize(arch));
        write(arch,n);
        close(arch);
   end;

   procedure modificarNovela (var arch:arch_novelas);
   var
      codBuscado:integer;
      n:novela;
      op:integer;
   begin
        reset(arch);
        writeln('Ingrese el codigo de la novela: ');
        readln(codBuscado);
        n.cod:=-999;
        while ((not eof(arch)) and (codBuscado <> n.cod)) do
              read(arch,n);
        if (codBuscado = n.cod) then begin
           repeat
                 writeln('----MODIFICAR NOVELA----');
                 writeln('[1]--> Modificar precio.');
                 writeln('[2]--> Modificar nombre.');
                 writeln('[3]--> Modificar genero.');
                 writeln('[0]--> Salir del programa.');
                 readln(op);
                 case op of
                      1:begin
                        writeln('Ingrese precio: ');
                        readln(n.precio);
                      end;
                      2:begin
                        writeln('Ingrese nuevo nombre: ');
                        readln(n.nombre);
                      end;
                      3:begin
                        writeln('Ingrese genero: ');
                        readln(n.genero);
                      end;
                 else
                     writeln('Ingresa una opcion valida.');
                 end;
           until
                op = 0;
           seek(arch,filepos(arch)-1);
           write(arch,n);
        end;
        close(arch);
   end;

   procedure listarNovelas(var arch:arch_novelas);
   var
      n:novela;
   begin
        reset(arch);
        while (not eof(arch)) do begin
              read(arch,n);
              with n do writeln('[',cod,'] "',nombre,'" ',genero,' $',precio:0:2);
        end;
   end;

begin
   assign(carga,'novelas.txt');
   assign(arch,'novelas.bin');
   repeat
         writeln('-----------------MENU PRINCIPAL------------------');
         writeln('[1]--> Cargar archivo binario a partir de texto.');
         writeln('[2]--> Abrir archivo binario.');
         writeln('[0]--> Salir del programa.');
         readln(opc);
         case opc of
              1:cargarBinario(arch,carga);
              2:begin
                     repeat
                           writeln('[1]--> Agregar una novela.');
                           writeln('[2]--> Modificar una novela.');
                           writeln('[3]--> Listar todas las novelas.');
                           writeln('[0]--> Salir del programa.');
                           case opc of
                                1:agregarNovela(arch);
                                2:modificarNovela(arch);
                                3:listarNovelas(arch);
                           else
                               writeln('Ingrese una opcion valida');
                           end;
                     until
                          opc = 0;
              end;
         else
             writeln('Ingrese una opcion valida');
         end;
   until
        opc = 0;
end.
