{Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de “enlace” de la lista (utilice el código de
novela como enlace), se debe especificar los números de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
}

program ejercicio3;
const 
  valorAlto = 9999;
type
  novela = record
    codigo:integer;
    genero:string;
    nombre:string;
    duracion:real;
    director:string;
    precio:real;
  end;

  archivo = file of novela;

procedure leerNovela(var n:novela);
begin 
  writeln('ingrese codigo de novela: '); readln(n.codigo);
  if(n.codigo<>-1)then begin
    writeln('ingrese genero de novela: '); readln(n.genero);
    writeln('ingrese nombre de novela: '); readln(n.nombre);
    writeln('ingrese duracion de novela: '); readln(n.duracion);
    writeln('ingrese director de novela: '); readln(n.director);
    writeln('ingrese precio de novela: '); readln(n.precio);
  end;
end;

procedure crearArchivo(var ar:archivo);
var
  n:novela;
begin
  rewrite(ar);
  n.codigo:= 0;
  write(ar,n);
  leerNovela(n);
  while(n.codigo<>-1)do begin
    write(ar,n);
    leerNovela(n);
  end;
  close(ar);
end;

{ si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.}

procedure darAlta(var ar:archivo);
var 
  nn,n:novela; libre:integer;
begin
  reset(ar);
  leerNovela(nn);
  read(ar,n);
  if (n.codigo < 0) then begin
    // Hay espacio libre en la lista invertida
    libre := n.codigo * -1; // Obtener la posición libre
    seek(ar, libre); // Ir a la posición libre
    read(ar, n); // Leer el registro en la posición libre
    seek(ar, filePos(ar) - 1); // Volver a la posición libre
    write(ar, nn); // Escribir la nueva novela en la posición libre
    seek(ar, 0); // Volver al registro cabecera
    write(ar, n); // Escribir la nueva cabecera
  end
  else begin
    seek(ar,fileSize(ar));
    write(ar,nn);
  end;
  writeln('novela dada de alta.');
  close(ar);
end;

{ Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.}

procedure modificar(var ar:archivo);
var
  n,nm:novela;  cod:integer;
begin
  reset(ar);
  writeln('ingrese codigo de novela a modificar: ');
  readln(cod);
  writeln('ingrese los cambios de la novela: ');
  leerNovela(n);
  nm.codigo:= cod;
  read(ar,n);
  while(not eof(ar)) and (n.codigo<>cod)do 
    read(ar,n);
  if(not eof(ar))then begin
    seek(ar, filePos(ar)-1);
    write(ar,nm);
    writeln('archivo modificado.');
  end
  else
    writeln('codigo de novela no encotrado, no se pudo modificar.');
  close(ar);
end;

{ Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.}

procedure darBaja(var ar:archivo);
var 
    n,cabecera:novela; cod,libre:integer
begin
  writeln('ingrese el codigo de novela a bajar: ');
  readln(cod);
  read(ar,n);
  while(not eof(ar)) and (n.codigo<>cod)do
    read(ar,n);
  if(not eof(ar))then begin
    libre:= filePos(ar)-1;
    n.codigo:= libre;
    seek(ar,0);
    read(ar,cabecera);
    seek(ar,filePos(ar)-1);
    write(ar,n);
    seek(ar,cabecera.codigo*(-1));
    write(ar,cabecera);
  end
  else
    writeln('codigo de novela no encotrado, no se pudo der de baja.');
  close(ar);
end;
procedure mantenimiento(var ar:archivo);
var
  eleccion:integer;
begin
  writeln('ingrese 1 para dar de alta una novela.');
  writeln('ingrese 2 para modificar una novela.');
  writeln('ingrese 3 para dar de baja una novela.');
  readln(eleccion);
  case eleccion of
    1:darAlta(ar);
    2:modificar(ar);
    3:darBaja(ar);
    otherwise writeln('el numero ingresado no es correcto.');
  end;
end;

var
  ar:archivo; nombre:string; eleccion:integer;
begin
  writeln('ingrese el nombre del archivo'); 
  readln(nombre);
  assign(ar,nombre);
  writeln('ingrese 1 crear un archivo.');
  writeln('ingrese 2 para abrir el archivo existente y permitir su mantenimiento.');
  readln(eleccion);
  while(eleccion<>0)do begin
    case eleccion of
      1:crearArchivo(ar);
      2:mantenimiento(ar);
      otherwise writeln('el numero ingresado no es correcto.');
    end;
    readln(eleccion);
  end;
end.
