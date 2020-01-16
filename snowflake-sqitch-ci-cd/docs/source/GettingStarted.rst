######################
Getting Started
######################

- We need to create a snowflake user with enough permissions to execute tasks that we are going to deploy through Pipeline.

      - Login to you snowflake account


      .. image::  images/dashboard.png
            :scale: 40 %
            :align:   center

      - Go to Accounts -> Users -> create


      .. image::  images/CreateUser.png
            :scale: 40 %
            :align:   center

      - Give the user sufficient permissions to execute required tasks.
      - For more info on user management in snowflake, Refer Snowflake's `User Management`_ and `Access Contol`_ Documentaion.


- Create the `database in snowflake`_  that you'll be using.

- Clone the repository from `github`_.

- If you are going to deploy using any cloud native solution, you need to have enough permissions assigned to access those services.

      Now, we have four ways to proceed, choose one according to the CI/CD setup you have in place.

      - :ref:`Jenkins`
      - :ref:`AWS`
      - :ref:`GCP`
      - :ref:`Azure`


.. _User Management: https://docs.snowflake.net/manuals/user-guide/admin-user-management.html
.. _Access Contol: https://docs.snowflake.net/manuals/user-guide/security-access-control.html
.. _github: https://github.com/prem0132/snowflake-sqitch-ci-cd
.. _database in snowflake: https://docs.snowflake.net/manuals/sql-reference/sql/create-database.html



