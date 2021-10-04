# dataproc

Working with Google Dataproc

# quick start

Just do this to create a dataproc cluster, submit the Pi spark job to it and delete it ...

`scripts/lifecycle.sh`

NOTE: The script calls these other scripts in sequence ...

1. `scripts/create_cluster.sh` - this creates a dataproc cluster using Terraform
2. `scripts/submit_job.sh` - this submits the Pi Spark job
3. `scripts/delete_cluster.sh` - this deletes the dataproc cluster

# prerequisites

1. You need to have Google Cloud account
2. You need to set up a config file (~/.dataproc/config.json) per the structure in the config section below
3. You should have installed `brew`
4. You should have installed `jq`
5. You should have installed `sbt`
6. You should have installed `google-cloud-sdk`

# config

Please set up this config file (~/.dataproc/config.json) ...

```
{
  "zone": "the-zone",
  "cluster": "dataproc-cluster-name",
  "keyfile": "/full/path/of/the-key-file"
}
```

NOTE:

1. You should be aware of the zone you want to use; that should go into the config file
2. You should think of an appropriate name for the dataproc cluster you want to use; that should go into the config file
3. You should have set up a Service Account in Google Cloud Console and downloaded its json file

# creating cluster 

This script creates a dataproc cluster using Terraform ...

`scripts/create_cluster.sh`

# submitting spark Pi job to dataproc cluster

This script submits spark Pi job to dataproc cluster ...

`scripts/submit_job.sh`

# deleting cluster

This script deletes the dataproc cluster ...

`scripts/delete_cluster.sh`

# create jar

This script creates the jar using `sbt` ...

`scripts/create_jar.sh`

NOTE: This script is called by other scripts

# code

The code to compute `Pi` is written in `Scala`

# build tool

`sbt` is the build tool used to compile and package the scala code

# important note

Before deploying to Google Cloud Dataproc cluster, you can ensure the jar works on local Spark cluster using ...

`submit_local.sh`
