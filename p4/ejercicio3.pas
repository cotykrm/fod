{Los árboles B+ representan una mejora sobre los árboles B dado que conservan la propiedad de
acceso indexado a los registros del archivo de datos por alguna clave, pero permiten además un
recorrido secuencial rápido. Al igual que en el ejercicio 2, considere que por un lado se tiene el
archivo que contiene la información de los alumnos de la Facultad de Informática (archivo de
datos no ordenado) y por otro lado se tiene un índice al archivo de datos, pero en este caso el
índice se estructura como un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos.
Resuelva los siguientes incisos:
a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se encuentran
en los nodos internos y que elementos se encuentran en los nodos hojas?
b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por qué?
c. Defina en Pascal las estructuras de datos correspondientes para el archivo de alumnos y su
índice (árbol B+). Por simplicidad, suponga que todos los nodos del árbol B+ (nodos internos y
nodos hojas) tienen el mismo tamaño
d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI específico
haciendo uso de la estructura auxiliar (índice) que se organiza como un árbol B+. ¿Qué
diferencia encuentra respecto a la búsqueda en un índice estructurado como un árbol B?
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI en el
rango entre 40000000 y 45000000, apoyando la búsqueda en un índice organizado como un
árbol B+. ¿Qué ventajas encuentra respecto a este tipo de búsquedas en un árbol B?}

program ejercicio3;
const 
  M = 43;  // según cálculo anterior
  max = M - 1;
type
  alumno = record
    nombre:string;
    apellido:string;
    dni:integer;
    legajo:integer;
    anioIngreso:integer;
  end;

  clave = record
    dni:integer;
    puntero:integer;
  end;

  nodo = record
    esHoja:boolean;
    cant_claves:integer;
    clavesInternas:array[1..max] of integer;
    hijos:array [1..M] of integer;
    hojas:array [1..max] of clave;
    siguienteHoja:integer;
  end;

  archivo = file of alumno;
  archivoIndices= file of nodo;


  las claves y los punteros al registro dentro del archivo, estan en los nodos externos(hojas),
  en los nodos internos hay copias de las claves.
  en los arboles B+ los nodos hojas estan enlazados entre si. asi permite un acceso secuencial 
  entre las claves.
    