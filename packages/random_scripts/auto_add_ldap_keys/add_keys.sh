ALLOWED_USER_FILE="./allowed_users"
LDAP_SERVER_URI="ldap.mycompany.com:389"
# LDAP_SERVER_URI="10.1.1.1:389" # This is also allowed
LDAP_BASE_DN="cn=accounts,dc=mycompany,dc=com"

BACKUP_FOLDER="$HOME/ssh_keys_bkp"
mkdir -p $BACKUP_FOLDER

# This script needs this
sudo apt-get install -y ldap-utils > /dev/null

ping -c 1 $(echo $LDAP_SERVER_URI | sed 's~:.*~~') > /dev/null
if [ $? -ne 0 ]; then
    echo "Cannot connect to LDAP_SERVER_URI: $LDAP_SERVER_URI"
    exit 1
fi

# Clear existing keys
cat $ALLOWED_USER_FILE |
while read -r LINE
do
    LINE=( $LINE )
    LOCAL_ACCOUNT=${LINE[1]}
    LOCAL_ACCOUNT_HOME=$(eval echo ~$LOCAL_ACCOUNT)
    if [ ! -d "$LOCAL_ACCOUNT_HOME" ]; then
        echo "Cannot find LOCAL_ACCOUNT: $LOCAL_ACCOUNT"
        continue
    fi

    # Backup existing keys
    BKP_FILE="$BACKUP_FOLDER/$LOCAL_ACCOUNT.authorized_keys.bkp"
    cat $LOCAL_ACCOUNT_HOME/.ssh/authorized_keys | sudo tee -a $BKP_FILE > /dev/null
    sudo cp /dev/null $LOCAL_ACCOUNT_HOME/.ssh/authorized_keys

    # Trim Backup file
    tail -n 10000 $BKP_FILE | sudo tee $BKP_FILE.tmp > /dev/null
    sudo mv $BKP_FILE.tmp $BKP_FILE > /dev/null
done


# Add keys from LDAP server
cat $ALLOWED_USER_FILE |
while read -r LINE
do
    LINE=( $LINE )
    LDAP_USER=${LINE[0]}
    LOCAL_ACCOUNT=${LINE[1]}
    LOCAL_ACCOUNT_HOME=$(eval echo ~$LOCAL_ACCOUNT)
    if [ ! -d "$LOCAL_ACCOUNT_HOME" ]; then
        continue
    fi

    LDAP_KEYS=$(ldapsearch -x -H ldap://$LDAP_SERVER_URI -b $LDAP_BASE_DN uid=$LDAP_USER ipaSshPubKey -LLL | grep -v ^dn | sed 's:^ ::' | tr -d '\n' |sed 's/ipaSshPubKey: /\n/g' |grep -v ^$| sudo tee -a $LOCAL_ACCOUNT_HOME/.ssh/authorized_keys)
    if [ "$LDAP_KEYS" == "" ]; then
        echo "Cannot find LDAP_USER: $LDAP_USER"
    else
        echo "Added LDAP_USER: $LDAP_USER to LOCAL_ACCOUNT: $LOCAL_ACCOUNT"
        sudo chown $LOCAL_ACCOUNT:$LOCAL_ACCOUNT $LOCAL_ACCOUNT_HOME/.ssh/authorized_keys
    fi
done
