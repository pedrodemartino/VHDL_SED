# VHDL_SED

## Creación del fichero de proyecto

Abrir Vivado y en la consola de Tcl ejecutar el comando:

```
pwd
```

Este comando imprime el directorio de trabajo actual:

```
C:/Users/nombre/AppData/Roaming/Xilinx/Vivado
```

Normalmente no será el que queremos. Usaremos el comando:

```
cd C:\Mi_directorio_raiz\mi_subdirectorio\...\mi_proyecto
```

para ir al directorio donde he clonado mi proyecto. Una vez en el directorio
donde está el script Tcl, lo ejecutaremos con:

```
source  ./Trabajo-VHDL-SED-G1.tcl
```

El proyecto se creará en la carpeta:

```
C:\Mi_directorio_raiz\mi_subdirectorio\...\mi_proyecto\Trabajo-VHDL-SED-G1
```

y se abrirá automáticamente. Esta carpeta no se debe incluir en el control de
versiones.

## Adición de nuevos ficheros

Vivado insistirá en crear los nuevos ficheros en su estructura de directorios.
No nos interesa. En mejor crear ficheros vacíos en src/ con el explorador,
incorporarlos al proyecto (vigilar que no esté marcada "Copy to project") y
luego ya editarlos en Vivado.
