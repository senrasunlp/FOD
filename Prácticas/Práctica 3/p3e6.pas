program p3e6;

uses crt;

type
    prenda = record
        cod_prenda:integer;
        descripcion:string[100];
        colores:string[100];
        tipo_prenda:string[50];
        stock:integer;
        precio_unitario:real;
    end;

    prendas = file of prenda;

    prenda_obsoleta = record
        cod_prenda:integer;
    end;

    prendas_obsoletas = file of prenda_obsoleta;

    procedure cargarMae(var mae:prendas);
    var
        reg:prenda;
        contCod:integer;
        fin:boolean;
    begin
        contCod:=1;
        fin:=false;
        rewrite(mae);
        reg.cod_prenda:= -3;
        while (not fin) do begin
            writeln('----NUEVA PRENDA----');
            writeln();
            writeln('Ingresar descripcion:');
            readln(reg.descripcion);
            if (reg.descripcion <> '') then begin
                writeln();
                writeln('Ingresar colores:');
                readln(reg.colores);
                writeln();
                writeln('Ingresar precio: ');
                readln(reg.precio_unitario);
                reg.tipo_prenda:='de verano';
                reg.stock:=50;
                reg.cod_prenda := contCod;
                contCod := contCod +1;
                write(mae,reg);
            end
                else fin := true;
            clrscr;
        end;
        close(mae);
    end;

    procedure cargarDet(var det:prendas_obsoletas);
    var
        reg:prenda_obsoleta;
    begin
        rewrite(det);
        reg.cod_prenda:= -3;
        while (reg.cod_prenda <> 0) do begin
            writeln('Ingresar codigo de prenda obsoleta (0 = FIN):');
            readln(reg.cod_prenda);
            write(det,reg);
            clrscr;
        end;
        close(det);
    end;
    procedure actualizarPrendas(var mae:prendas; var det:prendas_obsoletas);
    var
        regd:prenda_obsoleta;
        regm:prenda;
    begin
        reset(mae);
        reset(det);
        while (not eof(det)) do begin
            read(det,regd);
            read(mae,regm);
            while ((regd.cod_prenda <> regm.cod_prenda) and not eof(mae)) do
                read(mae,regm);
            if (regd.cod_prenda = regm.cod_prenda) then begin
                regm.stock := regm.stock*(-1);
                seek(mae,filepos(mae)-1);
                write(mae,regm);
            end;
            seek(mae,0);
        end;
        close(mae);
        close(det);
    end;

    procedure compactarMae(var mae:prendas);
    var
        regm:prenda;
        nuevoMae:prendas;
    begin
        assign(nuevoMae,'maePrendasCompactoP3E6');
        rewrite(nuevoMae);
        reset(mae);
        while (not eof(mae)) do begin
            read(mae,regm);
            if (regm.stock >= 0) then
                write(nuevoMae,regm);
        end;
        close(mae);
        close(nuevoMae);
        assign(mae,'maePrendasCompactoP3E6');
    end;

    procedure listarPrendas();
    var
        arch:prendas;
        reg:prenda;
    begin
        assign(arch,'maePrendasCompactoP3E6');
        reset(arch);
        while (not eof(arch)) do begin
            read(arch,reg);
            with reg do writeln(cod_prenda,' ',descripcion,' ',colores,' ',tipo_prenda,' ',stock,' ',precio_unitario:0:2);
        end;
        readln();
    end;
var
    mae:prendas;
    det:prendas_obsoletas;

begin
    assign(mae,'maePrendasP3E6');
    assign(det,'detPrendasObsoletasP3E6');
    cargarMae(mae);
    cargarDet(det);
    actualizarPrendas(mae,det);
    compactarMae(mae);
    listarPrendas();

end.
