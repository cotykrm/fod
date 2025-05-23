{Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}

program ejercicio14;
const
  valorAlto = 'zzz';
type
  f = record
    dia:integer;
    mes:integer;
    ano:integer;
  end;
  v = record
    destino:string;
    fecha:f;
    hora:integer;
  end;
  vueloM = record
    vuelo:v;
    asientosD:integer;
  end;
  vueloD = record
    vuelo:v;
    asientosC:integer;
  end;

  lista = ^nodo;
  nodo = record
    dato:v;
    sig:lista;
  end;

  detalle = file of vueloD;
  maestro = file of vueloM;

procedure agregarNodo(var l:lista; vue:v);
var  
  nue:lista;
begin
  new(nue);
  nue^.dato:=vue;
  nue^.sig:=l;
  l:=nue;
end;

procedure leerFecha(var fe:f);
begin
  writeln('ingrese dia: '); readln(fe.dia);
  writeln('ingrese mes: '); readln(fe.mes);
  writeln('ingrese año: '); readln(fe.ano);
end; 

procedure leerVuelo(var vu:v);
begin
  writeln('ingrese el destino: '); readln(vu.destino);
  if(vu.destino<>'fin')then begin
    leerFecha(vu.fecha);
    writeln('ingrese hora: '); readln(vu.hora);
  end;
end;

procedure leerVueloM(var v:vueloM);
begin
  leerVuelo(v.vuelo);
  if(v.vuelo.destino<>'fin')then begin
    writeln('ingrese asientos disponibles: '); readln(v.asientosD);
  end;
end;

procedure leerVueloD(var v:vueloD);
begin
  leerVuelo(v.vuelo);
  if(v.vuelo.destino<>'fin')then begin
    writeln('ingrese asientos comprados: '); readln(v.asientosC);
  end;
end;

procedure crearArchivoM(var m:maestro);
var
  v:vueloM;
begin
  rewrite(m);
  leerVueloM(v);
  while(v.vuelo.destino<>'fin') do begin
    write(m,v);
    leerVueloM(v);
  end;
  close(m);
end;

procedure crearArchivoD(var d:detalle);
var
  v:vueloD;
begin
  rewrite(d);
  leerVueloD(v);
  while(v.vuelo.destino<>'fin') do begin
    write(d,v);
    leerVueloD(v);
  end;
  close(d);
end;

procedure leer(var ar:detalle; var d:vueloD);
begin
  if(not eof(ar))then
    read(ar,d)
  else
    d.vuelo.destino:=valorAlto;
end;

procedure minimo(var d1,d2:detalle; var r1,r2,min:vueloD);
begin
  if(r1.vuelo.destino<=r2.vuelo.destino)then begin
    min:=r1;
    leer(d1,r1);
  end
  else begin
    min:=r2;
    leer(d2,r2);
  end;
end;

function compararFechas(f1,f2:f):boolean;
begin
    if(f1.dia=f2.dia)and(f1.mes=f2.mes)and(f1.ano=f2.ano)then
      compararFechas:= true
    else
      compararFechas:= false;
end;

procedure procesar(var m:maestro; var d1,d2:detalle; var l:lista; numAsientos:integer);
var
  r1,r2,min:vueloD; rm:vueloM; fecha:f; hora:integer;
begin
  reset(m);
  reset(d1);
  reset(d2);
  leer(d1,r1);
  leer(d2,r2);
  minimo(d1,d2,r1,r2,min);
  while(min.vuelo.destino<>valorAlto)do begin
    read(m,rm);
    while(min.vuelo.destino<>rm.vuelo.destino) do
      read(m,rm);
    while(min.vuelo.destino = rm.vuelo.destino)do begin
      fecha:=rm.vuelo.fecha;
      hora:= rm.vuelo.hora;
      while((min.vuelo.destino = rm.vuelo.destino)and(compararFechas(min.vuelo.fecha,fecha))and(min.vuelo.hora = hora))do begin
        rm.asientosD:=rm.asientosD - min.asientosC;
        minimo(d1,d2,r1,r2,min);
      end;
      if(rm.asientosD<numAsientos)then
        agregarNodo(l,rm.vuelo);
      seek(m,filePos(m)-1);
      write(m,rm);
    end;
  end;
  close(m);
  close(d1);
  close(d2);
end;

procedure imprimirLista(l: lista);
begin
  while l <> nil do
  begin
    writeln('Destino: ', l^.dato.destino);
    writeln('Fecha: ', l^.dato.fecha.dia, '/', l^.dato.fecha.mes, '/', l^.dato.fecha.ano);
    writeln('Hora: ', l^.dato.hora);
    writeln('-------------------------');
    l := l^.sig;
  end;
end;

var
  d1,d2:detalle; m:maestro; l:lista; asientos:integer;
begin
  assign(m,'maestro14.dat');
  assign(d1,'detalle1_14.dat');
  assign(d2,'detalle2_14.dat');
  crearArchivoD(d1);
  crearArchivoD(d2);
  crearArchivoM(m);
  l:=nil;
  writeln('ingrese una cantidad de asientos disponibles esperados: ');
  readln(asientos);
  procesar(m,d1,d2,l,asientos);
  imprimirLista(l);
end.

    
    

