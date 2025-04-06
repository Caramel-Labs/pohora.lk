"""Contains models and model connection managers to use in workflows."""

import os
from dotenv import load_dotenv
from langchain_cohere.llms import Cohere


class CohereCommandModel:
    """Generate a single instance of Cohere's `Command` model."""

    def __new__(cls, temperature=0.5, max_tokens=800, k=0, p=1):
        """Create and return a single instance of Cohere's `Command` model.

        Args:
            temperature (float, optional): The temperature (creativity) of the model. Defaults to 0.5.
            max_tokens (int, optional): The maximum number of tokens to generate. Defaults to 800.
            k (int, optional): The top-k value of the model. Defaults to 0.
            p (int, optional): The top-p value of the model. Defaults to 1.

        Returns:
            Cohere: instance of Cohere's `Command` model
        """
        # Load model API key
        load_dotenv()
        os.environ["COHERE_API_KEY"] = os.getenv("COHERE_API_KEY")

        # Instantiate and return model from `langchain_cohere.llms.Cohere`
        model_instance = Cohere(
            temperature=temperature,
            max_tokens=max_tokens,
            k=k,
            p=p,
        )

        return model_instance


class CohereCommandModelConnection:
    """Generate a connection to access Cohere's `Command` model."""

    def __init__(self, temperature=0.5, max_tokens=800, k=0, p=1):
        """Constructor to initialize connection to Cohere's `Command` model.

        Args:
            temperature (float, optional): The temperature (creativity) of the model. Defaults to 0.5.
            max_tokens (int, optional): The maximum number of tokens to generate. Defaults to 800.
            k (int, optional): The top-k value of the model. Defaults to 0.
            p (int, optional): The top-p value of the model. Defaults to 1.
        """

        # Load model API key
        load_dotenv()
        os.environ["COHERE_API_KEY"] = os.getenv("COHERE_API_KEY")

        # Initialize model configurations from input parameters
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.k = k
        self.p = p

        # Instantiate model from `langchain_cohere.llms.Cohere`
        self._model = Cohere(
            temperature=self.temperature,
            max_tokens=self.max_tokens,
            k=self.k,
            p=self.p,
        )

    @property
    def model(self):
        """Return an instance of the model.

        Returns:
            Cohere: instance of Cohere's `Command` model
        """

        return self._model


# Make module exportable
if __name__ == "__main__":
    pass
