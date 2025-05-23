{Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

program ejercicio5;
const 
  valorAlto = 9999;
type
  reg_flor = record
    nombre: String[45];
    codigo: integer;
  end;

  lista = ^nodo;
  nodo = record
    dato:reg_flor;
    sig:lista;
  end;

  tArchFlores = file of reg_flor;

procedure leerFlor(var f:reg_flor);
begin
  writeln('Ingrese codigo de la flor: '); readln(f.codigo);
  if(f.codigo<>0)then begin
    writeln('Ingrese nombre de la flor: '); readln(f.nombre);
  end;
end;

procedure crearArchivo(var ar:tArchFlores);
var
  f:reg_flor;
begin
  rewrite(ar);
  f.codigo:= 0;
  write(ar,f);
  leerFlor(f);
  while(f.codigo<>0)do begin
    write(ar,f);
    leerFlor(f);
  end;
  close(ar);
end;

procedure agregarFlor (var ar:tArchFlores; nombre:string; codigo:integer);
var
  fn,f:reg_flor; libre:integer;
begin
  reset(ar);
  fn.nombre:= nombre;
  fn.codigo:= codigo;
  read(ar,f);
  if(f.codigo<0)then begin
    libre:= f.codigo * (-1);
    seek(ar,libre);
    read(ar,f);
    seek(ar,filePos(ar)-1);
    write(ar,fn);
    seek(ar,0);
    write(ar,f);
  end
  else begin
    seek(ar,fileSize(ar)-1);
    write(ar,fn);
  end;
  writeln('flor dada de alta.');
  close(ar);
end;

procedure agregarNodo(var l:lista; f:reg_flor);
var
  nue:lista;
begin
  new(nue);
  nue^.dato:= f;
  nue^.sig:= l;
  l:= nue;
end;

procedure leer(var ar:tArchFlores; var f:reg_flor);
begin
  if not eof(ar) then
    read(ar,f)
  else
    f.codigo:= valorAlto;    
end;

procedure listar(var ar:tArchFlores; var l:lista);
var
  f:reg_flor;
begin
  reset(ar);
  leer(ar,f);
  while(f.codigo<>valorAlto) do begin
    if(f.codigo>0)then 
      agregarNodo(l,f);
    leer(ar,f);
  end;
  close(ar);
end;

procedure imprimir(f:reg_flor);
begin
  writeln('nombre de flor: ',f.nombre);
  writeln('codigo de flor: ',f.codigo);
end;

procedure imprimirLista(l:lista);
begin
  while(l<>nil)do begin
    imprimir(l^.dato);
    l:= l^.sig;
  end;
end;

procedure eliminarFlor (var ar: tArchFlores; flor:reg_flor);
var
  f,cabecera:reg_flor; libre:integer;
begin
  reset(ar);
  leer(ar,f);
  while(f.codigo<>valorAlto) and (f.codigo<>flor.codigo) do 
    leer(ar,f);
  if(f.codigo <> valorAlto) then begin
    libre:=filePos(ar)-1;
    seek(ar,0);
    read(ar,cabecera);
    seek(ar,filePos(ar)-1);
    f.codigo:= libre*(-1);
    write(ar,f);
    seek(ar,libre);
    write(ar,cabecera);
    writeln('registro dado de baja exitosamente.');
  end
  else
    writeln('el regidtro a borrar no se encuentra en el archivo.');
  close(ar);  
end;

var
  l:lista; ar:tArchFlores; f:reg_flor;
begin
  l:=nil;
  assign(ar,'altas4.dat');
  crearArchivo(ar);
  writeln('ingrese datos para agregar una flor nueva: ');
  leerFlor(f);
  agregarFlor(ar,f.nombre,f.codigo);
  listar(ar,l);
  imprimirLista(l);
end.