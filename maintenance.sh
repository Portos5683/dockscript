#!/bin/bash
function printMenu()
{
   echo "----------------------------------------------------------------------------------"
   echo ""
   echo "                   Configuration additionelles du fichier compose"
   echo ""
   echo "----------------------------------------------------------------------------------"
   echo ""
   echo ""
   echo "_______________________________________MENU_______________________________________"
   echo ""
   echo "   1) Nginx : Personnalisations de la configuration du reverse proxy nginx"
   echo ""
   echo "   2) Favicon :  Mettre un nouveau Favicon.ico"
   echo ""
   echo "   3) Changer le logo de l'application"
   echo ""
   echo "   4) Changer le Fond d'écran de connexion"
   echo ""
   echo "   5) Modifier les codes couleurs de l'application"
   echo ""
   echo "   6) Personnaliser les certificats pour epaiement"
   echo ""
   echo "   7) Changer le logo des bordereaux"
   echo ""
   echo "............................................."
   echo ""
}


sure=1
response=n
while [ $sure -ge 1 ]
do
    printMenu
    read -p " Quel est votre choix : " choix
    if [ $choix = 1 ]
    then
        # NGINX
        sed -i 's/#      - "/app/ace3i-epaiement-ui/nginx.conf:/etc/nginx/nginx.conf"/      - "/app/ace3i-epaiement-ui/nginx.conf:/etc/nginx/nginx.conf"/g' /app/service/ace3i-epaiement-core.yml
        echo "configuration du fichier"
        path=`pwd`
        $path/nginx.sh
        docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
    fi
    if [ $choix = 2 ]
    then
        #FAVICON CONFIGURATION
        sed -i 's/#      - "/app/ace3i-epaiement-ui/favicon.ico:/usr/share/nginx/html/assets/img/favicon.ico"/      - "/app/ace3i-epaiement-ui/favicon.ico:/usr/share/nginx/html/assets/img/favicon.ico"/g' /app/service/ace3i-epaiement-core.yml
        favicon=
        read -p "Avez vous copier le Favicon.ico dans le repertoire /app/ace3i-epaiement-ui/ ? [y/n] : " favicon
        if [ $favicon = "y" ]; then
            docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
        fi
    fi
    if [ $choix = 3 ]
    then
        #LOGO
        sed -i 's/#      - "/app/ace3i-epaiement-ui/logo.png:/usr/share/nginx/html/assets/img/logo.png"/      - "/app/ace3i-epaiement-ui/logo.png:/usr/share/nginx/html/assets/img/logo.png"/g' /app/service/ace3i-epaiement-core.yml
        logo=
        read -p "Avez vous copier le logo.png dans le repertoire /app/ace3i-epaiement-ui/ ? [y/n] : " logo
        if [ $logo = "y" ]; then
            docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
        fi
    fi
    if [ $choix = 4 ]
    then
        # Page de connexion
        sed -i 's/#      - "/app/ace3i-epaiement-ui/bg-loginBox.png:/usr/share/nginx/html/assets/img/bg-loginBox.png"/      - "/app/ace3i-epaiement-ui/bg-loginBox.png:/usr/share/nginx/html/assets/img/bg-loginBox.png"/g' /app/service/ace3i-epaiement-core.yml
        bg=
        read -p "Avez vous copier le bg-loginBox.png dans le repertoire /app/ace3i-epaiement-ui/ ? [y/n] : " bg
        if [ $bg = "y" ]; then
            docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
        fi
    fi
    if [ $choix = 5 ]
    then
        #Code couleur
        pcpl=
        read -p "Voulez-vous reconfigurer la couleur principale de l'application ? [y/n] : " pcpl
        if [ $pcpl = "y" ]; then
            pcplc=
            while [ "$pcplc" = "" ]
            do
                read -p "Veuillez saisir la nouvelle couleur principale de l'application (eg: #303f9f) : " pcplc
                if [ "$pcplc" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration des codes couleurs  [-_-]"
                    sed -i 's/      - APP_PRIMARYCOLOR=#303f9f/      - APP_PRIMARYCOLOR='$pcplc'/g' /app/service/ace3i-epaiement-core.yml
                fi
            done
        fi
        scdr=
        read -p "Voulez-vous reconfigurer la couleur secondaire de l'application ? [y/n] : " scdr
        if [ $scdr = "y" ]; then
            scdrc=
            while [ "$scdrc" = "" ]
            do
                read -p "Veuillez saisir la nouvelle couleur secondaire de l'application (eg: #303f9f) : " scdrc
                if [ "$scdrc" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration des codes couleurs  [-_-]"
                    sed -i 's/      - APP_SECONDARYCOLOR=#424242/      - APP_SECONDARYCOLOR='$scdrc'/g' /app/service/ace3i-epaiement-core.yml
                fi
            done
        fi
        accent=
        read -p "Voulez-vous reconfigurer la couleur d'accet de l'application ? [y/n] : " accent
        if [ $accent = "y" ]; then
            accentc=
            while [ "$accentc" = "" ]
            do
                read -p "Veuillez saisir la nouvelle couleur de l'accent de l'application (eg: #303f9f) : " accentc
                if [ "$accentc" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration des codes couleurs  [-_-]"
                    sed -i 's/      - APP_ACCENTCOLOR=#ff8400/      - APP_ACCENTCOLOR='$accentc'/g' /app/service/ace3i-epaiement-core.yml
                fi
            done
        fi

        blanc=
        read -p "Voulez-vous reconfigurer la couleur blanche de l'application ? [y/n] : " blanc
        if [ $blanc = "y" ]; then
            blancc=
            while [ "$blancc" = "" ]
            do
                read -p "Veuillez saisir la nouvelle couleur blanche de l'application (eg: #303f9f) : " blancc
                if [ "$blancc" != "" ]; then
                    echo ""
                    echo "Ajout de la configuration des codes couleurs  [-_-]"
                    sed -i 's/      - APP_LIGHTCOLOR=#FFFFFF/      - APP_LIGHTCOLOR='$blancc'/g' /app/service/ace3i-epaiement-core.yml
                fi
            done
        fi

        docker service scale epaiement_ace3i-epaiement-ui=0
        docker service scale epaiement_ace3i-epaiement-ui=0
        docker service scale epaiement_ace3i-epaiement-ui=1
    fi
    if [ $choix = 6 ]
    then
        #Certificat SSL
        sed -i 's/#      - "/app/ace3i-epaiement-ui/certs/cert.crt:/app/ssl/ace3i-epaiement-ui.crt"/      - "/app/ace3i-epaiement-ui/certs/cert.crt:/app/ssl/ace3i-epaiement-ui.crt"/g' /app/service/ace3i-epaiement-core.yml
        sed -i 's/#      - "/app/ace3i-epaiement-ui/certs/key.key:/app/ssl/ace3i-epaiement-key.key"/      - "/app/ace3i-epaiement-ui/certs/key.key:/app/ssl/ace3i-epaiement-key.key"/g' /app/service/ace3i-epaiement-core.yml
        cert=
        read -p "Avez vous copier les certificats(cert.crt et key.key) dans le repertoire /app/ace3i-epaiement-ui/certs/ ? [y/n] : " cert
        if [ $cert = "y" ]; then

            chmod -R 777 /app/ace3i-epaiement-ui/certs/*
            docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
        fi
    fi
    if [ $choix = 7 ]
    then
        #LogoBordereaux
        sed -i 's/#      - "/app/ace3i-epaiement-core/logo.png:/home/ace3i/.epaiement-online/images/logo.png"/      - "/app/ace3i-epaiement-core/logo.png:/home/ace3i/.epaiement-online/images/logo.png"/g' /app/service/ace3i-epaiement-core.yml
        logo=
        read -p "Avez vous copier le logo.png dans le repertoire /app/ace3i-epaiement-ui/ ? [y/n] : " logo
        if [ $logo = "y" ]; then
            docker stack deploy -c /app/service/ace3i-epaiement-core.yml epaiement
        fi
    fi
    read -p " Voulez vous sortir de cet Menu ? [y/n] : " response
    if [ $response = 'y' ]; then
        sure=0
    fi
done