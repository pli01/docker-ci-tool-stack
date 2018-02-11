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
Runtime configuration can be provided using environment variables:

* JENKINS_OPTS, Jenkins startup options.
* JENKINS_INSTANCE_SETNUMEXECUTORS: choose number of executors
* JENKINS_SECURITY_REALM, choose on of them: 'jenkins' for local user database, 'ldap' for LDAP auth or 'pam' for PAM authentication. Default to true (enabled).
* JENKINS_AUTHORIZATION_STRATEGY: choose one of: 'role' for role based strategy or 'full' for allow full access for authenticated users
* JENKINS_AUTHZ_JSON_URL: provide role mapping  in a json variable. Format is : '{ "admins": [ "admin", "userA" ], "builders": [ "groupB", "userB_zeta" ], "readers": ["authenticated"] }'
* JENKINS_ADMIN_USERNAME: admin . Choose admin login
* JENKINS_ADMIN_PASSWORD: admin123. Chosse admin password
* HTTP_PROXY_HOST: Define proxy hostname
* HTTP_PROXY_PORT: Define proxy port
* HTTP_PROXY_USER: Define proxy username
* HTTP_PROXY_PASSWORD: Define proxy password
* HTTP_PROXY_EXCEPTIONS: Define comma separeted list fo host to exclude from proxy request
* GIT_GLOBAL_CONFIG_NAME: Configure git plugin, Define git jenkins name when commit
* GIT_GLOBAL_CONFIG_EMAIL: Configure git plugin, Define git email

* for ldap realm
* LDAP_SERVER, the LDPA URI, i.e. ldap-host:389
* LDAP_ROOTDN, the LDAP BASE_DN
* LDAP_USER_SEARCH_BASE, base organization unit to use to search for users
* LDAP_USER_SEARCH, LDAP object field to use for the search query
* LDAP_GROUP_SEARCH_BASE, base organization unit to use to search for groups
* LDAP_GROUP_SEARCH_FILTER, filter to use querying for groups
* LDAP_GROUP_MEMBERSHIP_FILTER, filter to use when writing queries to verify if a user is member of a group
* LDAP_MANAGER_DN, LDAP adim user
* LDAP_MANAGER_PASSWORD, LDAP admin password
* LDAP_INHIBIT_INFER_ROOTDN, flag indicating if ROOT_DN should be infered
* LDAP_DISPLAY_NAME_ATTRIBUTE_NAME, LDAP object field used as a display name
* LDAP_DISABLE_MAIL_ADDRESS_RESOLVER, flag indicating if the email address resolver should be disabled
* LDAP_MAIL_ADDRESS_ATTRIBUTE_NAME, LDAP object field used as a email address


```
      JENKINS_INSTANCE_SETNUMEXECUTORS: 3
      JENKINS_SECURITY_REALM: jenkins # ldap pam
      JENKINS_AUTHORIZATION_STRATEGY: role  # full
      JENKINS_AUTHZ_JSON_URL: '{ "admins": [ "admin", "userA" ], "builders": [ "groupB", "userB_zeta" ], "readers": ["authenticated"] }'
      JENKINS_ADMIN_USERNAME: admin
      JENKINS_ADMIN_PASSWORD: password
      http_proxy: http://127.0.0.1:8888
      https_proxy: http://127.0.0.1:8888
      HTTP_PROXY_HOST: proxy
      HTTP_PROXY_PORT: 8888
      HTTP_PROXY_EXCEPTIONS: "localhost,gitlab,nexus"
      GIT_GLOBAL_CONFIG_NAME: GitDemoCI
      GIT_GLOBAL_CONFIG_EMAIL: GitDemoCI@test.com

      LDAP_SERVER="ldap:389"
      LDAP_ROOTDN="${LDAP_FULL_DOMAIN}"
      LDAP_USER_SEARCH_BASE="ou=people"
      LDAP_USER_SEARCH="uid={0}"
      LDAP_GROUP_SEARCH_BASE="ou=groups" 
      LDAP_GROUP_SEARCH_FILTER="" 
      LDAP_GROUP_SEARCH_FILTER="(&(cn={0}) (| (objectclass=groupOfNames) (objectclass=groupOfUniqueNames) (objectclass=posixGroup)))" 
      LDAP_GROUP_MEMBERSHIP_FILTER="" 
      LDAP_MANAGER_DN="cn=admin,${LDAP_FULL_DOMAIN}" 
      LDAP_MANAGER_PASSWORD=${LDAP_PWD} 
      LDAP_INHIBIT_INFER_ROOTDN="true" 
      LDAP_DISABLE_MAIL_ADDRESS_RESOLVER="false" 
      LDAP_DISPLAY_NAME_ATTRIBUTE_NAME="displayName" 
      LDAP_DISPLAY_NAME_ATTRIBUTE_NAME="cn" 
      LDAP_MAIL_ADDRESS_ATTRIBUTE_NAME="mail" 
  
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
