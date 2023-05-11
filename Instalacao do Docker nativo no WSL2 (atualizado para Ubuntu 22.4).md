
###### =============================================================================================
###### ATENÇÃO! ESTA INTALACAO ASSUME O O LINUX NO WSL2 ESTEJA RODANDO EM MODO PID1
###### A VERSAO DO UBUNTU 22.04 JÁ VEM COM P PID1 ATIVADO
###### Original:  https://nickjanetakis.com/blog/install-docker-in-wsl-2-without-docker-desktop
###### =============================================================================================


##### 1- Ativando o Ubuntu como PID1 no Wls2 tornado a execução do sistema no WLS2 mais próxima do nativo

Edite o arquivo wsl.conf:
```
	sudo -e /etc/wsl.conf
```
Adicione as seguintes linhas:
```
	[boot]
	systemd=true
```
Saia do Ubuntu e novamente:
```
	wsl --shutdown
```
Em seguida, reinicie o Ubuntu.

	sudo systemctl status

Isso deve mostrar seus serviços Systemd.



#### 2- Instalalando o Dockers


#### Install Docker, you can ignore the warning from Docker about using WSL

    curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh

#### Add your user to the Docker group

    sudo usermod -aG docker $USER

#### Install Docker Compose v2
	
    sudo apt-get update && sudo apt-get install docker-compose-plugin
    
#### Sanity check that both tools were installed successfully
	
    docker --version
	docker compose version
    
#### Using Ubuntu 22.04 or Debian 10 / 11? You need to do 1 extra step for iptables
##### compatibility, you'll want to choose option (1) from the prompt to use iptables-legacy.
	
    sudo update-alternatives --config iptables
    

###### =============================================================================================
###### 3 Corrigindo o problema: Erro “Permissão negada ao tentar se conectar ao Docker Daemon Socket
###### Orriginal:  https://www.baeldung.com/linux/docker-permission-denied-daemon-socket-error#
###### =============================================================================================

1- Elevar os privilegios

    sudo docker run -it ubuntu:latest /bin/bash
	[sudo] <password for root user>
	saida==>root@5a909c4c6138:/#

2- Adicionar os grupos

    sudo groupadd docker

	getent group docker
		saida==>docker:x:999:

	awk -F':' '/docker/{print $4}' /etc/group

	sudo usermod -aG docker <user root name>

3- Modificar as permissões de leitura e gravação


    sudo ls -la /var/run/docker.sock
	[sudo] <password for root user>
		saida==>srw-rw---- 1 root docker 0 Mar 13 06:05 /var/run/docker.sock


	sudo chmod 666 /var/run/docker.sock

	ls -la /var/run/docker.sock
		saida==>srw-rw-rw- 1 root docker 0 Mar 13 06:05 /var/run/docker.sock


4 - Por fim reinice o serviço

    sudo service docker restart
	sudo service docker status



