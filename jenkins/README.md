## Jenkins Docker Container

Usage:
```
$ docker build -t jenkins .
$ docker run -d -p=8080:8080 jenkins
```

Once Jenkins is up and running go to http://192.168.59.103:8080

# Configure Jenkins at runtime
Jenkins configuration is possible with runtime params. See init.groovy for samples

```
$ docker run -d -p=8080:8080 -e JENKINS_INSTANCE_SETNUMEXECUTORS=2 jenkins
```
```
      JENKINS_INSTANCE_SETNUMEXECUTORS: 3
      JENKINS_SECURITY_REALM: 'jenkins' # ldap pam
      JENKINS_AUTHORIZATION_STRATEGY: role  # full
      JENKINS_ADMIN_USERNAME: admin
      JENKINS_ADMIN_PASSWORD: password
      http_proxy: http://127.0.0.1:8888
      https_proxy: http://127.0.0.1:8889
      HTTP_PROXY_HOST:
      HTTP_PROXY_PORT: 80
      HTTP_PROXY_EXCEPTIONS: "localhost"
      GIT_GLOBAL_CONFIG_NAME: GitDemoCI
      GIT_GLOBAL_CONFIG_EMAIL: GitDemoCI@test.com

```

## Update Plugins

Install and update all plugins via the Jenkins Plugin Manager.
* http://<jenkins-url:port>/pluginManager/

After that use the Script Console to output all plugins including the version in the correct format for the **plugin.txt**.
* http://<jenkins-url:port>/script

```shell
def plugins = jenkins.model.Jenkins.instance.pluginManager.plugins
plugins.sort{it}
plugins.each {
  println it.shortName + ':' + it.getVersion()
}
```

More example scripts can be found in the **groovy** folder.

### Links

- Job DSL API https://jenkinsci.github.io/job-dsl-plugin/
