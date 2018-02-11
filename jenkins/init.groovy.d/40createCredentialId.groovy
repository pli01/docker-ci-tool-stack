import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*;

import hudson.security.*
import java.util.*
import groovy.json.*

def env = System.getenv()

def user = []
// user = '[ { "id": "jenkins-build-id", "description": "jenkins-build", "user": "jenkins-build", "password": "password01" } ]'


if (!env.JENKINS_CREDENTIAL_JSON_LIST) {
  println "--> No env.JENKINS_CREDENTIAL_JSON_LIST specified!"
  return
} else {
 def slurper = new groovy.json.JsonSlurper()
 user = slurper.parseText(env.JENKINS_CREDENTIAL_JSON_LIST)

// in case of url
//  URL jsonUrl = new URL(env.JENKINS_CREDENTIAL_JSON_LIST);
//  access = new JsonSlurper().parse(jsonUrl);
}


global_domain = Domain.global()
credentials_store = Jenkins.instance.getExtensionList(
    'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
 )[0].getStore()

def getUserPassword = { username ->
    def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
            com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials.class,
            jenkins.model.Jenkins.instance
            )
    def c = creds.findResult { it.username == username ? it : null }
    return c
}

def getID = { id ->
    def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
            com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials.class,
            jenkins.model.Jenkins.instance
            )
    def c = creds.findResult { it.id == id ? it : null }
    return c
}

user.each { k  ->
   if (! (getID(k.id)) || ! (getUserPassword(k.user)) ) {
      println ("--> Add user credential id ${k.id}")
      user = new UsernamePasswordCredentialsImpl(
                    CredentialsScope.GLOBAL,
                    k.id, k.description, k.user, k.password
             )
      credentials_store.addCredentials(global_domain, user)
   }
}

Jenkins.instance.save()

/*
if (! getUserPassword('user')) {
user = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  java.util.UUID.randomUUID().toString(), "description", "user", "password")
credentials_store.addCredentials(global_domain, user)
}
*/

/* DEBUG
def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
      com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
      Jenkins.instance,
      null,
      null
);
for (a in creds) {
       println(a.id + ": " + a.description + " " + a.username +" " + a.password)
}
*/
