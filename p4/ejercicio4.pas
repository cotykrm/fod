program ejercicio4;
const 
  MaxHijos = 4;
  MaxClaves = MaxHijos - 1;
type
  NodoB = record
    cantidadClaves: Integer;
    claves        : array[1..MaxClaves] of LongInt;
    hijos         : array[1..MaxHijos] of Integer;
  end;

  ArchivoNodos = file of NodoB;

procedure PosicionarYLeerNodo(var A: ArchivoNodos; var nodo: NodoB; NRR: Integer);
begin
  Seek(A, NRR);        { Posiciona el puntero en la posición NRR del archivo }
  Read(A, nodo);       { Lee el nodo desde el archivo y lo guarda en la variable nodo }
end;

{El procedimiento PosicionarYLeerNodo(A, nodo, NRR) realiza dos tareas fundamentales:
- Posicionar el puntero del archivo en la posición NRR (Número de Registro Relativo), 
es decir, busca el nodo que se encuentra en esa posición dentro del archivo A que 
representa el árbol B.
- Leer desde el archivo el nodo que se encuentra en esa posición y almacenarlo 
en la variable nodo

Forma de pasar los parámetros
- A: debe ser pasado por referencia o como un archivo abierto, ya que representa el archivo 
de nodos del árbol B y debe mantenerse abierto durante toda la operación.
- NRR: se pasa por valor, ya que solo se necesita saber la posición a acceder.
- nodo: se pasa por referencia, porque se va a modificar dentro del procedimiento al leer el
 contenido del archivo.}

procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado)
var clave_encontrada: boolean;
begin
  if (nodo = null)
    resultado := false; {clave no encontrada}
  else
    posicionarYLeerNodo(A, nodo, NRR);
  claveEncontrada(A, nodo, clave, pos, clave_encontrada);
  if (clave_encontrada) then begin
    NRR_encontrado := NRR; { NRR actual }
    pos_encontrada := pos; { posicion dentro del array }
    resultado := true;
  end
  else
    buscar(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado)
end;

{El procedimiento claveEncontrada(A, nodo, clave, pos, clave_encontrada) 
busca si una clave específica está presente dentro del nodo actual del árbol B. 
Si la clave está:
- Devuelve true en clave_encontrada.
- Devuelve en pos la posición (índice del arreglo de claves del nodo) donde se 
encuentra la clave.

Si no está:
- Devuelve false en clave_encontrada.
- Devuelve en pos la posición del hijo al que se debe seguir descendiendo 
(como en una búsqueda binaria modificada).

Formas de pasar los parametros:

| Parámetro          | Tipo      | ¿Cómo se pasa?                  | Motivo                                                                                              |
| ------------------ | --------- | ------------------------------- | --------------------------------------------------------------------------------------------------- |
| `A`                | archivo   | (No se necesita realmente aquí) | Este parámetro parece innecesario a menos que esté implícito en el contexto                         |
| `nodo`             | registro  | **por valor o referencia**      | Por valor si solo se consulta, por referencia si se va a modificar (en este caso, solo se consulta) |
| `clave`            | `LongInt` | **por valor**                   | Es un dato de entrada                                                                               |
| `pos`              | `Integer` | **por referencia**              | Se devuelve la posición donde está o donde seguir                                                   |
| `clave_encontrada` | `Boolean` | **por referencia**              | Se devuelve el resultado de la búsqueda                                                             |


errores del codigo:
el procedimiento buscar tiene un error importante de lógica: si el nodo es null, 
no hay manera de ejecutar posicionarYLeerNodo ni hacer ninguna operación, pero 
el código omite la lectura del nodo antes de verificar si está vacío.

Problemas detectados:
- nodo no fue inicializado antes de usar if (nodo = null).
- En Pascal no se usa null, se debería usar alguna señal válida (por ejemplo, 
NRR = -1 o eof(A) o manejar un campo nodoValido: boolean).
- Falta de declaración completa de variables.
- El llamado a claveEncontrada está fuera del else, por lo que se ejecutaría incluso si 
el nodo no existe.
- No se ve la definición del archivo ni del nodo, lo que es importante para el análisis.
}

//procedimiento corregido:

procedure buscar(var A: ArchivoNodos; NRR: Integer; clave: LongInt;
                 var NRR_encontrado, pos_encontrada: Integer; var resultado: Boolean);
var
  nodo: NodoB;
  clave_encontrada: Boolean;
  pos: Integer;
begin
  if (NRR = -1) then  { Caso base: nodo inválido o árbol vacío }
    resultado := false
  else
  begin
    posicionarYLeerNodo(A, nodo, NRR);  { Leer nodo desde archivo }
    claveEncontrada(nodo, clave, pos, clave_encontrada);

    if clave_encontrada then
    begin
      NRR_encontrado := NRR;     { Nodo actual donde se encontró la clave }
      pos_encontrada := pos;     { Posición dentro del array de claves }
      resultado := true;
    end
    else
      buscar(A, nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado);
  end;
end;
