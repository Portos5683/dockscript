#!/bin/bash
echo "---------------------------------------------------------------------------------------------------------"
echo ""
echo "               ATTENTION:  Vous rentrer dans la configuration de la base de donnees"
echo ""
echo "----------------------------------------------------------------------------------------------------------"

step=`echo $EPAIEMENT_STEP`
if [ "$step" = "" ]
then
    export EPAIEMENT_STEP=1
    usercr=`whoami`
    if [ "$usercr" = "root" ]
    then
        echo "export EPAIEMENT_STEP=1" >> /root/.bashrc
    else
        echo "export EPAIEMENT_STEP=1" >> /home/$usercr/.bashrc
    fi
    ###################################### INITIALISATION DE VARIABLE
    databasename=""
    databaseuser=""
    sure=1
    response=n
    while [ $sure -ge 1 ]
    do
    #********************************** Boucle pour recuperer le database_user et le database_name saisie par l'utilisateur
        read -p "Saississez le nom de votre base de donnee que vous allez creer : " databasename
        echo ""

        read -p "Saississez le nom de l'utilisateur de la base de donnee que vous allez creer : " databaseuser
        echo ""
        if [[ "$databaseuser"!="" && "$databasename"!="" ]]
        then
    ##*********************************** Si les valeur saise ne sont pas nul
            echo $databaseuser
            echo $databasename
            sure=0
    ##***********************************************************************************************************************
        fi
    #*********************************************************************************************************************************
    done
    pathdatabasedata=`find / -name pg_hba.conf`
    if [ -e $pathdatabasedata ]
    then
    #************************************** Si le fichier de configuration nommer pg_hba.conf existe
        #sed -i 's/local   all             all                                     peer/local   all             all                                     trust/g' /var/lib/pgsql/15/data/pg_hba.conf
        #systemctl reload postgresql*
        #psql -U postgres -w -c "CREATE ROLE ange WITH LOGIN PASSWORD 'ange';"
        #sed -i 's/local   all             all                                     trust/local   all             all                                     md5/g' /var/lib/pgsql/15/data/pg_hba.conf
        #systemctl reload postgresql*
        sed -i 's/local   all             all                                     /local   all             all                                     trust #/g' $pathdatabasedata
        systemctl reload postgresql*
        read -p "Veuillez saisir un mot de passe pour l'utilisateur $databaseuser : " databasepass
        psql -U postgres -c "CREATE ROLE $databaseuser WITH LOGIN PASSWORD '$databasepass';"
        psql -U postgres -c "create database $databasename with owner $databaseuser;"
        echo -e "# Acces a la base de donnees $databasename par l'utilisateur $databaseuser depuis toutes les adresses ip\nhost    $databasename             $databaseuser             0.0.0.0/0               scram-sha-256\nhost    $databasename             $databaseuser             0.0.0.0/0               md5" >> $pathdatabasedata
        sed -i 's/local   all             all                                     trust #/local   all             all                                     /g' $pathdatabasedata
        systemctl reload postgresql*
    #*****************************************************************************************************************************************************************************************************************************************************************
    fi
    systemctl reload postgresql*
    echo "---------------------------------------------------------------------------------------------------------"
    echo ""
    echo "               FIN DE CONFIGURATION DE LA BASE DE DONNEES"
    echo ""
    echo "----------------------------------------------------------------------------------------------------------"
else
###################################### INITIALISATION DE VARIABLE
pathdatabasedata=`find / -name pg_hba.conf`
if [ -e $pathdatabasedata ]
then
#************************************** Si le fichier de configuration nommer pg_hba.conf existe
    #sed -i 's/local   all             all                                     peer/local   all             all                                     trust/g' /var/lib/pgsql/15/data/pg_hba.conf
    #systemctl reload postgresql*
    #psql -U postgres -w -c "CREATE ROLE ange WITH LOGIN PASSWORD 'ange';"
    #sed -i 's/local   all             all                                     trust/local   all             all                                     md5/g' /var/lib/pgsql/15/data/pg_hba.conf
    #systemctl reload postgresql*
    sed -i 's/local   all             all                                     /local   all             all                                     trust #/g' $pathdatabasedata
    systemctl reload postgresql*
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB0DS4', '', 'DS4D', 'Facture Douane', 'BOTH' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB0DS4' OR prdcode = 'DS4D');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB0DFU', 'E', 'DFUS', 'DFU Seguce', 'CLASSIC' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB0DFU');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie, prdsynx) SELECT true, 'CB0TGT', '', 'TGTML', 'Facture Togo Terminal', 'BOTH', 'Numéro facture @ Code client. Exemple: 2007812@MG007' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB0TGT');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT true, 'CB0CS', '', 'CCNSS', 'Cotisations CNSS', 'BOTH' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB0CS' OR apiid='CB1CS');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB0MBNK', '', 'MBNKB2W', 'Transfert banque vers mobile', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB0MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB1MBNK', '', 'MBNKW2B', 'Transfert mobile vers banque', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB1MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB2MBNK', '', 'MBNKB2B', 'Transfer Banque vers banque', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB2MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB3MBNK', '', 'MBNKFB2W', 'Frais sur transfert banque vers mobile', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB3MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB4MBNK', '', 'MBNKFW2B', 'Frais sur transfert mobile vers banque', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB4MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB5MBNK', '', 'MBNKFB2B', 'Frais sur transfert banque vers banque', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB5MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB6MBNK', '', 'MBNKB2WFAILED', 'Annulation de transfert banque vers mobile', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB6MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB7MBNK', '', 'MBNKFBBE', 'Frais sur la récupération du solde de compte', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB7MBNK');"
    psql -U postgres -c "INSERT INTO public.epprd (prdmopa, apiid, prdbilst, prdcode, prdname, prdstrpaie) SELECT false, 'CB8MBNK', '', 'MBNKFBMS', 'Frais sur la récupération des dernières transactions', 'MBANKING' WHERE NOT EXISTS ( SELECT 1 FROM epprd WHERE apiid='CB8MBNK');"
    mbanking=
    while [ "$mbanking" = "" ]
    do
        read -p "Veuillez saisir l'adresse du serveur du connecteur mbanking (ex :192.168.1.90:8097) : " mbanking
        if [ "$mbanking" != "" ]; then
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB0MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB1MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB2MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB3MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB4MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB5MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB6MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB7MBNK';"
        psql -U postgres -c "update public.epbapi set apihost='https://$mbanking', apirpath='/', apinpath='/', apirrbexp='$..*', apinrbexp='', apirrepm='{"reference":"reference"}',apinreqm='{"reference":"reference"}',apinrepm='{"date":"date","confirmation":"confirmation"}' where apiid='CB8MBNK';"
        fi
    done
    echo -e "# Acces a la base de donnees $databasename par l'utilisateur $databaseuser depuis toutes les adresses ip\nhost    $databasename             $databaseuser             0.0.0.0/0               scram-sha-256\nhost    $databasename             $databaseuser             0.0.0.0/0               md5" >> $pathdatabasedata
    sed -i 's/local   all             all                                     trust #/local   all             all                                     /g' $pathdatabasedata
    systemctl reload postgresql*
#*****************************************************************************************************************************************************************************************************************************************************************
fi
systemctl reload postgresql*
echo "---------------------------------------------------------------------------------------------------------"
echo ""
echo "               FIN DE CONFIGURATION DE LA BASE DE DONNEES"
echo ""
echo "----------------------------------------------------------------------------------------------------------"
fi