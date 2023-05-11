##### ==========================================================================================
##### POSTGRESQL
#####  https://www.baeldung.com/ops/postgresql-docker-setup
##### ==========================================================================================
```USER.....: postgres```

```PASSWORD.: postgres```

##### Rodar o container:

    docker run -itd -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v /data:/var/lib/postgresql/data --name postgresql postgres

##### ==========================================================================================
##### SQL SERVER
##### https://hub.docker.com/_/microsoft-mssql-server
##### ==========================================================================================
```USER.....: sa```

```PASSWORD.: Sql@2022```

##### Rodar o container:
	
    sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Sql@2022" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest


##### ==========================================================================================
##### ORACLE
##### https://medium.com/geekculture/run-oracle-database-21c-in-docker-351049344d0c
##### ==========================================================================================

Database Info

```host: localhost```

```port: 1521```

```username: system```

```password: oracle```

```sid: xe```

##### -----------------------------------

``` USER.....: system ou sys ```
``` PASSWORD.: oracle ```


 Pegar a ultima imagem disponivel 

	docker pull container-registry.oracle.com/database/express:latest

##### Criar um container

```
	docker container create `
	   -it `
	   --name oracle-container `
	   -p 1521:1521 `
	   -e ORACLE_PWD=oracle `
	   container-registry.oracle.com/database/express:latest
```

##### Rodar o container:
  	  
      sudo docker run -e "ORACLE_PWD=oracle" -p 1521:1521 -d container-registry.oracle.com/database/express:latest