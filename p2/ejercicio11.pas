{Se tiene información en un archivo de las horas extras realizadas por los empleados de una empresa en un mes. 
Para cada empleado se tiene la siguiente información: departamento, división, número de empleado, categoría y 
cantidad de horas extras realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por departamento, 
luego por división y, por último, por número de empleado. Presentar en pantalla un listado con el siguiente formato: 
Departamento 
División 
Número de Empleado    Total de Hs.   Importe a cobrar 

  ......                ......           ......
  
  ......                ......           ......           

División:     

.........

Total de horas división:  ____    

Monto total por división: ____ 
  
  Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al iniciar el programa 
  con el valor de la hora extra para cada categoría. La categoría varía de 1 a 15. En el archivo de texto debe 
  haber una línea para cada categoría con el número de categoría y el valor de la hora, pero el arreglo debe 
  ser de valores de horas, con la posición del valor coincidente con el número de categoría. 
}


program ejercicio11;
const
  valorAlto = 9999;
type
  empleado = record
    departamento:integer;
    division:integer;
    nro:integer;
    categoria:integer;
    extras:integer;
  end;
  maestro = file of empleado;
  valor = array [1..15] of integer;

procedure crearTXT(var t:text);
var 
  i,m:integer;
begin
  assign(t,'valorHora.txt');
  rewrite(t);
  m:= 100;
  for i:=1 to 15 do begin
    writeln(t,i,' ',m);
    m:=m+50;
  end;
  close(t);
end;

procedure armarVector(var v:valor);
var
  t:text; pos,monto:integer;
begin
  crearTXT(t);
  reset(t);
  while not eof(t) do begin
    writeln('error');
    readln(t,pos,monto);
    v[pos]:= monto;
  end;
  close(t);
end;

procedure leerEmpleado(var e:empleado);
begin
  writeln('ingrese nro de empleado: '); readln(e.nro);
  if(e.nro<>-1)then begin
    writeln('ingrese deaprtamento de empleado: '); readln(e.departamento);
    writeln('ingrese división de empleado: '); readln(e.division);
    writeln('ingrese categoría de empleado: '); readln(e.categoria);
    writeln('ingrese cantidad de horas extras de empleado: '); readln(e.extras);
  end;
end;

procedure crearMaestro(var ar:maestro);
var
  e:empleado;
begin
  rewrite(ar);
  leerEmpleado(e);
  while(e.nro<>-1)do begin
    write(ar,e);
    leerEmpleado(e);
  end;
  close(ar);
end;

procedure leer(var ar:maestro; var e:empleado);
begin 
  if(not eof(ar))then
    read(ar,e)
  else
    e.departamento:= valorAlto;
end;

procedure corteControl(var ar:maestro; v:valor);
var
  dep,divi,horasDi,horasDe:integer; e:empleado; montoDi,montoDe,monto:integer;
begin
  reset(ar);
  leer(ar,e);
  while(e.departamento<>valorAlto)do begin
    dep:= e.departamento;
    montoDe:=0;
    horasDe:=0;
    writeln('departamento: ',dep);
    while(e.departamento = dep)do begin
      montoDi:=0;
      horasDi:=0;
      divi:= e.division;
      writeln('división: ',divi);
      while(e.departamento = dep) and (e.division = divi)do begin
        monto:=e.extras*v[e.categoria];
        montoDi:=montoDi + monto;
        horasDi:=horasDi + e.extras; 
        writeln('num empleado: ',e.nro);
        writeln('total de horas: ',e.extras);
        writeln('importe a cobrar: ',monto);
        leer(ar,e);
      end;
      writeln('Total de horas por división: ',horasDi);
      writeln('Monto total por división: ',montoDi);
      montoDe:=montoDe + montoDi;
      horasDe:=horasDe + horasDi;
    end;
    writeln('Total de horas por departamento: ',horasDe);
    writeln('Monto total por departamento: ',montoDe);
  end;
  close(ar);
end;

var
  ar:maestro; v:valor;
begin
  armarVector(v);
  assign(ar,'maestro11.dat');
  //crearMaestro(ar);
  corteControl(ar,v);
end.

  
  
    
