import { getQuestionsFromRepo } from "../repositories/question.repo";
import type { QuizPayload } from "../validators/quiz.schema";

let cache: QuizPayload | null = null;

export const getQuizPayload = (): QuizPayload => {
  if (!cache) cache = getQuestionsFromRepo(); // 起動後初回のみ読み込み
  return cache;
};
