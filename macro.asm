mVariables macro
    ;Mensaje de Bienvenida
    mensajeI db 0A,"Universidad de San Carlos de Guatemala",0A,"Facultad de Ingenieria",0A,"Escuela de Ciencias y Sistemas",0A,"Arquitectura de Compiladores y Ensambladores",0A,"Seccion B",0A,"Brandon Oswaldo Yax Campos",0A,"201800534",0A,"$";0A ES ENTER
    ;enter para avanzar
    espEnter db 0A,"(Presiona enter para poder continuar): $"
    ;MENU 1
    Menu db 0A,"Menu",3A,0A,"F1. Login",0A,"F2. Register",0A,"F9. Exit",0A,"$"
    ;Menu 2
    Menu2 db "F2. Play game",0A,"F3. Show top 10 scoreboard",0A,"F5. Show my top 10 scoreboard",0A,"F9. Logout",0A,"$"
    ; Opcion incorrecta
    opi db 0A,"**No se escogio una opcion entre las que existen**$"
    ;MENSAJE LUEGO DE EQUIVOCARSE 3 VECES
    blockUs db ">> Permission denied <<",0A,">> There where 3 failed login attempts <<",0A,">> Please contact the administrator <<",0A,">> Press Enter to go back to menu <<",0A,"$"
    ;INGRESO DE USUARIO
    msgLogin db 0A,"============Login",58t,"============",0A,"$"
    UsuarioI db 25 dup (24) ;nombre de usuario a ingresar
    PasswordI db 25 dup (24)   ;contraseña a ingresar
    msgUnE  db 0A,"===Usuario no Existe===",0A,"$"
    msgPinc  db 0A,"===Password Incorrecta===",0A,"$"
    msgUbloqueado db "==Usuario bloqueado==",0A,"$"
        ;MENU DE USUARIO
        msgMenuU db "Menu de usuario",0A,"$"

        ;MENU USUARIO ADMIN
        msgMuA db "Menu usuario Admin",0A,"$"

        ;MENU DE ADMIN
        msgMenuAdmin db "Menu de Admin",0A,"$"
        ;DELAY
        valort1 db 0
        valort2 db 0
        contadort dw 0
        StringNumT db 4 dup(24)
        ;PARA EL NUM2STRING
         contador db 0
    ;REGISTRO DE USUARIOS
    msgRegister db 0A,"============Register",58t,"============",0A,"$"
    ;adminG db "Nombre",01,"Contraseña",01,Numero de veces que se equivoco,01,"Bloqueado/n","Admin/n" enter (0A)
    adminG db "201800534BADM$$$$$$$$$$$$",01,"435008102$$$$$$$$$$$$$$$$",01,"0",01,"N",01,"A",0A," "
    rU db "Ingrese usuario",58t," $"
    rP db "Password",58t," $"

    UsuarioRegis db 25 dup (24) ;nombre de usuario a registrar
    PasswordRegis db 25 dup (24)   ;contraseña a registrar 
    validador db 0              ;validador 
        ActionR db "Accion rechazada! $" 
        ;MENSAJES DE NOMBRE DE USUARIO CONE ESTRUCTURA INCORRECTA
        msginitialbad db 0A,"Se debe de iniciar por una letra$"
        msglengtherror db 0A,"Tamanio del nombre de usuario no entre el rango (8-15 caracteres)$"
        msgUExist  db 0A, "El Usuario ya ha sido registrado previamente$"
        msgCaractP db 0A,"Los unicos caracteres permitidos fuera del alfabeto son -_.$"
        ;MENSAJES DE CONTRASEÑA CON ESTRUCTURA INCORRECTA
        msgunaM db 0A,"Password  debe de tener al menos una mayuscula$"
        msgunN db 0A,"Password debe de tener al menos un Numero$"
        msgunS db 0A,"Password  debe de tener al menos una !>%",59t,"*$"
        msglengtherror2 db 0A, "Tamanio de password no entre el rango (16-20 caracteres)$"
        ;GUARDAR USUARIO
        separador db 01
        enterg db 0A, " "
        Nequivdef db "0"
        Bloqdef db "N"
        admindef  db "N"
        Numerrordef db "0"
        BloqueoU db "B"
        AdminU db "A"
        ;ERRORES USUARIO
        numinicio db 0
        largoe db 0
        existee db 0
        caractNp db 0 ;caracteres no permitidos para el usuario
        ;CARACTERISTICAS PASSWORD
        mayuse db 0
        nume db 0
        sinCaractE db 0 ;caracteres especiales faltantes en la contraseña
        largoe2 db 0
        ;EXISTE ERROR
        enrango db 0
        eerror db 0
        contadoraux db 0
       

        RUSucces db "Registro exitoso",0A,"$"
            ;MENSAJE SUCCES
            msgRegistroSucces db "Se registro el usuario de forma exitosa"
        
        ;SIZE PILA 
        sizepila db 0

    ; Opcion escogida del menu
    opcion db 0 
    dollar db '$'
    ;STRING DE UN NUMERO Y NUMERO DE UN STRING 
    stringNumactual db 20 dup (24)
    Numactual dw 0 
    auxs db "$"
    espacio db " ","$"
    retroceso db 08, "$"
    asterisco db "*","$"

    ;ARCHIVO
    eleActual db 0 ;variable que contendra cada elemento leido por el programa
    a db "$"
    handler dw  0
    msgcargar db 0A,"Ingrese el nombre del archivo a cargar: ",'$'
    nameFile db 20 dup(0)
    nfcaux db '$'
    cargood db 0A,"Cargo con exito! (presione cualquier tecla)","$" 
    carbad  db 0A,"Fallo la carga! (presione cualquier tecla)","$"
    estadocarga db 0 ;si se logro cargar algo o no
    savegood db 0A,"Guardado con exito!", "$"
    savebad db 0A, "No se guardo el archivo!","$"
    creacionCorrecta db 0       ;si se creo  con exito un nuevo documento su valor sera 1, caso contrario sera 0
    posLectura dw 0 ;VARIABLE CON LA CUAL SI LLEGA A 0 LUEGO DE INSTANCIAR LA MARCO READFILE SIGNIFICA QUE
    ;EL DOCUMENTO LLEGO AL FINAL DE ESTE
    idEncontrado db 0 ;SE ENCONTRO LA PALABRA EN ESPECIAL QUE SE REQUERIA?
        ;APARTADO PARA LOS ARCHIVOS QUE FUNCIONARAN COMO BASE DE DATOS
        usersb db "users.gal",0
        scoresb db "scores.gal",0
        auxarchivo db 0
        aux1 db "$"
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
        call pBaseDatos
        call pLimpiarConsola
        call pDelayLetras
        mMostrarString mensajeI
         ;apartado de espera de un enter----------------------
            call pEspEnter
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
        ;la laptop que se posee para trabajar esto necesita de presionar una tecla antes de los FN
        ; para que los reconozca por tal motivo se hizo esto dos veces para que se pudiera a trapar el valor de Fn
        mov ah,01
        int 21
        mov ah,01  ;atrapa la tecla fn 
        int 21
        mov opcion,al
        cmp opcion,59t
        je Login
        cmp opcion,"<"
        je Register
        cmp opcion,"C"
        je salir
        mMostrarString opi
        jmp ciclomenu
    Login:
        mLogin
        jmp ciclomenu
    Register:
        call pResetFlagsE ;RESETEA LAS BANDERAS QUE DETECTAN DE ERRORES A LA HORA DE REGISTRAR
        mRegistrar
        call pLimpiarConsola
        jmp ciclomenu   
    salir: 
endm

mLogin macro
    local esadmin,noesadmin
    call pLimpiarConsola
    call pResetFlagsE
    mOpenFile2Write usersb ;abre el archivo de users
    mLimpiar UsuarioI,25,24 ;limpia el espacio para  almacenar el usuario ingresado
    mLimpiar PasswordI,25,24 ;limpia el espacio donde se almacenara temporalmente la contra ingresada
    mMostrarString msgLogin ;muestra mesaje de login
    ;captura de usuario y contraseña 
    mMostrarString rU
    mCapturarString UsuarioI
    mMostrarString rP 
    mCapturarPassword PasswordI
    ;ADMIN PRINCIPAL==================================================
    mReadFile eleActual
    mEncontrarId UsuarioI
    cmp idEncontrado,0
    je noesadmin
    esadmin: ;ES EL ADMIN PRINCIPAL
        mHallarSimbolo 01 ;pasa al separador que esta alapar de contraseña
        mReadFile eleActual;se salta el separador
        mEncontrarId PasswordI;verificar si la contraseña es la correcta 
        cmp idEncontrado,0
        je PasswordIncorrect
        cAdminCor:;password de admin correcta
            mMostrarString msgMenuAdmin
            call pEspEnter
            jmp salir 
    ;USUARIO O USUARIO ADMIN==================================================
    noesadmin: ;ENTONCES ES UN USUARIO NORMAL o ADMIN SECUNDARIO 
        mUserExiste UsuarioI
        cmp existee,1 ;EXISTE USUARIO?
        jne Noexiste  ;NO EXISTE
        ;luego del metodo mUserExiste  estara posicionado justo en la linea deseada
        mHallarSimbolo 01 ;Separador alapar de contraseña 
        mReadFile eleActual ;Primer elemento de contraseña 
        mEncontrarId PasswordI
        cmp idEncontrado,1
        jne PasswordIncorrect
        je PasswordCorrect
        ;EXISTE?
    PasswordCorrect:
        mHallarSimbolo 01 ;separador a la par de N veces repetido
        mHallarSimbolo 01 ;separador a la par de bloqueado o no bloqueado
        mReadFile eleActual ;B o N
        cmp eleActual,"B"
        je Ubloqueado
        mHallarSimbolo 01 ;separador a la par de admin o no admin 
        mReadFile eleActual ;A o N
        cmp eleActual,"A"
        je Usuarioadmin
        jne UsuarioNormal
    ;USUARIO NORMAL=================================================
    UsuarioNormal: 
        mMostrarString msgMenuU ;MENU DE USUARIO NORMAL
        call pespEnter
        jmp salir 
    
    ;USUARIO ADMIN==================================================
    Usuarioadmin: 
        mMostrarString msgMuA  ;MENU USUARIO ADMIN
        call pespEnter
        jmp salir 
           
    Ubloqueado:
        mMostrarString msgUbloqueado
        call pespEnter
        jmp salir 
    Adminbloqueado:
        
    PasswordIncorrect:
        ;LE SUMA UNO AL NUMERO DE ERRORES 
        mMostrarString msgPinc
        call pIncVEquivoco
        call pDarbloqueo
        call pEspEnter
        jmp salir 
    Noexiste:
        mMostrarString msgUnE ;MENSAJE USUARIO NO EXISTE 
        call pEspEnter
        jmp salir 
    ;NO EXISTE
    salir:
    mCloseFile
endm 

mUserExiste macro Username 
    local Existe,Noexiste,salir,cicloexiste
    ;SE VERIFICA SI NO ES EL ADMIN
    mReadFile eleActual ;TOMA EL PRIMER VALOR DEL ARCHIVO 
    mEncontrarId Username;lo primero en el documento de usuarios es el admin, que siempre estara aca
    cmp idEncontrado,1 ; se encontro usuario? 
    je Existe ;si se encontro se procede a decir que si existe el usuario y se marcara como error
    cicloexiste: ;caso contrario se procedera a un ciclo de lectura del archivo hasta hallar o un espacio o el id buscado
        mHallarSimbolo 0A  ;se salta hasta el enter hasta la posicion donde esta 0A
        mReadFile eleActual ; se corre una vez el elemento 
        cmp eleActual," " ;si hay un espacio es que ya se llego al fin del documento y el usuario no existe
        ;CADA VEZ QUE SE CREA UN USUARIO SE ELIMINA EL ULTIMO ESPACIO QUE DEJA LA CREACION DEL USUARIO ANTERIOR
        je Noexiste ; no existe usuario
        mEncontrarId Username ;si no es espacio lo que esta en esta posicion fijo es un nombre de user, el user a registrar  es igual a este? 
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
endm 




mRegistrar macro
    local salir 
    mov eerror,0
    mLimpiar UsuarioRegis,25,24
    mLimpiar PasswordRegis,25,24
    call pLimpiarConsola
    mMostrarString msgRegister
    mMostrarString rU
    mCapturarString UsuarioRegis
    mMostrarString rP
    mCapturarPassword PasswordRegis
    ;RESTRICCIONES 
    mUserInicial
    mSizeUser
    mUserExisteR
    mRequisitoCletra
    mAMayus
    mANum
    mASigno
    mSizePassword 
    ;EXISTE ERROR?
    mComparar eerror,1
    je ErrorRegistro
    jne noErrorRegistro
    ErrorRegistro:
        mMostrarString ActionR
        ;NUMERO INICIAL
        mComparar numinicio,0
        je nNinicial
        yNinicial:;error posee un numero en su caracter incial
            mMostrarString msginitialbad 
        nNinicial:; no posee error de este tipo
        
        mComparar largoe,0
        je nLerornea
        ;LONGITUD ERRONEA
        yLerronea: ; posee error 
            mMostrarString msglengtherror
        nLerornea:; no posee error de este tipo
        
        ;USUARIO EXISTENTE
        mComparar existee,0
        je nUexist
        yUexist:;usuario existe
            mMostrarString msgUExist
        nUexist:; no posee error de este tipo

        ;CARACTERES ESPECIALES NO PERMITIDOS PRESENTES
        mComparar caractNp,0
        je nCnexist
        yCnexist: ; error carateres especiales no permitidos presentes
            mMostrarString msgCaractP
        nCnexist: ; no posee error de este tipo
        
        ;PASSWORD SIN AL MENOS UNA MAYUSCULA
        mComparar mayuse,0
        je nPsm
        yPsm:; Password sin mayuscula
            mMostrarString msgunaM
        nPsm:; no posee error de este tipo
        
        ;PASSWORD SIN AL MENOS UN NUMERO
        mComparar nume,0
        je nPsn
        yPsn: ; Password sin numero
            mMostrarString msgunN
        nPsn:; no posee error de este tipo
        
        ;PASWORD SI AL MENOS UN SIMBOLO ESPECIAL(!>%;*)
        mComparar sinCaractE,0
        je nPss
        yPss: ;password sin simbolos
            mMostrarString msgunS
        nPss:; no posee error de este tipo
        
        ;PASSWORD CON LONGITUD ERRONEA
        mComparar largoe2,0
        je nPlongitud
        yPlongitud:; hay error respecto a la longitud 
            mMostrarString msglengtherror2
        nPlongitud:; no posee error de este tipo

        call pEspEnter
        jmp salir 

    noErrorRegistro: ;registro sin error
        call pAlmacenaruser
        mMostrarString RUSucces
        call pEspEnter
    salir: 
endm 



;REQUISITOS PARA EL USUARIO 
;NO DEBE DE TENER UN NUMERO AL INICIO
mUserInicial macro
    local iniNumero,iniLetra,salir 
    mEnRango UsuarioRegis[0],30h,39h  ; el dato se encuentra entre 0-9 del codigo ascii?
    cmp enrango,0     ;no
    je iniLetra       ;inicia con una letra y otro caracter, no hay error
    iniNumero:        ;inicia con un numero, si hay error 
        mov numinicio,1  ;marca con 1 la variable la variable global que indica un error sobre un numero inicial
        mov eerror,1 ;indica que hay un error en el usuario o en la contraseña por tal razon no se registra
        jmp salir       
      
    iniLetra:   
        mov numinicio,0 ;marca que no hubo error 
    salir: 
endm 
;EL TAMAÑO DEL USUARIO DEBE DE ESTAR ENTRE 8-15 LETRAS
mSizeUser macro
    local ciclosize,comparaciones,sentenciagood,salir,sentenciabad
    push si 
    mov contadoraux,0 ;inicializa variable que contendra el tamaño del nombre user 
    mov si, 0 
    ciclosize:
        cmp si, 25t ;si ya llego a 25? (el tamaño maximo de la variable)
        je comparaciones ; si, pase a comprobar el tamaño del nombre user con los rangos
        mComparar UsuarioRegis[si],"$" ;cuando llegue a $ es que llego al fin del nombre usuario
        je comparaciones ;si es asi pasa a comparar el tamaño con los margenes permitidos
        mSumardb contadoraux,1 ;si no, suma uno al tamaño del nombre user 
        inc si ;incrementa uno al index si 
        jmp ciclosize ; repite el ciclo 
    comparaciones:
        mEnRango contadoraux, 8t,15t ; el tamaño esta entre 8 -15  ?
        mComparar enrango,1  ; esta en rango?
        je sentenciagood     ;si, la sentencia es correcta
        jne sentenciabad     ;no, la sentencia no es correcta 
    sentenciagood:
        mov largoe, 0        ; no hay error respecto al rango 
        jmp salir            ; sale 
    sentenciabad:
        mov largoe,1         ; si hay error respecto al rango
        mov eerror,1         ; si hay error en name user o password 
    salir: 
    pop si 
endm 

;NO DEBE DE EXISTIR EL USUARIO
mUserExisteR macro 
    local Existe,Noexiste,salir,cicloexiste
    ;SE VERIFICA SI NO ES EL ADMIN
    mOpenFile usersb  ;abre el archivo en modo lectura 
    mReadFile eleActual ;TOMA EL PRIMER VALOR DEL ARCHIVO 
    mEncontrarId UsuarioRegis;lo primero en el documento de usuarios es el admin, que siempre estara aca
    cmp idEncontrado,1 ; se encontro usuario? 
    je Existe ;si se encontro se procede a decir que si existe el usuario y se marcara como error
    cicloexiste: ;caso contrario se procedera a un ciclo de lectura del archivo hasta hallar o un espacio o el id buscado
        mHallarSimbolo 0A  ;se salta hasta el enter hasta la posicion donde esta 0A
        mReadFile eleActual ; se corre una vez el elemento 
        cmp eleActual," " ;si hay un espacio es que ya se llego al fin del documento y el usuario no existe
        ;CADA VEZ QUE SE CREA UN USUARIO SE ELIMINA EL ULTIMO ESPACIO QUE DEJA LA CREACION DEL USUARIO ANTERIOR
        je Noexiste ; no existe usuario
        mEncontrarId UsuarioRegis ;si no es espacio lo que esta en esta posicion fijo es un nombre de user, el user a registrar  es igual a este? 
        cmp idEncontrado,1 ; si, entonces existe 
        je Existe 
        jne cicloexiste 
    Existe:
        mov existee,1 ;se reporta error pues existe usuario que se intenta registrar
        mov eerror,1  ;se reporta error general al registro
        mCloseFile
        jmp salir 
    Noexiste:
        mov existee, 0 ; no existe usuario, no hay error
        mCloseFile
    salir:
endm 

;MACRO QUE VERIFICA SI EXISTE UN ID EN EL DOCUMENTO 
mEncontrarId macro id
    local salir ,comparar,idhallado,idNohallado,finid
    push si 
    mov idEncontrado,0 ;limpiar idEncontrado
    mov si,0
    comparar:
    mComparar id[si],"$" ;llego al final del id escogido   
    je finid 
    mComparar id[si],eleActual   ; la letra obtenida es igual al elemento actual del id?
    jne idNohallado ; no, entonces no son el mismo id, id no se hallo
    ;si, se procede a seguir recorriendo
    mReadFile eleActual
    inc si 
    jmp comparar
    finid: ;llego al fin del id, pero llego al fin del usuario leido en el doc?
        cmp eleActual,"$"
        je idhallado ;si entonces si es ese el id 
        jne idNohallado ; los id no son iguales 
    idhallado:
        MovVariables eleActual,0;LIMPIEZA DE VARIABLE 
        mov idEncontrado,1 ;INDICA SI EL ID FUE ENCONTRADO 
        jmp salir 
    idNohallado:
        MovVariables eleActual,0;LIMPIEZA DE VARIABLE 
        mov idEncontrado,0 ;INDICA SI EL ID FUE ENCONTRADO 
    salir:
    pop si 
endm 



;VERIFICA QUE CADA LETRA DEL USER SEAN CARACTERES PERMITIDOS USANDO EL METODO MENRANGOESP
mRequisitoCletra macro
    local ciclo,sicumpleR,nocumpleR,salir 
    push si 
    mov si,0 ;inicializa si 
    ciclo: 
        cmp si,25t  ;si llego hasta 25? (el tamaño maximo deuna variable)
        je sicumpleR ;si, entonces no paso ningun error por lo tanto todas las letras en el username cumplen con las restricciones
        mComparar UsuarioRegis[si], "$" ; llego hasta $?
        je sicumpleR ;si llego hasta $ significa que no hay errores en los caracteres del name user
        mEnRangoEsp UsuarioRegis[si] ;revisa que esta letra cumpla con los requisitos de los margenes
        cmp enrango,1 ;esta en rango, entre los caracteres permitidos 
        jne nocumpleR ;no, no lo esta 
        inc si  ;si , si lo esta
        jmp ciclo 
    sicumpleR:
        mov caractNp,0 ; no hay errores entre los caracteres permitidos
        jmp salir 
    nocumpleR:
        mov caractNp,1 ;hay error y hay caracteres no permitidos
        mov eerror,1    ; error general 
    salir: 
    pop si 
endm 

;MUESTRA SI LA LETRA MANDADA ESTA ENTRE EL RANGO DE LETRAS Y SIMBOLOS ESPECIALES PEDIDOS 
mEnRangoEsp macro dato
    local enrangoEsp,noenrango,salir
    mEnRango dato, 41h,5Ah  ;de A-Z
    cmp enrango,1
    je enrangoEsp

    mEnRango dato, 61h, 7ah ; de a-z
    cmp enrango,1
    je enrangoEsp

    mEnRango dato, 30h,39h   ; de 0-9
    cmp enrango,1
    je enrangoEsp

    mEnRango dato, 45t,46t   ; "-","."
    cmp enrango,1
    je enrangoEsp

    mComparar dato,"$"
    je enrangoEsp

    mComparar dato,"_"
    je enrangoEsp
    jne noenrango ; si no cuplio con ninguna entonces hay algun simbolo que no esta dentro de los permitidos
    enrangoEsp:
        mov enrango,1
        jmp salir 
    noenrango:
        mov enrango,0
    salir:
endm 



;OPCIONES PARA CONTRASEÑA 
;QUE TENGA AL MENOS UNA MAYUSCULA
mAMayus macro 
    local ciclopassword, salir, tieneMayus,noTieneMayus
    push si 
    mov si, 0 ; se inicializa si 
    ciclopassword:   
        cmp si,25t ; si llego a 25 es que no habia ningun caracter con mayusculas
        je noTieneMayus
        mEnRango PasswordRegis[si],41h,5Ah  ; esta esta letra entre el rango de las mayusculas
        cmp enrango,1 ;esta en el rango?
        je tieneMayus ; si  se pasa a indicar que si tiene mayusculas por lo tanto no hay error
        inc si 
        jmp ciclopassword   
    tieneMayus:
        mov mayuse,0 ; se procede a decir que o hay error en la falta  de mayusculas
        jmp salir 
    noTieneMayus:
        mov mayuse,1 ;falta mayusculas
        mov eerror,1 ;hay error en usuario o password
    salir: 
    pop si 
endm 
;QUE TENGA LA MENOS UN NUMERO
mANum macro 
    local ciclopassword, salir, tieneCaracter,noTieneCAracter
    push si 
    mov si, 0 ; se inicializa si 
    ciclopassword:   
        cmp si,25t ; si llego a 25 es que no habia ningun caracter con numero
        je noTieneCAracter ; se salta a indicar que hay error y no cumple con tener al menos un numero
        mEnRango PasswordRegis[si],30h,39h  ;esta en el rango de numeros?
        cmp enrango,1 ;Si
        je tieneCaracter ;se procede a indicar que existe al menos un numero
        inc si  ;se busca si y se compara el siguiente elemento
        jmp ciclopassword   
    tieneCaracter:
        mov nume ,0 ;hay al menos un numero
        jmp salir 
    noTieneCAracter:
        mov nume,1 ;no hay numeros
        mov eerror,1 ;error 
    salir: 
    pop si 
endm 
; QUE TENGA AL MENOS UN !>%;*
mASigno macro 
    local ciclopassword, salir, tieneCaracter,noTieneCAracter
    push si 
    mov si, 0
    ciclopassword:   
        cmp si,25t ; si llego a 25 es que no habia al menos un caracter especificado en el password
        je noTieneCAracter
        mComparar PasswordRegis[si],"!"
        je tieneCaracter 
        mComparar PasswordRegis[si],">"
        je tieneCaracter
        mComparar PasswordRegis[si],"%"
        je tieneCaracter
        mComparar PasswordRegis[si],59t ;59t = puntoycoma
        je tieneCaracter
        mComparar PasswordRegis[si],"*"
        je tieneCaracter
        inc si 
        jmp ciclopassword   
    tieneCaracter:
        mov sinCaractE ,0
        jmp salir 
    noTieneCAracter:
        mov sinCaractE,1
        mov eerror,1
    salir: 
    pop si 
endm 
;TAMAÑO DE ENTRE 16 A 20
mSizePassword macro 
    local ciclosize,comparaciones,sentenciagood,salir,sentenciabad 
    push si  
    mov contadoraux,0 ; se inicializa la variable que contendra el tamaño del password
    mov si, 0
    ciclosize:
        cmp si,25t ; si llego a 25 (maximo tamaño para una password ) pasa a proceder a verificar el tamaño
        je comparaciones ;pasa a comparar con los margenes
        mComparar PasswordRegis[si],"$" ;llego hasta $, significa que llego al fin del tamaño del password
        je comparaciones ;pasa a comparar con los margenes
        mSumardb contadoraux,1
        inc si 
        jmp ciclosize
    comparaciones:
        mEnRango contadoraux, 16t,20t ;el tamaño esta entre 16 y 20 caracteres?
        mComparar enrango,1 
        je sentenciagood ;si, longitud de password correcta
        jne sentenciabad ;no, longitud de password incorrecta
    sentenciagood:
        mov largoe2 , 0 ;no hay error en el rango
        jmp salir 
    sentenciabad:
        mov largoe2 ,1 ;si hay eror en el rango
        mov eerror,1 ; hay error en usuario o contraseña
    salir: 
    pop si 
endm 

;MACRO PARA VERIFICAR SI ESTA EN RANGO O NO UN DATO 
mEnRango macro dato,limif, limsup
    local enElrango,noEnelrango,salir
    ;ja >,jb <,  jbe<=
    mComparar dato,limif
    jb noEnelrango ; si es menor al limite inferior no esa en el rango
    mComparar dato,limsup
    jbe enElrango ; si es menor o igual al limite superior esta en el rango
    ja noEnelrango; si es mayor no esta en el rango 
    enElrango:
        MovVariables enrango,1
        jmp salir 
    noEnelrango:
        MovVariables enrango,0
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
    push ax
    push si 
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
        pop si
        pop ax 
endm 
;CAPTURAR CONTRASEÑA
mCapturarPassword macro variableAlmacenadora 
    local salir,capturarLetras,deletCaracter
    push ax
    push si 
    mov si,0
    capturarLetras:
        mov ah,01h
        int 21h
        cmp al, 0dh ;es igual a enter?
        je salir ; una vez dado enter y capturado todo el nombre, pasar al siguiente procedimiento
        cmp al, 08 ;es igual a retroceso?
        je deletCaracter
        mMostrarString retroceso ;"<-"
        mMostrarString asterisco ; "*"
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
        pop si
        pop ax 
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


;SUMAR DW
mSumarDw macro var1,var2
    push ax 
    xor ax,ax 
    mov ax,var1
    add ax,var2
    mov var1,ax
    pop ax 
endm 
;SUMAR DB 
mSumardb macro var1,var2
    push ax 
    xor ax,ax 
    mov al,var1
    add al,var2
    mov var1,al
    pop ax 
endm 
;Resta dos variables
mRestadb macro var1,var2
    push ax 
    xor ax,ax 
    mov al, var1 
    sub al, var2
    mov var1, al
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
;ARCHIVOS 
mCrearFile macro nameFile
    local falloCT,salidaCT,salir 
    push ax
    mov cx,0    
    lea dx, nameFile
    mov ah, 3C
    int 21
    jc falloCT    
    mov handler, ax
    jmp salidaCT
    falloCT:
        mMostrarString savebad
        mov creacionCorrecta,0
        jmp salir
    salidaCT: ;sale del bucle
        mMostrarString savegood
        mov creacionCorrecta,1
        jmp salir
    salir:
    pop ax 
endm
;para escribir en un archivo externo
mWriteToFile macro palabra
    push ax 
    mov bx, handler
    mov cx, LENGTHOF palabra 
    mov dx, offset palabra
    mov ah,40
    int 21
    pop ax 
endm
mReadFile macro varAlmacenadora
    push ax 
    mov bx, handler
    mov cx, 1 
    lea dx, varAlmacenadora ; esto seria igual a:  mov dx, offset lectura, "EN LA POSICION DE LECTURA GRABAR LO LEIDO"
    mov ah, 3F
    int 21
    mov posLectura, ax 
    pop ax 
endm
mCloseFile macro
    mov bx, handler
    mov ah, 3Eh
    int 21
endm
;ARCHIVO
mOpenFile macro fileName
    local errorOpen,Opencorrecto,salidaOpen
    mov estadocarga,0
    mov al,0
    lea dx, fileName
    mov ah,3Dh
    int 21
    jc errorOpen
    mov handler, ax
    jmp Opencorrecto
    errorOpen:
        mMostrarString carbad
        mov estadocarga,0
        ;ESPERAR ENTER PARA VOLVER AL MENU
        mov ah, 01
        int 21 
        jmp salidaOpen
    Opencorrecto:
        ;mMostrarString cargood
        mov estadocarga,1
        ;ESPERAR ENTER PARA EMPEZAR A JUGAR
        mov ah, 01
        int 21 
        jmp salidaOpen
    salidaOpen:
endm

mOpenFile2Write macro fileName
    local errorOpen,Opencorrecto,salidaOpen
    mov estadocarga,0
    mov al,2
    lea dx, fileName
    mov ah,3Dh
    int 21
    jc errorOpen
    mov handler, ax
    jmp Opencorrecto
    errorOpen:
        mMostrarString carbad
        mov estadocarga,0
        jmp salidaOpen
    Opencorrecto:
        ;mMostrarString cargood
        mov estadocarga,1
        jmp salidaOpen
    salidaOpen:
endm
mHallarSimbolo macro simbolo 
    local buscar,salir 
    buscar:
    mReadFile eleActual 
    cmp posLectura,0  ;"LLEGO AL FINAL DEL DOCUMENTO?"
    je salir; si llego, salir del metodo sino seguir comparando 
    mComparar eleActual,simbolo ;buscando el simbolo buscado, si se hallo ya no se manda al ciclo buscar y se sale
    jne buscar
    salir:
endm 

;debug
;mMostrarString eProgram
;call pEspEnter 