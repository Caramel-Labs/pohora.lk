"""Contains chat models and chat model connection managers to use in workflows."""

import os
from dotenv import load_dotenv
from langchain_groq import ChatGroq

MODEL_NAME = "llama-3.3-70b-specdec"
# NOTE
# "mixtral-8x7b-32768" was used previously.
# This model is unable to invoke tools when the conversation has multiple messages.


class GroqChatModel:
    """Generate a single instance of Groq's chat model."""

    def __new__(cls, temperature=0.5, model=MODEL_NAME):
        """Create and return a single instance of Groq's chat model.

        Args:
            temperature (float, optional): The temperature (creativity) of the model. Defaults to 0.5.
            model (str, optional): The foundational model to be selected. Defaults to 'mixtral-8x7b-32768'.

        Returns:
            ChatGroq: instance of Groq's chat model
        """

        # Load model API key
        load_dotenv()
        os.environ["GROQ_API_KEY"] = os.getenv("GROQ_API_KEY")

        # Instantiate and return model from `langchain_groq.ChatGroq`
        model_instance = ChatGroq(
            temperature=temperature,
            model=model,
        )

        return model_instance


class GroqChatModelConnection:
    """Generate a connection to access Groq's chat model."""

    def __init__(self, temperature=0.5, model=MODEL_NAME):
        """Constructor to initialize connection to Groq's chat model.

        Args:
            temperature (float, optional): The temperature (creativity) of the model. Defaults to 0.5.
            model (str, optional): The foundational model to be selected. Defaults to 'mixtral-8x7b-32768'.
        """

        # Load model API key
        load_dotenv()
        os.environ["GROQ_API_KEY"] = os.getenv("GROQ_API_KEY")

        # Initialize model configurations from input parameters
        self.temperature = temperature
        self.model = model

        # Instantiate model from `langchain_groq.ChatGroq`
        self._model = ChatGroq(
            temperature=self.temperature,
            model=self.model,
        )

    @property
    def model(self):
        """Return an instance of the model.

        Returns:
            ChatGroq: instance of Groq's chat model
        """

        return self._model


# Make module exportable
if __name__ == "__main__":
    pass
