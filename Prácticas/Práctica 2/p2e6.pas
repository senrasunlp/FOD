program p2e6;

const
     valoralto= 9999;

type

  cliente = record
      cod:integer;
      nombre:string[30];
      apellido:string[30];
  end;

  fecha = record
      dia:integer;
      mes:integer;
      ano:integer;
  end;

  venta = record
        cli:cliente;
        fech:fecha;
        monto:real;
  end;

  ventas = file of venta;


  procedure leer(var arch:ventas; var dato:venta);
  begin
       if (not eof(arch)) then
          read(arch,dato)
       else
           dato.cli.cod:= valoralto;
  end;

{ Se cuenta con un archivo que posee informaci�n de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizado por cliente.

Para ello, se deber� informar por pantalla: los datos personales del cliente, el total mensual
(mes por mes cu�nto compr�) y finalmente el monto total comprado en el a�o por el cliente.

Adem�s, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro est� dado por: cliente (cod cliente, nombre y apellido), a�o, mes,
d�a y monto de la venta.

El orden del archivo est� dado por: cod cliente, a�o y mes.
Nota : tenga en cuenta que puede haber meses en los que los clientes no realizaron compras.}

var
   arch:ventas;
   v,aux:venta;
   totalAno,totalMes,totalEmpresa:real;

begin
     assign(arch,'archVentasP2E6');
     reset(arch);
     leer(arch,v);
     totalEmpresa:=0;
     while (v.cli.cod <> valoralto) do begin
           aux:= v;
           writeln();
           writeln('Cliente: ',v.cli.nombre,' ',v.cli.apellido,' cod:',v.cli.cod);
           while (v.cli.cod = aux.cli.cod) do begin
                 totalAno:=0;
                 while ((v.cli.cod = aux.cli.cod) and (v.fech.ano = aux.fech.ano)) do begin
                       totalMes:=0;
                       while ((v.cli.cod = aux.cli.cod) and (v.fech.mes = aux.fech.mes)) do begin
                             totalMes:=totalMes + v.monto;
                             leer(arch,v);
                       end;
                       writeln('Total mes ',v.fech.mes,': $',totalMes:0:2);
                       totalAno:= totalAno + totalMes;
                 end;
                 writeln('Total A�o ',v.fech.Ano,': $',totalMes:0:2);
                 totalEmpresa:= totalEmpresa + totalAno;
           end;
     end;
     writeln('El total recaudado de la empresa fue: $',totalEmpresa:0:2);
     close(arch);
end.
