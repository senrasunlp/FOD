program p1e2;

type
    archivo_enteros = file of integer;

var
   arch:archivo_enteros;
   int_buffer:integer;
   nombre_arch:string;
   menores1000:integer;
   total:real;
   cant:integer;

begin
     cant:=0;
     total:=0;
     //writeln('Ingrese el nombre del archivo: ');
     //readln(nombre_arch);
     assign(arch,'enteros.dat'); //Para no ingresar por teclado
     reset(arch);
     while (not EOF(arch)) do begin
           read(arch,int_buffer);
           cant:=cant+1;
           total:=total+int_buffer;
           if( int_buffer < 1000) then
               menores1000:=menores1000+1;
     end;
     writeln('La cantidad de numeros menores a 1000 es: ',menores1000);
     writeln('El promedio es: ',total/cant:5:2);
     readln();
     close(arch);
end.
