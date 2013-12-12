#!/usr/bin/env bash

CONFIG_VARS="${HEROKU_SHARE_CONFIGVARS} DATABASE_URL"

config_var_values=`curl --user $HEROKU_SHARE_API_EMAIL:$HEROKU_SHARE_API_TOKEN \
  -X GET https://api.heroku.com/apps/$HEROKU_SHARE_APPNAME/config-vars \
  -H "Accept: application/vnd.heroku+json; version=3"`

for CONFIG_VAR in $CONFIG_VARS
do
  config_var_value=`echo "$config_var_values" | grep $CONFIG_VAR | cut -d '"' -f 4`
  if [ -n "$config_var_value" ]
    export ${CONFIG_VAR}=$config_var_value
  fi
done
