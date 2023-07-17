program examenSegundaFecha26062018;

type
    prenda = record
           cod_prenda:integer;
           descripcion:string;
           colores:string;
           tipo_prenda:string;
           stock:integer;
           precio_unitario:real;
    end;

    prendas = file of prenda;

    prendas_obsoletas = file of integer;

var
   arch1:prendas;
   arch2:prendas_obsoletas;

   procedure bajaPrendaObsoleta(var arch1:prendas; codObsoleta:integer);
   var
      regPrenda:prenda;
   begin
        seek(arch1,0);
        read(arch1,regPrenda);
        while ((regPrenda.cod_prenda <> codObsoleta) and (not eof(arch1))) do
              read(arch1,regPrenda);
        if (not eof(arch1)) then begin
              regPrenda.stock := regPrenda.stock *(-1);
              seek(arch1,filepos(arch1)-1);
              write(arch1,regPrenda);
        end;

   end;
   procedure actualizarPrendasDisponibles(var arch1:prendas; var arch2:prendas_obsoletas);
   var
      codObsoleta:integer;

   begin
        reset(arch1);
        reset(arch2);
        read(arch2,codObsoleta);
        bajaPrendaObsoleta(arch1,codObsoleta);
        while not eof(arch2) do begin
              read(arch2,codObsoleta);
              bajaPrendaObsoleta(arch1,codObsoleta);
        end;
        close(arch1);
        close(arch2);
   end;

   procedure compactarPrendas(var arch1:prendas);
   var
      regPrenda,regAux:prenda;
      posBorrado, posAux:integer;
   begin
      posBorrado:= filesize(arch1)-1;
      read(arch1,regPrenda);
      while ((not eof(arch1)) and (filepos(arch1) < posBorrado)) do  begin
            if (regPrenda.stock < 0 ) then begin
               posAux:= filepos(arch1)-1;
               seek(arch1,posBorrado);
               read(arch1,regAux);
               posBorrado:= posBorrado -1;
               while (regAux.stock < 0) do begin
                     seek(arch1,posBorrado);
                     read(arch1,regAux);
                     posBorrado:= posBorrado -1;
               end;
               seek(arch1,posAux);
               write(arch1,regAux);
            end;
            read(arch1,regPrenda);
      end;
      seek(arch1, posBorrado+1);
      truncate(arch1);
      close(arch1);

   end;


begin
   assign(arch1,'prendasDisponibles');
   assign(arch2,'prendasDeBaja');
   actualizarPrendasDisponibles(arch1,arch2);
   compactarPrendas(arch1);

end.
