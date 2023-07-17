program p4e7;

const
     M = 5;

type

    logmail = record
            nro_usuario:integer;
            nombre_usuario:string[50];
            nombre:string[40];
            apellido:string[40];
            cant_mail_enviados:integer;
    end;

    logNro_usuario = record
            nro_usuario:integer;
            NRR:integer;
    end;

    nodoNro_usuario = record
            cant_elementos:integer;
            claves: array [1..M-1] of logNro_usuario; // El integer de las claves es el numero de usuario, ya que es la unica clave unívoca
            hijos: array [1..M] of integer;
    end;

    indice = file of nodoNro_usuario;
    logs = file of logmail;


begin

end.
