pipeline {
    options {
      timeout(time: 1, unit: 'HOURS') 
  }
  agent {
    docker {
      image 'hashmapinc/sqitch:jenkins'
      -p 9000:9000
      args "-u root -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --entrypoint=''"
    }
  }
  stages {
    stage('Moving .snowsql to workspace and replacing snowsql in /bin') {
        steps {
            sh '''
            rm /bin/snowsql 
            mv /var/snowsql /bin/
            mv /var/.snowsql ./
            ''' 
        
      }
    }
    stage('Deploy changes') {
      steps {
        withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])
          sh '''
              sqitch deploy "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
              '''           
        
      }
    }
    stage('Verify changes') {
      steps {
        withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])
          sh '''
              sqitch verify "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
              ''' 
        
      }
    }
}
    post {
    always {
      sh 'chmod -R 777 .'
    }
  }
}
  
