mVariables macro
    ;Mensaje de Bienvenida
    mensajeI db 0A,"Universidad de San Carlos de Guatemala",0A,"Facultad de Ingenieria",0A,"Escuela de Ciencias y Sistemas",0A,"Arquitectura de Compiladores y Ensambladores",0A,"Seccion B",0A,"Brandon Oswaldo Yax Campos",0A,"201800534",0A,"$";0A ES ENTER
    ;enter para avanzar
    espEnter db 0A,"(Presionar enter para poder avanzar): $"
    ;MENU 1
    Menu db 0A,"Menu",3A,0A,"F1. Login",0A,"F2. Register",0A,"F9. Exit",0A,"$"
    ;Menu 2
    Menu2 db "F2. Play game",0A,"F3. Show top 10 scoreboard",0A,"F5. Show my top 10 scoreboard",0A,"F9. Logout",0A,"$"
    ; Opcion incorrecta
    opi db 0A,"**No se escogio una opcion entre las que existen**$"
    ;MENSAJE LUEGO DE EQUIVOCARSE 3 VECES
    blockUs db ">> Permission denied <<",0A,">> There where 3 failed login attempts <<",0A,">> Please contact the administrator <<",0A,">> Press Enter to go back to menu <<",0A,"$"

    ; Opcion escogida del menu
    opcion db 0 
    dollar db '$'
    ;CALCULADORA
    stringNumactual db 20 dup (24)
    Numactual dw 0 
    auxs db "$"

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

    ;PARA LA COMPARACION DE CADENAS
    cadIguales db 0
    ;DEBUGER
    eProgram db "PROGRAMA SE ENCUENTRA AQUI$"
endm 

mFlujoProyecto2 macro
    mAjustarMemoria
        mLimpiarConsola
        mMostrarString mensajeI
         ;apartado de espera de un enter----------------------
            EsperaEnter:
            mMostrarString espEnter
            mov ah,01
            int 21
            cmp al,0dh
            jne EsperaEnter ; SI NO ES UN ENTER SE REPETIRA, CUANDO YA VENGA LA MACRO SEGUIRA SU CURSO NORMAL
            ;---------------------------------------------------
        mLimpiarConsola
        mFlujoMenu
    mRetControl
endm 

mFlujoMenu macro
    ciclomenu: 
    mov opcion,0
    mMostrarString Menu
    mov ah,01
    int 21
    mov opcion,al 
    mMostrarString eProgram
    mMostrarString opcion 
    cmp opcion,0
    je salir
    jne ciclomenu
    salir: 
endm



;LIMPIA CONSOLA 
mLimpiarConsola macro
    ;Limpia la consola 
    mov ax,0600h ; es igual a mov ah,06 (scroll up windows con el int 10)  y mov al,00
    mov bh, 07   
    mov cx, 00000  ; es igual a mov ch,0   mov cl, 0 , filas y coumnas de derecha a izquierda
    mov dx, 184FH  ;filas y columnas de both 
    int 10
    ;posiciona el cursor en la pos 0
    mov ah, 02
    mov bh,0  ;nuero de pagina
    mov dl,0   ;columna
    mov dh,0   ;fila 
    int 10
endm


;Imprime variables
mMostrarString macro var 
    push dx
    push ax
    lea dx, var
    mov ah, 09
    int 21
    pop ax
    pop dx 
endm
;Ajusta la memoria
mAjustarMemoria macro
    mov dx, @DATA
    mov ds,dx
    mov es,dx
endm
;Devuelve al sistema el control
mRetControl macro
    mov al, 10  
    mov ah, 4C  
    int 21
endm
;MACRO PARA CONVERTIR STRINGS A NUMEROS
String2Num macro stringToRead,whereToStore
    local readStringValue
    push ax 
    xor dx,dx ;limpia dx y la vuelve 0
    mov ax,dx ;ax = 0
    mov si,dx ;si = 0
    mov bx, 0A ;bx=10
    ;mov si, offset stringtoRead
    readStringValue:
    mov cl,stringToRead[si]
    sub cl,30 ; se le resta 30 para convertirlo a un numero legible (num de 0-9)
    mul bx    ; ax= ax*bx  se multiplica por 10 el valor actual de ax 
    add ax,cx ; se suma a ax el valor de cx
    inc si
    mCompararaux stringToRead[si],24  ; 24= "$"
    jne readStringValue
    mov whereToStore,ax 
    pop ax 
endm 
;NUMEROS A STRING
Num2String macro numero, stringvar  ;stringvar: variable donde se almacenara el numero
    local cNumerador,Convertir
    push ax 
    mov bx,0A
    mov ax, numero
    cNumerador:   ;condicion de numerador
        xor dx,dx
        div bx
        push dx
        inc contador ;tamaño de la pila, aumenta al agregarse un valor
        cmp ax, 0 ;numerador es igual a 0?
        jne cNumerador
    mov si, offset stringvar; donde se almacenara el nuevo numero
    Convertir:
        pop dx  ;pop = pila.pop(ultimo valor)
        add dx,30h
        mov [si],dx
        inc si 
        dec contador
        cmp contador,0 
        jne Convertir
        pop ax 
endm 
;MACRO PARA CAPTURAR STRINGS EN UNA VARIABLE
mCapturarString macro variableAlmacenadora 
    local salir,capturarLetras
    mov si,0
    capturarLetras:
        mov ah,01h
        int 21h
        cmp al, 0dh ;es igual a enter?
        je salir ; una vez dado enter y capturado todo el nombre, pasar al siguiente procedimiento
        mov variableAlmacenadora[si],al
        inc si
        jmp capturarLetras
    salir:
   
endm 
;LIMPIA UNA VARIABLE
mLimpiar macro lista,numero,signo
    local salir,borrar
    mov si,0
    borrar:
        mov lista[si],signo   
        inc si
        cmp si,numero
        je salir
        jne borrar
    salir:
endm
;MUEVE EL CONTENIDO DE UNA VARIABLE A OTRA 
MovVariables macro var1,var2
    mov dl,0
    mov dl,var2
    mov var1, dl ; SE INGRESA A LA NUEVA POSICION EL SIMBOLO ACTUAL
    mov dl,0
endm

;COMPARAR STRINGS 
mCompararStrings macro var1, var2
    local salir,Iguales,noIguales,comparar,pfvar1,pfvar2
    mov cadIguales,0
    mov si,0
    comparar:   
        mComparar var1[si],var2[si]
        je Pfvar1 
        jne noIguales
    pfvar1:
        mComparar var1[si],"$" ;cadena llego al final?
        je pfvar2 ;tambien llego al final en la cadena 2?
        inc si 
        jne comparar 
    pfvar2:
        mComparar var2[si],"$"
        je Iguales ;si llego al final al mismo tiempo que var 1, son iguales
        jne noIguales ;no son iguales 
    Iguales: 
        mov cadIguales,1
        jmp salir 
    noIguales:
        mov cadIguales,0
        jmp salir 
    salir: 
endm 

;COMPARA VARIABLES
mComparar macro var1,var2
    push ax 
    push bx 
    mov al,var1
    mov bl,var2
    cmp al,bl
    pop bx
    pop ax
endm 