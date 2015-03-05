[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


### Basic Auth for /admin

#### heroku

    heroku config:add BASIC_AUTH_USERNAME="<username>" BASIC_AUTH_PASSWORD="<password>" --app APPNAME

#### development 

    BASIC_AUTH_USERNAME="<username>" BASIC_AUTH_PASSWORD="<password>" rails s -b 0.0.0.0 -p 3030