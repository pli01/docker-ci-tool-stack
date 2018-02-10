import jenkins.model.*

// get Env var
def env = System.getenv()

// need git plugins
def gitGlobalConfigName = env['GIT_GLOBAL_CONFIG_NAME'] ?: ""
def gitGlobalConfigEmail = env['GIT_GLOBAL_CONFIG_EMAIL'] ?: ""

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    // Git Identity
    println "--> Configuring Git Identity"
    def desc_git_scm = instance.getDescriptor("hudson.plugins.git.GitSCM")
    desc_git_scm.setGlobalConfigName(gitGlobalConfigName)
    desc_git_scm.setGlobalConfigEmail(gitGlobalConfigEmail)
    // Save the state
    instance.save()
}
