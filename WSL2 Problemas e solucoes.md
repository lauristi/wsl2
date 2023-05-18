

#####  Kaspersky bloqueando o wsl2

Mesmo problema.
Consegui corrigi-lo entrando no modo de segurança e usando:

Pressione win + r;
Escreva "cmd"
Dê o comando:

```
sc config LxssManager start=auto
```

Parece que o Kaspersky bloqueou o serviço, então é bom reinstalá-lo se você tiver um 
e quando perguntar sobre a execução de comandos do Linux, deixe-o desbloqueado.

!!! Lembre-se de usar o CMD como administrador



##### Alterado a politica de execuções pelo Power Shell

1 - mostra as politicas de execucao
```
Get-ExecutionPolicy
```

2 - seta a politca bypass (tudo liberado) para o usuario atual
```
Set-ExecutionPolicy -Scope CurrentUser Bypass
```

##### DEPOIS DE EFETUAR UM IMPORT O WSL NÃO SETA AUTOMATICAMENTE O USUARIO PADRAO

1- Recupere o ```UID``` do usuário

PowerShell

```
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq <UbuntuCustom> | Set-ItemProperty -Name DefaultUid -Value 1000
```

DistributionName -> Nome da dsistribuicao usado no comamando 
```wsl --Import```.
e o "- Valor 1000" é o Uid do usuário que você deseja alterar.

Nota: Para encontrar o Uid basta escrever ```"cat /etc/passwd | grep"```

Por exemplo: 

```
cat /etc/passwd | grep Bob
```

Resultado: BobX1000:1000 Bob
Esse 1000 é o Uid

Exemplo:

```
cat /etc/passwd | grep asus
asus:x:1000:1000:asus:/home/asus:/bin/bash
```



##### Funcao completa que seta o usuario novamente

```
wsl -d <DistroName> -u <UserName> -e id -u
```
```
Function WSL-SetDefaultUser ($distro="<DistroName>", $user="<UserName>") { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); }; WSL-SetDefaultUser; Remove-Item Function:WSL-SetDefaultUser;
```

Exemplo:


##### Comando para recuperar o id do usuario
```
wsl -d Ubuntu-22.04 -u sysdba -e id -u
```

##### Funcao completa que seta o usuario novamente

```
Function WSL-SetDefaultUser ($distro="Ubuntu-22.04", $user="sysdba") { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); }; WSL-SetDefaultUser; Remove-Item Function:WSL-SetDefaultUser;
```


##### BACKUP E IMPORTACAO DO WLS2


1 - Crie um diretorio para receber o disco virtual.
2 - Copie o backup para este disco virtual

Exemplo de comando:

```
	wsl --import <NOME DA DISTRO> <DESTINO> <ORIGEM-BACKUP>
 
	wsl --import Ubuntu c:\Wsl2 c:\Wsl2\Ubuntu_Completo_30012023.tar
```

Caso esteja subistituindo uma imagem danificada,lembre-se de eliminar a atual:

```	
    wsl --unregister <NOME DA DISTRO>
	
	wsl --unregister Ubuntu
 ```
