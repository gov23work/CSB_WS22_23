# CSB_WS22_23

## Getting Started
To get it working, one needs to set their GOOGLE_AUTHENTICATION_CREDENTIALS.  
This can be done by navigating to https://console.cloud.google.com/iam-admin/serviceaccounts?, setting up a service account for the project or using the existing one And creating a key.  
This key then needs to be downloaded and set as the variable GOOGLE_AUTHENTICATION_Credentials i.e `export GOOGLE_AUTHENTICATION_CREDENTIALS /path/to/key.json` on Mac and Linux.  
In the two startup scripts, one needs to add their authentication token, which can be gotten from https://developers.google.com/oauthplayground.  There, select Cloud Storage API v1 -> https://www.googleapis.com/auth/devstorage.read_only and click on Authorize APIs.  
After allowing access to your Google account, click on "Exchange authorization code for tokens". Your access token will then presented and needs to be pasted into startup_client.sh (line 9) and startup_sut (lines 16 and 20) where it says "PASTE_TOKEN_HERE, completely replacing this string. In the end, the header should look like this, but contain your token:  
`Authorization: Bearer ya29.a0AVvZVsr3XE02gKiprQVMoZXX01MgU__KKMue6NEmg785g-92EddjYUUYsgT01M4T-0OfxvM8lexNHTdDcN45Ht8xN4BzCRD9gI2FrWok-r2_vVxD5HxKa5-kgUK3Xnoy-0TBYSJMKZRL_VhNrN-700AGQnVOatEaCgYKASsSAQASFQGbdwaIiCj11Y0HTnrFjiZK1Q-y4w0166`  
After doing all this, you're ready to start the benchmark.  
## Configuring the setup
The amount of machines are controlled via the count flag  on line 35 of main.tf.  
To change the targets that Prometheus needs to monitor, a script can be found in /tmp on the SUT called change_targets.sh, used like this:  
`sudo ./change_targets.sh firstip secondip thirdip`  
To change the interval that Prometheus scrapes targets, a script can be found in /tmp on the SUT called change_interval.sh, which takes the seconds as a parameter:
`sudo ./change_interval.sh 5` 
After changing these values, give Prometheus a couple of minutes to restart successfully just to be safe.  
To change the metrics provided by each client, a script can be found in /tmp on the node exporters called change_metrics.sh, which takes the number of metrics as a parameter. The functionality is setup so that after this number exceeds 10000 files, only step size of 10000 is possible. Therefore, monitoring 154382 extra metrics would not be possible, but monitoring 150000 or 160000. To avoid huge files, the script creates a new file for each 10000 metrics. Usage is as follows:  
`sudo ./change_metrics.sh 100000`
## Running the Benchmark
After following the instructions in Getting Started, you can initialize Terraform by using :
`terraform init`  
After adjusting the count variable to the amount of machines you want to use for your benchmark (be careful, Google has a limit of 8 machines with IN_USE_Addresses, therefore max is 7), you can `terraform plan` and, if that looks correct, `terraform apply`
## Data Assessment and Gathering
Prometheus provides an interface to access the monitored metrics, and also provides data about its scrape duration, scrape success, and overal metrics ingested.  The following commands were used to assess the data, and the value in square brackets was adjusted according to what scrape interval was set: 
`avg(avg_over_time(scrape_duration_seconds{instance!="localhost:9090"}[10m]))`    
`rate(prometheus_tsdb_head_samples_appended_total[10m])`
`avg(100*avg_over_time(up{job="prometheus"}[10m]))`  
This value should be set to 10m for 5s, 4m for 2s, and 2m for 1s to ensure 120 data points would be averaged.  
To access this page, go to "IP_OF_YOUR_PROMETHEUS_INSTANCE:9090". After initially creating the instances, give the system roughly 10 minutes to boot up, and first adjust the interval and targets on the SUT so Prometheus monitors the machines.  
You can then start with collecting data that Prometheus provides using the above expressions. 