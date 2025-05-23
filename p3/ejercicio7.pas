{Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que permita borrar especies de aves extintas. Este programa debe
disponer de dos procedimientos:
a. Un procedimiento que dada una especie de ave (su código) marque la misma
como borrada (en caso de querer borrar múltiples especies de aves, se podría
invocar este procedimiento repetidamente).
b. Un procedimiento que compacte el archivo, quitando definitivamente las
especies de aves marcadas como borradas. Para quitar los registros se deberá
copiar el último registro del archivo en la posición del registro a borrar y luego
eliminar del archivo el último registro de forma tal de evitar registros duplicados.
i. Implemente una variante de este procedimiento de compactación del
archivo (baja física) donde el archivo se trunque una sola vez.}

program ejercicio7;
const 
  valorAlto = 9999;
type
  ave = record
    codigo:integer;
    familia:string;
    descripcion:string;
    zona:string;
  end;

  archivo = file of ave;

procedure leerAve(var a:ave);
begin
  writeln('ingrese codigo del ave: '); readln(a.codigo);
  if(a.codigo<>0)then begin
    writeln('ingrese familia del ave: '); readln(a.familia);
    writeln('ingrese descripcion del ave: '); readln(a.descripcion);
    writeln('ingrese zona del ave: '); readln(a.zona);
  end;
end;

procedure crearArchivo(var ar:archivo);
var
  a:ave;
begin
  rewrite(ar);
  leerAve(a);
  while(a.codigo<>0)do begin
    write(ar,a);
    leerAve(a);
  end;
  close(ar);
end;

procedure leer(var ar:archivo; var a:ave);
begin
  if(not eof(ar))then
    read(ar,a)
  else
    a.codigo:= valorAlto;
end;

procedure imprimirAve(a:ave);
begin
  writeln('codigo del ave: ',a.codigo);
  writeln('familia del ave: ',a.familia);
  writeln('descripcion del ave: ',a.descripcion);
  writeln('zona del ave: ',a.zona);
end;

procedure imprimirArchivo(var ar:archivo);
var
  a:ave;
begin
  reset(ar);
  leer(ar,a);
  while a.codigo<>valorAlto do begin
    imprimirAve(a);
    leer(ar,a);
  end;
  close(ar);
end;

procedure darBajaL(var ar:archivo; n:integer);
var
  a:ave;
begin
  reset(ar);
  leer(ar,a);
  while(a.codigo<>valorAlto)and(a.codigo<>n)do 
    leer(ar,a);
  if(a.codigo<>valorAlto)then begin
    a.codigo:= -1;
    seek(ar,filePos(ar)-1);
    write(ar,a);
    writeln('baja lógica hecha.');
  end
  else
    writeln('no se encontró el registro a borrar.');
  close(ar);
end;

procedure darBajaF(var ar:archivo);
var
  pos:integer; a,copia:ave;
begin
  reset(ar);
  leer(ar,a);
  while(a.codigo<>valorAlto) do begin
    if(a.codigo<0)then begin
      pos:= filePos(ar)-1;
      seek(ar,fileSize(ar)-1);
      read(ar,copia);
      seek(ar,pos);
      write(ar,copia);
      seek(ar,fileSize(ar)-1);
      truncate(ar);
    end;
    leer(ar,a);
  end;
  close(ar);
end;

procedure compactar(var ar:archivo);
var
  pos,cantBorrar,ir:integer; a,copia:ave; 
begin
  reset(ar);
  leer(ar,a);
  cantBorrar:=0;
  while(a.codigo<>valorAlto) do begin
    if(a.codigo<0)then begin
      pos:= filePos(ar)-1;
      ir:= fileSize(ar)-1-cantBorrar;
      seek(ar,ir);
      read(ar,copia);
      seek(ar,pos);
      write(ar,copia);
      cantBorrar:= cantBorrar + 1;
    end;
    leer(ar,a);
  end;
  ir:= fileSize(ar)-cantBorrar;
  seek(ar,ir);
  truncate(ar); 
  close(ar);
end;

var
  ar:archivo; cod:integer;
begin
  assign(ar,'bajas7.dat');
  crearArchivo(ar);
  writeln('------------------------------------');
  writeln('archivo maestro: ');
  writeln('------------------------------------');
  imprimirArchivo(ar);
  writeln('ingrese codigo de ave para eliminar: '); 
  writeln('(ingrese 0 en caso de no borrar)');
  readln(cod);
  while(cod<>0)do begin
    darBajaL(ar,cod);
    writeln('ingrese codigo de ave para eliminar: '); 
    writeln('(ingrese 0 en caso de no borrar)');
    readln(cod);
  end;
  writeln('------------------------------------');
  writeln('archivo maestro con bajas marcadas: ');
  writeln('------------------------------------');
  imprimirArchivo(ar);
  darBajaF(ar);
  writeln('------------------------------------');
  writeln('archivo maestro con bajas hechas: ');
  writeln('------------------------------------');
  imprimirArchivo(ar);
end.