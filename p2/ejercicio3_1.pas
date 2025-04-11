{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ejercicio3;
const
  valorAlto = 'zzz';
type
  censos = record
    provincia:string;
    personasAlfa:integer;
    totalEnc:integer;
  end;
  
  censo = record
    provincia:string;
    codigoLoc:integer;
    personasAlfa:integer;
    cantEnc:integer;
  end;
  
  maestro = file of censos;
  detalle = file of censo;
  
procedure leerCenso(var c:censo);
begin
  writeln('ingrese nombre de la provincia: '); readln(c.provincia);
  if(c.provincia<>'fin') then begin
    writeln('ingrese código de localidad: '); readln(c.codigoLoc);
    writeln('ingrese cantidad de personas alfabetizadas: '); readln(c.personasAlfa);
    writeln('ingrese cantidad de personas encuestadas: '); readln(c.cantEnc);
  end;
end;

procedure leer(var ar:detalle; var c:censo);
begin
  if(not eof(ar))then
    read(ar,c)
  else
    c.provincia:=valorAlto;
end;

procedure leerCensos(var c:censos);
begin
  writeln('ingrese nombre de la provincia: '); readln(c.provincia);
  if(c.provincia<>'fin') then begin
    writeln('ingrese cantidad de personas alfabetizadas: '); readln(c.personasAlfa);
    writeln('ingrese total de personas encuestadas: '); readln(c.totalEnc);
  end;
end;

procedure crearArchivoM(var ar:maestro);
var
  c:censos;
begin
  rewrite(ar);
  leerCensos(c);
  while(c.provincia<>'fin')do begin
    write(ar,c);
    leerCensos(c);
  end;
  close(ar);
end;

procedure crearArchivoD(var ar:detalle);
var
  c:censo;
begin
  rewrite(ar);
  leerCenso(c);
  while(c.provincia<>'fin')do begin
    write(ar,c);
    leerCenso(c);
  end;
  close(ar);
end;

procedure minimo(var d1,d2:detalle; var r1,r2,min:censo);
begin
  if(r1.provincia<=r2.provincia)then begin
    min:= r1;
    leer(d1,r1);
  end
  else begin
    min:=r2;
    leer(d2,r2);
  end;
end;

procedure actualizar(var arD1,arD2:detalle; var arM:maestro);
var
  d1,d2,min:censo; m1:censos;
begin
  reset(arD1);
  reset(arD2);
  reset(arM);
  leer(arD1,d1);
  leer(arD2,d2);
  minimo(arD1,arD2,d1,d2,min);
  while(min.provincia<>valorAlto)do begin
    read(arM,m1);
    while(min.provincia <> m1.provincia)do 
      read(arM,m1);
    while(min.provincia = m1.provincia)do begin
      m1.personasAlfa:=m1.personasAlfa + min.personasAlfa;
      m1.totalEnc:= m1.totalEnc + min.cantEnc;
      minimo(arD1,arD2,d1,d2,min);
    end;
    seek(arM,filePos(arM)-1);
    write(arM,m1);
  end;
  close(arD1);
  close(arD2);
  close(arM);
end;

procedure imprimirCenso(c:censo);
begin
  writeln('provincia: ',c.provincia);
  writeln('codigo localidad: ',c.codigoLoc);
  writeln('personas alfabetizadas: ',c.personasAlfa);
  writeln('cantidad de encuestados: ',c.cantEnc);
end;

procedure imprimirCensos(c:censos);
begin
  writeln('provincia: ',c.provincia);
  writeln('personas alfabetizadas: ',c.personasAlfa);
  writeln('total de encuestados: ',c.totalEnc);
end;
 
procedure imprimirDet(var ar:detalle);
var
  c:censo;
begin
  reset(ar);
  while(not eof(ar))do begin
    read(ar,c);
    imprimirCenso(c);
  end;
  close(ar);
end;

procedure imprimirMae(var ar:maestro);
var
  c:censos;
begin
  reset(ar);
  while(not eof(ar))do begin
    read(ar,c);
    imprimirCensos(c);
  end;
  close(ar);
end;

var
  arD1,arD2:detalle; arM:maestro;
begin
  assign(arM,'maestro.dat');
  assign(arD1,'detalle1.dat');
  assign(arD2,'detalle2.dat');
  writeln('creando detalle 1');
  writeln('---------------------');
  crearArchivoD(arD1);
  writeln('---------------------');
  writeln('creando detalle 2');
  writeln('---------------------');
  crearArchivoD(arD2);
  writeln('---------------------');
  writeln('creando maestro');
  writeln('---------------------');
  crearArchivoM(arM);
  writeln('---------------------');
  actualizar(arD1,arD2,arM);
  writeln('imprimiendo detalle 1');
  writeln('---------------------');
  imprimirDet(arD1);
  writeln('---------------------');
  writeln('imprimiendo detalle 2');
  writeln('---------------------');
  imprimirDet(arD2);
  writeln('---------------------');
  writeln('imprimiendo maestro');
  writeln('---------------------');
  imprimirMae(arM);
  writeln('---------------------');
end.
