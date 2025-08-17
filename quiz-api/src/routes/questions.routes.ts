import { Router } from "express";
import { getQuestions } from "../controllers/questions.controller";

const router = Router();

// GET /api/quiz/v1/questions
router.get("/questions", getQuestions);

export default router;
