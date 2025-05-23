
alias spu = sudo pacman -Sy            # Actualizar la base de datos de paquetes
alias spua = sudo pacman -Syu          # Actualizar todos los paquetes
alias sps = pacman -Ss                 # Buscar paquetes en los repositorios
alias spl = pacman -Qs                 # Buscar paquetes instalados
alias spi = sudo pacman -S             # Instalar un paquete
alias spil = sudo pacman -U            # Instalar un paquete local (.pkg.tar.zst)
alias spr = sudo pacman -R             # Eliminar un paquete (conservando configuraciones)
alias sprd = sudo pacman -Rsn          # Eliminar un paquete y sus dependencias no requeridas
alias spra = sudo pacman -Rsc          # Eliminar un paquete con todas sus dependencias (¡Cuidado!)
alias spin = pacman -Si                # Mostrar información detallada de un paquete
alias spinl = pacman -Qi               # Mostrar información de paquetes instalados
alias spli = pacman -Ql                # Listar archivos de un paquete instalado
alias spo = pacman -Qo                 # Ver qué paquete provee un archivo
alias spc = sudo pacman -Sc            # Limpiar caché de paquetes (excepto versiones instaladas)
alias spca = sudo pacman -Scc          # Limpiar TODO el caché (¡Cuidado!)
alias spo = pacman -Qdt                # Listar paquetes huérfanos (dependencias no requeridas)
alias spe = pacman -Qe                 # Listar paquetes explícitamente instalados
alias spd = pacman -Qd                 # Listar paquetes instalados como dependencias

alias spro = sudo pacman -Rns (pacman -Qdtq | str join " ")     # Eliminar paquetes huérfanos
alias splo = expac --timefmt = \%Y-%m-%d %T\ \%l\t%n\ | sort -n # Ver historial de cambios en paquetes (necesita pacman-contrib)
