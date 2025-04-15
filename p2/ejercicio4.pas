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
  detalles = array [1..30] of detalle;
  
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
  for i:= 1 to 30 do
    crearArchivoD(d[i]);
end;

procedure imprimirVenta(v:venta);
begin
  writeln('codigo: ',v.codigo);
  writeln('cantidad vedida: ',v.cv);
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
  for i:=1 to 30 do 
    imprimirDet(d[i]);
end;

procedure leer(var ar:detalle; var v:venta);
begin
  if(not eof(ar))then
    read(ar,v)
  else
    v.codigo:= valorAlto;
end;

procedure minimo(d:detalles; var min:detalle);
var
  minC,i:integer; v:venta;
begin
  minC:=-1;
  for i:=1 to 30 do begin
    leer(d[i],v);
    if(v.codigo<minC)then
      minC:=i;
  end;
  min:=d[i];
  leer()
    


