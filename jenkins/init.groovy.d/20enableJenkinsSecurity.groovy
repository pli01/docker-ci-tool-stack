import jenkins.model.*
import hudson.security.*

// Order is important
//  Choose securiy first and after authorization
// Check if enabled
def env = System.getenv()

if (env['JENKINS_SECURITY_REALM'] == "jenkins" ) {

  def jenkinsAdminUsername = env['JENKINS_ADMIN_USERNAME'] ?: "admin"
  def jenkinsAdminPassword = env['JENKINS_ADMIN_PASSWORD'] ?: "admin123"

  def instance = Jenkins.getInstance()

  println "--> Checking if security has been set already"
  if (!instance.isUseSecurity()) {
      println "--> creating local user 'admin'"
      def hudsonRealm = new HudsonPrivateSecurityRealm(false)

      hudsonRealm.createAccount(jenkinsAdminUsername, jenkinsAdminPassword)
      instance.setSecurityRealm(hudsonRealm)

      instance.save()
  }

}
