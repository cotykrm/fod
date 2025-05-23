{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}

program ejercicio6;
const 
  valorAlto = 9999;
type
  prenda = record
    codigo:integer;
    descripcion:string;
    colores:string;
    tipo:string;
    stock:integer;
    precioUn:real;
  end;
  archivo = file of prenda;
  bajas = file of integer;

  lista = ^nodo;
  nodo = record
    dato:integer;
    sig:lista;
  end;

procedure leerPrenda(var p:prenda);
begin
  writeln('ingrese codigo de la prenda: '); readln(p.codigo);
  if(p.codigo<>0) then begin
    writeln('ingrese descripcion de la prenda: '); readln(p.descripcion);
    writeln('ingrese colores de la prenda: '); readln(p.colores);
    writeln('ingrese tipo de la prenda: '); readln(p.tipo);
    writeln('ingrese stock de la prenda: '); readln(p.stock);
    writeln('ingrese el precio unitario de la prenda: '); readln(p.precioUn);
  end;
end;

procedure crearArchivo(var ar:archivo);
var
  p:prenda;
begin
  rewrite(ar);
  leerPrenda(p);
  while(p.codigo<>0) do begin
    write(ar,p);
    leerPrenda(p);
  end;
  close(ar);
end;

procedure leer(var ar:archivo; var p:prenda);
begin
  if not eof(ar) then
    read(ar,p)
  else
    p.codigo:= valorAlto;
end;

procedure cargarArBajas(var ar:bajas);
var
  codigo:integer;
begin
  rewrite(ar);
  writeln('Ingrese codigo de la prenda para bajar:'); 
  readln(codigo);
  while(codigo<>0)do begin
    write(ar,codigo);
    writeln('Ingrese codigo de la prenda para bajar:'); 
    readln(codigo);
  end;
  close(ar);
end;

procedure agregarNodo(var l:lista; n:integer);
var
  nue:lista;
begin
  new(nue);
  nue^.dato:= n;
  nue^.sig:= l;
  l:= nue;
end;

procedure pasarLista(var ar:bajas; var l:lista);
var
  n:integer;
begin
  reset(ar);
  while(not eof(ar))do begin
    read(ar,n);
    agregarNodo(l,n);
  end;
  close(ar);
end;

function buscarRegistro(l:lista; n:integer):boolean;
begin
  while(l<>nil)and(l^.dato<>n)do 
    l:=l^.sig;
  if(l<>nil)then
    buscarRegistro:=true
  else
    buscarRegistro:=false;
end; 


procedure darBaja(var ar:archivo; var arB:bajas);
var
  p:prenda; l:lista;
begin
  l:=nil;
  pasarLista(arB,l);
  reset(ar);
  leer(ar,p);
  while(p.codigo<>valorAlto)do begin
    if(buscarRegistro(l,p.codigo))then begin
      p.stock:=-1;
      seek(ar,filePos(ar)-1);
      write(ar,p);
    end;
    leer(ar,p);
  end;
  close(ar);
end;

procedure archivoLimpio(var arV:archivo; var arN:archivo);
var
  p:prenda;
begin
  reset(arV);
  rewrite(arN);
  leer(arV,p);
  while(p.codigo<>valorAlto)do begin
    if(p.stock>=0)then
      write(arN,p);
    leer(arV,p);
  end;
  close(arN);
  close(arV);
end;

procedure imprimirPrenda(p:prenda);
begin
  writeln('codigo: ',p.codigo);
  writeln('descripcion: ',p.descripcion);
  writeln('colores: ',p.colores);
  writeln('tipo: ',p.tipo);
  writeln('stock: ',p.stock);
  writeln('precio unitario: ',p.precioUn);
end;

procedure imprimirArchivo(var ar:archivo);
var 
  p:prenda;
begin
  reset(ar);
  leer(ar,p);
  while p.codigo<>valorAlto do begin
    imprimirPrenda(p);
    leer(ar,p);
  end;
  close(ar);
end;

var
  arOriginal,arNuevo:archivo; b:bajas; nombre:string;
begin
  nombre:= 'maestro.dat';
  assign(arOriginal,nombre);
  assign(arNuevo,'copiaMaestro.dat');
  assign(b,'bajast6.dat');
  crearArchivo(arOriginal);
  writeln('------------------------------------');
  writeln('archivo maestro: ');
  writeln('------------------------------------');
  imprimirArchivo(arOriginal);
  cargarArBajas(b);
  darBaja(arOriginal,b);
  writeln('------------------------------------');
  writeln('archivo maestro con bajas marcadas: ');
  writeln('------------------------------------');
  imprimirArchivo(arOriginal);
  archivoLimpio(arOriginal,arNuevo);
  writeln('------------------------------------');
  writeln('archivo maestro con bajas hechas: ');
  writeln('------------------------------------');
  imprimirArchivo(arNuevo);
  assign(arNuevo,nombre);
end.
