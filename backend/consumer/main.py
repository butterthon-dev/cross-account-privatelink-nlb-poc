import os

import requests
from fastapi import FastAPI


app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello, World!"}


@app.get("/healthz")
def healthz():
    return {"message": "healthy from consumer."}


@app.get("/provider/healthz")
def provider_healthz():
    response = requests.get(f"{os.environ["PROVIDER_API_URL"].rstrip("/")}/healthz")
    return response.json()
