{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro
Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido}

program ejercicio2;
const
  valorAlto = 9999;
type
  producto = record
    codigo:integer;
    nombre:string;
    precio:real;
    stockA:integer;
    stockM:integer;
  end;
  
  venta = record
    codigo:integer;
    cv:integer;
  end;
  
  arM = file of producto;
  arD = file of venta;
  
procedure leerProducto(var p:producto);
begin
  writeln('Ingrese código: '); readln(p.codigo);
  if(p.codigo<>-1)then begin
    writeln('Ingrese nombre: '); readln(p.nombre);
    writeln('Ingrese precio: '); readln(p.precio);
    writeln('Ingrese stock actual: '); readln(p.stockA);
    writeln('Ingrese stock mínimo: '); readln(p.stockM);
  end;
end;

procedure leerVenta(var v:venta);
begin
  writeln('Ingrese código: '); readln(v.codigo);
  if(v.codigo<>-1)then begin
    writeln('Ingrese cantidades vendidas: '); readln(v.cv);
  end;
end;

procedure crearArchivoM(var ar:arM);
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

procedure crearArchivoD(var ar:arD);
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

procedure imprimirVenta(v:venta);
begin
  writeln('Código: ',v.codigo);
  writeln('Cantidad vendida: ',v.cv);
end;

procedure imprimirProducto(p:producto);
begin
  writeln('Código: ',p.codigo);
  writeln('Nombre: ',p.nombre);
  writeln('Precio: ',p.precio);
  writeln('Stock actual: ',p.stockA);
  writeln('Stock min: ',p.stockM);
end;

procedure imprimirDet(var ar:arD);
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

procedure imprimirMae(var ar:arM);
var
  p:producto;
begin
   reset(ar);
  while(not eof(ar)) do begin
    read(ar,p);
    imprimirProducto(p);
  end;
  close(ar);
end;

procedure leer(var ar:arD; var v:venta);
begin
  if(not eof(ar))then
    read(ar,v)
  else
    v.codigo:=valorAlto;
end;

procedure actualizar(var mae:arM; var det:arD);
var
  p:producto; v:venta; cv:integer; codActual:integer;
begin
  reset(mae); reset(det);
  leer(det,v); read(mae,p);
  while(v.codigo<>valorAlto)do begin
    codActual:=v.codigo;
	cv:=0;
    while(codActual = v.codigo)do begin
      cv:=cv+v.cv;
      leer(det,v);
    end;
    while(p.codigo <> codActual) do
      read(mae,p);
    p.stockA:=p.stockA-cv;
    seek(mae,filePos(mae)-1);
    if(not eof(mae))then
      write(mae,p);
  end;
  close(mae);
  close(det);
end;

procedure exportarSS(var ar:arM; var exSS:Text);
var
  p:producto;
begin
  reset(ar);
  rewrite(exSS);
  while(not eof(ar))do begin
    read(ar,p);
    if(p.stockA<p.stockM)then
      writeln(exSS,p.codigo,p.nombre,p.precio,p.stockA,p.stockM);
  end;
  close(ar);
  close(exSS);
end;

var
  mae:arM; det:arD; ex00:Text;
begin
  assign(mae,'productos.dat');
  assign(det,'ventasP.dat');
  crearArchivoM(mae);
  crearArchivoD(det);
  writeln('Maestro: ');
  writeln('---------------');
  imprimirMae(mae);
  writeln('---------------');
  actualizar(mae,det);
  writeln('Detalle: ');
  writeln('---------------');
  imprimirDet(det);
  writeln('---------------');
  writeln('Maestro: ');
  writeln('---------------');
  imprimirMae(mae);
  writeln('---------------');
  assign(ex00,'stock_minimo.txt');
  exportarSS(mae,ex00);
end.
