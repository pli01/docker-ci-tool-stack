import jenkins.model.*

// get Env var
def env = System.getenv()

// need git plugins
def httpProxyHost = env['HTTP_PROXY_HOST'] ?: ""
//def httpProxyPort = Integer.parseInt( env['HTTP_PROXY_PORT'] ) ?: 0
def httpProxyPort = env['HTTP_PROXY_PORT'] ?: ""
//int httpProxyPort = env['HTTP_PROXY_PORT'].toInteger() ?: 8888
def httpProxyUser = env['HTTP_PROXY_USER'] ?: ""
def httpProxyPassword = env['HTTP_PROXY_PASSWORD'] ?: ""
def httpProxyExceptions = env['HTTP_PROXY_EXCEPTIONS'] ?: ""

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    // proxy config
    if ( httpProxyHost.isEmpty() || httpProxyPort.isEmpty()) {
      println "--> No Proxy config"
      return
    }
    println "--> Configuring Proxy config"
    final String name = httpProxyHost
    final int port =  httpProxyPort.toInteger()
    final String userName = httpProxyUser
    final String password = httpProxyPassword
    final String noProxyHost = httpProxyExceptions.replace(',','\r\n')

    final def pc = new hudson.ProxyConfiguration( name, port , userName, password, noProxyHost)
    instance.proxy = pc
    // Save the state
    instance.save()
}
