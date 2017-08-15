# datadogmonitor

Recommended setup for running as an app on Aptible:

 1. Create an S3 bucket for your configuration files in the same region as the
    environment you wish to monitor.

 2. Create an IAM user to retrieve the configuration files. Give your IAM user
    permission to read/write from the bucket you created in step 2.
    Adding the following as an inline custom policy should be sufficient
    (replace `BUCKET_NAME` with the name of your S3 bucket):

    ```
    {
        "Statement": [
            {
                "Action": [
                    "s3:ListBucket",
                    "s3:GetBucketLocation",
                    "s3:ListBucketMultipartUploads",
                    "s3:ListBucketVersions"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::MY_BUCKET_NAME"
                ]
            },
            {
                "Action": [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject",
                    "s3:AbortMultipartUpload",
                    "s3:ListMultipartUploadParts"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::MY_BUCKET_NAME/*"
                ]
            }
        ],
        "Version": "2012-10-17"
    }

    ```

 3. Create an app in your Aptible account for the the Datadog Agent. You can do this through
    the [Aptible dashboard](https://dashboard.aptible.com) or using the
    [Aptible CLI](https://github.com/aptible/aptible-cli):

    ```
    aptible apps:create YOUR_APP_HANDLE
    ```

    In the steps that follow, we'll use &lt;YOUR_APP_HANDLE&gt; anywhere that
    you should substitute the actual app handle you've specified in this step.

 4. Set the following environment variables in your app's configuration:

     * `API_KEY`: Your Datadog API key (found on https://app.datadoghq.com/account/settings#api)
     * `S3_BUCKET`: Your S3 Bucket name.
     * `S3_BUCKET_BASE_PATH`: Destination path within bucket (Optional)
     * `S3_ACCESS_KEY_ID`: The access key you generated in step 3.
     * `S3_SECRET_ACCESS_KEY`: The secret key you generated in step 3.

 5. Create a limited-access `datadog` user on your database (using `aptible db:tunnel`), 
    per the instructinos here : https://docs.datadoghq.com/integrations/

    An example for PostgreSQL is :

    ```
    create user datadog with password 'Hunter2';
    grant SELECT ON pg_stat_database to datadog;
    ```

 6. Add configuration files to you S3 bucket. 
    You can find instructions and examples here: https://github.com/DataDog/integrations-core
 
    For a PoastgreSQL database with the user created in step 5, the `postgres.yaml` file may be:
 
     ```
     init_config:

     instances:
        - host : db-shared-us-east-1-yolo-8058.aptible.in
          port : 24714
          username : datadog
          password : Hunter2
          ssl : True
    ```
