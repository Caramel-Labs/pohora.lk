import time
import joblib
import numpy as np
from fastapi import APIRouter, HTTPException
from recommendation.payloads import CropFeatures
from settings import CROP_MODEL, CROP_ENCODER_MODEL


# Setup chatbot router
router = APIRouter(
    prefix="/recommendation",
    tags=["Recommendation"],
)


# --------------------------------
#             ROUTES
# --------------------------------


# Test router health
@router.get("/ping")
def ping_recommendation_router():
    return {
        "message": "Pohora.LK Intelligence (Recommendation) router is up and running.",
    }


@router.post("/crop", tags=["Live"])
def get_crop_recommendation(features: CropFeatures):
    # Set start time (for measuring execution time)
    start_time = time.time()

    # Load pickled model and encoder
    try:
        model = joblib.load(CROP_MODEL)
        label_encoder = joblib.load(CROP_ENCODER_MODEL)
    except Exception as e:
        raise RuntimeError(f"Failed to load model files: {str(e)}")

    try:
        # Convert input to 2D array (required for sklearn)
        input_data = np.array(
            [
                [
                    features.N,
                    features.P,
                    features.K,
                    features.temperature,
                    features.humidity,
                    features.ph,
                    features.rainfall,
                ]
            ]
        )

        # Predict
        encoded_pred = model.predict(input_data)
        crop_name = label_encoder.inverse_transform(encoded_pred)[0]

        # Measure execution time
        execution_time = time.time() - start_time
        print(f"Execution time: {execution_time} seconds")

        return {"crop": crop_name}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction failed: {str(e)}")


# Make module safely exportable
if __name__ == "__main__":
    pass
