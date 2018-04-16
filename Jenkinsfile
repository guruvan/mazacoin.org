def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
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
    def previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)
 
    stage('Test') {
      try {
        container('docker') {
          sh """
             pwd
             env
             ls -la
             docker run --rm -v `pwd`:/srv/jekyll -w /srv/jekyll jekyll/builder ls -la 
             docker run --rm -v ${WORKSPACE}:/srv/jekyll -w /srv/jekyll jekyll/builder bundle update
             docker run --rm -v ${WORKSPACE}:/srv/jekyll -w /srv/jekyll jekyll/builder rake test
          """
        }
      }
      catch (exc) {
        println "Failed to test - ${currentBuild.fullDisplayName}"
        throw(exc)
      }
    }
    stage('Build') {
      container('docker') {
        sh """
           echo "GIT_BRANCH=${gitBranch}" >> /etc/environment
           echo "GIT_COMMIT=${gitCommit}" >> /etc/environment
           test -f Dockerfile
           docker images
        """
      }
    }
    stage('Create Docker images') {
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
//    stage('Run helm') {
//      container('helm') {
//        sh "helm list"
//      }
//    }
    stage('Run kubectl') {
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
