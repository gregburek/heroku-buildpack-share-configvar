Heroku buildpack: share-configvar
=========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks)
that allows one to pull in config vars from another app on dyno boot,
It is meant to be used in conjunction with other buildpacks as part of a
[multi-buildpack](https://github.com/ddollar/heroku-buildpack-multi).

The primary use of this buildpack is to allow for the sharing of Heroku Postgres
DATABASE_URL config vars between applications as recommended by [this devcenter
article](https://devcenter.heroku.com/articles/connecting-to-heroku-postgres-databases-from-outside-of-heroku).

It uses [curl](http://curl.haxx.se//),
[netrc](http://manpages.ubuntu.com/manpages/intrepid/man5/netrc.5.html) and
[Heroku's v3 API](https://devcenter.heroku.com/articles/platform-api-reference).

Settings
-----

- `HEROKU_SHARE_API_EMAIL` Required
- `HEROKU_SHARE_API_PASSWORD` Required
- `HEROKU_SHARE_APPNAME` Required
- `HEROKU_SHARE_CONFIGVARS` Default is DATABASE_URL

Usage
-----

Example usage:

    $ ls -a
    .buildpacks  Gemfile  Gemfile.lock  Procfile  config/  config.ru

    $ heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

    $ heroku config:add HEROKU_SHARE_API_EMAIL=my-fake-email@gmail.com

    $ heroku config:add HEROKU_SHARE_API_PASSWORD=`heroku auth:token`

    $ heroku config:add HEROKU_SHARE_API_PASSWORD=ancient-everglades-9021

    $ cat .buildpacks
    https://github.com/gregburek/heroku-buildpack-share-configvar.git
    https://github.com/heroku/heroku-buildpack-ruby.git

    $ cat Procfile
    web:    bundle exec unicorn -p $PORT -c ./config/unicorn.rb -E $RACK_ENV
    worker: bundle exec rake worker

    $ git push heroku master
    ...
    -----> Fetching custom git buildpack... done
    -----> Multipack app detected
    =====> Downloading Buildpack: https://github.com/gregburek/heroku-buildpack-pgbouncer.git
    =====> Detected Framework: pgbouncer-stunnel
           Using pgbouncer version: 1.5.4
           Using stunnel version: 4.56
    -----> Fetching and vendoring pgbouncer into slug
    -----> Fetching and vendoring stunnel into slug
    -----> Moving the configuration generation script into app/.profile.d
    -----> Moving the start-pgbouncer-stunnel script into app/bin
    -----> pgbouncer/stunnel done
    =====> Downloading Buildpack: https://github.com/heroku/heroku-buildpack-ruby.git
    =====> Detected Framework: Ruby/Rack
    -----> Using Ruby version: ruby-1.9.3
    -----> Installing dependencies using Bundler version 1.3.2
    ...

The buildpack will install and configure pgbouncer and stunnel to connect to
`DATABASE_URL` over a SSL connection. Prepend `bin/start-pgbouncer-stunnel`
to any process in the Procfile to run pgbouncer and stunnel alongside that process.
