import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*

// get Env var
def env = System.getenv()
int jenkins_instance_setNumExecutors = env['JENKINS_INSTANCE_SETNUMEXECUTORS'].toInteger() ?: 5

println "--> Configuring Global Config"
Jenkins.instance.setNoUsageStatistics(true)
Jenkins.instance.setDisableRememberMe(true)
println "--> Configuring NumExecutors"
Jenkins.instance.setNumExecutors( jenkins_instance_setNumExecutors )

Jenkins.instance.save()
