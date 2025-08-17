import data from "../data/questions.json";
import { QuizPayload } from "../validators/quiz.schema";

// 起動時に検証（不正なら例外）
const payload = QuizPayload.parse(data);

export const getQuestionsFromRepo = () => payload;
