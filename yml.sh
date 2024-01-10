#!/bin/bash

echo "Configuration des extra_hosts"
redis=
while [ "$redis" = "" ]
do
    read -p "Veuillez saisir le port souhaiter pour le serveur redis (ex: 3092 ): " redis
    if [ "$redis" != "" ]; then
        echo ""
        echo "Ajout de la configuration redis dans le fichier compose  [-_-]"
        pathhost=`pwd`
        pathhost=$pathhost/epaiement.yml
        sed -i 's/      - "<port-serveur-redis>:6379"/      - "'$redis':6379"/g' $pathhost
    fi
done

redis=
while [ "$redis" = "" ]
do
    read -p "Veuillez saisir le mot de passe souhaiter pour le serveur redis (ex: Th!5W0r|DisHaqqY ): " redis
    if [ "$redis" != "" ]; then
        echo ""
        echo "Ajout de la configuration redis dans le fichier compose  [-_-]"
        pathhost=`pwd`
        pathhost=$pathhost/epaiement.yml
        sed -i 's/      REDIS_PASSWORD: "<mot-de-passe-serveur-redis>"/      REDIS_PASSWORD: "'$redis'"/g' $pathhost
    fi
done

ecore=
while [ "$ecore" = "" ]
do
    read -p "Veuillez saisir l'addresse IP de epaiement core (ex: 192.168.1.45 ): " ecore
    if [ "$ecore" != "" ]; then
        echo ""
        echo "Ajout de la configuration ecore dans le fichier compose  [-_-]"
        pathhost=`pwd`
        pathhost=$pathhost/epaiement.yml
        sed -i 's/      - "ace3i-epaiement-core:/      - "ace3i-epaiement-core:'$ecore'"#/g' $pathhost
    fi
done


ecore=
while [ "$ecore" = "" ]
do
    read -p "Veuillez saisir le port souhaiter pour le serveur ecore (ex: 8090 ): " ecore
    if [ "$ecore" != "" ]; then
        echo ""
        echo "Ajout de la configuration ecore dans le fichier compose  [-_-]"
        pathhost=`pwd`
        pathhost=$pathhost/epaiement.yml
        sed -i 's/      - "8090:8080"/      - "'$ecore':8080"/g' $pathhost
    fi
done


for arg in "$@"
do
        if [ $arg = amplitude ]; then
            amp=
            while [ "$amp" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur amplitude (eg: 192.168.1.34) : " amp
                if [ "$amp" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration amplitude dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-amplitude:/      - "ace3i-connector-amplitude:'$amp'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = otr ]; then
            otr=
            while [ "$otr" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur otr (eg: 192.168.1.34) : " otr
                if [ "$otr" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration otr dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-otr:/      - "ace3i-connector-otr:'$otr'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = paygate ]; then
            paygate=
            while [ "$paygate" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur paygate (eg: 192.168.1.34) : " paygate
                if [ "$paygate" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration paygate dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-paygate:/      - "ace3i-connector-paygate:'$paygate'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = seguce ]; then
            seguce=
            while [ "$seguce" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur seguce (eg: 192.168.1.34) : " seguce
                if [ "$seguce" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration seguce dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-seguce:/      - "ace3i-connector-seguce:'$seguce'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = togocom ]; then
            togocom=
            while [ "$togocom" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur togocom (eg: 192.168.1.34) : " togocom
                if [ "$togocom" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration togocom dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-togocom:/      - "ace3i-connector-togocom:'$togocom'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = moov ]; then
            moov=
            while [ "$moov" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur moov (eg: 192.168.1.34) : " moov
                if [ "$moov" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration moov dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-moov:/      - "ace3i-connector-moov:'$moov'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = vault ]; then
            vault=
            while [ "$vault" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur vault (eg: 192.168.1.34) : " vault
                if [ "$vault" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration vault dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "vault:/      - "vault:'$vault'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = maildev ]; then
            maildev=
            while [ "$maildev" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur maildev (eg: 192.168.1.34) : " maildev
                if [ "$maildev" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration maildev dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-maildev:/      - "ace3i-maildev:'$maildev'"#/g' $pathhost
                fi
            done
        fi
        if [ $arg = iso20022 ]; then
            iso20022=
            while [ "$iso20022" = "" ]
            do
                read -p "Veuillez saisir l'adresse IP du connecteur iso20022 (eg: 192.168.1.34) : " iso20022
                if [ "$iso20022" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration iso20022 dans le fichier compose  [-_-]"
                    pathhost=`pwd`
                    pathhost=$pathhost/epaiement.yml
                    sed -i 's/      - "ace3i-connector-iso20022:/      - "ace3i-connector-iso20022:'$iso20022'"#/g' $pathhost
                fi
            done
        fi
done
path=`pwd`
cp $path/epaiement.yml /app/service/ace3i-epaiement-core.yml