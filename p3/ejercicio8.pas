{Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un
nombre de distribución y devuelve la posición dentro del archivo donde se
encuentra el registro correspondiente a la distribución dada (si existe) o
devuelve -1 en caso de que no exista..
b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro
que contiene los datos de una nueva distribución, y se encarga de agregar
la distribución al archivo reutilizando espacio disponible en caso de que
exista. (El control de unicidad lo debe realizar utilizando el módulo anterior).
En caso de que la distribución que se quiere agregar ya exista se debe
informar “ya existe la distribución”.
c. BajaDistribucion: módulo que recibe como parámetro el archivo y el
nombre de una distribución, y se encarga de dar de baja lógicamente la
distribución dada. Para marcar una distribución como borrada se debe
utilizar el campo cantidad de desarrolladores para mantener actualizada
la lista invertida. Para verificar que la distribución a borrar exista debe utilizar
el módulo BuscarDistribucion. En caso de no existir se debe informar
“Distribución no existente”.
}
program ejercicio8;
const 
  valorAlto = 'zzzz';
type
  distribucion = record
    nombre:string;
    anioL:integer;
    kernel:integer;
    desarrolladores:integer;
    descripcion:string;
  end;

  archivo = file of distribucion;

procedure leerDistribucion(var d:distribucion);
begin
  writeln('ingrese el nombre de la distribucion: '); readln(d.nombre);
  if(d.nombre<>'zzz')then begin
    writeln('ingrese el año de lanzamiento de la distribucion: '); readln(d.anioL);
    writeln('ingrese va version de kernel de la distribucion: '); readln(d.kernel);
    writeln('ingrese cantidad de desarrolladores de la distribucion: '); readln(d.desarrolladores);
    writeln('ingrese descripcion de la distribucion: '); readln(d.descripcion);
  end;
end;

procedure crearArchivo(var ar:archivo);
var
  d:distribucion;
begin
  rewrite(ar);
  d.desarrolladores:= 0;
  write(ar,d);
  leerDistribucion(d);
  while(d.nombre<>'zzz')do begin
    write(ar,d);
    leerDistribucion(d);
  end;
  close(ar);
end;

procedure leer(var ar:archivo; var d:distribucion);
begin
  if(not eof(ar))then
    read(ar,d)
  else
    d.nombre:= valorAlto;
end;

function BuscarDistribucion(var ar:archivo; nombre:string):integer;
var
  d:distribucion; pos:integer;
begin
  reset(ar);
  leer(ar,d);
  pos:=-1;
  while d.nombre<>valorAlto do begin
    if(d.nombre = nombre)then
      pos:= filePos(ar)-1;
    leer(ar,d);
  end;
  BuscarDistribucion:=pos;
  close(ar);
end;

procedure AltaDistribucion(var ar:archivo; n:distribucion);
var
  d,aux:distribucion; libre:integer; pos:integer;
begin
  pos:=BuscarDistribucion(ar,n.nombre);
  reset(ar);
  if(pos < 0)then begin
    leer(ar,d);
    if(d.desarrolladores<0)then begin
      libre:= d.desarrolladores*(-1);
      seek(ar,libre);
      read(ar,aux);
      seek(ar,filePos(ar)-1);
      write(ar,n);
      seek(ar,0);
      write(ar,aux);
    end
    else begin
      seek(ar,fileSize(ar)-1);
      write(ar,n);    
    end;
    writeln('Distribución dada de alta.');
  end
  else
    writeln('La existe la distribución.');
  close(ar);
end;

procedure BajaDistribucion(var ar:archivo; nombre:string);
var
  d,cabecera:distribucion; pos:integer;
begin
  pos:= BuscarDistribucion(ar,nombre);
  reset(ar);
  if(pos<0)then
    writeln('Distribución no existente.')
  else begin
    read(ar,d);
    seek(ar,0);
    read(ar,cabecera);
    d.desarrolladores:= pos*(-1);
    seek(ar,filePos(ar)-1);
    write(ar,d);
    seek(ar,pos);
    write(ar,cabecera);
    writeln('Distribución dada de baja.');
  end;
  close(ar);
end;

procedure imprimirDistribucion(d:distribucion);
begin
  writeln('nombre de la distribucion: ',d.nombre);
  writeln('año de lanzamiento de la distribucion: ',d.anioL);
  writeln('kernel de la distribucion: ',d.kernel);
  writeln('cantidad de desarrolladores de la distribucion: ',d.desarrolladores);
  writeln('descripcion de la distribucion: ',d.descripcion);
end;

procedure imprimirArchivo(var ar:archivo);
var 
  d:distribucion;
begin
  reset(ar);
  seek(ar,1);
  leer(ar,d);
  while(d.nombre<>valorAlto)do begin
    if(d.desarrolladores>0)then 
      imprimirDistribucion(d);
    leer(ar,d);
  end;
  close(ar);
end;

var
  ar:archivo; alta:distribucion; nombre:string;
begin
  assign(ar,'bajas8.dat');
  //crearArchivo(ar);
  writeln('------------------------------------');
  writeln('archivo maestro: ');
  writeln('------------------------------------');
  imprimirArchivo(ar);
  writeln('ingrese nombre de distribucion para eliminar: '); 
  readln(nombre);
  BajaDistribucion(ar,nombre);
  writeln('------------------------------------');
  writeln('archivo maestro con baja hecha: ');
  writeln('------------------------------------');
  imprimirArchivo(ar);
  writeln('ingrese informacion de la distribucion a agregar:');
  leerDistribucion(alta);
  AltaDistribucion(ar,alta);
  writeln('------------------------------------');
  writeln('archivo maestro con alta hecha: ');
  writeln('------------------------------------');
  imprimirArchivo(ar);
end.

