#!/bin/bash

export superUser="sysdba"
export password="8088"
export client="sysdba"
#------------------------------------
export color_red="\033[1;31m"
export color_green="\033[1;32m"
export color_yellow="\033[1;33m"
export color_blue="\033[1;34m"
export color_purple="\033[1;35m"
export color_cyan="\033[1;36m"
export color_grey="\033[0;37m"
export color_reset="\033[m"

echo $password | sudo -S chown $superUser.$superUser -R /home/$client

#-----------------------------------------------------------------------------------
#Fixa o tamanho da janela do terminal
cols="$1"
rows="$(stty size | cut -d ' ' -f 1)"
printf '\033[10;%d;%dt' $rows $cols

# ====================================================================================
# MENU ITENS
# ====================================================================================

function Start_Docker() {

     echo -e "${color_green}================================================================================"
     echo -e "${color_green} Start Docker Service..."
     echo -e "${color_green}================================================================================"

     clear
     sudo service docker start

     echo -e "${color_reset}"
}

function Docker_Images() {

     clear

     echo -e "${color_green}================================================================================"
     echo -e "${color_green} Docker Imagens avaliable..."
     echo -e "${color_green}================================================================================"

     sudo docker image ls

     echo -e "${color_reset}"
}

function Docker_Containers() {

     clear

     echo -e "${color_yellow}================================================================================"
     echo -e "${color_yellow} Docker Containers avaliable..."
     echo -e "${color_yellow}================================================================================"

     sudo docker container ls -all

     echo -e "${color_reset}"
}

function Start_Glances() {

     clear
     sudo glances

     echo -e "${color_reset}"
}

function Start_All() {

     clear
     Start_PostgreSQL
     Start_SqlServer
     Start_Oracle

     sudo docker ps

     echo -e "${color_reset}"
}

function Stop_All() {

     clear
     Stop_PostgreSQL
     Stop_SqlServer
     Stop_Oracle

     sudo docker ps

     echo -e "${color_reset}"
}

function Start_PostgreSQL() {

     #     sudo docker run --name postgres_container \
     #     --detach \
     #     --tty \
     #     --env "POSTGRES_PASSWORD=postgres" \
     #     --publish 5432:5432 \
     #     --volume /tmp/postgres:/var/lib/dockerVolume/postgresql/data \
     #     postgres

     sudo docker start container_postgres
     sudo docker container --all
     echo -e "${color_reset}"
}

function Start_SqlServer() {
     sudo docker run --name sqlserver_container \ 
     --detach \
          --env "ACCEPT_EULA=Y" \ 
     --env "MSSQL_SA_PASSWORD=Sql@2022" \ 
     --publish 1433:1433 \ 
     mcr.microsoft.com/mssql/server:2022-latest

     sudo docker container -all
     echo -e "${color_reset}"
}

function Start_Oracle() {
     sudo docker run --name oracle_container \ 
     --detach \
          --env "ORACLE_PWD=oracle" \ 
     --publish 1521:1521 \ 
     container-registry.oracle.com/database/express:latest

     sudo docker container -all
     echo -e "${color_reset}"
}

function Stop_PostgreSQL() {
     docker stop postgres_container
     sudo docker ps
     echo -e "${color_reset}"
}

function Stop_SqlServer() {
     docker stop sqlserver_container
     sudo docker ps

     echo -e "${color_reset}"
}

function Stop_Oracle() {
     docker stop oracle_container
     sudo docker ps

     echo -e "${color_reset}"
}

function Terminal_PostgreSQL() {

     echo -e "${green}================================================================================"
     echo -e "${green} Postgres Conteiner terminal..."
     echo -e "${green}================================================================================"

     sudo docker exec -it postgres_container psql -U postgres

     echo -e "${color_reset}"
}

function Terminal_SqlServer() {
     echo -e "${color_reset}"
}

function Terminal_Oracle() {
     echo -e "${color_reset}"
}

function Create_PostgreSQL() {

     #--------------------------------------------------------------------------------------------------
     # Inicia a imagem no docker dentro do wsl2 criando um container
     # Este comando deve ser usado uma única vez para criar o container
     # Depois o container deve ser inciado com o comando START
     # -------------------------------------------------------------------------------------------------
     # sudo docker run   | Comando para rodar o container
     # --name            | Nome que será atribuido ao container
     # --env             | Define os valores de variaveis de ambiente da imagem
     # --volume          | Define um volume que será usado pela imagem <destino>:<origem>
     # --publish         | Define as portas para comunicação entre o docker e o host  <host>:<Docker>
     # --tty             | Keep STDIN open even if not attached/llocate a pseudo-tty
     # --detach          | Para iniciar um container no modo desanexado,

     containerName="container_postgres"
     publishPortHost=5432
     publishPortDocker=5432
     enviromentVariables="-e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres"
     volumeSource="/tmp/postgres/database"
     volumeDestination="/var/lib/postgresql/data"
     imageRepositoryName="postgres"

     sudo docker run --name $containerName --tty -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres --publish $publishPortHost:$publishPortDocker --volume $volumeSource:$volumeDestination --detach $imageRepositoryName

     sudo docker ps
     echo -e "${color_reset}"
}

function Create_SqlServer() {

     #--------------------------------------------------------------------------------------------------
     # Inicia a imagem no docker dentro do wsl2 criando um container
     # Este comando deve ser usado uma única vez para criar o container
     # Depois o container deve ser inciado com o comando START
     # -------------------------------------------------------------------------------------------------
     # sudo docker run   | Comando para rodar o container
     # --name            | Nome que será atribuido ao container
     # --env             | Define os valores de variaveis de ambiente da imagem
     # --volume          | Define um volume que será usado pela imagem <destino>:<origem>
     # --publish         | Define as portas para comunicação entre o docker e o host  <host>:<Docker>
     # --tty             | Keep STDIN open even if not attached/llocate a pseudo-tty
     # --detach          | Para iniciar um container no modo desanexado,

     containerName="container_mssql"
     publishPortHost=1433
     publishPortDocker=1433
     enviromentVariables="-e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD=Sql@2022"
     imageRepositoryName="mcr.microsoft.com/mssql/server"
     #volumeSource="/tmp/mssql/database"
     #volumeDestination="/var/opt/mssql/data"

     sudo docker run --name $containerName --tty -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Sql@2022" --publish $publishPortHost:$publishPortDocker --detach $imageRepositoryName

     sudo docker ps
     echo -e "${color_reset}"
}

function Create_Oracle() {

     sudo docker ps
     echo -e "${color_reset}"
}

function Start_PostGreSQL_Debug() {
     clear
     echo -e "${red_yellow}================================================================================"
     echo -e "${red_yellow} PostgreSQL container debug mode"
     echo -e "${red_yellow}================================================================================"
     echo -e "${color_reset}"

     docker logs container_postgres -f
}

function Start_SqlServer_Debug() {
     clear
     echo -e "${red_yellow}================================================================================"
     echo -e "${red_yellow} MS Sql Server container debug mode"
     echo -e "${red_yellow}================================================================================"
     echo -e "${color_reset}"

     docker logs container_mssql -f
}

function Start_Oracle_Debug() {
     clear
     echo -e "${red_yellow}================================================================================"
     echo -e "${red_yellow} Oracle container debug mode"
     echo -e "${red_yellow}================================================================================"
     echo -e "${color_reset}"

     docker logs container_oracle -f
}

# ===========================================================================================================
# MENU PRINCIPAL
# ===========================================================================================================

cmd=(dialog --keep-tite --menu "Docker Menu v1.1:" 22 76 16)

options=(
     1 "   ==> [Start All Container]"
     2 "       [Stop All Container ]"
     3 "   ==> [Start Container] PostgreSQL 14"
     4 "   ==> [Start Container] Sql Server 2022"
     5 "   ==> [Start Container] Sql Oracle 21c Express"
     6 "       [Stop Container ] PostgreSQL 14"
     7 "       [Stop Container ] Sql Server 2022"
     8 "       [Stop Container ] Sql Oracle 21c Express"
     9 "       [Terminal] PostgreSQL 14"
     10 "       [Terminal] Sql Server 2022"
     11 "       [Terminal] Sql Oracle 21c Express"
     12 "   --> [Create Container] PostgreSQL 14"
     13 "   --> [Create Container] Sql Server 2022"
     14 "   --> [Create Container] Sql Oracle 21c Express"
     15 "    Show docker images"
     16 "    Show docker containers"
     17 "    Start Daemon Docker"
     18 "==> Start Glances Monitor"
     19 " (!)  Start log container Postgres to debug"
     20 " (!)  Start log container Mssql to debug"
     21 " (!)  Start log container Oracle to debug"
)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices; do
     case $choice in
     1)
          Start_All
          ;;
     2)
          Stop_All
          ;;
     3)
          Start_PostgreSQL
          ;;
     4)
          Start_SqlServer
          ;;
     5)
          Start_Oracle
          ;;
     6)
          Stop_PostgreSQL
          ;;
     7)
          Stop_SqlServer
          ;;
     8)
          Stop_Oracle
          ;;
     9)
          Terminal_PostgreSQL
          ;;
     10)
          Terminal_SqlServer
          ;;
     11)
          Terminal_Oracle
          ;;
     12)
          Create_PostgreSQL
          ;;
     13)
          Create_SqlServer
          ;;
     14)
          Create_Oracle
          ;;
     15)
          Docker_Images
          ;;
     16)
          Docker_Containers
          ;;
     17)
          Start_Docker
          ;;
     18)
          Start_Glances
          ;;
     19)
          Start_PostGreSQL_Debug
          ;;
     20)
          Start_SqlServer_Debug
          ;;
     21)
          Start_Oracle_Debug
          ;;
     *)
          echo "invalid option $REPLY"
          ;;
     esac
     read -p "Enter para voltar ao menu ..."
     exec /bin/bash "$0" "$@"
done
