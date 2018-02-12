import jenkins.*
import hudson.*
import hudson.model.*
import jenkins.model.*
import jenkins.security.*
import java.io.File

def env = System.getenv()

// TODO: ENV at run time : list space separated
userListParameter = "jenkins admin"

def userList = userListParameter.split()

// create jenkins-job-builder config
def dir = env.HOME + "/.config/jenkins_jobs/"
def  d = new File(dir);
d.mkdirs()

// iterate list of user
userList.each {
User u = User.get(it)
ApiTokenProperty t = u.getProperty(ApiTokenProperty.class)

def token = t.getApiToken()

// FIXME: var file
def file = new File(dir + 'jenkins_job_builder_' + it + '.txt')
file.write("${token}")

def inifile = new File(dir + 'jenkins_jobs_' + it + '.ini')
inifile.write("[jenkins]\nuser=${it}\npassword=${token}\nurl=http://localhost:8080/jenkins/\n")

}

