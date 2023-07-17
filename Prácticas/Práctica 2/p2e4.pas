program p2e4;

const

     valoralto = 9999;

type
    fech = record
         dia:integer;
         mes:integer;
         ano:integer;
    end;

    sesion = record
           cod_usuario:integer;
           fecha:fech;
           tiempo_sesion:integer;
    end;

    sesionTotal = record
           cod_usuario:integer;
           fecha:fech;
           tiempo_total_de_sesiones_abiertas:integer;
    end;

    archDet = file of sesion;
    archMae = file of sesionTotal;

    logs = array [1..5] of archDet;
    sesiones = array [1..5] of sesion;

    {Suponga que trabaja en un oficina donde está montada una LAN (red local). La misma fue
    construida sobre una topología de red que conecta 5 máquinas entre sí y todas las máquinas
    se conectan con un servidor central. Semanalmente cada máquina genera un archivo de logs
    informando las sesiones abiertas por cada usuario en cada terminal y por cuánto tiempo estuvo
    abierta.
    Cada archivo detalle contiene los siguientes campos: cod_usuario, fecha,
    tiempo_sesion.
    Debe realizar un procedimiento que reciba los archivos detalle y genere un
    archivo maestro con los siguientes datos: cod_usuario, fecha,
    tiempo_total_de_sesiones_abiertas.
    Notas :
    - Cada archivo detalle está ordenado por cod_usuario y fecha.
    - Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
    máquinas.
    - El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}
var
   mae:archMae;
   detalles:logs;

   procedure leer(var archivo:archDet; var dato:sesion);
   begin
        if (not eof(archivo)) then
           read(archivo,dato)
        else
            dato.cod_usuario:= valoralto;
   end;

   procedure minimo (var min:sesion; var arrayRegd:sesiones; var detalles:logs);
   begin
        if ((arrayRegd[1].cod_usuario <= arrayRegd[2].cod_usuario) and (arrayRegd[1].cod_usuario <= arrayRegd[3].cod_usuario) and (arrayRegd[1].cod_usuario <= arrayRegd[4].cod_usuario) and (arrayRegd[1].cod_usuario <= arrayRegd[5].cod_usuario)) then begin
           min:= arrayRegd[1];
           leer(detalles[1],arrayRegd[1])
         end
            else if ((arrayRegd[2].cod_usuario <= arrayRegd[3].cod_usuario) and (arrayRegd[2].cod_usuario <= arrayRegd[4].cod_usuario) and (arrayRegd[2].cod_usuario <= arrayRegd[5].cod_usuario)) then begin
               min:= arrayRegd[2];
               leer(detalles[2],arrayRegd[2])
            end
               else if ((arrayRegd[3].cod_usuario <= arrayRegd[4].cod_usuario) and (arrayRegd[3].cod_usuario <= arrayRegd[5].cod_usuario)) then begin
                  min:= arrayRegd[3];
                  leer(detalles[3],arrayRegd[3])
               end
                  else if ((arrayRegd[4].cod_usuario <= arrayRegd[5].cod_usuario)) then begin
                     min:= arrayRegd[4];
                     leer(detalles[4],arrayRegd[4])
                  end
                     else begin
                        min:= arrayRegd[5];
                        leer(detalles[5],arrayRegd[5]);
                     end;
   end;

   procedure generarMaestro (var mae:archMae; var detalles:logs);
   var
      arrayRegd:sesiones;
      min:sesion;
      aux:sesionTotal;
   begin
        reset(detalles[1]);
        reset(detalles[2]);
        reset(detalles[3]);
        reset(detalles[4]);
        reset(detalles[5]);
        rewrite(mae);
        leer(detalles[1],arrayRegd[1]);
        leer(detalles[2],arrayRegd[2]);
        leer(detalles[3],arrayRegd[3]);
        leer(detalles[4],arrayRegd[4]);
        leer(detalles[5],arrayRegd[5]);
        minimo(min,arrayRegd,detalles);
        while (min.cod_usuario <> valoralto) do begin
              aux.cod_usuario := min.cod_usuario;
              aux.tiempo_total_de_sesiones_abiertas:= 0;
              aux.fecha:= min.fecha;
              while ((aux.cod_usuario=min.cod_usuario) and (aux.fecha.dia = min.fecha.dia) and (aux.fecha.mes = min.fecha.mes)) do begin
                    aux.tiempo_total_de_sesiones_abiertas:= aux.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
                    minimo(min,arrayRegd,detalles);
              end;
              write(mae,aux);
        end;
        close(mae);
        close(detalles[1]);
        close(detalles[2]);
        close(detalles[3]);
        close(detalles[4]);
        close(detalles[5]);
   end;

begin
   assign(mae,'/var/log/archMaeLogsP2E4');
   assign(detalles[1],'/var/log/archDet1LogsP2E4');
   assign(detalles[2],'/var/log/archDet1LogsP2E4');
   assign(detalles[3],'/var/log/archDet1LogsP2E4');
   assign(detalles[4],'/var/log/archDet1LogsP2E4');
   assign(detalles[5],'/var/log/archDet1LogsP2E4');
   generarMaestro(mae,detalles);

end.
