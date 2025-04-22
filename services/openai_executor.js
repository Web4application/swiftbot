import { createOpenAIExecutorHandler, Model } from "GoogleGenerativeAI";

module.exports = createOpenAIExecutorHandler(Model.gemini_1_5_flash);
