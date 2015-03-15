[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


### Import comments from wordpress exported xml


rake comment_storage:wpimport COMMENT_STORAGE_HOST=comment-storage.herokuapp.com WPXML_PATH=tmp/wordpress.2015-03-01.xml CLIENT_KEY=a0b2f8901dcc97b1feecdb72e4ca0e21d0b078e34c87c04c5495cf21b24447d4

recomended email notification off



### Basic Auth for /admin

#### heroku

    heroku config:add BASIC_AUTH_USERNAME="<username>" BASIC_AUTH_PASSWORD="<password>" --app APPNAME

#### development 

    BASIC_AUTH_USERNAME="<username>" BASIC_AUTH_PASSWORD="<password>" rails s -b 0.0.0.0 -p 3030