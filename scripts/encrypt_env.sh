#!/bin/sh

if [ -z $1 ]; then
  echo "No environment passed. Please call with \`prod\`, \`local\`, \`staging\`, or \`test\`"
  exit 1
fi

if [ "$1" = "prod" ]; then
  DECRYPTED_FILE=.env.prod
elif [ "$1" = "local" ]; then
  DECRYPTED_FILE=.env.local
elif [ "$1" = "staging" ]; then
  DECRYPTED_FILE=.env.staging
elif [ "$1" = "test" ]; then
  DECRYPTED_FILE=.env.test
else
  echo "Invalid environment. Please call with \`prod\`, \`local\`, \`staging\`, or \`test\`"
  exit 2
fi

ENCRYPTED_FILE=$DECRYPTED_FILE.encrypted
KEY_FILE=$DECRYPTED_FILE.key

if [ "$2" = "encrypt" ]; then
  if [ -z $ENV_PASSPHRASE ]; then
    gpg --batch --yes -o $ENCRYPTED_FILE -c --passphrase-file $KEY_FILE --armor --cipher-algo AES256 $DECRYPTED_FILE
  else
    gpg --batch --yes -o $ENCRYPTED_FILE -c --passphrase "$ENV_PASSPHRASE" --armor --cipher-algo AES256 $DECRYPTED_FILE
  fi
elif [ "$2" = "decrypt" ] || [ -z $2 ]; then
  if [ -z $ENV_PASSPHRASE ]; then
    gpg --batch --yes -o .env --decrypt --passphrase-file $KEY_FILE $ENCRYPTED_FILE
  else
    gpg --batch --yes -o .env --decrypt --passphrase "$ENV_PASSPHRASE" $ENCRYPTED_FILE
  fi
else
  echo "Invalid command. Please call with \`encrypt\` or \`decrypt\`"
  exit 3
fi