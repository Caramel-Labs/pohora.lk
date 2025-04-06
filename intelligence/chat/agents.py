from settings import AGENT_VERBOSITY
from providers.chat_models import GroqChatModel
from chat.prompts import ToolCallingAgentPromptTemplate
from langchain.agents import AgentExecutor, create_tool_calling_agent

# from oracle.contextualizers import fetch_news_by_category, fetch_single_news_article


class ToolCallingAgentBuilder:
    def __new__(cls):
        # Initialize model to be used by agent
        model = GroqChatModel()

        # Build agent toolkit (contextualizers)
        toolkit = []

        # Define agent instruction prompt
        prompt = ToolCallingAgentPromptTemplate()

        # Create agent with tool-calling capabilities
        agent = create_tool_calling_agent(
            model,
            toolkit,
            prompt,
        )

        # Define agent executor runtime
        runnable_agent = AgentExecutor(
            agent=agent,
            tools=toolkit,
            verbose=AGENT_VERBOSITY,
        )

        return runnable_agent


# Make module safely exportable
if __name__ == "__main__":
    pass
