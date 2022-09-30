## Build your model

1. Go to the one of example models folder:

   - [r-simple](r-simple/): [R] model by multiplying random numbers
   - [r-magic](r-magic/): [R] model using `Rmagic` package from [MAGIC](https://github.com/KrishnaswamyLab/MAGIC)
   - [py-deepimpute](py-deepimpute/): [Python] model using [deepimpute](https://github.com/lanagarmire/deepimpute)

2. Build the Docker image `docker.synapse.org/<synapse-project-id>/<model-name>:<image-tag>`, like the following command:

   ```bash
   # in the 'task1' folder
   docker build -t docker.synapse.org/syn123/example-model-task1:v1 .
   ```

## Test the model locally

1. Download and decompress [scrna_toy_data.tar.gz](https://www.synapse.org/#!Synapse:syn36753959)

2. Create an `output` folder

   ```
   mkdir output
   ```

3. Run the dockerized model.

   ```bash
   docker run \
       -v $PWD/scrna_toy_data/:/input:ro \
       -v $PWD/output:/output:rw \
       docker.synapse.org/syn123/example-model-task1:v1
   ```

4. Check if predictions files are saved to `output/`.

   ```
   $ ls output/*_imputed.csv | wc -l
   108
   # if it's less than 108, it means some data are not successfully imputed
   ```

## Submit this model to the DREAM Challenge

If your model meets the requirements and it can be pushed up to your project on Synapse. Please see the [instructions] on how to submit the model to synapse. Then submit it to the Task 1 of [the Dream Challenge].

[the dream challenge]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615338
[instructions]: https://www.synapse.org/#!Synapse:syn26720920/wiki/615352
