from fastapi import FastAPI


app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello, World!"}


@app.get("/healthz")
def healthz():
    return {"message": "healthy from provider."}
