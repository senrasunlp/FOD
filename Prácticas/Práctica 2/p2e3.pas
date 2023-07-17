program p2e3;

const

     valoralto = 9999;

type

    producto = record
         cod:integer;
         precio:real;
         stockact:integer;
         stockmin:integer;
         descrip:string[50];
    end;
    pedido = record
           cod:integer;
           cantPedida:integer;
    end;

    pedidos = file of pedido;
    productos = file of producto;

var
   mae:productos;
   det1,det2,det3,det4:pedidos;

{Se pide realizar el proceso de actualización del archivo maestro con los cuatro archivos detalle, obteniendo
un informe de aquellos productos que quedaron debajo del stock mínimo y de aquellos
pedidos que no pudieron satisfacerse totalmente por falta de elementos, informando: la
sucursal, el producto y la cantidad que no pudo ser enviada (diferencia entre lo que pidió y lo
que se tiene en stock) .
NOTA 1: Todos los archivos están ordenados por código de producto y el archivo maestro
debe ser recorrido sólo una vez y en forma simultánea con los detalle.
NOTA 2: En los archivos detalle puede no aparecer algún producto del maestro. Además,
tenga en cuenta que puede aparecer el mismo producto en varios detalles. Sin embargo, en
un mismo detalle cada producto aparece a lo sumo una vez.}

procedure leer(var arch:pedidos; var dato:pedido);
begin
     if (not eof(arch)) then
        read(arch,dato)
     else
         dato.cod:= valoralto;
end;

procedure minimo (var p1,p2,p3,p4,min:pedido; var sucursal:integer);

begin
     if (p1.cod <= p2.cod) and (p1.cod <= p3.cod) and (p1.cod<=p4.cod) then begin
        min := p1;
        sucursal:=1;
        read(det1,p1)
     end
        else if (p2.cod <= p3.cod) and (p2.cod<=p4.cod) then begin
            min:= p2;
            sucursal:=2;
            read(det2,p2)
        end
         else if(p3.cod<=p4.cod) then begin
                min := p3;
                sucursal:=3;
                read(det3,p3)
             end
                else begin
                     min:= p4;
                     sucursal:=4;
                     read(det4,p4);
                end;
end;

procedure actualizarMaestro(var mae:productos; var det1,det2,det3,det4:pedidos);
var
   regm:producto;
   regd1,regd2,regd3,regd4,min:pedido;
   diferenciaPedidos,sucursal:integer;
begin
   reset(mae);
   reset(det1);
   reset(det2);
   reset(det3);
   reset(det4);
   leer(det1,regd1);
   leer(det2,regd2);
   leer(det3,regd3);
   leer(det4,regd4);
   minimo(regd1,regd2,regd3,regd4,min,sucursal);
   read(mae,regm);
   while (min.cod <> valoralto) do begin
         while (regm.cod <> min.cod) do
               read(mae,regm);
         while (regm.cod = min.cod) do begin
               if (regm.stockact>=min.cantPedida) then
                  regm.stockact:=regm.stockact-min.cantPedida
               else begin
                  diferenciaPedidos:=min.cantPedida-regm.stockact;
                  regm.stockact:=0;
                  writeln('La sucursal ',sucursal,' no tiene suficiente stock del producto cod:',min.cod,'.Falto ',diferenciaPedidos,' unidades por enviar.');
               end;
               minimo(regd1,regd2,regd3,regd4,min,sucursal);
         end;
         if (regm.stockact < regm.stockmin) then
            writeln('No hay suficientes unidades para llegar al stock minimo del producto de cod:',regm.cod);
         seek(mae,filepos(mae)-1);
         write(mae,regm);
   end;
   close(mae);
   close(det1);
   close(det2);
   close(det3);
   close(det4);
end;

begin
     assign(mae,'maeP2E3');
     assign(det1,'det1P2E3');
     assign(det2,'det2P2E3');
     assign(det3,'det3P2E3');
     assign(det4,'det4P2E3');
     actualizarMaestro(mae,det1,det2,det3,det4);
end.
