#!/usr/bin/env bash

CONFIG_VARS="${HEROKU_SHARE_CONFIGVARS} DATABASE_URL"

config_var_values=`curl --user $HEROKU_SHARE_API_EMAIL:$HEROKU_SHARE_API_PASSWORD \
  -X GET https://api.heroku.com/apps/$HEROKU_SHARE_APPNAME/config-vars \
  -H "Accept: application/vnd.heroku+json; version=3"`

for CONFIG_VAR in $CONFIG_VARS
do
  export ${CONFIG_VAR}=`echo $config_var_values | grep $CONFIG_VAR | cut -d '"' -f 4`
done
