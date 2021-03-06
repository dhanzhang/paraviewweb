#!/usr/bin/env bash

INPUT_CONFIG=/etc/apache2/sites-available/001-pvw.conf
OUTPUT_CONFIG="${INPUT_CONFIG}"
TARGET_LINE="# APPLICATION-ENDPOINTS"
INPUT=$(<"${INPUT_CONFIG}")

while (($#)); do
    ENDPOINT=$1
    FILEPATH=$2

    if [ -z "$ENDPOINT" ] | [ -z "$FILEPATH" ]
    then
        echo "ERROR: args should come in pairs as ENDPOINT FILEPATH"
        exit 1
    fi

    aliasLine="Alias \"/${ENDPOINT}\" \"${FILEPATH}\""

    read -r -d '' directoryLines << EOM
    <Directory ${FILEPATH}>
      Options Indexes FollowSymLinks
      Order allow,deny
      Allow from all
      AllowOverride None
      Require all granted
    </Directory>
EOM

    replacement="${aliasLine}\n\n  ${directoryLines}\n\n  ${TARGET_LINE}"
    OUTPUT="${INPUT//"$TARGET_LINE"/"$replacement"}"
    INPUT=${OUTPUT}

    shift 2
done

# Make a backup copy before over-writing the file
BACKUP="${OUTPUT_CONFIG}.BAK"
echo "Backing up ${OUTPUT_CONFIG} to ${BACKUP}"
cp "${OUTPUT_CONFIG}" "${BACKUP}"

echo -e "$OUTPUT" > "${OUTPUT_CONFIG}"
