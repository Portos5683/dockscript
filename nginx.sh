#!/bin/bash
# Installation de Epaiement-core
path=`pwd`
cp $path/nginx.conf /app/ace3i-epaiement-ui/nginx.conf
function printArgurment()
{
   echo ""
   echo ""
   echo "----------------------------------------------------------------"
   echo ""
   echo "Vous avez lancer la configuration de tous ces elements dans nginx.conf"
   echo ""
   echo "----------------------------------------------------------------"
   echo ""
   echo ""
   echo "________________Liste des connecteurs_________________"
   echo ""
   echo ""
}
nbreargument=$#;
backend=
seguceip=
mbankingip=
if [ $nbreargument = 0 ]
then
#************************************************** Si il n'y a aucun argument a l'excution 
    read -p "Voulez vous ajouter la conguration de seguce ? [y/n] : " seguce
    if [ $seguce = "y" ]; then
##************************************************** Si le user veux configurer seguce
        while [ "$seguceip" = "" ]
        do
###************************************************* Boucle pour faire saisir l'addresse du connecteur seguce
            read -p "Veuillez saisir l'addresse du connecteur Seguce (eg: 192.168.1.34:8320 ) : " seguceip
            if [ "$seguceip" != "" ]; then
                echo "Ajout de la configuration de serveur seguce [-_-]"
                sed -i 's/#######//g' /app/ace3i-epaiement-ui/nginx.conf
            fi
###********************************************************************************************************************************************
        done
##*******************************************************************************************************************************************
    fi
    read -p "Voulez vous ajouter la conguration de mbanking ? [y/n] : " mbanking
    if [ $mbanking = "y" ]; then
##************************************************** Si le user veux configurer mbanking
        while [ "$mbankingip" = "" ]
        do
###************************************************* Boucle pour faire saisir l'addresse du connecteur mbanking
            read -p "Veuillez saisir l'addresse du connecteur Mbanking (eg: 192.168.1.34:8320 ) : " mbankingip
            if [ "$mbankingip" != "" ]; then
                echo "Ajout de la configuration de serveur mbanking [-_-]"
                sed -i 's/######//g' /app/ace3i-epaiement-ui/nginx.conf
            fi
###********************************************************************************************************************************************
        done
##******************************************************************************************************************************************* 
    fi
#**************************************************************************************************************************************************
fi
if [ $nbreargument != 0 ]
then
#********************************************** S'il y a plus d'un argument saisie par l'utilisateur
    printArgurment
    for conf in "$@"
    do
        echo ""
        echo "Configuration $conf";
        echo ""
    done
    echo ""
    echo "............................................."
    echo ""
    read -p "Etes vous sur de vouloir tous les configurer ?[y/n]" response
    if [ $response = 'y' ]; then 
##******************************************************* Si l'utilisateur est decider a configurer tout les connecteur qu'il a saisie
       for conf in "$@"
       do
###************************************************** Boucle pour recurer tout les argument saisie
            if [ $conf = seguce ]; then
####************************************************* Si l'utilisateur a ajouter l'option pour la configuration de seguce
               while [ "$seguceip" = "" ]
                do
                    read -p "Veuillez saisir l'ip et le port de serveur Seguce (eg: 192.168.1.34:8320 ) : " seguceip
                    if [ "$seguceip" != "" ]; then
                        echo "Ajout de la configuration de serveur seguce [-_-]"
                        sed -i 's/#######//g' /app/ace3i-epaiement-ui/nginx.conf
                    fi
                done
####***************************************************************************************************************************************
            fi
            if [ $conf = mbanking ]; then
####************************************************* Si l'utilisateur a ajouter l'option pour la configuration de Mbanking
                while [ "$mbankingip" = "" ]
                do
                    read -p "Veuillez saisir l'ip et le port de serveur mbanking (eg: 192.168.1.34:8320 ) : " mbankingip
                    if [ "$mbankingip" != "" ]; then
                        echo "Ajout de la configuration de serveur mbanking [-_-]"
                        sed -i 's/######//g' /app/ace3i-epaiement-ui/nginx.conf
                    fi
                done
####*******************************************************************************************************************************************
            fi
###*************************************************************************************************************************************************
       done
##******************************************************************************************************************************************************
    else
##************************************************************** Si l'utlisateur ne veux plus installer les connecteur saisie
        echo "********************************************************"
        echo ""
        echo "  J'ESPERE QUE VOUS SAVEZ CE QUE VOUS FAITES"
        echo ""
        echo "*********************************************************"
##*******************************************************************************************************************************************
    fi
    echo "********************************************************"
    echo ""
    echo "Configuration de NGINX -->    100%"
    echo ""
    echo "*********************************************************"
#************************************************************************************************************************************************************
fi