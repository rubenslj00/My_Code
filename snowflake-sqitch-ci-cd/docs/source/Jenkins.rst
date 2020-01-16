.. _Jenkins:


######################
Jenkins
######################

- `Store the credentials`_

        Since the Jenkinsfile is part of the code, we do not hardcode the credentials.
        We will store it in the Jenkins credentials Manager.
        Go to Jenkins -> Credentials

        .. image::  images/credentials.png
            :scale: 40 %
            :align:   center

- Add the webhook

    If you are using Jenkins and you want your builds to auto trigger on push, go ahead and add a `webhook`_ in your github repo for your jenkins server

- Add the repo to your Jenkins installation

    Use the `blueocean`_ plugin, it makes adding new repos very convienent.


- Let's create the pipeline

    - Adding the agent


               .. code-block:: groovy

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

        Here we are giving a ``timeout`` option of one hour.
        We are also specifying the docker container that will act as the ``agent`` for running the job.
        And we also specify that we want to run this as the ``root`` user.

    - Deploying the change

        .. code-block:: groovy

            stages {
            stage('Installing Latest snowsql') {
                steps {
                    sh 'snowsql --help'
                }
            }
            stage('Deploy changes') {
            steps {
                withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh '''
                    sqitch deploy "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
                    '''           
                }
            }
            }

        Here we re-install the latest version of ``snowsql`` for the ``root`` user.
        
        And then deploy the change to the target database.

            .. code-block:: groovy
                
                withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])

        We use the credentials stored in credentials manager to authenticate to snowflake

            .. code-block:: groovy

                sqitch deploy "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
        
        Sqitch requires the connection string to connect to snowflake which contains
    
        username variable ``$USERNAME``
        
        password variable ``$PASSWORD`` 
        
        Snowflake Account address ``hashmap.snowflakecomputing.com``

        Driver name ``Driver=Snowflake``
        
        Database name ``flipr``
        
        and the warehouse ``warehouse=sqitch_wh``

    - Verifying the change

            .. code-block:: groovy

                stage('Verify changes') {
                steps {
                    withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        sqitch verify "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
                        ''' 
                    }
                }      

        Again we use the credentials from the credentials manager to authenticate to snowflake and here we verify if our changes were successfully deployed.

    - Cleaning Up

            .. code-block:: groovy

                post {
                    always {
                    sh 'chmod -R 777 .'
                    }
                }                

        Since we ran the container with `root` user, jenkins won't we able to clean up the workspace if don't change the permissions on the files created by it.

        So we run a `chmod -R 777 .` on the working directory.
        And we put this stage in `post` bock with `always` condition, so that this is executed in every case and workspace can be cleaned.
        If this is not done, all consecutive builds will fail.

- Add the jenkinsfile in your code   
   
   .. code-block:: groovy

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
                    sh 'snowsql --help'
                }
            }
            stage('Deploy changes') {
            steps {
                withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh '''
                    sqitch deploy "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
                    '''           
                }
            }
            }
            stage('Verify changes') {
            steps {
                withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh '''
                    sqitch verify "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
                    ''' 
                }
            }
            }      
        }  
        post {
            always {
            sh 'chmod -R 777 .'
            }
        }
        }

- Commit your changes and push to github

    For information on how to add changes via sqitch, visit `Introduction to Sqitch on Snowflake`_.

    Once you push the changes, the webhook added in github will send a ``POST`` message to jenkins and the pipeline will be triggered.

    You should see something like this in the logs


        .. code-block::  bash

            [Pipeline] // stage
            [Pipeline] stage
            [Pipeline] { (Deploy changes)
            [Pipeline] withCredentials
            [Pipeline] {
            [Pipeline] sh
            [owflake-sqitch-ci-cd_master-4KRIUCFJ5X7PGMBERRN6PYWQF2S5EEPCMF6ULWY3K4N5SP2RPD5A] Running shell script
            + sqitch deploy db:snowflake://****:****@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh
            Adding registry tables to db:snowflake://****:@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh
            Deploying changes to db:snowflake://****:@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh
            + appschema .. ok
            + users ...... ok
            [Pipeline] }
            [Pipeline] // withCredentials
            [Pipeline] }
            [Pipeline] // stage
            [Pipeline] stage
            [Pipeline] { (Verify changes)
            [Pipeline] withCredentials
            [Pipeline] {
            [Pipeline] sh
            [owflake-sqitch-ci-cd_master-4KRIUCFJ5X7PGMBERRN6PYWQF2S5EEPCMF6ULWY3K4N5SP2RPD5A] Running shell script
            + sqitch verify db:snowflake://****:****@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh
            Verifying db:snowflake://****:@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh
            * appschema .. ok
            * users ...... ok
            Verify successful
            [Pipeline] }
            [Pipeline] // withCredentials

    As you can see the changes have been deployed successfully, and sqitch is also able to verify those changes.


- Reverting

    For Reverting your changes, you can either go in the Jenkinsfile and change the deploy command to revert

    Your deploy block should look something like this

        .. code-block:: groovy

            stage('Revert changes') {
            steps {
                withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh '''
                    sqitch revert "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr?Driver=Snowflake;warehouse=sqitch_wh"
                    '''           
                }
            }    


    Or you can add a new step in your sqitch plan to drop the change and you can continue without having to edit the pipeline

- Deploying to Production

    Once, you are sure of the changes, and want to deploy to production, just change the connection string to target your production database and you are good to go.

            .. code-block:: groovy

                stage('Deploy changes to Production') {
                steps {
                    withCredentials(bindings: [usernamePassword(credentialsId: 'snowflake_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        sqitch deploy "db:snowflake://$USERNAME:$PASSWORD@hashmap.snowflakecomputing.com/flipr_prod?Driver=Snowflake;warehouse=sqitch_wh"
                        '''           
                    }
                    }
                }




.. _Introduction to Sqitch on Snowflake: https://sqitch.org/docs/manual/sqitchtutorial-snowflake/
.. _blueocean: https://jenkins.io/doc/book/blueocean/getting-started/
.. _webhook: https://embeddedartistry.com/blog/2017/12/21/jenkins-kick-off-a-ci-build-with-github-push-notifications
.. _Store the credentials: https://support.cloudbees.com/hc/en-us/articles/203802500-Injecting-Secrets-into-Jenkins-Build-Jobs



