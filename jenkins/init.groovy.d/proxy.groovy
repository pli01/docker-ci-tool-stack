import jenkins.model.*

// get Env var
def env = System.getenv()

// need git plugins
def httpProxyHost = env['HTTP_PROXY_HOST'] ?: ""
def httpProxyPort = Integer.parseInt( env['HTTP_PROXY_PORT'] ?: "" )
def httpProxyUser = env['HTTP_PROXY_USER'] ?: ""
def httpProxyPassword = env['HTTP_PROXY_PASSWORD'] ?: ""
def httpProxyExceptions = env['HTTP_PROXY_EXCEPTIONS'] ?: ""

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    // proxy config
    println "--> Configuring Proxy config"
    final String name = httpProxyHost
    final int port = httpProxyPort
    final String userName = httpProxyUser
    final String password = httpProxyPassword
    final String noProxyHost = httpProxyExceptions

    final def pc = new hudson.ProxyConfiguration(name, port, userName, password)
    instance.proxy = pc
    // Save the state
    instance.save()
}
