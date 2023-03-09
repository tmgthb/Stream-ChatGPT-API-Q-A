import openai
import os
import streamlit as st
openai.api_key = st.secrets["SECRET_KEY"]
st.title('Stream ChatGPT Answers')
prompt = st.text_input(label="Ask your question: ")


collected_events = []
collected_messages = []
speed = 0.2 #smaller is faster
max_response_length = 200
start_time = time.time()

# Generate Answer
response = openai.ChatCompletion.create(
    model='gpt-3.5-turbo',
    messages=[
        {'role': 'user', 'content': f'{prompt}'}
    ],
    max_tokens=max_response_length,
    temperature=0,
    stream=True,  # this time, we set stream=True
)

# Stream Answer
for event in response:
    event_time = time.time() - start_time  # calculate the time delay of the event
    collected_events.append(event)  # save the event response
    event_text = event['choices'][0]['delta']  # extract the text     
    collected_messages.append(event_text)  # append the text
    full_reply_content = ''.join([m.get('content', '') for m in collected_messages])
    st.text(f'{full_reply_content}', flush=True)
    time.sleep(speed)
