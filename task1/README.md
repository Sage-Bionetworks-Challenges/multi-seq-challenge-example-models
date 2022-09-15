## Build your model

1. Go to the example model folder you would like to build, i.e. [r-model]('./task1/r-model/)

2. Build the Docker image `docker.synapse.org/<synapse-project-id>/<model-name>:<image-tag>`, like the following command:

    ```bash
    # in the 'r-model' folder
    docker build -t docker.synapse.org/syn123/r-example-model:t1 .
    ```

## Run the model locally on ...

1. Find training data ...

2. Download [scrna_input_basenames.txt](https://www.synapse.org/#!Synapse:syn36397657) into the same folder where you store the training data

3. Create an `output` folder

    ```
    mkdir output
    ```

4. Run the dockerized model

    ```bash
    docker run \
        -v $(pwd)/<folder-of-training-data>/:/data:ro \
        -v $(pwd)/output:/output:rw \
        --cpus=20 \ # change based on your local machine, don't use more than 20 cores
        --memory=160g \ # change based on your local machine, don't use more than 160g
        r-example-model:t1
    ```

5. The predictions files are saved to `/output/`.

    ```
    $ ls output/*_imputed.csv
    ds1_c1_p05_n1_imputed.csv	
    ds1_c1_p05_n2_imputed.csv
    ...
    ds3r_c0_p50k_n3_imputed.csv

    $ ls output/*_imputed.csv | wc -l
    108
    # if it's less than 108, it means some data are not successfully imputed
    ```

## Submit this model to the DREAM Challenge

If your model meets the requirements and it can be pushed up to your project on Synapse. Please see the [instructions] on how to submit the model to synapse. Then submit it to the Task 1 of [the Dream Challenge].

[the Dream Challenge]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615338
[instructions]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615352
