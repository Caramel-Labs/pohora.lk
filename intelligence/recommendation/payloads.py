from pydantic import BaseModel


class CropFeatures(BaseModel):
    N: float
    P: float
    K: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float


class FertilizerFeatures(BaseModel):
    temperature: float
    moisture: float
    rainfall: float
    ph: float
    nitrogen: float
    phosphorous: float
    potassium: float
    carbon: float
    soil: str
    crop: str


# Make module safely exportable
if __name__ == "__main__":
    pass
