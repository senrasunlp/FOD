program p2e5;

uses crt;
const
     valoralto = 9999;

type

     producto = record
         cod:integer;
         precio:real;
         stockact:integer;
         stockmin:integer;
         nombre:string[50];
     end;

     venta = record
         cod:integer;
         cant:integer;
     end;

     productos = file of producto;

     ventas = file of venta;


     procedure leer (var archivo:ventas; var dato:venta);
     begin
          if (not eof(archivo)) then
             read(archivo,dato)
          else
              dato.cod:=valoralto;
     end;

     procedure cargarMaestroDeTxt (var mae:productos);
     var
        cargaMae:Text;
        p:producto;
     begin
          assign(cargaMae,'productos.txt');
          reset(cargaMae);
          assign(mae,'productosMaeP2E5');
          rewrite(mae);
          while (not eof(cargaMae)) do begin
                with p do readln(cargaMae,cod,precio,stockact,stockmin,nombre);
                write(mae,p);
          end;
          close(cargaMae);
          close(mae);
     end;

     procedure generarReporteMae (var mae:productos);
     var
        exportMae:Text;
        p:producto;
     begin
        reset(mae);
        assign(exportMae,'reporte.txt');
        rewrite(exportMae);
        while (not eof(mae)) do begin
              read(mae,p);
              with p do writeln(exportMae,cod,precio,stockact,stockmin,nombre);
        end;
        close(exportMae);
        close(mae);
     end;

     procedure cargarDetalleDeTxt (var det:ventas);
     var
        cargaDet:Text;
        v:venta;
     begin
        assign(cargaDet,'ventas.txt');
        reset(cargaDet);
        assign(det,'ventasDetP2E5');
        rewrite(det);
        while (not eof(cargaDet)) do begin
              with v do readln(cargaDet,cod,cant);
              write(det,v);
        end;
        close(det);
        close(cargaDet);
     end;

     procedure listarVentasEnPantalla (var det:ventas);
     var
        v:venta;
     begin
        reset(det);
        while (not eof(det)) do begin
              read(det,v);
              writeln('Venta de producto cod:',v.cod,' ',v.cant,' unidades.');
        end;
        close(det);
     end;

     procedure actualizarMaestro(var mae:productos; var det:ventas);
     var
        regd:venta; regm:producto;
     begin
        reset(det);
        reset(mae);
        leer(det,regd);
        read(mae,regm);
        while (regd.cod <> valoralto) do begin
              while (regm.cod <> regd.cod) do
                    read(mae,regm);
              while (regm.cod = regd.cod) do begin
                    regm.stockact:= regm.stockact - regd.cant;
                    leer(det,regd);
              end;
              seek(mae, filepos(mae)-1);
              write(mae,regm);
        end;
        close(det);
        close(mae);
     end;

     procedure generarArchBajoStock(var mae:productos);
     var
        p:producto;
        productosFaltaStock:Text;
     begin
          reset(mae);
          assign(productosFaltaStock,'stock_minimo.txt');
          rewrite(productosFaltaStock);
          while (not eof(mae)) do begin
                read(mae,p);
                if(p.stockact < p.stockmin) then
                      with p do writeln(productosFaltaStock,cod,precio,stockact,stockmin,nombre)
          end;
          close(mae);
          close(productosFaltaStock);
     end;
var
   mae:productos;det:ventas;
   opc:char;
   fin:boolean;

begin
     fin:=false;
     while (not fin) do begin
           writeln('------------------------------MENU------------------------------');
           writeln();
           writeln('(a)-> Cargar archivo maestro de productos a partir de productos.txt.');
           writeln('(b)-> Generar reporte.txt a partir del archivo maestro.');
           writeln('(c)-> Cargar archivo detalle de ventas a partir de ventas.txt.');
           writeln('(d)-> Listar en pantalla las ventas del archivo detalle.');
           writeln('(e)-> Actualizar el archivo maestro a partir del detalle.');
           writeln('(f)-> Generar stock_minimo.txt con los productos que tengan menos del stock minimo.');
           writeln('(0)-> Salir del programa.');
           readln(opc);
           clrscr();
           case opc of
                'a':begin
                         cargarMaestroDeTxt(mae);
                         writeln('a)Se ha cargado el archivo maestro binario.');
                    end;
                'b':begin
                         generarReporteMae(mae);
                         writeln('b)Se ha generado el archivo reporte.txt del archivo maestro.');
                    end;
                'c':begin
                         cargarDetalleDeTxt(det);
                         writeln('c)Se ha generado el archivo detalle binario.');
                    end;
                'd':begin
                         writeln('--------------------------LISTA DE VENTAS--------------------------');
                         listarVentasEnPantalla(det);
                    end;
                'e':begin
                         actualizarMaestro(mae,det);
                         writeln('Se ha actualizado el archivo maestro.');
                    end;
                'f':begin
                         generarArchBajoStock(mae);
                         writeln('Se ha generado el archivo stock_minimo.txt.');
                    end;
                '0':fin:= true;
           else
               writeln('Ingrese una opcion valida.');
           end;
           writeln();
     end;
end.
