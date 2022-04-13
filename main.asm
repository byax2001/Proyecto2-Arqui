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
        xor ax,ax
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

pMemVideoMode proc
    push dx
    mov dx, 0A000
    mov ds,dx 
    pop dx 
    ret 
pMemVideoMode endp 

pGame proc
    call pMemVideoMode
    call pVideoMode 
   
    ;mDrawPixel 100t,160t,10t
    call pDrawNave
        Delayt 5t
    call pTextMode
    ret
pGame endp

pDrawNave proc
    push cx 
    mov cNave_x,160t
    mov cNave_y,160t
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
    mDecVar cNave_y,10t
    mDrawFila cNave_x,cNave_y,15t,5t
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,15t
    inc cNave_y
    mDrawPixel cNave_x,cNave_y,39t
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,5t
    ;otra parte 
    inc cNave_x
    mDecVar cNave_y,14t
    mDrawFila cNave_x,cNave_y,15t,15t
    ;otra parte
    inc cNave_x
    mDecVar cNave_y,15t
    mDrawFila cNave_x,cNave_y,15t,15t
    ;otra parte 
    inc cNave_x
    mDecVar cNave_y,16t
    mDrawFila cNave_x,cNave_y,15t,3t 
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,7t 
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,3t 
    ;OTRA PARTE 
    inc cNave_x
    mDecVar cNave_y,18t
    mDrawFila cNave_x,cNave_y,15t,3t 
    inc cNave_y
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,39t,2t 
    mDrawFila cNave_x,cNave_y,15t,3t 
    mDrawFila cNave_x,cNave_y,39t,2t 
    inc cNave_y
    inc cNave_y
    inc cNave_y
    mDrawFila cNave_x,cNave_y,15t,3t
    pop cx 
    ret 
pDrawNave endp 

END start 
