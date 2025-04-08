{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez}

program ejercicio1;
const
  valorAlto = 9999;
type
  empleado = record
    codigo:integer;
    nombre:string;
    comision:real;
  end;
  empleados = file of empleado;

procedure leerEmpleado(var e:empleado);
begin
    writeln('Ingrese código: '); readln(e.codigo);
    if(e.codigo<> -1)then begin
      writeln('Ingrese nombre: '); readln(e.nombre);
      writeln('Ingrese comision: '); readln(e.comision);
    end;
end;

procedure crearArchivo(var ar:empleados);
var
  e:empleado;
begin
  rewrite(ar);
  leerEmpleado(e);
  while(e.codigo<>-1) do begin
    write(ar,e);
    leerEmpleado(e);
  end;
  close(ar);
end;

procedure imprimirEmpleado(e:empleado);
begin
  writeln('Código: ',e.codigo);
  writeln('Nombre: ',e.nombre);
  writeln('Monto de comisión: ',e.comision);
end;

procedure imprimir(var ar:empleados);
var
  e:empleado;
begin
  reset(ar);
  while(not eof(ar))do begin
    read(ar,e);
    imprimirEmpleado(e);
  end;
  close(ar);
end;

procedure leer(var ar:empleados; var e:empleado);
begin
  if(not eof(ar))then 
    read(ar,e)
  else
    e.codigo:= valorAlto;
end;

procedure compactar(var mae,det:empleados);
var
  codActual:integer; e,em:empleado; montoTotal:real;
begin
  reset(det);
  rewrite(mae);
  leer(det,e);
  while(e.codigo<>valorAlto)do begin
    codActual:=e.codigo;
    montoTotal:=0;
    em.nombre:= e.nombre;
    while(e.codigo = codActual)do begin
      montoTotal:= montoTotal + e.comision;
      leer(det,e);
    end;
    em.codigo:=codActual;
    em.comision:=montoTotal;
    write(mae,em);
  end;
  close(mae);
  close(det);
end; 

var
  mae:empleados; det:empleados;
begin
  assign(mae,'compacto.dat'); assign(det,'detalle.dat');
  crearArchivo(det);
  writeln('---------------');
  writeln('Detalle:');
  writeln('---------------');
  imprimir(det);
  writeln('---------------');
  compactar(mae,det);
  writeln('Maestro: ');
  writeln('---------------');
  imprimir(mae);
  writeln('---------------');
end.
