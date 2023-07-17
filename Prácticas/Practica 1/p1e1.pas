program p1e1;

type
    archivo_enteros = file of integer;

var
   arch:archivo_enteros;
   int_buffer:integer;
   nombre_arch:string;

begin
     //writeln('Ingrese el nombre del archivo: ');
     //readln(nombre_arch);
     assign(arch,'enteros.dat'); {Así no lo tengo que ingresar}
     rewrite(arch);
     writeln('Ingrese un numero entero: ');    {Lee el primer numero}
     read(int_buffer);
     while (int_buffer <> 10000) do begin
           write(arch,int_buffer);
           writeln('Ingrese un numero entero: ');
           read(int_buffer);
     end;
     close(arch);

end.
