#!groovy
import jenkins.model.*
import hudson.security.*
// Check if enabled
def env = System.getenv()
if (env['JENKINS_SECURITY_REALM'] == "pam" ) {
    println "--> Jenkins PAM Realm"

def instance = Jenkins.getInstance()

def hudsonRealm = new PAMSecurityRealm("")
instance.setSecurityRealm(hudsonRealm)

instance.save()
}
