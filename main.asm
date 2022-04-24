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
    call pMovimientoGame
    call pTextMode
    ret
pGame endp

;#########################################################################################
pMovimientoGame proc
    mov auxfpsT,0
    reset: 
        call pConfigIni   
    fps: ;ciclo que provoca un movimiento cada centisegundo 
        mov ah,2Ch
        int 21
        cmp dl, auxfpsT
        je fps
    mov auxfpsT, dl
    call pDrawCleansCorazones
    call pDrawCorazones 
    cmp nivelGame,4 ; si se finalizo el 3 nivel, nivelgame llegara a 4 indicando que finalizo el juego 
    je gameover
    cmp liNave,0 ;si la vida de la nave llego a 0 es game over 
    je gameover
    ;MOVIMIENTO 
    
    call pLevel 
    call pScore
    call pTimeGame
    ;MOVIMIENTOS DE LA NAVE 
    call pMovNave
    call pDrawNaveBorr
    call pDrawNave
    cmp exitGame,1 ; si luego de una pausa se selecciono en salir del juego 
    je salir 

    ;IMPRESION DE ENEMIGOS-NIVELES  
    cmp printEnemyE,1 ;SI YA SE IMPRIMIO NO VOLVER A IMPRIMIR 
    je yaimpresoEnemy
    ;SE ESPERA A QUE EL USUARIO PRESIONE ESPACIO PARA PODER IMPRIMIR LOS ENEMIGOS Y SEGUIR CON EL RESTO DEL JUEGO  
        call pEspInicial

    call pDrawEnemigos ;SE IMPRIME ENEMIGOS 
    mov printEnemyE,1 ;SE MARCA QUE YA SE IMPRIMIO 
    ;COORDENADAS INICIALES PARA EL MOVIMIENTO DE ENEMIGOS 
        
        mov ce_x,45t
        mMultiplicacionDw ce_x,nivelGame
        mov ce_y, 140t
        mov filaIgame,45t  ;auxiliar que contendra la fila actual recorrida 
        mMultiplicacionDw filaIgame,nivelGame
    yaimpresoEnemy: 
    call pMovEnemys ;mover enemigos 

    ;MOVIMIENTO DE BALAS
    ;BALA 1 
        cmp estD1,0 ;no se tiene permitido imprimir la bala 
        je sinAccion
        ;si se tiene permitido disparar la bala 
            call pMovbala
        sinAccion: 
        cmp nivelGame,1
        je fps 
    ;BALA 2 
        cmp estD2,0 
        je sinAccion2 
        ;si se tiene permitido disparar la bala 
            call pMovbala2
        sinAccion2: 
        cmp nivelGame,2
        je fps 
    ;BALA 3  
        cmp estD3,0 
        je sinAccion3 ; si esta en 0 nos e tiene permitido mover la bala 
            call pMovbala3;si se tiene permitido mover la bala 
        sinAccion3: 
        jmp fps
    gameover:
        mImprimirLetreros letGover,8t,23t,15t ;imprimir letrero de game over 
        mImprimirLetreros letEsp,12t,18t,15t ;mensaje indicando accion a realizar 
        mWaitKey " "
    salir:
    ret 
pMovimientoGame endp 


;DRAW--------------------------------------------------------------------------------
pDrawCorazon proc
    push ax 
    push dx 
    mov ax,corazonx
    mov dx, corazony
    ;punta corazon 
    mDrawPixel corazonx,corazony,39t ;rojo
    ;fila de arriba 
    dec corazonx
    dec corazony
    mDrawFila corazonx,corazony,39t,3t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,4t 
    mDrawFila corazonx,corazony,39t,5t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,39t,7t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,7t
    mDrawFila corazonx,corazony,39t,7t
    ;fila de arriba  
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,39t,2t
    inc corazony
    mDrawFila corazonx,corazony,39t,2t
    mov corazonx,ax 
    mov corazony,dx 
    pop dx 
    pop ax 
    ret 
pDrawCorazon endp 

pDrawCleanCorazon proc
    push ax 
    push dx 
    mov ax,corazonx
    mov dx, corazony
    ;punta corazon 
    mDrawPixel corazonx,corazony,0t ;rojo
    ;fila de arriba 
    dec corazonx
    dec corazony
    mDrawFila corazonx,corazony,0t,3t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,4t 
    mDrawFila corazonx,corazony,0t,5t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,0t,7t
    ;fila de arriba 
    dec corazonx
    mDecVar corazony,7t
    mDrawFila corazonx,corazony,0t,7t
    ;fila de arriba  
    dec corazonx
    mDecVar corazony,6t
    mDrawFila corazonx,corazony,0t,2t
    inc corazony
    mDrawFila corazonx,corazony,0t,2t
    mov corazonx,ax 
    mov corazony,dx 
    pop dx 
    pop ax 
    ret 
pDrawCleanCorazon endp 

pDrawEnemigo1 proc
    ;punta sur del enemigo
    push ax
    push dx  
    mov ax, ce_x
    mov dx, ce_y
    mDecVar ce_y,4
    mDrawPixel ce_x,ce_y,01
    mIncVar ce_y,7
    mDrawPixel ce_x,ce_y,01
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,7
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    ;fila anterior
    dec ce_x
    mDecVar ce_y,6
    mDrawFila ce_x,ce_y,01,2t 
    inc ce_y
    inc ce_y
    mDrawFila ce_x,ce_y,01,2t
    ;fila anterior
    dec ce_x
    mDecVar ce_y,7
    mDrawFila ce_x,ce_y,01,8t
    ;fila anterior
    dec ce_x
    mDecVar ce_y,7
    mDrawPixel ce_x,ce_y,01
    inc ce_y
    inc ce_y
    mDrawFila ce_x,ce_y,01,2t
    inc ce_y
    mDrawPixel ce_x,ce_y,01
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,4t
    mDrawFila ce_x,ce_y,01,4t
    ;antenas
    dec ce_x
    mDecVar ce_y,5
    mDrawPixel ce_x,ce_y,01
    mIncVar ce_y,5t
    mDrawPixel ce_x,ce_y,01
    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    ret 
pDrawEnemigo1 endp 

pDrawEnemigo2 proc 
    push ax
    push dx
    ;mov ce_x,40t 
    ;mov ce_y,140t   
    mov ax, ce_x
    mov dx, ce_y
    ;parte sur del enemigo
    mDecVar ce_y,4t
    mDrawPixel ce_x,ce_y,2t
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,2t
    inc ce_y
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,2t
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,2t
    ;fila anterior
    dec ce_x
    mDecVar ce_y, 6t
    mDrawFila ce_x,ce_y,2t,2
    inc ce_y
    inc ce_y
    mDrawFila ce_x,ce_y,2t,2
    ;fila anterior 
    dec ce_x
    mDecVar ce_y, 7t
    mDrawFila ce_x,ce_y,2t,8t
    ;fila de los ojos  
    dec ce_x
    mDecVar ce_y, 8t
    mDrawPixel ce_x,ce_y,2t
    mIncVar ce_y,3
    mDrawFila ce_x,ce_y,2t,2t
    mIncVar ce_y,2
    mDrawPixel ce_x,ce_y,2t
    ;fila anterior 
    dec ce_x
    mDecVar ce_y, 6t
    mDrawFila ce_x,ce_y,2t,6t
    ;Antenas
    dec ce_x
    mDecVar ce_y, 5t
    mDrawPixel ce_x,ce_y,2t
    inc ce_y
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,2t
    ;Antenas2 
    dec ce_x
    mDecVar ce_y, 4t
    mDrawPixel ce_x,ce_y,2t
    mIncVar ce_y,5t
    mDrawPixel ce_x,ce_y,2t
    ;fila anterior 
    dec ce_x
    mDecVar ce_y, 4t
    mDrawPixel ce_x,ce_y,2t
    inc ce_y
    inc ce_y
    inc ce_y
    mDrawPixel ce_x,ce_y,2t
    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    
    ret 
pDrawEnemigo2 endp

pDrawEnemigo3 proc
    push ax
    push dx
    ;mov ce_x,50t  
    ;mov ce_y,140t   
    mov ax, ce_x
    mov dx, ce_y
    ;punta sur del enemigo
    dec ce_y
    mDrawFila ce_x,ce_y,44t,2t 
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,3
    mDrawFila ce_x,ce_y,44t,4t 
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,5
    mDrawFila ce_x,ce_y,44t,6t 
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,7
    mDrawFila ce_x,ce_y,44t,2t 
    inc ce_y
    mDrawFila ce_x,ce_y,44t,2t 
    inc ce_y
    mDrawFila ce_x,ce_y,44t,2t
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,8
    mDrawPixel ce_x,ce_y,44t
    inc ce_y
    inc ce_y
    mDrawFila ce_x,ce_y,44t,4t
    inc ce_y
    mDrawPixel ce_x,ce_y,44t
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,4
    mDrawFila ce_x,ce_y,44t,2t
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,4
    mDrawFila ce_x,ce_y,44t,2t
    inc ce_y
    inc ce_y
    mDrawFila ce_x,ce_y,44t,2t
    ;fila anterior 
    dec ce_x
    mDecVar ce_y,6
    mDrawPixel ce_x,ce_y,44t
    mIncVar ce_y, 5t
    mDrawPixel ce_x,ce_y,44t
    mov ce_x,ax
    mov ce_y,dx
    pop dx
    pop ax
    ret 
pDrawEnemigo3 endp 

pDrawNave proc
    push cx 
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
    cmp nivelGame,1 
    je salir 
    ;caño izquierdo 
        mIncVar cNave_x,5t 
        mDecVar cNave_y,7t 
        mDrawPixel cNave_x,cNave_y,39t
        mov cx,3t 
        canonizq:
            inc cNave_x
            mDrawPixel cNave_x,cNave_y,15t
        loop canonizq
        mov cNave_x,ax
        mov cNave_y,dx
        cmp nivelGame,2 
        je salir
    ;cañon derecho 
        mIncVar cNave_x,5t 
        mIncVar cNave_y,7t 
        mDrawPixel cNave_x,cNave_y,39t
        mov cx,3t 
        canonder:
            inc cNave_x
            mDrawPixel cNave_x,cNave_y,15t
        loop canonder
        mov cNave_x,ax
        mov cNave_y,dx 

    salir:     
    pop dx
    pop ax 
    pop cx 
    ret 
pDrawNave endp 

pDrawBala1 proc
    push ax 
    push cx 
    mov ax, bala1x  
    mov cx,3
    ciclo:
        mDrawPixel bala1x,bala1y,25t ;blanco 
        inc bala1x
        loop ciclo 

    mov bala1x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala1 endp 

pDrawBala2 proc
    push ax 
    push cx 
    mov ax, bala2x  
    mov cx,3
    ciclo:
        mDrawPixel bala2x,bala2y,5t ;morado
        inc bala2x
        loop ciclo 
    mov bala2x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala2 endp 

pDrawBala3 proc
    push ax 
    push cx 
    mov ax, bala3x  
    mov cx,3
    ciclo:
        mDrawPixel bala3x,bala3y,39t ;rojo
        inc bala3x
        loop ciclo 
    mov bala3x,ax 
    pop cx 
    pop ax 
    ret 
pDrawBala3 endp 
;BORRA EL MOVIMIENTO DE LA NAVE 
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

;FILAS DE ELEMENTOS --------------------------------------------------------------------------
pDrawCorazones proc 
    push cx 
    mov corazonx,125t
    mov corazony,60t
    mov cx, liNave ;vida de la nave
    cmp cx, 0
    je salir  
    corazones: 
        call pDrawCorazon
        mSumarDw corazony,14t
        mov corazonx,125t
        loop corazones
    salir: 
    pop cx 
    ret 
pDrawCorazones endp 
;PARA LIMPIAR LOS CORAZONES 
pDrawCleansCorazones proc 
    push cx 
    mov corazonx,125t
    mov corazony,60t
    mov cx, 3t
    je salir  
    corazones: 
        call pDrawCleanCorazon
        mSumarDw corazony,14t
        mov corazonx,125t
        loop corazones
    salir: 
    pop cx 
    ret 
pDrawCleansCorazones endp 

pFilaEnemigo1 proc
    push ax  
    push dx 
    push cx 
    ;mov ce_x,15t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx,ce_y  
    mov ax,ce_x
    mov cx, 7
     drawFila: 
        call pDrawEnemigo1
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y,dx;para escribir cada elemento en la misma columna
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo1 endp 

pFilaEnemigo2 proc
    push ax  
    push dx 
    push cx
    ;mov ce_x,30t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx,ce_y  
    mov ax,ce_x
    mov cx, 7
    drawFila: 
        call pDrawEnemigo2
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y, dx
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo2 endp 

pFilaEnemigo3 proc
    push ax  
    push dx 
    push cx
    ;mov ce_x,45t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    ;mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov dx, ce_y
    mov ax, ce_x
    mov cx, 7t ;cx es el contador de cuantas veces el loop se repetira 
    drawFila: 
        call pDrawEnemigo3
        mSumarDw ce_y,28t 
        loop drawFila
    mov ce_y, dx 
    pop cx 
    pop dx 
    pop ax 
    ret 
pFilaEnemigo3 endp 

pDrawEnemigos proc 
    push cx 
    mov cx, nivelGame
    mov ce_x,15t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    drawE:
        ;ENEMIGOS TIPO 1 
        call pFilaEnemigo1
        mSumarDw ce_x,15t 

        ;ENEMIGOS TIPO 2 
        mov ce_y,140t
        call pFilaEnemigo2
        mSumarDw ce_x,15t 

        ;ENEMIGOS TIPO 3 
        mov ce_y,140t
        call pFilaEnemigo3
        mSumarDw ce_x,15t 
        mov ce_y,140t
    loop drawE

    mov ce_x,15t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    mov ce_y,140t  ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
    pop cx 
    ret 
pDrawEnemigos endp 

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
        cmp al, 27t ;escape 
        je Pausa 
        cmp al, "v"
        je Disparo1
        cmp al, "V"
        je Disparo1
        cmp nivelGame,1t ;si el el nivel es 1 solo debera de cumplir con estas instrucciones  
        je salir 
        ;NIVEL 2 O MAS
        cmp al,"b"
        je Disparo2
        cmp al,"B"
        je Disparo2
        cmp nivelGame,2t  ;si el el nivel es 2 solo debera de cumplir con estas instrucciones 
        je salir 
        ;NIVEL 3 O MAS 
        cmp al, "n"
        je Disparo3
        cmp al, "N"
        je Disparo3 
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
    Pausa: 
        call pPauseGame ;PAUSA DONDE SOLO HABRA O
        jmp salir 
    Disparo1:
        ;tomar en cuanta que esta opcion solo se tomara cuando se presione el boton indicado   
        cmp estD1,1t ;si ya se presiono una vez y la bala se esta moviendo se ignora estas otras instrucciones
        je salir 
        ;si no se oprimio antes se reestablece el punto de partida de la bala y se comienza a mover 
        MovVariablesDw bala1x, cNave_x ;regresa la bala a su posicion inicial en el cañon de enmedio 
        mDecVar bala1x,3t ; le resta 3 para que la bala comience 3 espacios arriba de este cañon 
        movVariablesDw bala1y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mov estD1,1 ;se le autoriza al programa a pintar la bala
        ;cuando la bala llegue al fin del movimiento estD volver a 0 y le prohibira al programa pintar la bala
        ;EL METODO PARA PINTAR BALA SE LLAMA EN OTRO PROC (el corazon del movimiento del juego)
        jmp salir 
    Disparo2:
        cmp estD2,1 
        je salir 
        MovVariablesDw bala2x, cNave_x ;regresa la bala a su posicion inicial en el cañon de enmedio 
        mIncVar bala2x,2t ; le resta 3 para que la bala comience 3 espacios arriba de este cañon 
        movVariablesDw bala2y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mDecVar bala2y,8t
        mov estD2,1 ;  se le autoriza al programa a pintar la bala
        jmp salir 
    Disparo3:
        cmp estD3,1 
        je salir 
        MovVariablesDw bala3x, cNave_x ;regresa la bala a su posicion inicial en el cañon de enmedio 
        mIncVar bala3x,2t ; le resta 3 para que la bala comience 3 espacios arriba de este cañon 
        movVariablesDw bala3y, cNave_y ;es la columna de la posicion del cañon 1 de la nave
        mIncVar bala3y,8t
        mov estD3,1 ;  se le autoriza al programa a pintar la bala
        jmp salir 
    salir: 
    pop ax 
    ret 
pMovNave endp 

pMovbala proc
    push ax
    push dx
    
    mov cx,3t
    movnormal:
    cmp bala1x,5t
    je  finmovimiento
        push cx 
        
        ;OBTENER EL VALOR DE UN PIXEL 
        dec bala1x
        mov cx,bala1y ;column
        dec cx 
        mov dx,bala1x ;fila
        dec dx 
        dec dx 
        mov ah, 0Dh
        int 10h 
        cmp al,1t; azul 
        je DestEnemigo
        cmp al,44t ;si es igual al enemigo tipo 2 desaparece la bala pues no es de mayor calibre
        je colision
        cmp al,2t ;si es igual al enemigo tipo 3 desaparece la bala pues no es de mayor calibre
        je colision
        ;DIBUJO DE LA BALA 
        call pDrawBala1
        mIncVar bala1x,3t
        mDrawPixel bala1x,bala1y,0t
        inc dx 
        inc dx 
        mov bala1x,dx 
        pop cx 
    loop movnormal
    jmp salir
    DestEnemigo:
        pop cx 
        mDrawNaveEdestruida bala1x,bala1y 
        mSumarDw scoreG, 100t 
        jmp finmovimiento
    colision:  ;enemigo no posible de eliminar 
        pop cx     
    finmovimiento:
        mLimpiarDisparo bala1x,bala1y ;borrar bala 
        mov estD1,0
    salir: 
    pop dx 
    pop ax  
    ret
pMovbala endp  

pMovbala2 proc
    push ax
    push dx
    mov cx,3t
    movnormal:
        cmp bala2x,5t
        je  finmovimiento
        push cx 
        ;OBTENER EL VALOR DE UN PIXEL 
        dec bala2x
        mov cx,bala2y ;column
        dec cx 
        mov dx,bala2x ;fila
        dec dx 
        dec dx 
        mov ah, 0Dh
        int 10h 
        cmp al,1t; si es igual al enemigo tipo 1 lo destruye y la bala sigue el recorrido con el daño de esta restada en 1 
        je DestEnemigot1
        cmp al,2t ;si es igual al enemigo tipo 2 lo destruye y la bala desaparece
        je DestEnemigot2
        cmp al,44t ;si es igual al enemigo tipo 3 desaparece la bala pues no es de mayor calibre
        je colision
        call pDrawBala2
        mIncVar bala2x,3t
        mDrawPixel bala2x,bala2y,0t
        inc dx 
        inc dx 
        mov bala2x,dx 
        pop cx 
    loop movnormal
    jmp salir
    DestEnemigot1: 
        pop cx 
        mDrawNaveEdestruida bala2x,bala2y
        mSumarDw scoreG, 100t  
        cmp damageb2,1 ; si el daño de la bala es de 1 (desaparece la bala)
        je finmovimiento
            dec damageb2 ;si es de 2 se le resta 1 al daño de la bala y sigue su camino 
            mLimpiarDisparo bala2x,bala2y ;borrar bala 
            jmp salir ;no desaparece la bala 2 
    DestEnemigot2:
        pop cx 
        cmp damageb2,1 ; si el daño de la bala es de 1 (desaparece la bala) ya no tiene el daño necesario
        je finmovimiento
        mDrawNaveEdestruida bala2x,bala2y 
        mSumarDw scoreG, 200t  
        jmp finmovimiento
    colision: ;enemigo no posible de eliminar 
        pop cx     
    finmovimiento:
        mov damageb2,2t 
        mLimpiarDisparo  bala2x,bala2y ;borrarbala 
        mov estD2,0 ;estado disparo 2 
    salir: 
    pop dx 
    pop ax  
    ret 
pMovbala2 endp 

pMovbala3 proc 
    mov cx,3t
    movnormal:
        cmp bala3x,5t ;si llega al tope de la pantalla se detiene 
        je  finmovimiento
        push cx 
        ;OBTENER EL VALOR DE UN PIXEL 
        dec bala3x
        mov cx,bala3y ;column
        dec cx 
        mov dx,bala3x ;fila
        dec dx  ;dec dx no tiene que ver con el procedimiento para dibujar la bala
        dec dx  ;si embargo se decrementa dos veces para saber como es el pixel  a la bala dos posiciones arriba 
        mov ah, 0Dh
        int 10h 
        cmp al,1t; si es igual al enemigo tipo 1 lo destruye y la bala sigue el recorrido con el daño de esta restada en 1 
        je DestEnemigot1
        cmp al,2t ;si es igual al enemigo tipo 2 lo destruye y y la bala sigue el recorrido con el daño de esta restada en 2 
        je DestEnemigot2
        cmp al,44t ;si es igual al enemigo tipo 3 lo destruye y la bala desaparece 
        je DestEnemigot3
        call pDrawBala3 ;pinta la bala 
        mIncVar bala3x,3t ;para borrar el rastro de la bala se posiciona en el ultimo pixel pintado de esta
        mDrawPixel bala3x,bala3y,0t ;se pinta de negro 
        inc dx 
        inc dx 
        mov bala3x,dx 
        pop cx 
    loop movnormal
    jmp salir
    DestEnemigot1: 
        pop cx 
        mDrawNaveEdestruida bala3x,bala3y
        mSumarDw scoreG, 100t  
        cmp damageb3,1 ; si el daño de la bala es de 1 (desaparece la bala)
        je finmovimiento
            dec damageb3 ;si es de 2 o mas se le resta 1 al daño de la bala y sigue su camino 
            mLimpiarDisparo bala3x,bala3y ;borrar bala 
            jmp salir ;no desaparece la bala 
    DestEnemigot2: 
        pop cx 
        cmp damageb3,1 ; si el daño de la bala es menor a 1 ya no tiene el daño necesario para destruir al enemigo 2 
        je finmovimiento ;se borra la nave 
        mDrawNaveEdestruida bala3x,bala3y
        mSumarDw scoreG, 200t  
        cmp damageb3,2 ; si el daño de la bala es de 2 (desaparece la bala)
        je finmovimiento
            dec damageb3 
            dec damageb3 ;si es de 3 se le resta 2 al daño de la bala y sigue su camino 
            mLimpiarDisparo bala3x,bala3y ;borrar bala 
            jmp salir ;no desaparece la bala 2 
    DestEnemigot3:  
        pop cx 
        cmp damageb3,2 ; si el daño de la bala es menor o igual que 2 ya no tiene el daño necesario para destruir al enemigo 3 
        jle finmovimiento ;se borra la bala
        mDrawNaveEdestruida bala2x,bala2y ;si tiene los 3 justos si destruye la nave y suma al score 
        mSumarDw scoreG, 500t  
        jmp finmovimiento    
    finmovimiento:
        mov damageb3,3t 
        mLimpiarDisparo  bala3x,bala3y ;borrarbala 
        mov estD3,0 ;estado disparo 3 
    salir: 
    pop dx 
    pop ax 
    ret 
pMovbala3 endp 
;MOVIMIENTO DE LOS ENEMIGOS 
pMovEnemys proc  
    push cx 
    cmp estEnem,3
    je filaene3
    cmp estEnem,2
    je filaene2
    cmp estEnem,1
    je filaene1
    jmp salir ;SE MUEVE EL ESTADO PARA PASAR AL NIVEL 2 
    filaene3: 
        mov cx,nivelGame    
        movi3: 
            call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov3 
            movVariablesDw borrXenemy, ce_x
            movVariablesDw borrYenemy, ce_y 
            mDrawEborrado borrXenemy,borrYenemy
            call pColision
            cmp colisionE,1; si colisiono con la nave principal
            je finMov3
            cmp ce_x,196t ;si llego al margen inferior de la pantalla 
            je finMov3
            inc ce_x
            call pDrawEnemigo3
        dec cx 
        jne movi3 
        jmp salir 
        finMov3: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame ;fila actual 
            mSumarDw ce_y,28t
            cmp ce_y,336t ;comparar con la ultima posicion que puede tener una nave enemgia 
            jb  salir ;si es menor al margen salir y seguir graficando de forma normal 
            mRestaDw ce_x,15t 
            movVariablesDw filaIgame, ce_x ; se actualiza la fila actual a usar 
            mov ce_y,308t 
            mov estEnem,2
    filaene2:
        mov cx,nivelGame 
            
        movi2: 
            call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov2 
            movVariablesDw borrXenemy, ce_x ; con las filas actualizadas 
            movVariablesDw borrYenemy, ce_y ;con la columna actualizada 
            mDrawEborrado borrXenemy,borrYenemy
            call pColision
            cmp colisionE, 1 ; si la nave enemiga choco con la nave principal 
            je finMov2
            cmp ce_x,196t 
            je finMov2
            inc ce_x
            call pDrawEnemigo2
        dec cx 
        jne movi2  
        jmp salir 
        finMov2: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame ;se vuelve a reestablecer x en la fila actual 
            mRestaDw ce_y,28t ;se resta 28 a la columna actual 
            cmp ce_y,140t ; si es menor a 140t es que ya se movieron los 7 enemigos 
            jae salir ;si es mayor o igual al margen salir y seguir graficando de forma normal
            mRestaDw ce_x,15t ;si es menor entonces pasar a la siguiente fila de enemigos 
            movVariablesDw filaIgame,ce_x ; se actualiza la fila actual 
            mov ce_y,140t 
            mov estEnem,1
    filaene1: 
        mov cx,nivelGame 
           
        movi1: 
             call pDestEnemA ;el enemigo fue destruido con anterioridad?
            cmp DestEnemA, 1 ;si entonces saltar a fin de movimiento
            je finMov 
            movVariablesDw borrXenemy, ce_x ;toma la fila del enemigo
            movVariablesDw borrYenemy, ce_y ;toma la fila del enemigo
            mDrawEborrado borrXenemy,borrYenemy ;pinta un cuadro negro en dicha poisicon
            call pColision ;verifica si el enemigo no choco con la nave principal
            cmp colisionE,1 ; si la nave choco significa el fin del movimiento de dicha nave 
            je finMov
            cmp ce_x,196t ;llego al margen inferior de la pantalla 
            je finMov; si llego al final de la pantalla, es su fin de movimiento 
            inc ce_x ;se incrementa su fila de 1 en 1 
            call pDrawEnemigo1 ;se manda a dibujar el enemigo 1 
        dec cx 
        jne movi1  
        jmp salir 
        finMov: 
            call pDrawEborradoU
            movVariablesDw ce_x,filaIgame
            mSumarDw ce_y,28t
            cmp ce_y,336t ; si es mayor a 336t es que ya se movieron los 7 enemigos 
            jb salir ;si es menor al margen salir y seguir graficando de forma normal
            mRestaDw ce_x,15t 
            movVariablesDw filaIgame,ce_x
            cmp ce_x, 0 
            jne SeguirMoviendo
    FinalizarMovEnemigos:
        mov estEnem,3 ;incrementa en uno el nivel 
        inc nivelGame
        mov printEnemyE,0 ;para indicarle al programa que debe de volver a imprimir enemigos 
        jmp salir 
    SeguirMoviendo:
        movVariablesDw ce_x,filaIgame
        mov ce_y,140t 
        mov estEnem,3
    salir:
    pop cx    
    ret 
pMovEnemys endp 

pColision proc  
    push cx 
    push dx 
    push bx 
        mov colisionE,0
        mov bx,ce_y ;salvalguardar posicion y 
        mov dx,ce_x ;fila
        inc  dx 
        inc dx 
        mov cx,8 
        mDecVar ce_y,5t
        cuerpoenemigo: 
            push cx
            mov cx,ce_y ;column
            mov ah, 0Dh
            int 10h 
            cmp al,15t ;blanco 
            je choque 
            inc ce_y
            pop cx 
        loop cuerpoenemigo
        jmp nochoque
        choque:
            pop cx
            call pDrawNaveBorr;desaparece la nave en el momento del choque 
            mov colisionE,1  ;indicador de que hubo colision 
            cmp liNave,0 ;si la nave tiene vida 0 entonces ya no se hace nada, caso contrario restar 1 a la vida 
            je nochoque 
            dec liNave
        nochoque: 
        mov ce_y,bx 
    pop bx 
    pop dx 
    pop cx 
    ret 
pColision endp 

pDestEnemA proc
    push cx 
    push dx
    push ax 
    mov DestEnemA,0
    mov cx,ce_y ;column
    mov dx,ce_x ;fila
    dec dx 
    dec dx 
    dec dx 
    mov ah, 0Dh
    int 10h 
    cmp al,0t; negro, entonces fue eliminado 
    jne nodestruido ; si no ha sido destruido no hacer nada 
        mov DestEnemA,1 ;si esta destruido indicarle al programa que ha sido destruido anteriormente 
    nodestruido: 
    pop ax 
    pop dx 
    pop cx 
    ret 
pDestEnemA endp 

    ;AUXILIARES PARA BORRAR LA ULTIMA POSICION DE LOS ENEMIGOS 
pFilaEborradoU proc
    push cx
    push ax
    push dx 
    mov cx, 7 ;cx es el contador de cuantas veces el loop se repetira 
    mov borrUx,197t   
    mov borrUy,140t  
    mov ax, borrUx ;aux para reestablecer el valor de la fila escogida 
    mov dx, borrUy
    filaE:
        call pDrawEborradoU
        mIncVar borrUy,28t
        MovVariablesDw borrUx, ax ;CAMBIAR ESTE 30T POR UNA VARIABLE GLOBAL 
        loop filaE
    MovVariablesDw borrUy, dx 
    pop dx
    pop ax 
    pop cx 
    ret 
pFilaEborradoU endp 

pDrawEborradoU proc
    push cx
    push ax
    push dx 
    mov ax, borrXenemy
    mov dx, borrYEnemy
    mov cx, 8t
    figuraB:
        mDecVar borrYenemy,4t 
        mDrawFila borrXenemy,borrYenemy,0t,8     
        mov borrYenemy, dx 
        dec borrXenemy
        loop figuraB
    mov borrXenemy,dx
    pop dx
    pop ax
    pop cx 
    ret
pDrawEborradoU endp 

;CONFIGURACIONES 
pConfigIni proc 
    ;CUADROS DIVISORES PARA EL JUEGO
                   ;FILA,COLUMNA,ANCHO,ALTO,COLOR
    mDrawRectangulo 1t,1t,120t,130t,53t
    mDrawRectangulo 132t,1t,120t,67t,53t
    mDrawRectangulo 1t,121t,200t,198t,53t
    ;RESTAURA VIDA DE NAVE 
    mov liNave, 3t
    ;LETREROS PRINCIPALES
    mImprimirLetreros Usergame,1t,1t,9t
    mImprimirLetreros Leveltitle,4t,1t,9t
    mImprimirLetreros Scoregame,7t,1t,9t
    mImprimirLetreros Timegame,10t,1t,9t
    mImprimirLetreros Livesgame,13t,1t,9t
    mImprimirLetreros PressSpace,18t,1t,9t
    mImprimirLetreros toStartG,20t,1t,9t
    ;NIVELES 
        mov printEnemyE,0  ; para saber si ya se pinto las filas de los enemigos o no 
        mov nivelGame,2 ;nivel del juego 
    ;COORDENADAS INICIALES PARA LOS ENEMIGOS Y NAVE PRINCIPAL 
    mov cNave_x,185t ;fila inicial de la nave 
    mov cNave_y,220t ;columna inicial de la nave
    mov estEnem,3  ;para que se empiece moviendo el enemigo tipo 3 
    mov mingameN,0 ;minutos desde que se inicio el juego 
    mov seggameN,0 ;segundos desde que se inicio el juego 
    mov cengameN,0 ;centisegundos desde que se inicio el juego 
    ret 
pConfigIni endp  
;IMPRIME EL TIEMPO DEL JUEGO 
pTimeGame proc 
    inc cengameN
    cmp cengameN,100t
    jne salir 

    mov cengameN,0 ;centisegundos vuelve a 0
    inc seggameN ;se aumenta a uno los segundos 
    cmp seggameN,60t;cuando llegue a 60 se repetira lo mismo 
    jne salir 

    mov seggameN,0t
    inc mingameN
    salir: 
        mLimpiar cengameS,4,0
        mLimpiar seggameS,4,0
        mLimpiar mingameS,4,0
        Num2String cengameN,cengameS
        Num2String seggameN,seggameS
        Num2String mingameN,mingameS
        mImprimirLetreros mingameS,12t,4t,15t
        mImprimirLetreros dospuntosg,12t,6t,15t
        mImprimirLetreros seggameS,12t,7t,15t
        mImprimirLetreros dospuntosg,12t,9t,15t
        mImprimirLetreros cengameS,12t,10t,15t  
    ret 
pTimeGame endp 
;IMPRIME EL NIVEL DEL JUEGO 
pLevel proc
    movVariablesDw nivelGameS,nivelGame
    add nivelGameS,30h
    mImprimirLetreros nivelGameS,6,10t,15t 
    ret 
pLevel endp 
;IMPRIME EL SCORE DEL JUEGO 
pScore proc
    mLimpiar scoreGString,5,0
    Num2String scoreG,scoreGString
    mImprimirLetreros scoreGString,9t,4t,15t
    ret 
pScore endp 
;PAUSA DEL JUEGO 
pPauseGame proc 
    call pGuardarMatrizVideo ; guardar el estado de la matriz de video para posteriormente cargarla sin los letreros 
    mov exitGame, 0
    mImprimirLetreros letPause,5t,25t,15t
    mImprimirLetreros letRen,12t,20t,15t
    mImprimirLetreros letExit,15t,20t,15t
    ciclo:
        mov ah, 00  ;Espera a que se presione una tecla y la lee
        int 16h
        cmp al, 27t ;escape 
        je exitG 
        cmp al, " " ;espacio 
        je salir
        jmp ciclo  ;estara en un ciclo si no es o espacio o escape 
    exitG: 
        mov exitGame,1 
    salir: 
        call pCargarMatrizVideo ;cargar la matriz de video guardada luego de los letreros 
    ret 
pPauseGame endp 
;PAUSA PARA PRESENTAR EL NIVEL A JUGAR Y ESPERAR SE PRESIONE LA TECLA ESPACIO 
pEspInicial proc
    cmp nivelGame,1 
    je nivel1 
    cmp nivelGame,2 
    je nivel2 
    cmp nivelGame,3 
    je nivel3 
    jmp salir 
    nivel1: ;imprime "nivel 1" y espera un espacio
        mImprimirLetreros letN1,8t,24t,15t 
        mWaitKey " "
        mImprimirLetreros letclear,8t,24t,15t 
        jmp salir 
    nivel2: ;imprime "nivel 2" y espera un espacio
        mImprimirLetreros letN2,8t,24t,15t 
        mWaitKey " "
        mImprimirLetreros letclear,8t,24t,15t
        jmp salir
    nivel3: ;imprime "nivel 3" y espera un espacio
        mImprimirLetreros letN3,8t,24t,15t 
        mWaitKey " "
        mImprimirLetreros letclear,8t,24t,15t
        jmp salir
    salir: 
    ret 
pEspInicial endp 

;MACROS PARA GUARDAR Y CARGAR LA MATRIZ DE VIDEO 
;Macro para sobreescribir la matriz de video en un archivo "matriz.vi"
pGuardarMatrizVideo proc
    push cx 
    push ax 
    push si  
    mCrearFile matrizgraph
    mOpenFile2Write matrizgraph
    mov si,0
    mov cx, 64000t
    copiarmatriz:
        mov bl, es:[si]
        mov eleactualG,bl 
        mWriteToFile eleactualG
        inc si 
    loop copiarmatriz
    mCloseFile
    pop si 
    pop bx 
    pop cx 
    ret 
pGuardarMatrizVideo endp 

;macro para cargar la matriz guardada con anterioridad 
pCargarMatrizVideo proc
    push cx 
    push ax 
    push si  
    mOpenFile2Write matrizgraph
    mov si,0
    mov cx, 64000t
    copiarmatriz2:
        mReadFile eleactualG
        mov bl,eleactualG
        mov  es:[si],bl
        inc si 
    loop copiarmatriz2
    mCloseFile
    pop si 
    pop bx 
    pop cx 
    ret
pCargarMatrizVideo endp 

END start 
