{Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un lado el archivo
que contiene la información de los alumnos de la Facultad de Informática (archivo de datos no
ordenado) y por otro lado mantener un índice al archivo de datos que se estructura como un árbol
B que ofrece acceso indizado por DNI de los alumnos.
a. Defina en Pascal las estructuras de datos correspondientes para el archivo de alumnos y su
índice.
b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál sería el
orden del árbol B (valor de M) que se emplea como índice? Asuma que los números enteros
ocupan 4 bytes. Para este inciso puede emplear una fórmula similar al punto 1b, pero
considere además que en cada nodo se deben almacenar los M-1 enlaces a los registros
correspondientes en el archivo de datos.
c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678 usando el
índice definido en este punto.
e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido usar el
índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo haría para brindar
acceso indizado al archivo de alumnos por número de legajo?
f. Suponga que desea buscar los alumnas que tienen DNI en el rango entre 40000000 y
45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo de un árbol B que solo
provee acceso indizado por DNI al archivo de alumnos?
}

program ejercicio2;
const 
  M = 10;
  max = M - 1;
type
  alumno = record
    nombre:string;
    apellido:string;
    dni:integer;
    legajo:integer;
    anioIngreso:integer;
  end;

  nodo = record
    cant_claves:integer;
    claves: array [1..max] of longint;
    enlaces:  array [1..max] of integer; //son los punteros que tienen la direccion 
    //de memoria del registro alumno al que hace referencia ese indice.
    hijos:  array [1..M] of integer;

  archivo = file of alumno;
  archivoIndices= file of nodo;



  para buscar, se hace lo mismo que en el punto 1, pero luego, una vez encontrado 
  el nodo con la clave correspondiente, se debe hacer una lectura extra para aceder 
  al archivo con el puntero guardado.
  si se intenta buscar por legajo, no sirve usar el archivo de indices, ya que es el otro criterio.
  si se quiere buscar por numero de legajo, se debe buscar directamente en el archivo de registros.
  para brindar acceso indizado al archivo de alumnos por número de legajo, se deberia organizar el 
  archivo de indices pero utilizando como criterio el legajo
  este tipo de búsquedas con apoyo de un árbol B que solo provee acceso indizado por DNI al archivo 
  de alumnos tiene el problema de que solo se puede acceder a una clave.

