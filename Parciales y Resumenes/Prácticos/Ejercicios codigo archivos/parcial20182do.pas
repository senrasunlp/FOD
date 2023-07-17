program parcial20182do;
type
    prenda = record
           cod_prenda:integer;
           descripcion:string[200];
           colores:string[100];
           tipo_prenda:string[50];
           stock:integer;
           precio_unitario:real;
    end;
    prenda_obsoleta = record
           cod_prenda:integer;
    end;

    maestro = file of prenda;

    detalle = file of prenda_obsoleta;
var
   mae:maestro; det:detalle;

procedure realizarBaja(var mae:maestro; var det:detalle);
var
   regm,regaux:prenda;regd:prenda_obsoleta;
   ult,posaux:integer;
begin
   reset(mae);
   reset(det);
   read(mae,regm);
   read(det,regd);
   while (not eof(det)) do begin
         while (regm.cod_prenda <> regd.cod_prenda) do begin
               read(mae,regm);
         end;
         regm.stock:=regm.stock*(-1);
         read(det,regd);
   end;
   seek(det,filesize(det)-1);
   ult:=filepos(det);
   seek(det,0);
   while (not eof(mae)) do begin
         read(mae,regm);
         if (regm.stock<0) then begin
            posaux:=filepos(mae)-1;
            regaux:=regm;
            seek(mae,ult);
            read(mae,regm);
            seek(mae,filepos(mae)-1);
            write(mae,regaux);
            seek(mae,posaux);
            write(mae,regm);
            ult:=ult-1;
         end;
   end;
   truncate(mae);
   close(det);
   close(mae);
end;

begin
     assign(mae,'maeparcial2018segundo');
     assign(det,'detparcial2018segundo');
     realizarbaja(mae,det);
end.



