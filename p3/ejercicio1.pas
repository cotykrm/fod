{Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}


program ejercicio1;
const
  valorAlto = 9999;
type 
  empleado = record
    numero:integer;
    apellido:string;
    nombre:string;
    edad:integer;
    dni:integer;
  end;

  arc_emple = file of empleado;

procedure leerEmpleado(var emple:empleado);
begin
  writeln('Ingrese el apellido: '); readln(emple.apellido);
  if(emple.apellido<>'fin')then begin
    writeln('Ingrese el numero de empleado: '); readln(emple.numero);
    writeln('Ingrese el nombre: '); readln(emple.nombre);
    writeln('Ingrese la edad: '); readln(emple.edad);
    writeln('Ingrese el dni: '); readln(emple.dni);
  end;
end;

procedure cargarArchivo(var ar:arc_emple);
var
  emple:empleado;
begin
  rewrite(ar);
  leerEmpleado(emple);
  while(emple.apellido<>'fin')do begin
    write(ar,emple);
    leerEmpleado(emple);
  end;
  close(ar);
end;

procedure imprimirEmple(emple:empleado);
begin
  writeln('datos: ');
  writeln('numero de empleado: ',emple.numero);
  writeln('nombre de empleado: ',emple.nombre);
  writeln('apellido de empleado: ',emple.apellido);
  writeln('edad: ',emple.edad);
  writeln('dni: ',emple.dni);
end;

procedure listari(var ar:arc_emple);
var
  emple:empleado; nombre:string; apellido:string;
begin
  reset(ar);
  writeln('ingrese un nombre a buscar: '); readln(nombre);
  writeln('o un apellido: '); readln(apellido);
  while not eof(ar) do begin
    read(ar,emple);
    if(emple.nombre=nombre)or(emple.apellido=apellido)then begin
      imprimirEmple(emple);
      writeln('--------------------------');
    end;
  end;
  close(ar);
end;

procedure listarii(var ar:arc_emple);
var
  emple:empleado;
begin
  reset(ar);
  while not eof(ar) do begin
    read(ar,emple);
    imprimirEmple(emple);
    writeln('--------------------------');
  end;
  close(ar);
end;

procedure listariii(var ar:arc_emple);
var
  emple:empleado;
begin
  reset(ar);
  while not eof(ar) do begin
    read(ar,emple);
    if(emple.edad>70)then begin
      imprimirEmple(emple);
      writeln('--------------------------');
    end;
  end;
  close(ar);
end;

procedure modificarEdad(var ar:arc_emple);
var
  r:empleado; nro:integer; 
begin
  reset(ar);
  writeln('Ingrese el número de emppleado a modificar: '); readln(nro);
  while not eof(ar) do begin
    read(ar,r);
    if(r.numero=nro)then begin
      r.edad:= r.edad+3;
      seek(ar,filePos(ar)-1 );
      write(ar,r);
    end;
  end;
  close(ar);
end;

procedure puntoB(var ar:arc_emple);
var
  eleccion:integer;
begin
  writeln('Ingrese 1 si quiere listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
  writeln('Ingrese 2 si quiere listar en pantalla los empleados de a uno por línea.');
  writeln('Ingrese 3 si quiere listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.');
  readln(eleccion);
  case eleccion of
    1:listari(ar);
    2:listarii(ar);
    3:listariii(ar);
    otherwise writeln('el numero ingresado no es correcto.');
  end;
end;

procedure puntoA(var ar:arc_emple);
begin
  cargarArchivo(ar);
end;

procedure agregarEmple(var ar:arc_emple);
var 
  empn,r:empleado; 
begin
  reset(ar);
  leerEmpleado(empn);
  while empn.nombre <> ' ' do begin
    read(ar,r);
    while (not eof(ar))and (r.numero<>empn.numero) do 
      //writeln('segundo while');
      read(ar,r);
    if(r.numero=empn.numero) then
        writeln('El nro de empleado ya esat registrado.')
    else begin
      writeln('agregando');
      seek(ar,filesize(ar));
      write(ar,empn);
    end;
    leerEmpleado(empn);
    seek(ar,0);
  end;
  close(ar);
end;  

procedure exportarTodos(var ar:arc_emple);
var
  r:empleado; ex00:text;
begin
  assign(ex00,'todos_empleados.txt');
  reset(ar);
  rewrite(ex00);
  while not eof(ar) do begin
    read(ar,r);
    writeln(ex00,r.numero,r.nombre);
    writeln(ex00,r.edad,r.dni,r.apellido);
  end;
  close(ar);
  close(ex00);
  writeln('Exportado.');
end;

procedure exportar00(var ar:arc_emple);
var r:empleado; ex00:text;
begin
  assign(ex00,'faltaDNIEmpleado.txt');
  reset(ar);
  rewrite(ex00);
  while(not eof(ar))do begin
    read(ar,r);
    if(r.dni=0)then
      writeln(ex00,r.numero,r.nombre);
      writeln(ex00,r.edad,r.dni,r.apellido);
  end;
  close(ar);
  close(ex00);
  writeln('Exportado.');
end;

procedure leer(var ar:emple; var e:empleado);
begin
  if(e.numero<>valorAlto)then
    read(ar,e)
  else
    e.numero:=valorAlto;
end;

procedure bajar(var ar:arc_emple);
var
  aux,e:empleado; buscado:integer; posBorrar, posUlt: integer;
begin
  writeln('Ingrese el número de empleado a eliminar: '); readln(buscado);
  reset(ar);
  posUlt:= filesize(ar)-1;
  seek(posUlt);
  read(ar,aux);
  seek(ar,0);
  leer(ar,e);
  while(e.numero<>valorAlto) and (e.numero<>buscado) do
    leer(ar,e);
  if(e.numero<>valorAlto)then begin
    posBorrar:= filePos(ar)-1;
    if(posUlt<>posBorrar)then begin
      seek(ar,posBorrar);
      write(ar,aux);
    end;
    seek(ar,posUlt);
    truncate(ar);
    writeln('Empleado borrado exitosamente.');
  end
  else 
    writeln('no se encontró el empleado buscado.');
  close(ar);  
end;

var
  ar:arc_emple; eleccion:integer; 
  //nombre:string;
begin
  writeln('Ingrese el nombre del archivo:');  
  //nombre = 'emple.txt';
  //readln(nombre);
  assign(ar,'emple.dat');
  writeln('Ingrese 1 si quiere Crear un archivo.');
  writeln('Ingrese 2 si quiere Abrir el archivo anteriormente generado.');
  writeln('Ingrese 3 si quiere agregar elementos al archivo.');
  writeln('Ingrese 4 si quiere modificar la edad de algún empleado.');
  writeln('Ingrese 5 si quiere exportar el contenido del archivo a un archivo de texto.');
  writeln('Ingrese 6 si quiere Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI.');
  writeln('Ingrese 7 si quiere realizar una baja.')
  writeln('Ingrese 0 si quiere salir');
  readln(eleccion);
  repeat
    case eleccion of 
      1:puntoA(ar);
      2:puntoB(ar);
      3:agregarEmple(ar);
      4:modificarEdad(ar);
      5:exportarTodos(ar);
      6:exportar00(ar);
      7:bajar(ar);
      0:writeln('Saliendo.');  
    end;
    until(eleccion=0);
  //close(ar);
  //exportar(ar,exp1);
end.
