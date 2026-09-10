# Proyecto Módulo 1: Visor de Memoria (x86-64)

## Objetivo del Proyecto
Desarrollar un programa en lenguaje ensamblador (arquitectura x86-64, sin dependencias externas) para gestionar e inspeccionar la memoria RAM[cite: 2].

## Requisitos Cumplidos
De acuerdo con la rúbrica solicitada, este proyecto implementa satisfactoriamente las siguientes características[cite: 2]:

1. **Definición de Datos:** Se definió un arreglo de 10 números (valores de 64 bits o `DQ`) dentro de la sección `.data`[cite: 2].
2. **Recorrido de Arreglo:** Se recorrió el arreglo utilizando un bucle (con el contador `RCX`) y un puntero mediante registro indirecto (usando el registro `RBX`)[cite: 2].
3. **Salida por Consola:** El programa muestra exitosamente en la pantalla de la consola el contenido en formato hexadecimal estricto (16 dígitos) de cada elemento del arreglo, precedido por su respectiva dirección de memoria[cite: 2].

## Herramientas y Compilación
Este código está escrito en ensamblador puro y utiliza únicamente `kernel32.dll` para las funciones básicas de la consola (cumpliendo con la restricción de cero dependencias externas)[cite: 2]. 

Para compilar y enlazar el código:
1. `uasm64 -win64 proyecto.asm`
2. `GoLink.exe proyecto.obj kernel32.dll /fo proyecto.exe /console /entry main`

## Video Demostrativo
En el siguiente video se explica el código paso a paso, se demuestra la ejecución en la consola y se verifica el comportamiento de los punteros en la memoria utilizando el depurador `x64dbg`.

🎥 **Enlace al video:** [Inserta tu enlace de YouTube o Drive aquí]
