pipeline {
    options {
    timeout(time: 1, unit: 'HOURS')
}
 agent {
    docker {
    image 'hashmapinc/sqitch:snowflake-dev'
    args "-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=''"
    }
}
stages {
    
    stage('Installing Latest snowsql') {
        steps {
            echo 'this is stage 1'
            sh 'snowsql --help'
        }
    }
    stage('Tracking Status') {
    steps {
        echo 'this is stage 2'
        withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh '''
            sqitch status "db:snowflake://$USERNAME:$PASSWORD@jja46528.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
            '''
        }
    }
    }
    stage('Deploy changes') {
    steps {
        echo 'this is stage 3'
        withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh '''
            sqitch deploy "db:snowflake://$USERNAME:$PASSWORD@jja46528.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
            '''
        }
    }
    }
    stage('Verify changes') {
    steps {
        echo 'this is stage 4'
        withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh '''
            sqitch verify "db:snowflake://$USERNAME:$PASSWORD@jja46528.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
            '''
        }
    }
    }
}
}
