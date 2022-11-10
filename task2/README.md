## Build your model

1. Build the Docker image `docker.synapse.org/<synapse-project-id>/<model-name>:<image-tag>`, like the following command:

   ```bash
   # in an example model folder
   docker build -t docker.synapse.org/syn123/example-model-task2:v1 .
   ```

## Test the model locally

1. Find training data ... TBD
2. Create an `output` folder

   ```
   mkdir output
   ```

3. Run the dockerized model

   ```bash
   docker run \
       -v $(pwd)/<folder-of-training-data>/:/input:ro \
       -v $(pwd)/output:/output:rw \
       docker.synapse.org/syn123/example-model-task2:v1
   ```

4. The predictions file should be compressed and saved to `output/`.

   ```
   $ ls output/
   predictions.tar.gz
   ```

## Submit this model to the DREAM Challenge

If your model meets the requirements and it can be pushed up to your project on Synapse. Please see the [instructions] on how to submit the model to synapse. Then submit it to the Task 2 of [the Dream Challenge].

[the dream challenge]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615338
[instructions]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615352
