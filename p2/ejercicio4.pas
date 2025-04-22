{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto}

program ejercicio4;
const
  valorAlto = 9999;
  det = 3;
type
  producto = record
    codigo:integer;
    nombre:string;
    descripcion:string;
    stockD:integer;
    stockM:integer;
    precio:real;
  end;
  
  venta = record
    codigo:integer;
    cv:integer;
  end;
  
  maestro = file of producto;
  detalle = file of venta;
  detalles = array [1..det] of detalle;
  ventas = array [1..det] of venta;
  
procedure leerProducto(var p:producto);
begin
  writeln('Ingrese código del producto: '); readln(p.codigo);
  if(p.codigo<>-1)then begin
    writeln('Ingrese nombre: '); readln(p.nombre);  
    writeln('Ingrese descripción: '); readln(p.descripcion);
    writeln('Ingrese stock disponible: '); readln(p.stockD);
    writeln('Ingrese stock mínimo: '); readln(p.stockM);
    writeln('Ingrese precio: '); readln(p.precio);
  end;
end;

procedure leerVenta(var v:venta);
begin
  writeln('Ingrese código del producto: '); readln(v.codigo);
  if(v.codigo<>-1)then begin
    writeln('Ingrese cantidad vendida: '); readln(v.cv);  
  end;
end;
procedure crearArchivoM(var ar:maestro);
var
  p:producto;
begin
  rewrite(ar);
  leerProducto(p);
  while(p.codigo<>-1)do begin
    write(ar,p);
    leerProducto(p);
  end;
  close(ar);
end;

procedure crearArchivoD(var ar:detalle);
var
  v:venta;
begin
  rewrite(ar);
  leerVenta(v);
  while(v.codigo<>-1)do begin
    write(ar,v);
    leerVenta(v);
  end;
  close(ar);
end;

procedure armarDetalles(var d:detalles);
var
  i:integer;
begin
  for i:= 1 to det do
    crearArchivoD(d[i]);
end;

procedure imprimirVenta(v:venta);
begin
  writeln('codigo: ',v.codigo);
  writeln('cantidad vendida: ',v.cv);
end;

procedure imprimirDet(var ar:detalle);
var
  v:venta;
begin
  reset(ar);
  while(not eof(ar)) do begin
    read(ar,v);
    imprimirVenta(v);
  end;
  close(ar);
end;

procedure imprimirDetalles(d:detalles);
var
  i:integer;
begin
  for i:=1 to det do begin
    writeln('detalle nro ',i);
    writeln('-------------------------');
    imprimirDet(d[i]);
    writeln('-------------------------');
  end;
end;

procedure imprimirProducto(p:producto);
begin
  writeln('código: ',p.codigo);
  writeln('nombre: ',p.nombre);
  writeln('descripción: ',p.descripcion); 
  writeln('stock disponible: ',p.stockD); 
  writeln('stock mínimo: ',p.stockM); 
  writeln('precio: ',p.precio);
end;

procedure imprimirMaestro(var m:maestro);
var
  p:producto;
begin
  reset(m);
  while(not eof(m))do begin
    read(m,p);
    imprimirProducto(p);
  end;
  close(m);
end;

procedure leer(var ar:detalle; var v:venta);
begin
  if(not eof(ar))then
    read(ar,v)
  else
    v.codigo:= valorAlto;
end;

procedure minimo(d:detalles; var min:venta; var rd:ventas);
var
  minC,i,minI:integer; 
begin
  minC:=valorAlto;
  for i:=1 to det do begin
    if(rd[i].codigo<minC)then begin
      minC:=rd[i].codigo;
      minI:= i;
    end;
  end;
  if minC<>valorAlto then begin
    min:=rd[minI];
    leer(d[minI],rd[minI]);
  end
  else
    min.codigo:= valorAlto;
end;

procedure leerDetalles(d:detalles; var rd:ventas);
var
  i:integer;
begin
  for i:=1 to det do
    leer(d[i],rd[i]);
end;

procedure actualizar(var m:maestro; d:detalles);
var 
  i:integer; min:venta; p:producto; rd:ventas;
begin
  reset(m);
  for i:=1 to det do 
    reset(d[i]);
  leerDetalles(d,rd); 
  minimo(d,min,rd);
  while(min.codigo<>valorAlto)do begin
    read(m,p);
    while(min.codigo<>p.codigo)do
      read(m,p);
    while(min.codigo = p.codigo)do begin
      p.stockD:= p.stockD - min.cv;
      minimo(d,min,rd);
    end;
    seek(m,filePos(m)-1);
    write(m,p);
  end;
  close(m);
  for i:=1 to det do
    close(d[i]);
end;

{ Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.}

procedure crearInforme(var m:maestro; var informe:text);
var
  p:producto;
begin
  reset(m);
  rewrite(informe);
  while(not eof(m))do begin
    read(m,p);
    if(p.stockD<p.stockM)then begin
      writeln(informe,p.nombre);
      writeln(informe,p.stockD, p.precio,p.descripcion);
    end;
  end;
  close(m);
  close(informe);
end;

var
  m:maestro; d:detalles; informe:text;
begin
  assign(m,'maestro4.dat');
  assign(informe,'informe.txt');
  {for i:=1 to det do begin
    assign(d[i],'detalle.dat');
    crearArchivoD(d[i]);
  end;}
  writeln('crear detalle 1');
  assign(d[1],'detalle1.dat');
  crearArchivoD(d[1]);
  writeln('crear detalle 2');
  assign(d[2],'detalle2.dat');
  crearArchivoD(d[2]);
  writeln('crear detalle 3');
  assign(d[3],'detalle3.dat');
  crearArchivoD(d[3]);
  writeln('crear maestro');
  crearArchivoM(m);
  writeln('-------------------------');
  writeln('detalles: ');
  imprimirDetalles(d);
  writeln('-------------------------');
  actualizar(m,d);
  writeln('-------------------------');
  writeln('maestro: ');
  writeln('-------------------------');
  imprimirMaestro(m);
  crearInforme(m,informe);
end.