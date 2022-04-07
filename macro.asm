mVariables macro
    ;Mensaje de Bienvenida
    mensajeI db 0A,"Universidad de San Carlos de Guatemala",0A,"Facultad de Ingenieria",0A,"Escuela de Ciencias y Sistemas",0A,"Arquitectura de Compiladores y Ensambladores",0A,"Seccion B",0A,"Brandon Oswaldo Yax Campos",0A,"201800534",0A,"$";0A ES ENTER
    ;enter para avanzar
    espEnter db 0A,"(Presionar enter para poder avanzar): $"
    ;MENU
    Menu db 0A,"Menu",3A,0A,"1. Calculadora",0A,"2. Archivo",0A,"3. Salir",0A,"$"
    ; Opcion incorrecta
    opi db 0A,"**No se escogio una opcion entre las que existen**$"
    ; Opcion escogida del menu
    opcion db 0 
    dollar db '$'
    ;CALCULADORA
    stringNumactual db 20 dup (24)
    Numactual dw 0 
    auxs db "$"
    lfconsola db 20 dup (" "),"$" ;limpiar fila de la consola
    nfilas  db 0
    salto db 0A,"$"
    Numero1 dw 0
    naux db "$"
    Numero2 dw 0
    naux2 db "$"
    rnegativo dw 0
    auxElevado dw 0
    deseaImprimir db 0

    ;ARCHIVO
    handler dw  0
    msgcargar db 0A,"Ingrese el nombre del archivo a cargar: ",'$'
    nameFile db 20 dup(0)
    nfcaux db '$'
    ;nameArchivo db "prueba.txt",0
    cargood db 0A,"Cargo con exito! (presione cualquier tecla)","$" 
    carbad  db 0A,"Fallo la carga! (presione cualquier tecla)","$"
    estadocarga db 0 ;si se logro cargar algo o no
    archError db 0A,"El archivo posee errores! $"
    eleActual db 0 ;variable que contendra cada elemento leido por el programa
    auxele db "$"
    idEncontrado db 0 ;SE ENCONTRO LA PALABRA EN ESPECIAL QUE SE REQUERIA?
    posLectura dw 0 ;VARIABLE CON LA CUAL SI LLEGA A 0 LUEGO DE INSTANCIAR LA MARCO READFILE SIGNIFICA QUE
    ;EL DOCUMENTO LLEGO AL FINAL DE ESTE
    
    
endm 