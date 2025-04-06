import time
from fastapi import APIRouter
from chat.agents import ToolCallingAgentBuilder
from langchain_core.messages import AIMessage, HumanMessage
from chat.payloads import ConversationPayload, MessageAuthor


# Setup chatbot router
router = APIRouter(
    prefix="/chat",
    tags=["Chat"],
)


# --------------------------------
#             ROUTES
# --------------------------------


# Test router health
@router.get("/ping")
def ping_chat_router():
    return {
        "message": "Pohora.LK Intelligence (Chat) is up and running.",
    }


# Get agent response
@router.post("/get-agent-response/", tags=["Live"])
def get_agent_response(chat: ConversationPayload):
    # Set start time (for measuring execution time)
    start_time = time.time()

    # Instatiate empty list to store chat history
    # in a format the agent can understand
    chat_history = []

    # Iterate through messages in chat (except last message)
    for message in chat.messages[:-1]:
        # Format message using relevant Message classes from LangChain
        if message.sender == MessageAuthor.HUMAN:
            formatted_msg = HumanMessage(content=message.content)
        elif message.sender == MessageAuthor.AI:
            formatted_msg = AIMessage(content=message.content)
        # Add formatted message to chat history
        chat_history.append(formatted_msg)

    print(chat_history)

    # Setup agent
    agent = ToolCallingAgentBuilder()

    # Invoke agent with last message in the chat (the user's latest input)
    # and the formatted chat history
    response = agent.invoke(
        {
            "input": chat.messages[-1].content,
            "chat_history": chat_history,
        }
    )

    # Measure execution time
    execution_time = time.time() - start_time
    print(f"Execution time: {execution_time} seconds")

    return {
        "data": response,
        "time": round(execution_time),
    }


# Make module safely exportable
if __name__ == "__main__":
    pass
