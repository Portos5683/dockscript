#!/bin/bash
echo ""
echo ""
echo ""
echo "#############################################################"
echo ""
echo "Bienvenue dans l'installation et/ou la configuration de Vault"
echo ""
echo "#############################################################"
echo ""
echo ""
echo ""
cowsay Welcome in the GOULAG
echo ""
echo ""
echo "Verification du mode d'excution"
echo ""
function verify_extension_file_in_folder()
{
    accpet_route=0
    while [ $accpet_route = 0  ]
    do
        echo ""
        read -p "Veuillez preciser le chemin absolu vers le Dossier contenant les fichiers zip de Vault excepter du dernier / ( eg : au lieu de /home/ace3i/zip/ saisir /homme/ace3i/zip ) : " zip_home
        temp=`ls $zip_home/*.$1`
        temp=${temp:0:2}
        if [[ -d "$zip_home/" && "$temp" != "" ]]
        then
           zip_home=$zip_home
           accpet_route=1 
        else
            echo "-------------------------------------------------------------------------------------------"
            echo ""
            echo "  ERROR DE SAISIE:  le dossier $zip_home/ n'existe pas ou il n'y en a pas de fichier .$1 "
            echo ""
            echo "--------------------------------------------------------------------------------------------"
        fi
    done
}
excution_type=
for args in "$@"
do
   if [ $args = external ]
   then
        excution_type=yes
        echo " Vous executer ce fichier de configuration grace a un autre programme"
        echo ""
   fi
done
if [ "$excution_type" = "yes" ]
then
    echo "Recuperation des variable d'environnement"
    echo ""
    zip_home=$EPAIEMENT_HOME
else
    echo "Vous excuter ce fichier en mode utilisateur"
    echo "" 
    verify_extension_file_in_folder zip
fi
mode=$1

#********************************************** Si la premiere option n'est pas exit < exit >
vaultinstall=`vault --version`
vaultinstall=${vaultinstall:0:5}
if [ "$vaultinstall" = "Vault" ]
then
##********************************************* Si vault est installer
   echo "Vault est déjà installé avec la version suivante :"
   vault --version
   #CONFIGURATION DE REGLE DE PAREFEU
   echo "Configuration des règles de sécurité et de pare-feu --> 0%"
   setenforce 0
   sed -i 's/\(SELINUX=enforcing\).*/\SELINUX=permissive/' /etc/selinux/config
   systemctl start firewalld.service
   firewall-cmd --add-port=80/tcp --permanent
   firewall-cmd --add-port=8200/tcp --permanent
   firewall-cmd --add-port=443/tcp --permanent
   firewall-cmd --reload
   sudo systemctl daemon-reload
   echo "Configuration des règles de sécurité et de pare-feu --> 100%"
   export VAULT_ADDR="http://127.0.0.1:8200"
   if [ -e "/etc/vault/init.file" ]
   then
###******************************************* Si le fichier de sauvergarde des cles existes
      echo ""
      echo "AUTO-EXTRACTION DES CLES DE VAULT CAR LE FICHIER DE SAUVEGARDE DES CLES EXISTE /etc/vault/init.file"
      echo ""
      echo "Extraction des clés et du jeton"
      tokenline=`sed '7!d' /etc/vault/init.file`
      token=${tokenline:20:50}
      vaultkey1=`sed '1!d' /etc/vault/init.file`
      key1=${vaultkey1:14:100}
      vaultkey2=`sed '2!d' /etc/vault/init.file`
      key2=${vaultkey2:14:100}
      vaultkey3=`sed '3!d' /etc/vault/init.file`
      key3=${vaultkey3:14:100}
###************************************************************************************
   else
###****************************************** Si le fichier de sauvegarde des cles n'existe pas 
      token=""
      while [ "$token" = "" ]
      do
         read -p "Saisissez la valeur du token : " $token
      done
      $key1=""
      while [ "$key1" = "" ]
      do
         read -p "Saisissez la valeur de la cle numero 1: " key1
      done
      $key2=""
      while [ "$key2" = "" ]
      do
         read -p "Saisissez la valeur de la cle numero 2: " key2
      done
      $key3=""
      while [ "$key3" = "" ]
      do
         read -p "Saisissez la valeur de la cle numero 3: " key3
      done
###***************************************************************************************************************
   fi
##*****************************************************************************************************************************
else
##********************************************* Si vault n'est pas installer
echo ""
echo "Aucune version de vault n'a été trouvée ;"
echo "Nous allons donc poursuivre avec l'installation de vault v-1.15.0"
echo ""
#installation de vault
echo ""
echo "Installation de vault --> 0%"
echo ""
unzip $zip_home/vault_1.15.0_linux_amd64.zip
mv vault /usr/local/bin/
vault -autocomplete-install
complete -C /usr/local/bin/vault vault
mkdir /etc/vault
echo ""
echo "Installation de vault --> 20%"
echo ""
mkdir -p /var/lib/vault/data
useradd --system --home /etc/vault --shell /bin/false vault
chown -R vault:vault /etc/vault /var/lib/vault/
echo ""
echo "Installation de vault --> 50%"
echo ""
echo "Initialisation du service Vault --> 0%"
echo ""
cat <<EOF | sudo tee /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.hcl

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl
ExecReload=/bin/kill --signal HUP 
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitBurst=3
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
echo ""
echo "Installation de vault --> 70%"
echo ""
cat <<EOF | sudo tee /etc/vault/config.hcl
disable_cache = true
disable_mlock = true
ui = true
listener "tcp" {
   address          = "0.0.0.0:8200"
   tls_disable      = 1
}
storage "file" {
   path  = "/var/lib/vault/data"
 }
api_addr         = "http://0.0.0.0:8200"
max_lease_ttl         = "10h"
default_lease_ttl    = "10h"
cluster_name         = "vault"
raw_storage_endpoint     = true
disable_sealwrap     = true
disable_printable_check = true
EOF
echo ""
echo "Initialisation du service Vault --> 100%"
#CONFIGURATION DE REGLE DE PAREFEU
echo ""
echo "Configuration des regles de securite et de pare-feu --> 0%"
setenforce 0
sed -i 's/\(SELINUX=enforcing\).*/\SELINUX=permissive/' /etc/selinux/config
systemctl start firewalld.service
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=8200/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --reload
echo ""
echo "Configuration des regles de securite et de parefeu --> 100%"
echo ""
echo "Installation de vault --> 95%"
echo ""
sudo systemctl daemon-reload
sudo systemctl enable --now vault
tempvaultaddr=`cat /root/.bashrc | grep "export VAULT_ADDR="`
if [ "$tempvaultaddr" = "" ]
then
   echo "export VAULT_ADDR=\"http://127.0.0.1:8200\"" >> "/root/.bashrc"
fi
export VAULT_ADDR="http://127.0.0.1:8200"
sudo rm -rf  /var/lib/vault/data/*
echo ""
echo "Installation de vault --> 100%"
echo ""
#Configuration de Vault
echo "Configuration de vault --> 0%"
echo "Sauvegarde des cles de deverrouillage"
vault operator init > /etc/vault/init.file
tempvaultinfo=/etc/vault/init.file
printFilePath $tempvaultinfo
echo ""
echo "Extraction des clés et du jeton"
tokenline=`sed '7!d' /etc/vault/init.file`
token=${tokenline:20:50}
vaultkey1=`sed '1!d' /etc/vault/init.file`
key1=${vaultkey1:14:100}
vaultkey2=`sed '2!d' /etc/vault/init.file`
key2=${vaultkey2:14:100}
vaultkey3=`sed '3!d' /etc/vault/init.file`
key3=${vaultkey3:14:100}
##********************************************************************************************************************
fi
if [ "$token" = "" ]
then
##************************************************* Si le token a une valeur vide
   echo "------------------------------------------"
   echo ""
   echo "ERROR DE SAISIE:  Vous n'avez pas saise de Jeton (Token : $token)"
   echo ""
   echo "------------------------------------------"
   if [ "$key1" = "" ]
   then
###************************************************ Si le valeur de la premiere cle est vide
      if [ "$key2" = "" ]
      then
####*********************************************** Si la valeur de la deuxieme cle est vide
         if [ "$key3" = "" ]
         then
#####********************************************** Si la valeur de la troisieme cle est vide
            echo "------------------------------------------"
            echo ""
            echo "ERROR DE SAISIE:  Vous n'avez entrer aucune cle de deverrouillage "
            echo " (key1 : $key1),"
            echo " (key2 : $key2),"
            echo " (key3 : $key3)"
            echo ""
            echo "------------------------------------------"
#####************************************************************************************************************
         fi
####***********************************************************************************************************
      fi
###************************************************************************************************************
   fi
##******************************************************************************************************************************************************
else
##************************************************ Si la valeur du token n'est pas vide 
   ### FOR OFFLINE PACKAGE CONFIG BEGIN VAULT CONFIG HERE
   echo ""
   echo "Configuration de vault -->    30%"
   echo ""
   vault operator seal
   vault operator unseal $key1
   vault operator unseal $key2
   vault operator unseal $key3
   #recuperation de l'addresse IP
   echo "Récupération de l'adresse ip"
   interface=`ip addr | grep enp`
   interface=${interface:3:15}
   interface=$(echo $interface | sed 's/:.*//')
   ipaddr=`ip -f inet -o addr show $interface | cut -d\  -f 7 | cut -d/ -f 1`
   #Initialisation des variables dans /root/.bashrc
   echo "Initialisation des variables dans /root/.bashrc"
   tempvaultaddr=`cat /root/.bashrc | grep "export VAULT_ADDR="`
   tempvaulttoken=`cat /root/.bashrc | grep "export VAULT_TOKEN="`
   if [[ "$tempvaultaddr" = "" && "$tempvaulttoken" = "" ]]
   then
      echo "export VAULT_ADDR=\"http://$ipaddr:8200\"" >> "/root/.bashrc"
      echo "export VAULT_TOKEN=\"$token\"" >> "/root/.bashrc"
   fi
   echo "Initialisation des variables dans à chaud"
   export VAULT_ADDR="http://127.0.0.1:8200"
   export VAULT_ADDR="http://$ipaddr:8200"
   export VAULT_TOKEN="$token"
   echo ""
   echo "Configuration de vault -->    60%"
   echo ""
   #Insertion des informations important de vault
   read -p " Voulez vous creer un engine ? [y/n] : " response
   if [ $response = 'y' ]
   then
###***********************************************  Si vous voulez creer un engine
      echo "Insertion des informations importantes de vault --> 0%"
      echo ""
      echo "Inserer un nom pour l'engine utilisable dans vault"
      read engine
      echo "Creation de l'engine"
      vault secrets enable -path=$engine kv-v2
###************************************************************************************************
   fi
##*****************************************************************************************************
fi
#*****************************************************************************************************************

#************************************************ Si le premier argument est exit

#############################################################  FONCTIONS   ###################################################
function printArgurment()
{
   echo ""
   echo ""
   echo "----------------------------------------------------------------"
   echo ""
   echo "Vous avez lancer la configuration de plusieurs connecteur"
   echo ""
   echo "----------------------------------------------------------------"
   echo ""
   echo ""
   echo "________________Liste des connecteurs_________________"
   echo ""
   echo ""
}
function printConnectorMenu()
{
   echo "------------------------------------------"
   echo ""
   echo "Insertion des informations dans Vault"
   echo ""
   echo "------------------------------------------"
   echo ""
   echo ""
   echo "____________________MENU_____________________"
   echo ""
   echo "1) Connecteur d'amplitude"
   echo ""
   echo "2) Connecteur d'otr"
   echo ""
   echo "3) Connecteur de Paygate"
   echo ""
   echo "4) Connecteur de Seguce"
   echo ""
   echo "5) Connecteur de Sydonia"
   echo ""
   echo "6) Connecteur de Tgterminal"
   echo ""
   echo "7) Connecteur de Togocom"
   echo ""
   echo "8) Connecteur de Epaiement"
   echo ""
   echo "9) Connecteur de Moov"
   echo ""
   echo "............................................."
   echo ""
}
function printMenu()
{
   echo ""
   echo ""
   echo "-------------------------------------------------------"
   echo ""
   echo "Quel operation voulez-vous operer sur votre serveur vault"
   echo ""
   echo "-------------------------------------------------------"
   echo ""
   echo ""
   echo "____________________MENU_____________________"
   echo ""
   echo "1) Insertion de donnees"
   echo ""
   echo ""
   echo "2) Mise a jour de donnees"
   echo ""
   echo ""
   echo "3) Consultation de donnees"
   echo ""
   echo "............................................."
   echo ""
}
########################### OPTION 2 ##################
function modifySecret()
{
   echo ""
   read -p "Saississez le path du secret (eg: engine/secret) : " secretpath
   echo ""
   read -p "Saissisez le key que vous voulez remplacer : " secretkey
   echo ""
   oldvalue=`vault kv get -field="$secretkey" $secretpath/`
   echo "L'ancienne valeur pour la key $secretkey est : $oldvalue"
   echo ""
   read -p "Saississez la nouvelle valeur : " newvalue
   export VAULT_FORMAT="json"
   vault kv get -field=data $secretpath/ > json/temp.json
   sed -i 's/\("'$secretkey'":\).*/\"'$secretkey'": "'$newvalue'"/' json/temp.json
   vault kv put $secretpath/ @json/temp.json
   rm -rf json/temp.json
   export VAULT_FORMAT="table"
   echo "##############################################################################################################"
   echo ""
   echo "Update $oldvalue --> $newvalue for $secretkey in $secretpath"
   echo ""
   echo "#############################################################################################"
}
########################################################
#################   OPTION 3 ########
function printConsulVault()
{
   echo ""
   echo ""
   echo "------------------------------------------"
   echo ""
   echo "Quel operation voulez-vous faire ?"
   echo ""
   echo "------------------------------------------"
   echo ""
   echo ""
   echo "____________________MENU_____________________"
   echo ""
   echo "1) Voir l'enpemble des engines"
   echo ""
   echo ""
   echo "2) Voir la liste des secrets d'un engines"
   echo ""
   echo ""
   echo "3) Recuperer en fichier externes les Datas d'un secret [-BACKUP-]"
   echo "     NB: Pour cette option preciser le chemin : engine/secret"
   echo ""
   echo "............................................."
   echo ""
}
function listVaultSecret()
{
   echo ""
   echo ""
   echo "------------------------------------------"
   echo ""
   echo "Liste des secrets de l'engine : $1"
   echo ""
   echo "------------------------------------------"
   echo ""
   echo ""
   vault kv list $1/ > temp.txt
   tail -n +3 temp.txt
   rm -rf temp.txt
   echo "............................................."
   echo ""
}
function listVaultEngine()
{
   echo ""
   echo ""
   echo "------------------------------------------"
   echo ""
   echo "            Liste des engine"
   echo ""
   echo "------------------------------------------"
   echo ""
   echo ""
   vault secrets list > temp.txt
   tail -n +1 temp.txt
   rm -rf temp.txt
   echo "............................................."
   echo ""
}
function listSecretData()
{
   echo ""
   echo ""
   echo "---------------------------------------------"
   echo ""
   echo "            Liste des datas du secret : $1 "
   echo ""
   echo "---------------------------------------------"
   echo ""
   echo ""
   export VAULT_FORMAT="table"
   vault kv get $1/
   export VAULT_FORMAT="json"
   vault kv get $1/ > json/data.json
   export VAULT_FORMAT="table"
   echo "............................................."
   echo ""
   printFilePath "json/data.json"
}
####################################################################
function printFilePath()
{
   echo "##################################################"
   echo ""
   echo "  Le fichier est sauvegarder sous le nom de $1"
   echo ""
   echo "##################################################"
}
function epaiementInsertData()
{
   sure=1
   response=n
   while [ $sure -ge 1 ]
   do
      echo ""
      echo "----------------------------------------------------------------------------"
      echo ""
      echo "Insertion des informations pour la configuration de vault --> epaiement"
      echo ""
      echo "----------------------------------------------------------------------------"
      echo ""
      echo "Veuillez insérer l'adresse email de l'administrateur (eg: admin@mail.com)"
      echo "La valeur actuelle est : \"$adminemail\""
      read -p "New value : " adminemail 
      echo ""
      echo "Insérer une valeur pour la variable connector.amplitude.host : Url du connecteur amplitude (eg: https://ace3i-connector-amplitude:8300)"
      echo "La valeur actuelle est : \"$connectoramplitudehost\""
      read -p "New value : " connectoramplitudehost 
      echo ""
      echo "Insérer une valeur pour la variable gateway.url : Url d'accès de Epaiement (eg: https://<adresse-serveur-epaiement>)"
      echo "La valeur actuelle est : \"$gatewayurl\""
      read -p "New value : " gatewayurl
      echo ""
      echo "Insérer une valeur pour la variable spring.datasource.hostname : adresse IP ou nom d'hôte du serveur de base de données"
      echo "La valeur actuelle est : \"$springdatasourcehostname\""
      read -p "New value : " springdatasourcehostname
      echo ""
      echo "Insérer une valeur pour la variable spring.datasource.password : Mot de passe de l'utilisateur de la base de données"
      echo "La valeur actuelle est : \"$springdatasourcepassword\""
      read -p "New value : " springdatasourcepassword
      echo ""
      echo "Insérer une valeur pour la variable spring.datasource.username : Nom d'utilisateur de la base de données "
      echo "La valeur actuelle est : \"$springdatasourceusername\""
      read -p "New value : " springdatasourceusername
      echo ""
      echo "Insérer une valeur pour la variable spring.datasource.port : Port de la base de données "
      echo "La valeur actuelle est : \"$springdatasourceport\""
      read -p "New value : " springdatasourceport
      echo ""
      echo "Insérer une valeur pour la variable spring.mail.from: Adresse email utilisée pour envoyer les mails"
      echo "La valeur actuelle est : \"$springmailfrom\""
      read -p "New value : " springmailfrom
      echo ""
      echo "Insérer une valeur pour la variable spring.mail.host: adresse IP ou nom d'hôte du serveur de messagerie"
      echo "La valeur actuelle est : \"$springmailhost\""
      read -p "New value : " springmailhost
      echo ""
      echo "Insérer une valeur pour la variable spring.mail.password: Mot de passe du compte de messagerie utilisé pour l'envoi des mails"
      echo "La valeur actuelle est : \"$springmailpassword\""
      read -p "New value : " springmailpassword
      echo ""
      echo "Insérer une valeur pour la variable spring.mail.port: Port du serveur de messagerie"
      echo "La valeur actuelle est : \"$springmailport\""
      read -p "New value : " springmailport
      echo ""
      echo "Insérer une valeur pour la variable spring.mail.username : Nom d'utilisateur du compte de messagerie"
      echo "La valeur actuelle est : \"$springmailusername\""
      read -p "New value : " springmailusername
      echo ""
      echo "Insérer une valeur pour la variable spring.redis.host : Adresse IP ou nom d'hôte du serveur redis"
      echo "La valeur actuelle est : \"$springredishost\""
      read -p "New value : " springredishost
      echo ""
      echo "Insérer une valeur pour la variable spring.redis.password : Mot de passe d'accès à la base redis (eg: MotDePasse)"
      echo "La valeur actuelle est : \"$springredispassword\""
      read -p "New value : " springredispassword
      echo ""
      echo "Insérer une valeur pour la variable spring.redis.port : Port de la base redis"
      echo "La valeur actuelle est : \"$springredisport\""
      read -p "New value : " springredisport 
      echo ""
      echo "Formatage des donnees qui seront envoyer a vault"  
      echo ""
      echo "#########################################################################################################################"
      echo ""
      echo " Etes vous sur de vos informations saisies ?"
      echo ""
      echo ""
      echo "\"admin.email\": \"$adminemail\""
      echo "\"connector.amplitude.host\": \"$connectoramplitudehost\""
      echo "\"gateway.url\": \"$gatewayurl\""
      echo "\"spring.datasource.hostname\": \"$springdatasourcehostname\""
      echo "\"spring.datasource.password\": \"$springdatasourcepassword\""
      echo "\"spring.datasource.port\": \"$springdatasourceport\""
      echo "\"spring.datasource.username\": \"$springdatasourceusername\""
      echo "\"spring.mail.from\": \"$springmailfrom\""
      echo "\"spring.mail.host\": \"$springmailhost\""
      echo "\"spring.mail.password\": \"$springmailpassword\""
      echo "\"spring.mail.port\": \"$springmailport\""
      echo "\"spring.mail.username\": \"$springmailusername\""
      echo "\"spring.redis.host\": \"$springredishost\""
      echo "\"spring.redis.password\": \"$springredispassword\""
      echo "\"spring.redis.port\": \"$springredisport\""
      echo ""
      echo "##################################################################################################################"
      read -p " Valider les informations ci-dessus ? [y/n] : " response
      if [ $response = 'y' ]; then
         sure=0
      fi
   done
   ##########perl -i -p -e 's|"admin.email": .*|"admin.email": "'$adminemail'",|g' "test.json"
   echo "Insertion des donnees dans le fichiers $EPAIEMENT_HOME/auto/json/config.json"
   sed -i 's/\("admin.email":\).*/\"admin.email": "'$adminemail'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("connector.amplitude.host": \).*/\"connector.amplitude.host": "'$connectoramplitudehost'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("gateway.url": \).*/\"gateway.url": "'$gatewayurl'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.datasource.hostname": \).*/\"spring.datasource.hostname": "'$springdatasourcehostname'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.datasource.password": \).*/\"spring.datasource.password": "'$springdatasourcepassword'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.datasource.port": \).*/\"spring.datasource.port": "'$springdatasourceport'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.datasource.username": \).*/\"spring.datasource.username": "'$springdatasourceusername'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.mail.from": \).*/\"spring.mail.from": "'$springmailfrom'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.mail.host": \).*/\"spring.mail.host": "'$springmailhost'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.mail.password": \).*/\"spring.mail.password": "'$springmailpassword'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.mail.port": \).*/\"spring.mail.port": "'$springmailport'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.mail.username": \).*/\"spring.mail.username": "'$springmailusername'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.redis.host": \).*/\"spring.redis.host": "'$springredishost'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.redis.password": \).*/\"spring.redis.password": "'$springredispassword'",/' $EPAIEMENT_HOME/auto/json/config.json
   sed -i 's/\("spring.redis.port": \).*/\"spring.redis.port": "'$springredisport'",/' $EPAIEMENT_HOME/auto/json/config.json
   vault kv put $1/epaiement-online @$EPAIEMENT_HOME/auto/json/config.json
   sure=1
   response=n
}
#####################   CONFIGURATION DANS VAULT ################################
echo ""
echo ""
echo "Welcome in the GOULAG"
echo ""
echo ""
echo ""
echo "Initialisation des variables de procedure"
adminemail=""
connectorotrhost=""
gatewayurl=""
springdatasourcehostname=""
springdatasourcepassword=""
springdatasourceusername=""
springdatasourceport=""
springmailfrom=""
springmailhost=""
springmailpassword=""
springmailport=""
springmailusername=""
springredishost=""
springredispassword=""
springredisport=""
connectoramplitudehost=""
makesure=1
repo=n
while [ $makesure -ge 1 ]
do
##************************************************************* BOUCLE DE MENU  ########################
   printMenu
   read -p "Quel est votre choix : " choix
   ########################################################## OPTION INSERTION DE DONNEES  ##############################################
   if [ $choix = 1 ]
   then
###***************************************************** Si l'option 1 est choisi "Insertion de donnees"
      mode=$1
      nbreargument=$#;
      firstarg=$1
      if ([ $nbreargument = 0 ] || [[ $firstarg = exit && $nbreargument = 1 ]])
      then
####**************************************************** Si le premier argument est vide ou que il n'y a que un seul argument etu que c'est "exit"
         sure=1
         response=n
         while [ $sure -ge 1 ]
         do
#####*************************************************** Boucle sur le menu "configuration assiter des connecteur"
            printConnectorMenu
            read -p "Quel configuration de connecteur voulez-vous operer : " connecteur
            if [ $connecteur = 1 ]
            then
               echo "lllll"
            fi
            if [ $connecteur = 2 ]; then
               otrInsertData
            fi
            if [ $connecteur = 3 ]
            then
               echo "lllll"
            fi
            if [ $connecteur = 4 ]
            then
               echo "lllll"
            fi
            if [ $connecteur = 5 ]
            then
               echo "lllll"
            fi
            if [ $connecteur = 6 ]
            then
               echo "lllll"
            fi
            if [ $connecteur = 7 ]
            then
               echo "lllll"
            fi
            if [ $connecteur = 8 ]
            then
               listVaultEngine
               echo ""
               read -p "Dans que engine voulez vous inserer les donnees de epaiement ? : " engine
               echo ""
               epaiementInsertData $engine
            fi
            if [ $connecteur = 9 ]; then
               echo "lllll"
            fi
            echo ""
            read -p " Voulez vous sortir de cette option "Configuration assiter des connecteur" ? [y/n] : " response
            echo ""
            if [ $response = 'y' ]; then
               sure=0
            fi
#####************************************************************************************************************************************
         done
         sure=1
         response=n
####****************************************************************************************************************************************
      else
####**************************************************** Si les argument sont plus que un ou que il sont plus que deux mais le premier argument est "exit"
        printArgurment
        for connecteur in "$@"
        do
           if [[ $connecteur != external && $connecteur != exit ]]
           then
              echo ""
              echo "Connecteur $connecteur";
              echo ""
           fi
        done
        echo ""
        echo "............................................."
        echo ""
        read -p "Etes vous sur de vouloir tous les installer ? [y/n] : " response
        echo ""
        if [ $response = 'y' ]; then
#####************************************************** Si on est sur d'installer tout les arguments
           for connecteur in "$@"
           do
              if [[ $connecteur != external && $connecteur != exit ]]
              then
                 if [ $connecteur = amplitude ]; then
                    echo "dsddssdsdsd"
                 fi
                 if [ $connecteur = otr ]; then
                    otrInsertData
                 fi
                 if [ $connecteur = paygate ]; then
                 echo "lllll"
                 fi
                 if [ $connecteur = seguce ]; then
                 echo "lllll"
                 fi
                 if [ $connecteur = sydonia ]; then
                 echo "lllll"
                 fi
                 if [ $connecteur = tgterminal ]; then
                 echo "lllll"
                 fi
                 if [ $connecteur = togocom ]; then
                 echo "lllll"
                 fi
                 if [ $connecteur = epaiement ]; then
                     listVaultEngine
                     echo ""
                     read -p "Dans que engine voulez vous inserer les donnees de epaiement ? : " engine
                     echo ""
                     epaiementInsertData $engine
                 fi
                 if [ $connecteur = moov ]; then
                    echo "lllll"
                 fi
              fi
           done
#####****************************************************************************************************
        fi
        echo "********************************************************"
        echo ""
        echo "Configuration de vault -->    100%"
        echo ""
        echo "*********************************************************"
        rm -rf $zip_home/vault_1.15.0_linux_amd64.zip
        echo ""
        echo "Utiliser ce token ($token) pour vous connecter a l'interface http://$ipaddr:8200"
        echo ""
####***********************************************************************************************************
      fi
###**********************************************************************************************************************
   fi
    ########################################################## OPTION MODIFICATION DE DONNEES  ##############################################
   if [ $choix = 2 ]
   then
###************************************************************ Si on choisi l'option 2 "modification de donnees"
      echo ""
      modifySecret
      echo ""
###********************************************************************************************************************************
   fi
   ########################################################## OPTION CONSULTATION DE DONNEES  ##############################################
   if [ $choix = 3 ]
   then
###************************************************************ Si l'option 3 est choisi "Consultation des donnees"
      sure=1
      response=n
      while [ $sure -ge 1 ]
      do
####******************************************************************** Boucle pour le menu de consultation
         printConsulVault
         echo ""
         read -p "Choississez votre option : " vaultopt
         echho ""
         if [ $vaultopt = 1 ]
         then
            listVaultEngine
         fi
         if [ $vaultopt = 2 ]
         then
            echo ""
            read -p "Saissisez l'engine : " eng
            echo ""
            listVaultSecret $eng
         fi
         if [ $vaultopt = 3 ]
         then
            echo ""
            read -p "Saississez le path du secret (eg: engine/secret) : " secretpath
            echo ""
            listSecretData $secretpath
         fi
         echo ""
         read -p " Voulez vous sortir de l'option << Consultation de donnees >> ? [y/n] : " response
         echo ""
         if [ $response = 'y' ]; then
            sure=0
         fi
####*****************************************************************************************************
      done
      sure=1
      response=n
###***********************************************************************************************************************************
   fi
   echo ""
   read -p " Voulez vous quitter le << MENU PRINCIPALE DE VAULT >> ? [y/n] : " repo
   echo ""
   if [ $repo = 'y' ]; then
      echo ""
      echo ""
      echo "#############################################################"
      echo ""
      echo "               EXIT VAULT PROGRAM "
      echo ""
      echo "#############################################################"
      echo ""
      echo ""
      makesure=0
   fi
##********************************************************************************************************************
done
makesure=1
repo=n
#***********************************************************************************************************************************

################################################################################# FIN D'EXECUTION   ###########################################