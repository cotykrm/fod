{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad                 Total de Votos
................................    ......................
................................    ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.}

program ejercicio2;
const 
  valorAlto = 9999;
type
  mesa = record
    codigo:integer;
    nro:integer;
    votos:integer;
  end;

  auxiliar = file of mesa;
  archivo = file of mesa;

procedure leerMesa(var m:mesa);
begin
  writeln('ingrese codigo de localidad de la mesa'); readln(m.codigo);
  if(m.codigo<>-1)then begin
   writeln('ingrese nro de la mesa'); readln(m.nro);
   writeln('ingrese cantidad de votos de la mesa'); readln(m.votos);
  end;
end;

procedure crearArchivo(var ar:archivo);
var
  m:mesa;
begin
  rewrite(ar);
  leerMesa(m);
  while(m.codigo<>-1)do begin
    write(ar,m);
    leerMesa(m);
  end;
  close(ar);
end;

procedure agregarMesaAux(var ar:auxiliar; m:mesa);
var
  esta:boolean;
begin
  reset(ar);
  while(not eof(ar))do begin
    
  end;


    
  
