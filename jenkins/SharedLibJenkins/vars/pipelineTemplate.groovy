import com.exakaconsulting.Openshift

def call(Closure body) {

    def config = [:]                     // create empty map
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()      // 👈 this line is essential — it executes the closure

    println("JENKINS_SERVICE_NAME : ${env.JENKINS_SERVICE_NAME}")

    def gitUrl = config.gitUrl
    def gitBranch = config.gitBranch
    def subRepository = config.subRepository

     if (!gitUrl) {
        error "Git URL must be specified!"
    }

    if (!gitBranch){
        error "Git Branch must be specified"
    }

    if (!subRepository){
        error "SubRepository must be specified"
    }

    node {
        stage('Checkout') {
            git branch: gitBranch, url: gitUrl
        }

        // Build maven
        stage('BuildpackageWithoutTestUnit'){
            script {
                steps.dir("${subRepository}"){
                    steps.bat "mvn clean package -DskipTests=true"
                }
            }
        }

        stage('OpenshiftPrepareBuild') {
            script {
                steps.dir("${subRepository}/StationDemoWeb/docker"){
                    def helper = new com.exakaconsulting.Openshift(this)
                    helper.preparedBuild()
                }
            }
        }

        stage('OpenshiftRunBuild') {
            script {
                steps.dir("${subRepository}/StationDemoWeb/docker"){
                    steps.bat  "copy ..\\target\\StationDemoSecureWeb.jar ."
                    def helper = new com.exakaconsulting.Openshift(this)
                    helper.runBuild()
                }
            }
        }
    }
}
