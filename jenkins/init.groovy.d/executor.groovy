import jenkins.model.*

// get Env var
def env = System.getenv()

def jenkins_instance_setNumExecutors = env['jenkins_instance_setNumExecutors'] ?: "5"
Jenkins.instance.setNumExecutors(jenkins_instance_setNumExecutors)
