{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
NOTA: La información está ordenada por código de provincia y código de localidad
informar:
  codigoprov
  codigoLoc
  total votos loc
  total votos prov
  ...
  total de votos general
  }

program ejercicio10;
const 
  valorAlto = 9999;
type 
  mesa = record
    codigoP:integer;
    codigoL:integer;
    nroM:integer;
    votos:integer;
  end;
  maestro = file of mesa;

procedure leerMesa(var m:mesa);
begin 
  writeln('ingrese código de provincia: '); readln(m.codigoP);
  if(m.codigoP<>-1)then begin
    writeln('ingrese código de localidad: '); readln(m.codigoL);
    writeln('ingrese número de mesa: '); readln(m.nroM);
    writeln('ingrese votos: '); readln(m.votos);
  end;
end;

procedure crearArchivo(var ar:maestro);
var 
  m:mesa;
begin
  rewrite(ar);
  leerMesa(m);
  while(m.codigoP<>-1)do begin
    write(ar,m);
    leerMesa(m);
  end;
  close(ar);
end;

procedure leer(var ar:maestro; var m:mesa);
begin
  if(not eof(ar))then
    read(ar,m)
  else
    m.codigoP:= valorAlto;
end;

procedure corteControl(var ar:maestro);
var
  m:mesa; totalL,totalP,totalG,codP,codL:integer;
begin
  reset(ar);
  leer(ar,m);
  totalG:=0;
  while(m.codigoP<>valorAlto)do begin
    totalP:=0;
    codP:=m.codigoP;
    writeln('cod provincia: ',codP);
    while(m.codigoP = codP)do begin
      codL:=m.codigoL;
      writeln('cod localidad: ',codL);
      totalL:=0;
      while(m.codigoP = codP)and(m.codigoL = codL)do begin
        totalL:=totalL + m.votos;
        leer(ar,m);
      end;
      writeln('total votos localidad: ',totalL);
      totalP:= totalP+totalL;
    end;
    writeln('total votos provincia: ',totalP);
    totalG:=totalG+totalP;
  end;
  writeln('total votos: ',totalG); 
  close(ar);
end;

var
  m:maestro;
begin
  assign(m,'maestroVotos.dat');
  crearArchivo(m);
  corteControl(m);
end.
