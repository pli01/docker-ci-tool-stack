import jenkins.*;
import jenkins.model.*;
import hudson.*;
import hudson.model.*;
import com.michelin.cio.hudson.plugins.*;

/*
d = new com.michelin.cio.hudson.plugins.maskpasswords.MaskPasswordsConfig()
desc = d.getInstance()
config = d.load()
desc.save(config)
*/

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    println "--> Configuring MaskPassword"
    def d = new com.michelin.cio.hudson.plugins.maskpasswords.MaskPasswordsConfig()
    desc = d.getInstance()
    config = d.load()
    desc.save(config)

    // Save the state
    instance.save()
}
