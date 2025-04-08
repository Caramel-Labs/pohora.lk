import time
import joblib
import numpy as np
from fastapi import APIRouter, HTTPException
from recommendation.payloads import CropFeatures, FertilizerFeatures
from settings import (
    CROP_MODEL,
    CROP_ENCODER_MODEL,
    FERTILIZER_ENCODER_MODEL,
    FERTILIZER_MODEL,
)


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


@router.post("/fertilizer", tags=["Live"])
def get_fertilizer_recommendation(features: FertilizerFeatures):
    # Set start time (for measuring execution time)
    start_time = time.time()

    # Load pickled model and encoder
    try:
        model = joblib.load(FERTILIZER_MODEL)
        label_encoder = joblib.load(FERTILIZER_ENCODER_MODEL)
    except Exception as e:
        raise RuntimeError(f"Failed to load model files: {str(e)}")

    try:
        # Create base numerical features array
        numerical_features = np.array(
            [
                features.temperature,
                features.moisture,
                features.rainfall,
                features.ph,
                features.nitrogen,
                features.phosphorous,
                features.potassium,
                features.carbon,
            ]
        ).reshape(
            1, -1
        )  # Reshape to 2D array

        # One-hot encode soil type
        soil_categories = [
            "Acidic Soil",
            "Alkaline Soil",
            "Loamy Soil",
            "Neutral Soil",
            "Peaty Soil",
        ]
        soil_encoded = np.zeros(len(soil_categories))
        if features.soil in soil_categories:
            soil_index = soil_categories.index(features.soil)
            soil_encoded[soil_index] = 1

        # One-hot encode crop type
        crop_categories = [
            "Black gram",
            "Chickpea",
            "Coconut",
            "Coffee",
            "Cotton",
            "Jute",
            "Kidney Beans",
            "Lentil",
            "Moth Beans",
            "Mung Bean",
            "Pigeon Peas",
            "apple",
            "banana",
            "grapes",
            "maize",
            "mango",
            "muskmelon",
            "orange",
            "papaya",
            "pomegranate",
            "rice",
            "watermelon",
        ]
        crop_encoded = np.zeros(len(crop_categories))
        if features.crop in crop_categories:
            crop_index = crop_categories.index(features.crop)
            crop_encoded[crop_index] = 1

        # Combine all features
        input_data = np.hstack(
            [
                numerical_features,
                soil_encoded.reshape(1, -1),
                crop_encoded.reshape(1, -1),
            ]
        )

        # Predict
        encoded_pred = model.predict(input_data)
        fertilizer_name = label_encoder.inverse_transform(encoded_pred)[0]

        # Measure execution time
        execution_time = time.time() - start_time
        print(f"Execution time: {execution_time} seconds")

        return {"fertilizer": fertilizer_name}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction failed: {str(e)}")


# Make module safely exportable
if __name__ == "__main__":
    pass
