import jenkins.model.*
import java.util.logging.Logger

println ('--> set default email suffix')

def env = System.getenv()

def defaultEmailSuffix = env['JENKINS_EMAIL_SUFFIX'] ?: "noreply@nowhere"
def publicUrl          = env['JENKINS_PUBLIC_URL']


def instance = Jenkins.getInstance()

def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setAdminAddress( defaultEmailSuffix )

if (publicUrl) {
  jenkinsLocationConfiguration.setUrl( publicUrl )
}

jenkinsLocationConfiguration.save()

instance.save()
