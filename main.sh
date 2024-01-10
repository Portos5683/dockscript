#!/bin/bash
#cd /var/tmp/
for arg in "$@"
do
   if [ $arg != exit ]
   then
        wget https://interfaces.ace3i.com/bin/bin/$arg
        docker load < $arg
   fi
done
docker image ls
mkdir -p /app/service/
#path=`pwd`
#$path/maildev.sh
connector=
while [ "$connector" = "" ]
do
   read -p "Veuillez saisir la liste des connecteurs que vous voulez confifgurer dans le fichier compose ( ex: amplitude otr seguce ) : " connector
   if [ "$connector" != "" ]; then
      path=`pwd`
      $path/yml.sh $connector
   fi
done
mkdir -p /app/ace3i-epaiement-core/client/input
mkdir -p /app/ace3i-epaiement-core/client/output
mkdir -p /app/ace3i-epaiement-core/export/output
mkdir -p /app/ace3i-epaiement-core/export/processed
mkdir -p /app/ace3i-epaiement-core/reconciliation/input
mkdir -p /app/ace3i-epaiement-core/reconciliation/processed
mkdir -p /app/ace3i-epaiement-core/logs
mkdir -p /app/ace3i-epaiement-ui/certs
mkdir -p /app/ace3i-epaiement-ui/logs
chmod -R 777 /app/ace3i-epaiement-core/*
chmod -R 777 /app/ace3i-epaiement-ui/*
docker stack rm epaiement
docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
docker service ls --filter name=epaiement_ace3i-epaiement-core
docker service ls --filter name=epaiement_ace3i-epaiement-ui