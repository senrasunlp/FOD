program p4e3;

const M = 4;

TYPE

    medico = record
           dni:integer;
           legajo:integer;
           apellidoyNombre:String[100];
    end;



    medicoDni = record
           dni:integer;
           NRR:integer;
    end;

    medicoLegajo = record
           legajo:integer;
           clavePrincipal:integer;
    end;

    mediconombreyApellido = record
           nombreyApellido:string[100];
           clavePrincipal:integer;
    end;

    nodoPrincipal = record
           cant_elementos:integer;
           claves: array [1..M-1] of MedicoDni;
           hijos: array [1..M] of integer;
           nodo_sig:^nodoPrincipal;
    end;

    nodoLegajo = record
           cant_elementos:integer;
           claves: array [1..M-1] of MedicoLegajo;
           hijos: array [1..M] of integer;
           nodo_sig:^nodoLegajo;
    end;

    nodoNombreyApellido = record
           cant_elementos:integer;
           claves: array [1..M-1] of mediconombreyApellido;
           hijos: array [1..M] of integer;
           nodo_sig:^nodoNombreyApellido;
    end;

    archivo = file of medico;
    indicePrincipal_Dni = file of nodoPrincipal;
    indiceSecundario_Legajo = file of nodoLegajo;                    //Podria usar el legajo como clave principal también y hacer un índice principal.
    indiceSecundario_NombreyApellido = file of nodoNombreyApellido;  //Los indices secundarios tienen en su registro una referencia al elemento del indice principal, el cual tiene la dirección fisica efectiva del elemento en el archivo de datos.

begin
end.
