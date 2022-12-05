# choose existing image or build your own
FROM python:3.9.1-slim-buster

# install deepimpute package
RUN pip install --upgrade pip
RUN pip install deepimpute pandas

# copy model script to container
COPY imputation_model.py /imputation_model.py
COPY run_model.py /run_model.py

# execute the model with '/input' as input dir and 'output' as output dir
ENTRYPOINT ["python", "/run_model.py", "-i", "/input", "-o", "/output"]
