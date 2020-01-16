######################
Prerequisites
######################


-  Jenkins Setup

   -  We need to have a Jenkins Server, which can schedule executors via
      docker.

-  Docker image for sqitch-snowflake

   -  The executor used in this demonstration is a docker container
      which contains sqitch, snowflake odbc driver, and the snowsql
      client. Visit `docker-sqitch`_ on instructions on how to build the
      docker image. There might be some customizations required
      depending upon your Jenkins Setup. See `Caveats.md`_.

      `Docker Image`_ with tag ``snowflake-dev`` can be used for similar
      use case. `Docker Image`_ with tag ``snowflake`` is the as it is
      image after building from `docker-sqitch`_ for snowflake with
      default Dockerfile

-  Git Client

   -  We will also need the git client for communicating with github

-  Snowflake account

   -  If you do not have a snowflake account, You can sign up for one by
      visiting `Snowflake Free Trial`_ This will get you 30 days of free
      trial worth $400

.. _docker-sqitch: https://github.com/sqitchers/docker-sqitch
.. _Caveats.md: https://github.com/prem0132/snowflake-sqitch-ci-cd/blob/master/Caveats.md
.. _Docker Image: https://cloud.docker.com/u/hashmapinc/repository/docker/hashmapinc/sqitch
.. _Snowflake Free Trial: https://trial.snowflake.com/?_ga=2.198251247.151166467.1558600181-331987107.1558493529