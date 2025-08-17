import { Router } from "express";
import questions from "./questions.routes";
import scores from "./scores.routes";

export const apiRouter = Router();

apiRouter.use(questions);
apiRouter.use(scores);
