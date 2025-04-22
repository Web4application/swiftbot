const axios = require('axios');

module.exports = async function handleAnalyzeCommand(message) {
  const text = message.content.slice(9).trim();
  if (!text) {
    return message.channel.send('Please provide some text to analyze.');
  }

  try {
    const response = await axios.post('http://localhost:3000/api/analyze', { text });
    const result = response.data;
    message.channel.send(`Analysis result: ${result.analysis}`);
  } catch (error) {
    console.error('Error analyzing text:', error.message);
    message.channel.send('Sorry, I couldn\'t analyze the text at the moment.');
  }
};
const handleAnalyzeCommand = require('./bot/analyzeHandler');

if (message.content.startsWith('!analyze')) {
  await handleAnalyzeCommand(message);
}
