import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*
import com.michelin.cio.hudson.plugins.rolestrategy.*
import java.util.logging.Logger

// Check if enabled
def env = System.getenv()
if (env['JENKINS_AUTHORIZATION_STRATEGY'] == "full" ) {
    println "--> Jenkins Authorization Strategy FullControlOnceLoggedIn"

  AuthorizationStrategy strategy = Jenkins.instance.getAuthorizationStrategy()
  
  logger = Logger.getLogger("FullControlOnceLoggedInAuthorizationStrategy Updater")
  
  //if(strategy ==null || !strategy instanceof FullControlOnceLoggedInAuthorizationStrategy){
   logger.info("FullControlOnceLoggedInAuthorizationStrategy set!")
   strategy = new FullControlOnceLoggedInAuthorizationStrategy()
   strategy.setAllowAnonymousRead(false)
   Jenkins.instance.setAuthorizationStrategy(strategy)
  //}
  
  Jenkins.instance.save()
  logger.info("AuthorizationStrategy done")
}
