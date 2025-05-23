{Dada la siguiente estructura:
type
  reg_flor = record
    nombre: String[45];
    codigo: integer;
  end;
  tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}

program ejercicio4;
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








