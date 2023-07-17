program p2e11;

const
    valoralto = 9999;

type

    log = record
        nro_usuario:integer;
        nombreUsuario:string[30];
        nombre:string[30];
        apellido:string[30];
        cantidadMailEnviados:integer;
    end;

    mail = record
        nro_usuario:integer;
        cuentaDestino:integer;
        cuerpoMensaje:string[200];
    end;

    logs = file of log;
    mails = file of mail;

var
    mae:logs;
    det:mails;

    procedure leer (var arch:mails;var dato:mail);
    begin
        if not eof(arch) then
            read(arch,dato)
        else
            dato.nro_usuario := valoralto;
    end;

    procedure actualizarMaestro (var mae:logs;var det:mails);
    var
        regd:mail;
        regm:log;
        cantMailsDelDia:integer;
        exportarDet:Text;
    begin
        assign(exportarDet,'/var/log/mailsDelDia.txt');
        rewrite(exportarDet);
        reset(mae);
        reset(det);
        leer(det,regd);
        while (not eof(mae)) do begin
            read(mae,regm);
            if (regm.nro_usuario = regd.nro_usuario) then begin
                cantMailsDelDia := 0;
                while ((regm.nro_usuario = regd.nro_usuario) and (regd.nro_usuario <> valoralto)) do begin
                    cantMailsDelDia := cantMailsDelDia + 1;
                    leer(det,regd);
                end;
                regm.cantidadMailEnviados := regm.cantidadMailEnviados + cantMailsDelDia;
                seek(mae,filepos(mae)-1);
                write(mae,regm);
            end;
            with regm do writeln('nro_usuario:',regm.nro_usuario,'     cantidadMensajesEnviados:',regm.cantidadMailEnviados);
        end;
        close(exportarDet);
        close(mae);
        close(det);
    end;

{
Suponga que usted es administrador de un servidor de correo electrónico.
En los logs del mismo (información guardada acerca de los movimientos que ocurren en el server) que se encuentra en la siguiente ruta:
/var/log/logmail.dat se guarda la siguiente información: nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados.

Diariamente el servidor de correo genera un archivo con la siguiente información: nro_usuario, cuentaDestino, cuerpoMensaje.
Este archivo representa todos los correos enviados por los usuarios en un día determinado.
Ambos archivos están ordenados por nro_usuario y se sabe que un usuario puede enviar cero, uno o más mails por día.

a- Realice el procedimiento necesario para actualizar la información del log en un día particular.
Defina las estructuras de datos que utilice su procedimiento.

b- Genere un archivo de texto que contenga el siguiente informe dado un archivo detalle de un día determinado:

nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados

Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que existen en el sistema.
}

begin
    assign(mae,'/var/log/logmail.dat');
    assign(det,'/var/log/mails.dat');
    actualizarMaestro(mae,det);
end.
