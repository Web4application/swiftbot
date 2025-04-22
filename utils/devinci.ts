import openai

# Set up your OpenAI API key
openai.api_key = 'AIzaSyAvrxOyAVzPVcnzxuD0mjKVDyS2bNWfC10'
# Define a function to generate text using GPT-4
def generate_text(prompt):
response = openai.Completion.create(
engine="text-davinci-004",
prompt=prompt,
max_tokens=150
)
return response.choices[0].text.strip()

prompt = "Explain the theory of relativity in simple terms."
print(generate_text(prompt))
