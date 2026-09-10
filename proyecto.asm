; ------------------------------------------------------------
; Proyecto Módulo 1 - Visor de Memoria
; ------------------------------------------------------------

; Funciones de Windows
extern GetStdHandle: proc
extern WriteConsoleA: proc

.data

    ; ---- REQUISITO 1: Arreglo de 10 elementos de 64 bits ----
    arreglo DQ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50

    ; ---- Tabla para convertir números a hexadecimal ----
    hex_chars DB '0123456789ABCDEF'

    ; ---- Plantilla de texto ----
    msg_texto  DB "Direccion: "
    addr_hex   DB 16 DUP('0')
               DB " Valor: "
    val_hex    DB 16 DUP('0')
    newline    DB 13, 10, 0

    ; ---- Variables para la API de Windows ----
    hConsole   DQ 0
    written    DQ 0

.code

; ------------------------------------------------------------
; Función: print_hex_qword
;
; Entrada:
;   RAX = número que se va a convertir
;   RDI = dirección donde se guardará el texto
;
; Convierte un QWORD de 64 bits a 16 caracteres hexadecimales.
; ------------------------------------------------------------

print_hex_qword proc

    push rbx
    push rcx
    push rdx
    push r8

    mov rcx, 16

    ; Empezamos desde el último carácter
    add rdi, 15

    ; Máscara para obtener 4 bits
    mov rbx, 0Fh

hex_loop:

    ; Obtener los últimos 4 bits
    mov rdx, rax
    and rdx, rbx

    ; --------------------------------------------------------
    ; CORRECCIÓN IMPORTANTE:
    ; Usamos RIP-relative addressing para acceder a hex_chars
    ; en código x64.
    ; --------------------------------------------------------
    lea r8, hex_chars
    movzx rdx, byte ptr [r8 + rdx]

    ; Guardar carácter hexadecimal
    mov [rdi], dl

    ; Moverse una posición hacia la izquierda
    dec rdi

    ; Siguiente grupo de 4 bits
    shr rax, 4

    loop hex_loop

    pop r8
    pop rdx
    pop rcx
    pop rbx

    ret

print_hex_qword endp


; ------------------------------------------------------------
; Función: print_string
;
; Entrada:
;   RDI = dirección del texto terminado en 0
;
; Utiliza WriteConsoleA para imprimir.
; ------------------------------------------------------------

print_string proc

    push rbx
    push rcx
    push rdx
    push r8
    push r9

    ; --------------------------------------------------------
    ; Contar longitud del texto
    ; --------------------------------------------------------

    mov rcx, -1
    xor al, al

    repne scasb

    not rcx
    dec rcx

    ; Regresar RDI al inicio del texto
    sub rdi, rcx
    sub rdi, 1

    ; --------------------------------------------------------
    ; Shadow Space para la llamada de Windows
    ; --------------------------------------------------------

    sub rsp, 38h

    ; WriteConsoleA(
    ;     hConsole,
    ;     lpBuffer,
    ;     nNumberOfCharsToWrite,
    ;     lpNumberOfCharsWritten,
    ;     lpReserved
    ; )

    mov r8, rcx
    mov rdx, rdi
    mov rcx, [hConsole]
    lea r9, written

    mov qword ptr [rsp+20h], 0

    call WriteConsoleA

    add rsp, 38h

    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx

    ret

print_string endp


; ------------------------------------------------------------
; Función principal
; ------------------------------------------------------------

main proc

    ; Shadow Space
    sub rsp, 28h

    ; --------------------------------------------------------
    ; Inicializar consola
    ; --------------------------------------------------------

    mov rcx, -11
    call GetStdHandle

    mov hConsole, rax

    ; --------------------------------------------------------
    ; Preparar recorrido del arreglo
    ; --------------------------------------------------------

    lea rbx, arreglo

    mov rcx, 10

recorrer_arreglo:

    ; Guardar contador
    push rcx

    ; --------------------------------------------------------
    ; PASO A: Obtener dirección
    ; --------------------------------------------------------

    mov rax, rbx

    lea rdi, addr_hex

    call print_hex_qword

    ; --------------------------------------------------------
    ; PASO B: Obtener valor
    ; --------------------------------------------------------

    mov rax, [rbx]

    lea rdi, val_hex

    call print_hex_qword

    ; --------------------------------------------------------
    ; PASO C: Imprimir línea
    ; --------------------------------------------------------

    lea rdi, msg_texto

    call print_string

    ; Imprimir salto de línea
    lea rdi, newline

    call print_string

    ; --------------------------------------------------------
    ; PASO D: Avanzar al siguiente elemento
    ; --------------------------------------------------------

    add rbx, 8

    ; Recuperar contador
    pop rcx

    loop recorrer_arreglo

    ; --------------------------------------------------------
    ; Terminación limpia
    ; --------------------------------------------------------

    xor eax, eax

    add rsp, 28h

    ret

main endp

end main