{Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program ejercicio2;
const 
  valorAlto = 9999;
type
  asistente = record
    nro:integer;
    aYn:string;
    email:string;
    telefono:integer;
    dni:integer;
  end;
  archivo = file of asistente;

procedure leerAsistente(var a:asistente);
begin
  writeln('ingrese nro de asistente: '); readln(a.nro);
  if(a.nro<>-1)then begin
    writeln('ingrese apellido y nombre de asistente: '); readln(a.aYn);
    writeln('ingrese email de asistente: '); readln(a.email);
    writeln('ingrese telefono de asistente: '); readln(a.telefono);
    writeln('ingrese dni de asistente: '); readln(a.dni);
  end;
end;

procedure crearArchivo(var ar:archivo);
var
  a:asistente;
begin
  rewrite(ar);
  leerAsistente(a);
  while(a.nro<>-1)do begin
    write(ar,a);
    leerAsistente(a);
  end;
  close(ar);
end;

procedure imprimirAsistente(a:asistente);
begin
  writeln('nro de asistente: ',a.nro);
  writeln('apellido y nombre de asistente: ',a.aYn);
  writeln('email de asistente: ',a.email);
  writeln('telefono de asistente: ',a.telefono);
  writeln('dni de asistente: ',a.dni);
end;

procedure imprimirArchivo(var ar:archivo);
var 
  a:asistente;
begin
  reset(ar);
  while(not eof(ar)) do begin 
    read(ar,a);
    imprimirAsistente(a);
  end;
  close(ar);
end;

procedure leer(var ar:archivo; var a:asistente);
begin
  if(not eof(ar))then
    read(ar,a)
  else
    a.nro := valorAlto;
end;

procedure bajar(var ar:archivo);
var 
  a:asistente;
begin
  reset(ar);
  leer(ar,a);
  while(a.nro<>valorAlto)do begin
    if(a.nro<1000)then begin
      a.aYn := '@' + a.aYn;
      seek(ar,filePos(ar)-1);
      write(ar,a);
    end;
    leer(ar,a);
  end;
  close(ar);
end;

var
  ar:archivo;
begin
  assign(ar,'bajas1.dat');
  //crearArchivo(ar);
  writeln('-------------------------');
  writeln('impimir archivo sin bajas');
  writeln('-------------------------');
  imprimirArchivo(ar);
  bajar(ar);
  writeln('-------------------------');
  writeln('impimir archivo con bajas');
  writeln('-------------------------');
  imprimirArchivo(ar);
end.


