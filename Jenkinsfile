def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
  containerTemplate(name: 'jekyll', image: 'jekyll/builder', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:latest', command: 'cat', ttyEnabled: true)
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node(label) {
    def myRepo = checkout scm
    def gitCommit = myRepo.GIT_COMMIT
    def gitBranch = myRepo.GIT_BRANCH
    def shortGitCommit = "${gitCommit[0..10]}"
 //  def git_branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true)
    def previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)
 //  sh(script: "echo \"Running ${env.BUILD_ID} on ${env.JENKINS_URL}\"", returnStdout: true)
    sh(script: "echo \"Building sha1 ${sha1}\"", returnStdout: true)
    sh(script: "echo \"Building gitBranch ${gitBranch}  commit ${gitCommit}\"", returnStdout: true)
    sh(script: "echo \"Original source for build from GHPRB: ${ghprbSourceBranch}\"", returnStdout: true)
    sh 'env > env.txt' 
for (String i : readFile('env.txt').split("\r?\n")) {
    println i
}
 //  sh(script: "echo \"Building ${BRANCH_NAME} BRANCH_NAME ${env.BRANCH_NAME} commit ${gitCommit}\"",returnStdout: true)
 // issue with UID/GID between containers prevents us from writing to the 
 // workspace inside the jekyll container, so we copy the workdir over to /srv/jekyll
 // https://issues.jenkins-ci.org/browse/JENKINS-41418
      if (ghprbSourceBranch == '') {
         println "Not building from PR - will run deploy stage"
        def prDetect = false
      } else {
        println "PR Build detected - sha1 is ${sha1}"
         def prDetect = true
      }
    println "PR detected? ${prDetect}"
    stage('Test') {
    if (gitBranch == 'origin/master') { 
      try {
        container('jekyll') {
          sh """
             cp -av ./ /srv/jekyll
             cd /srv/jekyll
             chown -R jekyll.jekyll /srv/jekyll
             bundle update
             rake test
          """
        }
      }
      catch (exc) {
        println "Failed to test - ${currentBuild.fullDisplayName}"
        throw(exc)
      } 
    }
    }
    if (prDetect == false) {
    stage('Deploy Docker Images to Registry') {
      if (gitBranch	 == 'origin/develop') {
          container('docker') {
            withCredentials([[$class: 'UsernamePasswordMultiBinding',
              credentialsId: 'dockerhub',
              usernameVariable: 'DOCKER_HUB_USER',
              passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
                sh """
                  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
                  docker build -t guruvan/mazacoin-org:${shortGitCommit} .
                  docker tag guruvan/mazacoin-org:${shortGitCommit} guruvan/mazacoin-org:dev
                  docker push guruvan/mazacoin-org:${shortGitCommit}
                  docker push guruvan/mazacoin-org:dev
                """
              }
          }
      }
      if (ghprbSourceBranch == "origin/master" ) {
          container('docker') {
            withCredentials([[$class: 'UsernamePasswordMultiBinding',
              credentialsId: 'dockerhub',
              usernameVariable: 'DOCKER_HUB_USER',
              passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
                sh """
                  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
                  docker build -t guruvan/mazacoin-org:${shortGitCommit} .
                  docker tag guruvan/mazacoin-org:${shortGitCommit} guruvan/mazacoin-org:latest
                  docker push guruvan/mazacoin-org:${shortGitCommit}
                  docker push guruvan/mazacoin-org:latest
                """
              }
            }
      }
    }
//    stage('Run helm') {
//      container('helm') {
//        sh "helm list"
//      }
//    }
    stage('Deploy Pod') {
      switch(ghprbSourceBranch) {
        case "origin/develop":
          container('kubectl') {
          withCredentials([string(credentialsId: 'c40d0d5f-875b-4dfe-b3c0-4374606f635e', variable: 'KUBECTL_TOKEN')]) {
            sh """
              kubectl --token $KUBECTL_TOKEN get pods -n maza-web
              kubectl --token $KUBECTL_TOKEN delete -f k8s/dev/mazaweb.yaml
              kubectl --token $KUBECTL_TOKEN create -f k8s/dev/mazaweb.yaml
            """
          }
          }
        case "origin/master":
          container('kubectl') {
          withCredentials([string(credentialsId: 'c40d0d5f-875b-4dfe-b3c0-4374606f635e', variable: 'KUBECTL_TOKEN')]) {
            sh """
              kubectl --token $KUBECTL_TOKEN get pods -n maza-web
              kubectl --token $KUBECTL_TOKEN delete -f k8s/dev/mazaweb.yaml
              kubectl --token $KUBECTL_TOKEN create -f k8s/dev/mazaweb.yaml
            """
          }
          }        
      }
    }
    }
}
}
