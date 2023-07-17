program parcial20161ra;
const
     sc = '&';
     sr = '$';

type
    cliente = record
            telefono:integer;
            nombre:string;
            apellido:string;
            domicilio:string;

    end;

    archivo = file of cliente;

var
arch:archivo;
reg:cliente;
tel:integer;

procedure escribirReg(var arch:archivo; var cli:cliente);
var
   aux:string;
begin
     str(cli.telefono,aux);
     Blockwrite(arch,aux,length(aux));
     Blockwrite(arch,sc,length(sc));
     Blockwrite(arch,cli.nombre[1],length(cli.nombre));
     Blockwrite(arch,sc,length(sc));
     Blockwrite(arch,cli.apellido[1],length(cli.apellido));
     Blockwrite(arch,sc,length(sc));
     Blockwrite(arch,cli.domicilio[1],length(cli.domicilio));
     Blockwrite(arch,sr,length(sr));
end;

procedure crearArchivo(var arch:archivo);
var
   cli:cliente;
begin
     writeln('Ingrese telefono: ');
     readln(cli.telefono);
     while (cli.telefono <> 0) do begin
           writeln('Ingrese nombre: ');
           readln(cli.nombre);
           writeln('Ingrese apellido: ');
           readln(cli.apellido);
           writeln('Ingrese domicilio: ');
           readln(cli.domicilio);
           writeln('Ingrese telefono: ');
           readln(cli.telefono);
           escribirReg(arch,cli);
    end;
end;

procedure encontrarCliente(arch,tel);
var
    car:char;
    encontrado:boolean;
begin
    reset(arch,1);
    writeln('REGISTRO...........................');
    encontrado:=false;
    while(car <> sr)and(not eof(archivo)) and (encontrado = false) do begin
		campo:=' ';
		blockread(archivo,car,1);
		while(car<>sc)and(car<>sr)and(not eof(archivo))do begin
			campo:=campo+car;
			blockread(archivo,car,1);
		end;
		if (car=sr) and (not eof(archivo)) then //hago una lectura de mas para leer el separador
		begin
			writeln('REGISTRO...........................');			
			blockread(archivo,car,1);
			seek(archivo,filepos(archivo)-1);//esto lo hago para no perder un caracter
		end
		else
		begin		
			writeln(campo);
			readln;
		end;
	end;


    end;
begin
    assign(arch,'archparcial20161ra');
    crearArchivo(arch);
    writeln('Ingrese el numero de telefono del cliente que desea buscar: ');
    readln(tel);
    encontrarCliente(arch,tel);

end.
