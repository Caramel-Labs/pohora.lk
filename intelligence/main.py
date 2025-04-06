import langchain
from fastapi import FastAPI
from chat.routes import router as chat_router
from recommendation.routes import router as recommendation_router
from fastapi.middleware.cors import CORSMiddleware

# Set LangChain runtime configurations
langchain.debug = True

# Instantiate FastAPI application
app = FastAPI(
    title="Pohora.LK Intelligence",
    description="The AI/ML service application of Pohora.LK",
)

# Bind routers to main application
app.include_router(chat_router)
app.include_router(recommendation_router)

# Define allowed origins for CORS
origins = [
    "*",
    "http://localhost",
    "http://localhost:3000",
    "http://localhost:3001",
    "http://localhost:4000",
]

# Setup CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Root route (to test service health)
@app.get("/", tags=["Internals"])
async def root():
    return {
        "message": "Pohora.LK Intelligence is up and running! Navigate to /docs to view the SwaggerUI.",
    }
