from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pickle
import numpy as np

# Load the model
with open("model.pkl", "rb") as f:
    model = pickle.load(f)

app = FastAPI()


# Define input format using Pydantic
class InputData(BaseModel):
    feature1: float
    feature2: float
    feature3: float
    # Add more features as per your model


@app.post("/predict")
def predict(data: InputData):
    try:
        input_array = np.array([[data.feature1, data.feature2, data.feature3]])
        prediction = model.predict(input_array)
        return {"prediction": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
