import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*

// get Env var
def env = System.getenv()
//def jenkins_instance_setNumExecutors = Integer.parseInt( env['JENKINS_INSTANCE_SETNUMEXECUTORS'] ?: "5" )

int jenkins_instance_setNumExecutors = env['JENKINS_INSTANCE_SETNUMEXECUTORS'].toInteger() ?: 5

Jenkins.instance.setNumExecutors( jenkins_instance_setNumExecutors )
Jenkins.instance.save()
