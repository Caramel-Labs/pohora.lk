from pydantic import BaseModel


class CropFeatures(BaseModel):
    N: float
    P: float
    K: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float


# Make module safely exportable
if __name__ == "__main__":
    pass
