program parcial;
const 
    valorAlto = 9999;
type
    art = record
        codigo:integer;
        nombre:string;
    end;

    presentacion = record
        artista:art;
        anio:integer;
        codigo:integer;
        nombre:string;
        likes:integer;
        dislikes:integer;
        puntaje:real;
    end;

    //ordenado por anio cod evento y cod artista

    archivo = file of presentacion;

procedure leer(var ar:archivo; var p:presentacion);
begin
    if(not eof(ar))then
        read(ar,p)
    else
        p.anio := valorAlto;
end;

procedure procesar(var ar:archivo);
var
    p:presentacion;
    anios,anio,dislikes,likes,codE,codA,presentacionesT,presentacionesXanio,maxDislikes:integer;
    puntajeMin,puntajeT,porcentajeT:real;
    nomA,nomE,menosIn:string;
begin
    reset(ar);
    leer(ar,p);
    presentacionesT:= 0;
    anios:= 0;
    while(p.anio<>valorAlto)do begin
        anio := p.anio;
        writeln('anio: ',anio);
        presentacionesXanio:= 0;
        while(p.anio = anio) do begin
            codE:= p.codigo;
            nomE:= p.nombre;
            writeln('nombre evento: ',nomE);
            writeln('codigo evento: ',codE);
            puntajeMin:= valorAlto;
            maxDislikes:= -1;
            while(p.anio = anio) and (p.codigo = codE) do begin
                codA := p.artista.codigo;
                nomA:= p.artista.nombre;
                dislikes:= 0;
                likes:= 0;
                puntajeT:= 0;
                writeln('nombre artista: ',nomA);
                writeln('codigo artista: ',codA);
                while(p.anio = anio) and (p.codigo = codE) and (p.artista.codigo = codA) do begin       
                    dislikes:= dislikes + p.dislikes;
                    likes:= likes + p.likes;
                    puntajeT:= puntajeT + p.puntaje;
                    presentacionesXanio:= presentacionesXanio + 1;
                    leer(ar,p);
                end;
                writeln('likes totales: ',likes);
                writeln('dilikes totales: ',dislikes);
                writeln('diferencia: ',likes-dislikes);
                writeln('puntaje total: ',puntajeT);
                if(puntajeT<puntajeMin)then 
                    menosIn:= nomA
                else if(puntajeT = puntajeMin) then 
                    if(dislikes > maxDislikes)then
                        menosIn:= nomA;
            end;
            writeln('artista ',menosIn,' fue el menos influyente de ',nomE, ' del anio ',anio);
        end;
        writeln('durante el anio ',anio,' se registraron ',presentacionesXanio,'presentaciones de artistas');
        anios:= anios + 1;
        presentacionesT:= presentacionesT + presentacionesXanio;
    end;
    porcentajeT:= presentacionesT / anios;
    writeln('el promedio total de presentaciones por anio es de ',porcentajeT,' presentaciones');
    close(ar);
end;

procedure leerPresentacion(var p:presentacion);
begin
    writeln('ingrese anio de presentacion: '); readln(p.anio);
    if(p.anio<>valorAlto)then begin
        writeln('ingrese codigo de artista: '); readln(p.artista.codigo);
        writeln('ingrese nombre de artista: '); readln(p.artista.nombre);
        writeln('ingrese codigo de evento: '); readln(p.codigo);
        writeln('ingrese nombre de evento: '); readln(p.nombre);
        writeln('ingrese cantidad de likes: '); readln(p.likes);
        writeln('ingrese cantidad de dislikes: '); readln(p.dislikes);
        writeln('ingrese puntaje de jurado: '); readln(p.puntaje);
    end;
end;

procedure crearArchivo(var ar:archivo);
var 
    p:presentacion;
begin
    rewrite(ar);
    leerPresentacion(p);
    while(p.anio<>valorAlto)do begin
        write(ar,p);
        leerPresentacion(p);
    end;
    close(ar);
end;

var
    ar:archivo;
begin
    assign(ar,'arParcial.dat');
    crearArchivo(ar);
    procesar(ar);
end.