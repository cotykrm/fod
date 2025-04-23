{Se tiene información en un archivo de las horas extras realizadas por los empleados de una empresa en un mes. Para cada empleado se tiene la siguiente información: departamento, división, número de empleado, categoría y cantidad de horas extras realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por división y, por último, por número de empleado. Presentar en pantalla un listado con el siguiente formato: 
Departamento División 
Número de Empleado    
Total de Hs.   
Importe a cobrar 

......                                ......                                ..........               ..........               

Total de horas división:  ____ .........    .........    Monto total por división: ____ 
  
  Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la posición del valor coincidente con el número de categoría. 
}


program ejercicio11;
const
  valorAlto = 9999;
type
  empleado = record
    departamento:integer;
    division:integer;
    nro:integer;
    categoria:char;
    extras:integer;
  end;
  maestro = file of empleado;
  
  procedure leerEmpleado(var e:empleado);
  begin
    writeln('ingrese nro de empleado: '); readln(e.nro);
    if(r.nro<>-1)ten begin
      writeln('ingrese deaprtamento de empleado: '); readln(e.departamento);
      writeln('ingrese división de empleado: '); readln(e.division);
      writeln('ingrese categoría de empleado: '); readln(e.categoria);
      writeln('ingrese cantidad de horas extras de empleado: '); readln(e.extras);
    end;
  end;
  
procedure leer(var ar;maestro; var e:enpleado);
begin 
  if(not eof(ar))then
    read(ar,e)
  else
    e.departamento:= valorAlto;
end;

procedure corteControl(var ar:maestro);
var
  dep,divi,nro:integer; e:empleado;
begin
  reset(ar);
  leer(ar,e);
  while(e.departamento<>valorAlto)do begin
    dep:= e.departamento;
    writeln('departamento: ',dep);
    while(e.departamento = dep)do begin
      divi:= e,division;
      writeln('división: ',divi);
      while(e.division = divi)do begin
        
  
  
    
