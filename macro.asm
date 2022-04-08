
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
    ;REGISTRO DE USUARIOS
    UsuarioRegis db 20 dup (24) ;nombre de usuario a registrar
    Password db 20 dup (24)   ;contraseña a registrar 
    validador db 0              ;validador 
        ActionR db "Accion rechazada! $" 
        ;MENSAJES DE NOMBRE DE USUARIO CONE ESTRUCTURA INCORRECTA
        initialbad db "Se debe de iniciar por una letra$"
        lengtherror db "Tamanio del nombre de usuario no entre el rango (8-15 caracteres)$"
        UnExist  db  "El usuario no debe de existir$"
        CaracteresP db "Los unicos caracteres permitidos fuera del alfabeto son -_.$"
        ;MENSAJES DE CONTRASEÑA CON ESTRUCTURA INCORRECTA
        unaM db "Password  debe de tener al menos una mayuscula$"
        unN db "Password debe de tener al menos un Numero$"
        unS db "Password  debe de tener al menos una !>%",59t,"*$"
        lengtherror2 db "Tamanio de contrasenia no entre el rango (8-15 caracteres)$"

    ; Opcion escogida del menu
    opcion db 0 
    dollar db '$'
    ;STRING DE UN NUMERO Y NUMERO DE UN STRING 
    stringNumactual db 20 dup (24)
    Numactual dw 0 
    auxs db "$"
    espacio db " ","$"
    retroceso db 08, "$"

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
    ;FECHA 
    dia db 4 dup (0)
    mes db 4 dup (0)
    anio db 4 dup (0)
    hora db 4 dup (0)
    min db 4 dup (0)
    segun db 4 dup (0)
    year dw 0
    month dw 0
    day  dw 0
    hours dw 0
    minutes dw 0
    seconds dw 0
    ;CONTADOR DELAY
    cdelay db 0

    ;PARA LA COMPARACION DE CADENAS
    cadIguales db 0
    ;DEBUGER
    eProgram db "PROGRAMA SE ENCUENTRA AQUI$"
endm 

mFlujoProyecto2 macro
    call pAjustarMemoria
        call pLimpiarConsola
        mMostrarString mensajeI
         ;apartado de espera de un enter----------------------
            EsperaEnter:
            mMostrarString espEnter
            mov ah,01
            int 21
            cmp al,0dh
            jne EsperaEnter ; SI NO ES UN ENTER SE REPETIRA, CUANDO YA VENGA LA MACRO SEGUIRA SU CURSO NORMAL
            ;---------------------------------------------------
        call pLimpiarConsola
        mFlujoMenu 
    call pRetControl
endm 

mFlujoMenu macro
    local ciclomenu,salir    
    ciclomenu: 
        mov opcion,0
        mMostrarString Menu
        mMostrarString eProgram
        mov ah,01
        int 21
        mov opcion,al 
        cmp opcion,"C"
        je salir
        jmp ciclomenu
    Login:

    Register:

    salir: 
endm


;Imprime variables
mMostrarString macro var 
    push dx
    push ax
    xor ax,ax
    mov dx,ax 
    lea dx, var
    mov ah, 09
    int 21
    pop ax
    pop dx 
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
    local salir,capturarLetras,deletCaracter
    mov si,0
    capturarLetras:
        mov ah,01h
        int 21h
        cmp al, 0dh ;es igual a enter?
        je salir ; una vez dado enter y capturado todo el nombre, pasar al siguiente procedimiento
        cmp al, 08 ;es igual a retroceso?
        je deletCaracter
        mov variableAlmacenadora[si],al
        inc si
        jmp capturarLetras
    deletCaracter:
        cmp si,0
        je capturarLetras
        mov variableAlmacenadora[si],24
        dec si 
        mMostrarString espacio ; " "
        mMostrarString retroceso ;"<-"
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
    xor ax,ax
    mov bx,ax 
    mov al,var1
    mov bl,var2
    cmp al,bl
    pop bx
    pop ax
endm 

mSumar macro var1,var2
    push ax 
    xor ax,ax 
    mov ax,var1
    add ax,var2
    mov var1,ax 
    pop ax 
endm 
;Resta dos variables
mResta macro var1,var2
    push ax 
    xor ax,ax 
    mov ax, var1 
    sub ax, var2
    mov var1, ax 
    pop ax 
endm 
;Multiplicacion
mMultiplicacion macro var1,var2
    push ax
    push bx 
    xor ax,ax 
    xor bx,bx 
    mov ax,var1
    mov bx, var2
    mul bx
    mov var1,ax  
    pop bx
    pop ax 
endm 



;Division
mModdb macro var1,var2
;CUANDO SE LEEN ARCHIVOS LOS 4 REGISTROS SON AFECTADOS 
    push ax
    push bx 
    xor ax,ax
    mov bx,ax 
    mov al, var1
    mov bl, var2
    div bl
    mov var2, ah 
    pop bx 
    pop ax 
endm


MovVariablesDw macro var1,var2
    push dx
    mov dx,0
    mov dx,var2
    mov var1, dx ; SE INGRESA A LA NUEVA POSICION EL SIMBOLO ACTUAL
    pop dx 
endm

mDelay macro  
    local salir,ciclodelay 
    mov cdelay,0
    pop ax 
    pop dx 
    ciclodelay:
        mov ah,2Ch
        int 21h
        mov cdelay,dh ;SEGUNDOS  
        cmp cdelay,30t ; dara 0 en el mod si CDELAY ES UN MULTIPLO DE 30 POR LO CUAL PASARON 30 SEGUNDOS
        je salir   
        jmp ciclodelay 
    salir: 
    push ax 
    push dx 
endm 

;macro para rellenar las variables de tiempo
mFechaTime macro
    push bx 
    xor bx,bx
    ;dia,mes,anio,hora,min,segun
    mov ah,2Ah   
    int 21h 
    mov year,cx  ;valor numerico de año
    mov bl, dh   ;valor numerico de mes
    mov month,bx  
    mov bl, dl   ;valor numerico de dia
    mov day,bx   

    mov ah,2Ch
    int 21h
    mov bl, ch  ;valor numerico de horas
    mov hours,bx 
    mov bl, cl   ;valor numerico de minutos
    mov minutes,bx 
    mov bl, dh   ;valor numerico de segundos
    mov seconds,bx 
    
    ;CONVERSION DE NUMEROS A VARIABLES
    Num2String year, anio
    Num2String month, mes
    Num2String day, dia
    Num2String hours, hora
    Num2String minutes,min
    Num2String seconds,segun 
    pop bx 
endm
