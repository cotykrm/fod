{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte}

program ejercicio9;
const
   valorAlto = 9999;
type
  cliente = record
    codigo:integer;
    nombre:string;
    apellido:string;
  end;
  
  venta = record
    cli:cliente;
    ano:integer;
    mes:integer;
    dia:integer;
    monto:real;
  end;

  maestro = file of venta;
  
procedure leer(var ar:maestro; var v:venta);
begin
  if(not eof(ar))then
    read(ar,v)
  else
    v.cli.codigo:= valorAlto;
end;

procedure leerVenta(var v:venta);
begin 
  writeln('ingrese código de cliente: '); readln(v.cli.codigo);
  if(v.cli.codigo<>-1)then begin
    writeln('ingrese nombre de cliente: '); readln(v.cli.nombre);
    writeln('ingrese apellido de cliente: '); readln(v.cli.apellido);
    writeln('ingrese año: '); readln(v.ano);
    writeln('ingrese mes: '); readln(v.mes);
    writeln('ingrese día: '); readln(v.dia);
    writeln('ingrese monto: '); readln(v.monto);
  end;
end;

procedure crearArchivo(var ar:maestro);
var
  v:venta;
begin
  writeln('hola');
  rewrite(ar);
  leerVenta(v);
  while(v.cli.codigo<>-1)do begin
    write(ar,v);
    leerVenta(v);
  end;
  close(ar);
end;

procedure imprimirCliente(c:cliente);
begin
  writeln('codigo cliente: ',c.codigo);
  writeln('nombre cliente: ',c.nombre);
  writeln('apellido cliente: ',c.apellido);
end;

{los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El orden del archivo está dado por: cod cliente, año y mes.}

procedure corteControl(var ar:maestro);
var
  codAc,mes,ano:integer; totalC,totalE,totalA,totalM:real; v:venta;
begin
  reset(ar);
  leer(ar,v);
  totalE:=0;
  while(v.cli.codigo<>valorAlto)do begin
    totalC:=0;
    codAc:=v.cli.codigo;
    imprimirCliente(v.cli);
    while(codAc = v.cli.codigo)do begin
      totalA:=0;
      ano:= v.ano;
      writeln('año: ',ano);
      while((codAc = v.cli.codigo) and (v.ano = ano))do begin
        totalM:=0;
        mes:= v.mes;
        writeln('mes: ',mes);
        while((codAc = v.cli.codigo) and (v.ano = ano) and (mes = v.mes)) do begin
          totalM:=totalM + v.monto;
          leer(ar,v);
        end;
        totalA:= totalA + totalM;
        writeln('total mes: ',totalM);
      end;
      totalC:= totalC + totalA;
      writeln('total año: ',totalA);
    end;
    totalE:=totalE + totalC;
    writeln('total cliente: ',totalC);
  end;
  writeln('total empresa: ',totalE);
  close(ar);
end;

var
  ar:maestro;
begin
  writeln('hola');
  assign(ar,'maestroCC.dat');
  crearArchivo(ar);
  corteControl(ar);
end.
