## Build your model

1. Go to the example model folder you would like to build, i.e. [macs2-model]('./task2/macs2-model/)

2. Build the Docker image `docker.synapse.org/<synapse-project-id>/<model-name>:<image-tag>`, like the following command:

    ```bash
    # in the 'r-model' folder
    docker build -t docker.synapse.org/syn123/example-model-t2:v1 .
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
        --cpus=tbd \ # change based on your local machine, don't use more than 20 cores
        --memory=tbd \ # change based on your local machine, don't use more than 160g
        docker.synapse.org/syn123/example-model-t2:v1
    ```

5. The predictions files are saved to `/output/`.

    ```
    $ ls output/*.narrowPeak | wc -l
    960
    # if it's less than 960, it means some data are not successfully imputed
    ```

## Submit this model to the DREAM Challenge

If your model meets the requirements and it can be pushed up to your project on Synapse. Please see the [instructions] on how to submit the model to synapse. Then submit it to the Task 2 of [the Dream Challenge].

[the Dream Challenge]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615338
[instructions]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615352
