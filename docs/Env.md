### Environment

# default variable
docker-compose.yml
# load with ENV
docker-compose.${ENV}yml
# define variable in env file
${ENV}-config.env

# precedence environment
values of environment variables is taken from environment key first (docker-compose)
 and then from environment file,
  then from a Dockerfile ENV entry


# ENV files format
VAR=VALUE
 no quote value
ex: 
GITLAB_OMNIBUS_CONFIG=external_url 'http://url'; gitlab_rails['gitlab_email_display_name']='Gitlab';
