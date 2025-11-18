package com.exakaconsulting

class Openshift {

    def steps  // pipeline context

    def cluster_name = "exaka-clustername"

    Openshift(steps) {
        this.steps = steps
    }

    
    /********************* PrepareBuild     *************************/
    def preparedBuild(){
        def step_openshift = steps.openshift
        //steps.bat "openshift"
        step_openshift.withCluster(cluster_name) {
            step_openshift.withCredentials('OPENSHIFT_TOKEN'){
                step_openshift.withProject('stationdev') {
                    // Prepare build
                    def bc = step_openshift.selector('bc', 'station-buildconfig')
                    println("bc : ${bc}")
                    if (bc.exists()) {
                        println "BuildConfig station-buildconfig exists, deleting..."
                        bc.delete()
                        def istagSelector = step_openshift.selector(
                        'imagestreamtag',"station-back:0.0.99")
                        if (istagSelector.exists()){
                            istagSelector.delete()
                            println "ImageStreamTag station-back:0.0.99  exists, deleting..."
                        }
                        
                    } else {
                        println "BuildConfig station-buildconfig does not exist. Skipping delete."
                    }
                    bc = step_openshift.newBuild("--name=station-buildconfig", \
                                "--allow-missing-images=true", \
                                // To push on external registry not internal openshift
                                "--to-docker=true", \
                                "--strategy=docker", \
                                "--binary=true", \
                                "--to=docker.io/kagzouli/station-back:0.0.99",
                                "--push-secret=regi-secret" 
                            )
                }
            }
        }
    }


    /********************* runBuild     *************************/
    def runBuild(){

        def step_openshift = steps.openshift
        step_openshift.withCluster(cluster_name) {
            step_openshift.withCredentials('OPENSHIFT_TOKEN'){
                step_openshift.withProject('stationdev') {
                    // Select the BuildConfig
                    def bc = step_openshift.selector('bc', 'station-buildconfig')

                    // Start the build
                    def build = bc.startBuild("--from-dir=.") // starts the build asynchronously

                    println "Triggered build: ${build.object().metadata.name}"

                    // Optional: stream logs to Jenkins console
                    build.logs('-f')

                    // Optional: wait for build to finish
                    build.untilEach(1) { b ->
                        return b.object().status.phase == 'Complete' || b.object().status.phase == 'Failed'
                    }

                    println "Build finished with status: ${build.object().status.phase}"
                }
            }
        }
                    
    }
}
