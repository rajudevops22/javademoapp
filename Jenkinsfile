node{
   try{
   emailext body: "Jenkins job started with build number ${BUILD_NUMBER}", subject: "Jenkins job started with ${BUILD_NUMBER}", to: 'raju.seeram22@gmail.com'
   def ansibleip = '192.168.1.95'
   def ansibleuser = 'raju'
   def ansibledploy = "ssh ${ansibleuser}@${ansibleip}  ansible-playbook  /home/raju/deployartifacts/ansibleTomactDeployPlaybook.yaml --key-file '/home/raju/deploy-server-key.pem'"
   def copyWar = "scp -o StrictHostKeyChecking=no target/myweb.war ${ansibleuser}@${ansibleip}:/home/raju/deployartifacts"
   def copyansibleplaybook = "scp -o StrictHostKeyChecking=no ansibleTomactDeployPlaybook.yaml ${ansibleuser}@${ansibleip}:/home/raju/deployartifacts"
  
   stage('SCM Checkout'){
     git 'https://github.com/rajudevops22/javademoapp'
   }
   stage('Compile-Package'){

      def mvnHome =  tool name: 'Maven-3', type: 'maven'   
      sh "${mvnHome}/bin/mvn clean package -DskipTests=true"
   }

  stage('SonarQube Analysis') {
        def mvnHome =  tool name: 'Maven-3', type: 'maven'
		
			 
        withSonarQubeEnv('sonarserver') { 
          sh "${mvnHome}/bin/mvn  sonar:sonar -DskipTests=true"
	}
    }

  stage('Unit Test'){
     def mvnHome =  tool name: 'Maven-3', type: 'maven'   
      sh "${mvnHome}/bin/mvn test"
	junit 'target/surefire-reports/*.xml'
   } 
	
stage('deploy to nexus'){
	   def mvnHome =  tool name: 'Maven-3', type: 'maven'
       sh "${mvnHome}/bin/mvn deploy -DskipTests=true"
   } 
	   
stage('Build Docker Image'){
	def dockerhome =  tool name: 'docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
        env.PATH = "${dockerhome}/bin:${env.PATH}"
	   sh 'sudo docker build -t rajuseeram22/demoapp:0.0.1 .'
   }

  stage('Upload Image to DockerHub'){
	 def dockerhome =  tool name: 'docker', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
	 env.PATH = "${dockerhome}/bin:${env.PATH}"
	  withCredentials([string(credentialsId: 'docker-pwd5', variable: 'docker-hub-pwd5')]) {
		   sh "sudo docker login -u rajuseeram22 -p ${docker-hub-pwd5}"		   
}
	  sh 'sudo docker push rajuseeram22/demoapp:0.0.1'
  }
 	   
stage ('deploy to tomcat'){
sshagent(['ansible-server-key']) {
	sh 'mv target/myweb*.war target/myweb.war' 
	sh 'cd target'
	sh 'pwd'
	sh 'ls -lart'
  sh "${copyWar}"
  sh "${copyansibleplaybook}"
  sh "${ansibledploy}"
}
}
   

 }
	
	catch (err) {
		//publishHTML(target: [allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: 'coverage', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: 'Report'])
		emailext body: "${err} at Build numebr ${BUILD_NUMBER}", subject: 'Failure', to: 'raju.seeram22@gmail.com'
    /*stage('Email Notification'){
      mail bcc: '', body: '''Hi Welcome to jenkins email alerts
      Thanks
      Raju''', cc: '', from: '', replyTo: '', subject: 'Jenkins Job', to: 'raju.seeram22@gmail.com' 
   } */
   }
	
}


