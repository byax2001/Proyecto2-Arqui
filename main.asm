include macro.asm   
.MODEL small
.STACK
.RADIX 16
.DATA
;APARTADO PARA LA DECLARACION DE VARIABLES Y LISTAS
mVariables
.CODE
;APARTADO PARA EL CODIGO
start:
    main proc
        mFlujoProyecto2
    main endp

;METODO PARA LIMPIAR LA CONSOLA 
pLimpiarConsola proc 
    push ax
    push bx
    push cx
    push dx 
    ;Limpia la consola 
    mov ax,0600h ; es igual a mov ah,06 (scroll up windows con el int 10)  y mov al,00
    mov bh, 07   
    mov cx, 00000  ; es igual a mov ch,0   mov cl, 0 , filas y coumnas de derecha a izquierda
    mov dx, 184FH  ;filas y columnas de both 
    int 10
    ;posiciona el cursor en la pos 0
    mov ah, 02
    mov bh,0  ;numero de pagina
    mov dl,0   ;columna
    mov dh,0   ;fila 
    int 10
    pop dx
    pop cx
    pop bx
    pop ax 
    ret 
pLimpiarConsola  endp 
;PROC PARA DEVOLVER EL CONTROL AL SISTEMA
pRetControl proc
    mov al, 10  
    mov ah, 4C  
    int 21
    ret
pRetControl endp
;PROC PARA AJUSTAR LA MEMORIA AL SISTEMA
pAjustarMemoria proc 
    mov dx, @DATA
    mov ds,dx
    mov es,dx
    ret
pAjustarMemoria endp
;PROC PARA CREAR BASE DE DATOS USUARIOS, SCORES
pBaseDatos proc
    mCrearFile usersb
    mWriteToFile adminG
    mCloseFile
    mCrearFile scoresb
    mCloseFile
    ret 
pBaseDatos endp 
;PROC PARA DELAY DE 30 SEGUNDOS CON IMPRESION DE SEGUNDOS EN LA CONSOLA 
pDelay30 proc  
    push ax 
    push dx 
    mov valort1,0
    mov auxt, 0
    mov valort2,0
    mov contadort,0
    ;SE TOMA EL VALOR DE T1 
    mov ah,2Ch
    int 21h
    mov valort1,dh  ;VALOR 1 TOMA UN TIEMPO INICIAL
    ciclodelay:
        mov dx,ax 
        mov ah,2Ch
        int 21h
        mov valort2,dh  ;VALOR 2 TOMA OTRO TIEMPO DESPUES DE VALOR 1
        movVariables auxt,valort2 
        mModdb valort1,2 ;para saber si es par o impar el  valor 1 
        mModdb valort2,2 ;para saber si es par o impar el valor 2
        mComparar valort1,valort2 ;EL CICLO SE REPETIRA HASTA QUE SEAN DISTINTOS
        jne segundo ;ES DISTINTO POR LO CUAL YA CAMBIO DE SEGUNDO 
        jmp ciclodelay
        segundo:
            mLimpiar StringNumT,4,24 ;SE LIMPIA EL STRING QUE ALMACENARA EL SEGUNDO
            Num2String contadort,StringNumT ;SE PASA EL CONTADOR ACTUAL A STRING 
            mMostrarString StringNumT ;SE IMPRIME EL STRING DEL CONTADOR 
            cmp contadort,30t ;CONTADOR ES IGUAL A 30?
            jae salir  ;SI, SALIR 
            MovVariables valort1,auxt ;NO, ENTONCES VALORT1=auxt (que contiene el valor2 sin el efecto de mod)
            mSumarDw contadort,1t ; SE LE SUMA UNO AL CONTADOR 
            jmp ciclodelay
    salir: 
        pop dx
        pop ax 
    ret 
pDelay30 endp 

pAlmacenaruser proc
    mOpenFile2Write usersb
    call pFinaldoc
    mWriteToFile UsuarioRegis
    mWriteToFile separador
    mWriteToFile PasswordRegis
    mWriteToFile separador
    mWriteToFile Numerrordef
    mWriteToFile separador 
    mWriteToFile Bloqdef
    mWriteToFile separador
    mWriteToFile admindef
    mWriteToFile enterg 
    mCloseFile
    ret 
pAlmacenaruser endp 

pincSizePila proc
    push dx 
    xor dl,dl 
    mov dl,sizePila
    add dl,1
    mov sizePila,dl 
    pop dx 
    ret
pincSizePila endp 

pdecSizePila proc
    push dx
    xor dl,dl
    mov dl,sizePila
    sub dl,1
    mov sizePila,dl 
    pop dx 
    ret
pdecSizePila endp 


pEspEnter proc
    push ax 
    cicloEspEnter:
        mMostrarString espEnter
        mov ah,01
        int 21
        cmp al,0dh
        jne cicloEspEnter ; SI NO ES UN ENTER SE REPETIRA EL CICLO
    pop ax 
    ret 
pEspEnter endp
;RESETEAR LAS BANDERA QUE INDICAN LOS ERRORES EN EL REGISTRO 
pResetFlagsE proc
    ;ERRORES USUARIO
    mov numinicio,0  
    mov largoe,0  
    mov existee,0  
    mov caractNp,0   ;caracteres no permitidos para el usuario
    ;CARACTERISTICAS PASSWORD
    mov mayuse,0 
    mov nume,0  
    mov sinCaractE,0  ;caracteres especiales faltantes en la contraseña
    mov largoe2,0  
    ;EXISTE ERROR
    mov enrango,0 
    mov eerror,0 
    mov contadoraux,0 
    ret 
pResetFlagsE endp


;cx: me coloco en esta posicion --- dx: me mueve tantas cantidades de posiciones desde la posicion de cx
;cx:1 me quedo en la posicion actual  dx:  me mueve tantas cantidades de posiciones desde la posicion de cx
;cx:0 inicio
;cx:2 final de archivo
pInidoc proc
    mov al,0
    mov bx,handler
    mov cx,0
    mov dx,0
    mov ah,42h
    int 21 
    ret
pInidoc endp 

pFinaldoc proc
    mov al,2
    mov bx,handler
    mov cx,-1
    mov dx,-1
    mov ah,42h
    int 21 
    ret
pFinaldoc endp 

;coloca el documento una posiciona anterior al lugar actual leido 
pPosAnterior proc
    mov al,1
    mov bx,handler
    mov cx,-1
    mov dx,-1
    mov ah,42h
    int 21 
    ret
pPosAnterior endp 


;user db "Nombre",01,"Contraseña",01,Numero de veces que se equivoco,01,"Bloqueado/n","Admin/n" enter (0A)
   
;AUMENTA EL NUMERO DE VECES QUE SE EQUIVOCO
pIncVEquivoco proc
    mHallarSimbolo separador ; esta situado en la posicion de contraseña solo es necesario buscar una vez el separador 
    mReadFile eleActual; saltarse el separador 
    cmp eleActual,33h ;no se suma si es exactamente 3 el numero de veces que se equivoco
    je salir 
    mSumardb eleActual,1
    call pPosAnterior
    mWriteToFile eleActual
    salir: 
    ret 
pIncVEquivoco endp 

;DAR BLOQUEO 
pDarbloqueo proc 
    ;ya que dar bloqueo va despues de incrementar veces que se equivoco solo se busca una vez el separador
    cmp eleActual,33h
    jne nobloquear 
    mHallarSimbolo separador
    mWriteToFile BloqueoU
    jmp salir 
    nobloquear: ;si no se bloquea al menos se debe de desplazar la misma cantidad de espacios de como
    ;si se hubiera bloqueado 
        mHallarSimbolo separador
        mReadFile eleActual
    salir: 
    ret 
pDarbloqueo endp

;QUITAR BLOQUEO ADMIN
pQuitarbloqAdmin proc
    mHallarSimbolo separador
    mWriteToFile Nequivdef
    mHallarSimbolo separador
    mWriteToFile Bloqdef
    ret
pQuitarbloqAdmin endp 




;QUITAR BLOQUEO
pQuitarbloqueo proc
    call pLimpiarConsola
    mLimpiar Umoderado,25,24
    mOpenFile2Write usersb 
    call pResetFlagsE
    mMostrarString usDesBloq
    mCapturarString Umoderado; CAPTURAR STRING DE USUARIO
    call pExisteUserM
    cmp existee,0 ;no existe el usuario ingresado?
    je Unoexiste ; no existe, entonces marca error y se sale
    ;SI EXISTE, ENTONCES EL ARCHIVO YA SE ENCUENTRA POSICIONADO EN EL ESPACIO DESEADO 
    mHallarSimbolo separador; contraseña
    mHallarSimbolo separador ; n veces error
    mHallarSimbolo separador; B/n 
    mReadFile eleActual
    cmp eleActual, "N" ; no bloqueado
    je noBloqAnt
    call pPosAnterior ; separador antes de B/n
    call pPosAnterior ;n veces error
    call pPosAnterior ; separador antes de n veces eror
    mWriteToFile Nequivdef
    mHallarSimbolo 01
    mWriteToFile Bloqdef
    mMostrarString Udesbloqueado
    call pEspEnter
    jmp salir 
    noBloqAnt:
        mMostrarString Unoblock ;el usuario no estaba bloqueado 
        call pEspEnter
        jmp salir 
    Unoexiste:
    mMostrarString MsgUnE ;usuario no existe
    call pEspEnter
    jmp salir 
    salir: 
    mCloseFile
    ret
pQuitarbloqueo endp 

;DAR ADMIN
pDarAdmin proc 
    call pLimpiarConsola
    mLimpiar Umoderado,25,24
    mOpenFile2Write usersb
    call pResetFlagsE
    mMostrarString usDarAdmin
    mCapturarString Umoderado; CAPTURAR STRING DE USUARIO
    call pExisteUserM
    cmp existee,0 ;no existe el usuario ingresado?
    je Unoexiste ; no existe, entonces marca error y se sale
    ;SI EXISTE, ENTONCES EL ARCHIVO YA SE ENCUENTRA POSICIONADO EN EL ESPACIO DESEADO 
    mHallarSimbolo separador; contraseña
    mHallarSimbolo separador ; n veces error
    mHallarSimbolo separador; B/n 
    mHallarSimbolo separador; separador antes de Admin/No admin 
    mReadFile eleActual
    cmp eleActual, "A" ; el elemento es admin
    je AdminAnt
    call pPosAnterior ; separador antes de Admin/No admin
    mWriteToFile AdminU
    mMostrarString Udadoadmin
    call pEspEnter
    jmp salir 
    AdminAnt:
        mMostrarString Uadmin ;el usuario ya era admin
        call pEspEnter
        jmp salir 
    Unoexiste:
    mMostrarString MsgUnE ;usuario no existe
    call pEspEnter
    jmp salir 
    salir: 
    mCloseFile
    ret
pDarAdmin endp 

;QUITAR ADMIN
pQuitarAdmin proc
    call pLimpiarConsola
    mLimpiar Umoderado,25,24
    mOpenFile2Write usersb
    call pResetFlagsE
    mMostrarString usQuitarAdmin
    mCapturarString Umoderado; CAPTURAR STRING DE USUARIO
    call pExisteUserM
    cmp existee,0 ;no existe el usuario ingresado?
    je Unoexiste ; no existe, entonces marca error y se sale
    ;SI EXISTE, ENTONCES EL ARCHIVO YA SE ENCUENTRA POSICIONADO EN EL ESPACIO DESEADO 
    mHallarSimbolo separador; contraseña
    mHallarSimbolo separador ; n veces error
    mHallarSimbolo separador; B/n 
    mHallarSimbolo separador; separador antes de Admin/No admin 
    mReadFile eleActual
    cmp eleActual, "N" ; el elemento es admin
    je AdminAnt
    call pPosAnterior ; separador antes de Admin/No admin
    mWriteToFile admindef
    mMostrarString UquitAdmin
    call pEspEnter
    jmp salir 
    AdminAnt:
        mMostrarString uNoAdmin ;el usuario no era admin
        call pEspEnter
        jmp salir 
    Unoexiste:
    mMostrarString MsgUnE ;usuario no existe
    call pEspEnter
    jmp salir 
    salir: 
    mCloseFile
    ret

pQuitarAdmin endp 

pExisteUserM proc 
    ;SE VERIFICA SI NO ES EL ADMIN
    mReadFile eleActual ;TOMA EL PRIMER VALOR DEL ARCHIVO 
    mEncontrarId Umoderado;lo primero en el documento de usuarios es el admin, que siempre estara aca
    cmp idEncontrado,1 ; se encontro usuario? 
    je Existe ;si se encontro se procede a decir que si existe el usuario y se marcara como error
    cicloexiste: ;caso contrario se procedera a un ciclo de lectura del archivo hasta hallar o un espacio o el id buscado
        mHallarSimbolo 0A  ;se salta hasta el enter hasta la posicion donde esta 0A
        mReadFile eleActual ; se corre una vez el elemento 
        cmp eleActual," " ;si hay un espacio es que ya se llego al fin del documento y el usuario no existe
        ;CADA VEZ QUE SE CREA UN USUARIO SE ELIMINA EL ULTIMO ESPACIO QUE DEJA LA CREACION DEL USUARIO ANTERIOR
        je Noexiste ; no existe usuario
        mEncontrarId Umoderado ;si no es espacio lo que esta en esta posicion fijo es un nombre de user, el user a registrar  es igual a este? 
        cmp idEncontrado,1 ; si, entonces existe 
        je Existe 
        jne cicloexiste 
    Existe:
        mov existee,1 ;se reporta error pues existe usuario que se intenta registrar
        mov eerror,1  ;se reporta error general al registro
        jmp salir 
    Noexiste:
        mov existee, 0 ; no existe usuario, no hay error
    salir:
    ret 
pExisteUserM endp 

;APARTADOS PARA LA MANIPULACION DE TEXTO Y JUEGOS
;POR DEFAULT DOSBOX SE MANEJA CON EL TEXT MODE, SI SE DESEA VOLVER AL MODO NORMAL LUEGO DEL MODO VIDEO VOLVER
;A INSTANCIAR ESTE METODO 
pTextMode proc
    push ax
    mov ax, 03
    int 10h
    pop ax 
    ret 
pTextMode endp 
;PARA EL JUEGO SE DEBE DE CAMBIAR A MODO VIDEO 
pVideoMode proc
    push ax
    mov ax, 13
    int 10h
    pop ax 
    ret 
pVideoMode endp 
;PARA PONER LA MEMORIA DE VIDEO EN "ES" 
pMemVideoMode proc
    push dx
    mov dx, 0A000
    mov es,dx 
    pop dx 
    ret 
pMemVideoMode endp 
;METODO PARA PONER EL SEGMENTO DE DATOS EN "ES" 
pDataS_ES proc
    push dx
    mov dx, @DATA
    mov es,dx 
    pop dx 
    ret 
pDataS_ES endp 

pGame proc
    call pMemVideoMode
    call pVideoMode 
    ;CUADROS DIVISORES PARA EL JUEGO
                   ;FILA,COLUMNA,ANCHO,ALTO,COLOR
    mDrawRectangulo 1t,1t,120t,130t,1t
    mDrawRectangulo 132t,1t,120t,67t,1t
    mDrawRectangulo 1t,121t,200t,198t,1t
    
    call pMovimientoGame
    ;call pDrawEborrado
    
    call pTextMode
    ret
pGame endp



pMovimientoGame proc
    mov auxfpsT,0
    reset: 
    ;RESTAURA LA VIDA DE TODOS LOS ENEMIGOS 
    call pRestartLifeEnemy
    ;LETREROS PRINCIPALES
    mImprimirLetreros Usergame,1t,1t,9t
    
    mImprimirLetreros Leveltitle,4t,1t,9t
    mImprimirLetreros Scoregame,7t,1t,9t
    mImprimirLetreros Timegame,10t,1t,9t
    mImprimirLetreros Livesgame,13t,1t,9t
    mImprimirLetreros PressSpace,18t,1t,9t
    mImprimirLetreros toStartG,20t,1t,9t
    ;COORDENADAS INICIALES PARA LOS ENEMIGOS Y NAVE PRINCIPAL 
    mov cNave_x,185t
    mov cNave_y,220t
    mov ce1_x,20t  
    mov ce1_y,140t   
    mov ce2_x,20t   
    mov ce2_y,140t   
    mov ce3_x,20t 
    mov ce3_y,140t 
    mov estEnem,1  ;para que se empiece moviendo el enemigo 1 
    fps:
        mov ah,2Ch
        int 21
        cmp dl, auxfpsT
        je fps
    mov auxfpsT, dl 
    ;MOVIMIENTOS 
    call pMovNave
    call pDrawNaveBorr
    call pDrawNave
    mImprimirLetreros mingame,2t,1t,9t 
    ;MOVIMIENTO DE ENEMIGO  
    cmp estEnem,1
    jne NoDespenemigos1
    DespEnemigos1:
        call pMovEnemigo1
    NoDespenemigos1:
    cmp estEnem,2
    jne NoDespenemigos2
    DespEnemigos2:
        call pMovEnemigo2
    NoDespenemigos2:
    cmp estEnem,3
    jne NoDespenemigos3
    DespEnemigos3:
        call pMovEnemigo3
    NoDespenemigos3:
    ;MOVIMIENTO DE BALAS
    cmp estD1,0
    je sinAccion
    movBala1: 
        call pMovbala
        jmp sinAccion
    sinAccion: 
    jmp fps 
    ret 
pMovimientoGame endp 
;FILAS DE ENEMIGOS---------------------------------------------------------------------------

pFilaEnemigo1 proc
    push ax  
    push dx 
    ;mov ce1_x,30t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce1_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx,ce1_y  
    mov ax,ce1_x
    ;DIBUJAR NAVE 1
        cmp elife11,1 ;saber si esta vivo si no,no graficar
        jne Enovivo1
        call pDrawEnemigo1
        mov ce1_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo1:
        mIncVar ce1_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 2
        cmp elife12,1 ;saber si esta vivo si no,no graficar 
        jne Enovivo2
        call pDrawEnemigo1
        mov ce1_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo2:
        mIncVar ce1_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 3
        cmp elife13,1 ;saber si esta vivo si no,no graficar
        jne Enovivo3
        call pDrawEnemigo1
        mov ce1_x,ax ;volver a la fila original para graficar otro ahi mismo 
        Enovivo3:
        mIncVar ce1_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 4
        cmp elife14,1 ;saber si esta vivo si no,no graficar
        jne Enovivo4
        call pDrawEnemigo1
        mov ce1_x,ax;volver a la fila original para graficar otro ahi mismo 
        Enovivo4:
        mIncVar ce1_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 5
        cmp elife15,1 ;saber si esta vivo si no,no graficar
        jne Enovivo5
        call pDrawEnemigo1
        mov ce1_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo5:
        mIncVar ce1_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 6
        cmp elife16,1 ;saber si esta vivo si no,no graficar
        jne Enovivo6
        call pDrawEnemigo1 
        mov ce1_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo6:
        mIncVar ce1_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 7
        cmp elife17,1 ;saber si esta vivo si no,no graficar
        jne Enovivo7
        call pDrawEnemigo1
        mov ce1_x,ax ;volver a la fila original 
        Enovivo7:

    mov ce1_y,dx;para escribir cada elemento en la misma columna  
    pop dx 
    pop ax 
    ret 
pFilaEnemigo1 endp 

pFilaEnemigo2 proc
    push ax  
    push dx 
    push cx
    mov cx, 7
    ;mov ce2_x,60t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce2_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx,ce2_y  
    mov ax,ce2_x
    ;DIBUJAR NAVE 1
        cmp elife21,1 ;saber si esta vivo si no,no graficar
        jne Enovivo1
        call pDrawEnemigo2
        mov ce2_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo1:
        mIncVar ce2_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 2
        cmp elife22,1 ;saber si esta vivo si no,no graficar 
        jne Enovivo2
        call pDrawEnemigo2
        mov ce2_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo2:
        mIncVar ce2_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 3
        cmp elife23,1 ;saber si esta vivo si no,no graficar
        jne Enovivo3
        call pDrawEnemigo2
        mov ce2_x,ax ;volver a la fila original para graficar otro ahi mismo 
        Enovivo3:
        mIncVar ce2_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 4
        cmp elife24,1 ;saber si esta vivo si no,no graficar
        jne Enovivo4
        call pDrawEnemigo2
        mov ce2_x,ax;volver a la fila original para graficar otro ahi mismo 
        Enovivo4:
        mIncVar ce2_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 5
        cmp elife25,1 ;saber si esta vivo si no,no graficar
        jne Enovivo5
        call pDrawEnemigo2
        mov ce2_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo5:
        mIncVar ce2_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 6
        cmp elife26,1 ;saber si esta vivo si no,no graficar
        jne Enovivo6
        call pDrawEnemigo2 
        mov ce2_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo6:
        mIncVar ce2_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 7
        cmp elife27,1 ;saber si esta vivo si no,no graficar
        jne Enovivo7
        call pDrawEnemigo2
        mov ce2_x,ax ;volver a la fila original 
        Enovivo7:    
    mov ce2_y, dx
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo2 endp 

pFilaEnemigo3 proc
    push ax  
    push dx 
    push cx
    mov cx, 7 ;cx es el contador de cuantas veces el loop se repetira 
    ;mov ce3_x,90t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce3_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx, ce3_y
    mov ax, ce3_x
    ;DIBUJAR NAVE 1
        cmp elife31,1 ;saber si esta vivo si no,no graficar
        jne Enovivo1
        call pDrawEnemigo3
        mov ce3_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo1:
        mIncVar ce3_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 2
        cmp elife32,1 ;saber si esta vivo si no,no graficar 
        jne Enovivo2
        call pDrawEnemigo3
        mov ce3_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo2:
        mIncVar ce3_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 3
        cmp elife33,1 ;saber si esta vivo si no,no graficar
        jne Enovivo3
        call pDrawEnemigo3
        mov ce3_x,ax ;volver a la fila original para graficar otro ahi mismo 
        Enovivo3:
        mIncVar ce3_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 4
        cmp elife34,1 ;saber si esta vivo si no,no graficar
        jne Enovivo4
        call pDrawEnemigo3
        mov ce3_x,ax;volver a la fila original para graficar otro ahi mismo 
        Enovivo4:
        mIncVar ce3_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 5
        cmp elife35,1 ;saber si esta vivo si no,no graficar
        jne Enovivo5
        call pDrawEnemigo3
        mov ce3_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo5:
        mIncVar ce3_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 6
        cmp elife36,1 ;saber si esta vivo si no,no graficar
        jne Enovivo6
        call pDrawEnemigo3 
        mov ce3_x,ax ;volver a la fila original para graficar otro ahi mismo
        Enovivo6:
        mIncVar ce3_y,28t ;aumentar siempre la columna a graficar para el siguiente
    ;DIBUJAR NAVE 7
        cmp elife37,1 ;saber si esta vivo si no,no graficar
        jne Enovivo7
        call pDrawEnemigo3
        mov ce3_x,ax ;volver a la fila original 
        Enovivo7:    
    mov ce3_y, dx 
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo3 endp 

pFilaE1borrado proc
    push cx
    push ax
    push dx 
    mov cx, 7 ;cx es el contador de cuantas veces el loop se repetira 
    ;mov borrx,90t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov borry,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov ax, borrE1x ;aux para reestablecer el valor de la fila escogida 
    mov dx, borrE1y
    filaE:
        call pDrawEborrado
        mIncVar borrE1y,28t
        MovVariablesDw borrE1x, ax ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
        loop filaE
    MovVariablesDw borrE1y, dx 
    pop dx
    pop ax 
    pop cx 
    ret 
pFilaE1borrado endp 
;DRAW--------------------------------------------------------------------------------
pDrawEnemigo1 proc
    ;punta sur del enemigo
    push ax
    push dx
    ;mov ce1_x,30t   
    ;mov ce1_y,140t  
    mov ax, ce1_x
    mov dx, ce1_y
    mDecVar ce1_y,4
    mDrawPixel ce1_x,ce1_y,01
    mIncVar ce1_y,7
    mDrawPixel ce1_x,ce1_y,01
    ;fila anterior 
    dec ce1_x
    mDecVar ce1_y,7
    mDrawPixel ce1_x,ce1_y,01
    inc ce1_y
    inc ce1_y
    mDrawPixel ce1_x,ce1_y,01
    inc ce1_y
    inc ce1_y
    inc ce1_y
    mDrawPixel ce1_x,ce1_y,01
    inc ce1_y
    inc ce1_y
    mDrawPixel ce1_x,ce1_y,01
    ;fila anterior
    dec ce1_x
    mDecVar ce1_y,6
    mDrawFila ce1_x,ce1_y,01,2t 
    inc ce1_y
    inc ce1_y
    mDrawFila ce1_x,ce1_y,01,2t
    ;fila anterior
    dec ce1_x
    mDecVar ce1_y,7
    mDrawFila ce1_x,ce1_y,01,8t
    ;fila anterior
    dec ce1_x
    mDecVar ce1_y,7
    mDrawPixel ce1_x,ce1_y,01
    inc ce1_y
    inc ce1_y
    mDrawFila ce1_x,ce1_y,01,2t
    inc ce1_y
    mDrawPixel ce1_x,ce1_y,01
    ;fila anterior 
    dec ce1_x
    mDecVar ce1_y,4t
    mDrawFila ce1_x,ce1_y,01,4t
    ;antenas
    dec ce1_x
    mDecVar ce1_y,5
    mDrawPixel ce1_x,ce1_y,01
    mIncVar ce1_y,5t
    mDrawPixel ce1_x,ce1_y,01
    mov ce1_x,ax
    mov ce1_y,dx
    pop dx
    pop ax
    
    ret 
pDrawEnemigo1 endp 

pDrawEnemigo2 proc 
    push ax
    push dx
    ;mov ce2_x,40t 
    ;mov ce2_y,140t   
    mov ax, ce2_x
    mov dx, ce2_y
    ;parte sur del enemigo
    mDecVar ce2_y,4t
    mDrawPixel ce2_x,ce2_y,2t
    inc ce2_y
    inc ce2_y
    mDrawPixel ce2_x,ce2_y,2t
    inc ce2_y
    inc ce2_y
    inc ce2_y
    mDrawPixel ce2_x,ce2_y,2t
    inc ce2_y
    inc ce2_y
    mDrawPixel ce2_x,ce2_y,2t
    ;fila anterior
    dec ce2_x
    mDecVar ce2_y, 6t
    mDrawFila ce2_x,ce2_y,2t,2
    inc ce2_y
    inc ce2_y
    mDrawFila ce2_x,ce2_y,2t,2
    ;fila anterior 
    dec ce2_x
    mDecVar ce2_y, 7t
    mDrawFila ce2_x,ce2_y,2t,8t
    ;fila de los ojos  
    dec ce2_x
    mDecVar ce2_y, 8t
    mDrawPixel ce2_x,ce2_y,2t
    mIncVar ce2_y,3
    mDrawFila ce2_x,ce2_y,2t,2t
    mIncVar ce2_y,2
    mDrawPixel ce2_x,ce2_y,2t
    ;fila anterior 
    dec ce2_x
    mDecVar ce2_y, 6t
    mDrawFila ce2_x,ce2_y,2t,6t
    ;Antenas
    dec ce2_x
    mDecVar ce2_y, 5t
    mDrawPixel ce2_x,ce2_y,2t
    inc ce2_y
    inc ce2_y
    inc ce2_y
    mDrawPixel ce2_x,ce2_y,2t
    ;Antenas2 
    dec ce2_x
    mDecVar ce2_y, 4t
    mDrawPixel ce2_x,ce2_y,2t
    mIncVar ce2_y,5t
    mDrawPixel ce2_x,ce2_y,2t
    ;fila anterior 
    dec ce2_x
    mDecVar ce2_y, 4t
    mDrawPixel ce2_x,ce2_y,2t
    inc ce2_y
    inc ce2_y
    inc ce2_y
    mDrawPixel ce2_x,ce2_y,2t
    mov ce2_x,ax
    mov ce2_y,dx
    pop dx
    pop ax
    
    ret 
pDrawEnemigo2 endp

pDrawEnemigo3 proc
    push ax
    push dx
    ;mov ce3_x,50t  
    ;mov ce3_y,140t   
    mov ax, ce3_x
    mov dx, ce3_y
    ;punta sur del enemigo
    dec ce3_y
    mDrawFila ce3_x,ce3_y,44t,2t 
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,3
    mDrawFila ce3_x,ce3_y,44t,4t 
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,5
    mDrawFila ce3_x,ce3_y,44t,6t 
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,7
    mDrawFila ce3_x,ce3_y,44t,2t 
    inc ce3_y
    mDrawFila ce3_x,ce3_y,44t,2t 
    inc ce3_y
    mDrawFila ce3_x,ce3_y,44t,2t
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,8
    mDrawPixel ce3_x,ce3_y,44t
    inc ce3_y
    inc ce3_y
    mDrawFila ce3_x,ce3_y,44t,4t
    inc ce3_y
    mDrawPixel ce3_x,ce3_y,44t
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,4
    mDrawFila ce3_x,ce3_y,44t,2t
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,4
    mDrawFila ce3_x,ce3_y,44t,2t
    inc ce3_y
    inc ce3_y
    mDrawFila ce3_x,ce3_y,44t,2t
    ;fila anterior 
    dec ce3_x
    mDecVar ce3_y,6
    mDrawPixel ce3_x,ce3_y,44t
    mIncVar ce3_y, 5t
    mDrawPixel ce3_x,ce3_y,44t
    mov ce3_x,ax
    mov ce3_y,dx
    pop dx
    pop ax
    ret 
pDrawEnemigo3 endp 

pDrawEborrado proc
    push cx
    push ax
    push dx 
    mov cx, 8
    mov ax, borrE1x
    mov dx, borrE1y 
    figuraB:
        mDecVar borrE1y,5t 
        mDrawFila borrE1x,borrE1y,0t,8     
        mov borrE1y, dx 
        dec borrE1x
        loop figuraB
    mov borrE1x,dx

    pop dx
    pop ax
    pop cx 
    ret
pDrawEborrado endp 

pDrawNave proc
    push ax
    push dx 
    mov ax,cNave_x
    mov dx, cNave_y
    ;CAÑON PRINCIPAL 
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_x 
    mDrawPixel cNave_x,cNave_y,15t
    ;CUERPO
    inc cNave_x
    dec cNave_y
    mDrawFila cNave_x,cNave_y,15t,3t
    inc cNave_x
    mDecVar cNave_y,4t
    mDrawFila cNave_x,cNave_y,15t,5t 
    inc cNave_x
    mDecVar cNave_y,6t
    mDrawFila cNave_x,cNave_y,15t,7t 
    ;VENTANAS PRINCIPALES NAVE 
    inc cNave_x
    mDecVar cNave_y,7t  
    mDrawFila cNave_x,cNave_y,15t,2t
    mDrawFila cNave_x,cNave_y,39t,3t
    mDrawFila cNave_x,cNave_y,15t,2t
    ;siguiente parte y parte de las ventanas 
    inc cNave_x 
    mDecVar cNave_y,9t
    mDrawFila cNave_x,cNave_y,15t,4t
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,4t
    ;otra parte 
    inc cNave_x
    mDecVar cNave_y,12t
    mDrawFila cNave_x,cNave_y,15t,13t

    ;otra parte 
    inc cNave_x
    mDecVar cNave_y,13t
    mDrawFila cNave_x,cNave_y,15t,2t 
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,7t 
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,2t 

    ;OTRA PARTE 
    inc cNave_x
    mDecVar cNave_y,14t
    mDrawFila cNave_x,cNave_y,15t,2t 
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,39t,2t 
    mDrawFila cNave_x,cNave_y,15t,3t 
    mDrawFila cNave_x,cNave_y,39t,2t 
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,2t
    ;11 filas 
    inc cNave_x
    mDecVar cNave_y,11t 
    mDrawFila cNave_x,cNave_y,39t,2t 
    inc cNave_y
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,39t,2t


    mov cNave_x,ax
    mov cNave_y,dx
    pop dx
    pop ax 
    ret 
pDrawNave endp 

pDrawBala1 proc
    push ax 
    push cx 
    mov ax, bala1x  
    mov cx,3
    ciclo:
        mDrawPixel bala1x,bala1y,25t
        inc bala1x
        loop ciclo 

    mov bala1x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala1 endp 

pDrawBala2 proc

    ret 
pDrawBala2 endp 

pDrawBala3 proc

    ret 
pDrawBala3 endp 

pDrawNaveBorr proc
    push ax
    push cx 
    ;12 filas x 15 columnas
    MovVariablesDw borrx, cNave_x
    MovVariablesDw borry, cNave_y
    mDecVar borry,8t
    mov ax, borry
    mov cx,12t
    ciclo:
        mDrawFila borrx,borry,00,17t
        mov borry,ax 
        inc borrx 
        loop ciclo 
    pop cx 
    pop ax 
    ret
pDrawNaveBorr endp

;MOV-------------------------------------------------------------------------------------
pMovNave proc
    push ax 
        mov ah,01 ;existe pulsascion o no?
        int 16h
        jz salir ; no hay pulsacion, salir 
        mov ah, 00  ;Espera a que se presione una tecla y la lee
        int 16h
        cmp al,"a"
        je movIzquierda
        cmp al,"A"
        je movIzquierda
        cmp al, "d"
        je movDerecha
        cmp al, "D"
        je movDerecha
        cmp al, "v"
        je Disparo1
        cmp al, "V"
        je Disparo1
        jmp salir 
    movIzquierda:
        cmp cNave_y,132t
        jb salir 
        dec cNave_y
        jmp salir 
    movDerecha:
        cmp cNave_y,310t
        ja salir 
        inc cNave_y  
        jmp salir   
    Disparo1:
        cmp estD1,1t 
        je salir 
        MovVariablesDw bala1x, cNave_x
        mDecVar bala1x,3t 
        movVariablesDw bala1y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        Num2String cNave_y,mingame; =================================================================00
        mov estD1,1
        jmp salir 
    salir: 
    pop ax 
    ret 
pMovNave endp 

pMovbala proc
    push ax
    push dx
    cmp bala1x,2 
    je  finmovimiento
    movnormal:

        dec bala1x
        dec bala1x
        ;OBTENER EL VALOR DE UN PIXEL 
        mov cx,bala1y ;column
        mov dx,bala1x ;fila 
        mov ah, 0Dh
        int 10h 
        cmp al,44t ;si es igual al enemigo tipo 2 desaparece la bala pues no es de mayor calibre
        je finmovimiento
        cmp al,2t ;si es igual al enemigo tipo 2 desaparece la bala pues no es de mayor calibre
        je finmovimiento

        mov dx,bala1x
        call pDrawBala1
        mIncVar bala1x,3t
        mDrawPixel bala1x,bala1y,0t
        inc bala1x
        mDrawPixel bala1x,bala1y,0t
        mov bala1x,dx 
        jmp salir 
    finmovimiento:
        mDrawPixel bala1x,bala1y,0t
        inc bala1x
        mDrawPixel bala1x,bala1y,0t
        inc bala1x
        mDrawPixel bala1x,bala1y,0t
        inc bala1x
        mDrawPixel bala1x,bala1y,0t
        mov estD1,0
    salir: 
    pop dx 
    pop ax  
    ret
pMovbala endp  

pMovEnemigo1 proc
    movVariablesDw borrE1x,ce1_x
    movVariablesDw borrE1y,ce1_y
    call pFilaEnemigo1
    mDrawBfila borrE1x , borrE1y,elife11,elife12,elife13,elife14,elife15,elife16,elife17
    ;call pFilaE1borrado 
    cmp ce1_x, 196t
    ja finMov 
    inc ce1_x
    call pFilaEnemigo1
    jmp salir 
    finMov: 
        mov estEnem,2
    salir: 
    ret
pMovEnemigo1 endp 

pMovEnemigo2 proc
    movVariablesDw borrE2x ,ce2_x
    movVariablesDw borrE2y,ce2_y
    mDrawBfila borrE2x , borrE2y ,elife21,elife22,elife23,elife24,elife25,elife26,elife27
    ;call pFilaE1borrado 
    cmp ce2_x, 196t
    ja finMov 
    inc ce2_x
    call pFilaEnemigo2
    jmp salir 
    finMov: 
        mov estEnem,3
    salir: 
    ret
pMovEnemigo2 endp 

pMovEnemigo3 proc
    movVariablesDw borrE3x ,ce3_x
    movVariablesDw borrE3y,ce3_y
    mDrawBfila borrE3x , borrE3y,elife31,elife32,elife33,elife34,elife35,elife36,elife37 
    ;call pFilaE1borrado 
    cmp ce3_x, 196t
    ja finMov 
    inc ce3_x
    call pFilaEnemigo3
    jmp salir 
    finMov: 
        mov estEnem,0
    salir: 
    ret
pMovEnemigo3 endp 


;CONFIGURACIONES 
pRestartLifeEnemy proc  
    ;VIDA DE ENEMIGOS TIPO 1
    mov elife11,1
    mov elife12,1
    mov elife13,1
    mov elife14,1
    mov elife15,1
    mov elife16,1
    mov elife17,1
    ;VIDA DE ENEMIGOS TIPO 2
    mov elife21,1
    mov elife22,1
    mov elife23,1
    mov elife24,1
    mov elife25,1
    mov elife26,1
    mov elife27,1
    ;VIDA DE ENEMIGOS TIPO 3
    mov elife31,1
    mov elife32,1
    mov elife33,1
    mov elife34,1
    mov elife35,1
    mov elife36,1
    mov elife37,1
    ret
pRestartLifeEnemy endp 

END start 
