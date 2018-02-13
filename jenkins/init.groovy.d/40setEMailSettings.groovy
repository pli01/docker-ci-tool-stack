// These are the basic imports that Jenkin's interactive script console
// automatically includes.
// Don't edit : This file is generated !

import jenkins.model.*
import org.jenkinsci.plugins.*
// Check if enabled
def env = System.getenv()
if (!env['JENKINS_SMTP_HOST']) {
 println ('--> no env.JENKINS_SMTP_HOST defined. skipping')
 return
}

println ('--> set SmtpHost')
def smtpHost = env.JENKINS_SMTP_HOST
def smtpssl = env.JENKINS_SMTP_SSL ?: ""

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor("hudson.tasks.Mailer")

// desc.setSmtpAuth("user", "userpass")
// desc.setReplyToAddress("dummy@jenkins.bla")
desc.setSmtpHost( smtpHost )
desc.setUseSsl( smtpssl.toBoolean() )
desc.setSmtpPort("25")
desc.setCharset("UTF-8")

desc.save()
inst.save()
