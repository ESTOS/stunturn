#!/bin/sh

if [ -z "$EXTERNAL_IP_ADDRESS" ]
then
    echo "No EXTERNAL_IP_ADDRESS env variable set. Exiting...";
    exit 1;
fi


if [ -z "$TURN_PORT" ]
then
    echo "No TURN_PORT env variable set. Default 3478 UDP and TCP will be used";
    TURN_PORT="3478"        
fi

if [ -n "$TURN_USERNAME" ] 
then        
        if [ -z "$TURN_PASSWORD" ] 
        then
                RETURN_PASSWORD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
                echo "No TURN_PASSWORD env variable set, generated a random one: "$RETURN_PASSWORD
        fi
else
    TURN_PASSWORD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
    TURN_USERNAME="stunturn"
    echo "No TURN_USERNAME env variable set, user will be set to 'stunturn' and password will be randomly generated"
fi    

echo "Created TURN user '"$TURN_USERNAME"' with password '"$TURN_PASSWORD"'. Please use said credentials into your estos application"
echo "Executing TURN service... "

echo "Your STUN and TURN server is now running"
echo "Please configure your estos UCServer own STUN and TURN servers according to the following template: "
echo "STUN Server --> stun:$EXTERNAL_IP_ADDRESS:$TURN_PORT"
echo "TURN Server --> turn:$EXTERNAL_IP_ADDRESS:$TURN_PORT"
echo "TURN username: $TURN_USERNAME"
echo "TURN password: $TURN_PASSWORD"
echo "More information at https://help.estos.com/help/en-US/procall/7.3/ucserver/dokumentation/tapisrv/IDH_TURN_STUN_DLG.htm"

exec /usr/bin/turnserver -n -r defaultrealm --no-cli -a -u $TURN_USERNAME:$TURN_PASSWORD -p $TURN_PORT -L $EXTERNAL_IP_ADDRESS 

