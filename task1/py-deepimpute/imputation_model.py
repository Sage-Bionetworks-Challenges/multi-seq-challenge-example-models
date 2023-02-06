import pandas as pd
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # hide all messages from tf


def imputation_model(model_inputs, ncores=4):
    """here is just an example of deepimpute, please change to use your own model"""
    # need to import in each process
    from deepimpute.multinet import MultiNet

    input_path, output_path, ncores = model_inputs

    print(f'Imputing {input_path} ...')

    # read count data
    count_data = pd.read_csv(input_path, index_col=0)

    # set cores to use
    NN_params = {'learning_rate': 1e-4, 'ncores': ncores, 'verbose': 0}
    model = MultiNet(**NN_params)

    # impute the data
    model.fit(count_data, cell_subset=1)
    imputed = model.predict(count_data)

    # save data as csv
    imputed.to_csv(output_path)
