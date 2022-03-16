#!/bin/sh

if [ -n "$LISTENING_IP_ADDRESS" ]
then
    echo "Listening on $LISTENING_IP_ADDRESS network interface"
    LISTENING_IP_ADDRESS_OPTS=" -L $LISTENING_IP_ADDRESS"    
else
    echo "No LISTENING_IP_ADDRESS env variable set. Listening on all interfaces...";
fi

if [ -n "$EXTERNAL_IP_ADDRESS" ]
then
    echo "Using explicitly set $EXTERNAL_IP_ADDRESS as TURN relay address"
else
    EXTERNAL_IP_ADDRESS=$(detect-external-ip)
    echo "Using autodetected $EXTERNAL_IP_ADDRESS as TURN relay address"
fi

if [ -z "$TURN_PORT" ]
then
    echo "No TURN_PORT env variable set. Default 3478 UDP and TCP will be used";
    TURN_PORT="3478"        
fi

if [ -z "$TURN_USERNAME" ] 
then  
    TURN_USERNAME="stunturn"
    echo "No TURN_USERNAME env variable set, user will be set to 'stunturn' and password will be randomly generated"
fi    

if [ -z "$TURN_PASSWORD" ] 
then
    TURN_PASSWORD=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
    echo "No TURN_PASSWORD env variable set, generated a random one: "$TURN_PASSWORD
fi

case $LOG_LEVEL in

    moderate)
        echo "Log level set to moderate"
        $LOG_LEVEL_OPTS=" -v"
        ;;
    
    debug)
        echo "Log level set to debug"
        $LOG_LEVEL_OPTS=" -V"
        ;;
    
    *)
        echo "Log level set to normal (default)"
        $LOG_LEVEL_OPTS=""
esac

echo "Created TURN user '"$TURN_USERNAME"' with password '"$TURN_PASSWORD"'. Please use said credentials into your estos application"
echo "Executing TURN service... "

echo "Your STUN and TURN server is now running"
echo "Please configure your estos UCServer own STUN and TURN servers according to the following template: "
echo "STUN Server --> stun:$EXTERNAL_IP_ADDRESS:$TURN_PORT"
echo "TURN Server --> turn:$EXTERNAL_IP_ADDRESS:$TURN_PORT"
echo "TURN username: $TURN_USERNAME"
echo "TURN password: $TURN_PASSWORD"
echo "More information at https://help.estos.com/help/en-US/procall/7.3/ucserver/dokumentation/tapisrv/IDH_TURN_STUN_DLG.htm"

exec /usr/bin/turnserver -n -r defaultrealm --no-tls --no-dtls --no-cli \
--pidfile /var/tmp/turnserver.pid -l /var/tmp/stunturn.log \
-a -u $TURN_USERNAME:$TURN_PASSWORD \
-p $TURN_PORT -X $EXTERNAL_IP_ADDRESS $LISTENING_IP_ADDRESS_OPTS