import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import java.util.logging.Logger

def env = System.getenv()
def httpProxy = env['http_proxy'] ?: ""
def httpsProxy = env['https_proxy'] ?: ""
def targetPlateformeName = env['TARGET_PLATEFORME_NAME'] ?: ""
def targetPlateformeEmail = env['TARGET_PLATEFORME_EMAIL'] ?: ""

logger = Logger.getLogger("globalNodeProperties Updater")
nodes = Jenkins.instance.globalNodeProperties

nodes.getAll(hudson.slaves.EnvironmentVariablesNodeProperty.class)

if ( nodes.size() == 0) {
  // ajout 1 er node
  logger.info("add 1er node")
  nodes.add(new hudson.slaves.EnvironmentVariablesNodeProperty([]))
  nodes.getAll(hudson.slaves.EnvironmentVariablesNodeProperty.class)
}

envVars = nodes[0].envVars
/*
  Global VAR
*/
envVars["JENKINS_HTTP_PROXY"]  = httpProxy
envVars["JENKINS_HTTPS_PROXY"] = httpsProxy

envVars["TARGET_PLATEFORME_NAME"] = targetPlateformeName
envVars["TARGET_PLATEFORME_EMAIL"] = targetPlateformeEmail

Jenkins.instance.save()
logger.info("env var updated")

