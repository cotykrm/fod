{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log}

program ejercicio5;
const
  valorAlto = 9999;
  df = 5;
type
  f = record
    dia:integer;
    mes:integer;
    ano:integer;
  end;
  logs = record
    codigo:integer;
    fecha:f;
    tiempo_sesion:real;
  end;
  
  logsT = record
    codigo:integer;
    fecha:f;
    tiempo_total:real;
  end;
  
  maestro = file of logsT;
  detalle = file of logs;
  
  detalles = array [1..df] of detalle;
  registros = array [1..df] of logs;
  
procedure leerSesion(var l:logs);
begin
  writeln('ingrese código: '); readln(l.codigo);
  if(l.codigo<>-1)then begin
    writeln('ingrese dia: '); readln(l.fecha.dia);
    writeln('ingrese mes: '); readln(l.fecha.mes);
    writeln('ingrese año: '); readln(l.fecha.ano);
    writeln('ingrese tiempo de la sesión: '); readln(l.tiempo_sesion);
  end;
end;

procedure crearDetalle(var d:detalle);
var
  l:logs;
begin
  rewrite(d);
  leerSesion(l);
  while(l.codigo<>-1)do begin
    write(d,l);
    leerSesion(l);
  end;
  close(d);
end;

procedure crearDetalles(var ar:detalles);
var
  i:integer;
begin
  for i:=1 to df do begin
    writeln('crear detalle nro ',i);
    writeln('-------------------------');
    crearDetalle(ar[i]);
    writeln('-------------------------');
  end;
end;

procedure imprimirSesion(l:logs);
begin
  writeln('codigo: ',l.codigo);
  writeln('dia: ',l.fecha.dia);
  writeln('mes: ',l.fecha.mes);
  writeln('año: ',l.fecha.ano);
  writeln('tiempo de la sesión: ',l.tiempo_sesion);
end;

procedure imprimirDet(var ar:detalle);
var
  l:logs;
begin
  reset(ar);
  while(not eof(ar)) do begin
    read(ar,l);
    imprimirSesion(l);
  end;
  close(ar);
end;

procedure imprimirDetalles(d:detalles);
var
  i:integer;
begin
  for i:=1 to df do begin
    writeln('detalle nro ',i);
    writeln('-------------------------');
    imprimirDet(d[i]);
    writeln('-------------------------');
  end;
end;

procedure imprimirRegM(l:logsT);
begin
  writeln('codigo: ',l.codigo);
  writeln('dia: ',l.fecha.dia);
  writeln('mes: ',l.fecha.mes);
  writeln('año: ',l.fecha.ano);
  writeln('tiempo de la sesión: ',l.tiempo_total);
end;

procedure imprimirMaestro(var m:maestro);
var
  l:logsT;
begin
  reset(m);
  while(not eof(m))do begin
    read(m,l);
    imprimirRegM(l);
  end;
  close(m);
end;

procedure leer(var ar:detalle; var l:logs);
begin
  if(not eof(ar))then
    read(ar,l)
  else
    l.codigo:= valorAlto;
end;

procedure leerDetalles(d:detalles; var r:registros);
var
  i:integer;
begin
  for i:=1 to df do
    leer(d[i],r[i]);
end;

procedure minimo(d:detalles; var min:logs; var r:registros);
var
  minC,i,minI:integer; 
begin
  minC:=9999;
  for i:=1 to df do begin
    if(r[i].codigo<minC)then begin
      minC:=r[i].codigo;
      minI:=i;
    end;
  end;
  if minC<>valorAlto then begin
    min:=r[minI];
    leer(d[minI],r[minI]);
  end
  else
    min.codigo:= valorAlto;
end;

procedure merge(var m:maestro; d:detalles);
var
  i:integer; min:logs; aux:logsT; r:registros; total:real;
begin
  rewrite(m);
  for i:= 1 to df do
    reset(d[i]);
  leerDetalles(d,r);
  minimo(d,min,r);
  while(min.codigo <> valorAlto)do begin
    aux.codigo:=min.codigo;
    aux.fecha:= min.fecha;
    total:=0;
    while(min.codigo = aux.codigo) do begin
      total:= total + min.tiempo_sesion;
      minimo(d,min,r);
    end;
    aux.tiempo_total:=total;
    write(m,aux);
  end;
  for i:= 1 to df do
    close(d[i]);
  close(m);
end;

var
  m:maestro; d:detalles;
begin
  assign(m,'maestro5.dat');
  assign(d[1],'det1.dat');
  assign(d[2],'det2.dat');
  assign(d[3],'det3.dat');
  assign(d[4],'det4.dat');
  assign(d[5],'det5.dat');
  //crearDetalles(d);
  writeln('detalles: ');
  writeln('----------------------');
  imprimirDetalles(d);
  merge(m,d);
  writeln('maestro: ');
  writeln('----------------------');
  imprimirMaestro(m);
end.