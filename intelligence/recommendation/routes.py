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
    start_time = time.time()

    try:
        model = joblib.load(CROP_MODEL)
        label_encoder = joblib.load(CROP_ENCODER_MODEL)
    except Exception as e:
        raise RuntimeError(f"Failed to load model files: {str(e)}")

    try:
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

        # Get both prediction and probabilities
        if hasattr(model, "predict_proba"):
            probabilities = model.predict_proba(input_data)[0]
            encoded_pred = model.predict(input_data)
            crop_name = label_encoder.inverse_transform(encoded_pred)[0]

            # Get top 3 confident predictions
            top_n = 3
            top_indices = probabilities.argsort()[-top_n:][::-1]
            top_crops = label_encoder.inverse_transform(top_indices)
            top_confidences = probabilities[top_indices].tolist()

            confidences = {
                "top_choices": [
                    {"crop": crop, "confidence": float(conf)}
                    for crop, conf in zip(top_crops, top_confidences)
                ],
                "predicted_confidence": float(probabilities[encoded_pred][0]),
            }
        else:
            # Fallback for models without predict_proba
            encoded_pred = model.predict(input_data)
            crop_name = label_encoder.inverse_transform(encoded_pred)[0]
            confidences = {"warning": "Model doesn't support confidence scores"}

        execution_time = time.time() - start_time
        print(f"Execution time: {execution_time} seconds")

        return {
            "crop": crop_name,
            "confidence": confidences,
            "execution_time": execution_time,
        }

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
        raise HTTPException(status_code=500, detail=f"Model loading failed: {str(e)}")

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
        ).reshape(1, -1)

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
        else:
            raise ValueError(f"Invalid soil type: {features.soil}")

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
        else:
            raise ValueError(f"Invalid crop type: {features.crop}")

        # Combine all features
        input_data = np.hstack(
            [
                numerical_features,
                soil_encoded.reshape(1, -1),
                crop_encoded.reshape(1, -1),
            ]
        )

        # Prediction with confidence scores
        if hasattr(model, "predict_proba"):
            probabilities = model.predict_proba(input_data)[0]
            encoded_pred = model.predict(input_data)
            fertilizer_name = label_encoder.inverse_transform(encoded_pred)[0]

            # Get top recommendations
            top_n = 3
            top_indices = probabilities.argsort()[-top_n:][::-1]
            top_fertilizers = label_encoder.inverse_transform(top_indices)
            top_confidences = probabilities[top_indices].tolist()

            confidence_data = {
                "top_choices": [
                    {"fertilizer": fert, "confidence": float(conf)}
                    for fert, conf in zip(top_fertilizers, top_confidences)
                ],
                "predicted_confidence": float(probabilities[encoded_pred][0]),
            }
        else:
            encoded_pred = model.predict(input_data)
            fertilizer_name = label_encoder.inverse_transform(encoded_pred)[0]
            confidence_data = {
                "warning": "This model doesn't support confidence scores"
            }

        execution_time = time.time() - start_time

        return {
            "fertilizer": fertilizer_name,
            "confidence": confidence_data,
            "execution_time": execution_time,
            # "input_features": {  # For debugging/transparency
            #     "numerical": numerical_features.tolist()[0],
            #     "soil_type": features.soil,
            #     "crop_type": features.crop,
            # },
        }

    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Invalid input: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")


# Make module safely exportable
if __name__ == "__main__":
    pass
