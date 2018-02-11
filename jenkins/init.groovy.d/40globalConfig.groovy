import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*

println "--> Configuring Global Config"
Jenkins.instance.setNoUsageStatistics(true)
Jenkins.instance.setDisableRememberMe(true)
Jenkins.instance.save()
