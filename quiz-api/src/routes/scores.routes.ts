import { Router } from "express";
import { postScore, getLeaderboard } from "../controllers/scores.controller";

const router = Router();

// POST /api/quiz/v1/scores
router.post("/scores", postScore);

// GET /api/quiz/v1/leaderboard?period=daily|weekly|all
router.get("/leaderboard", getLeaderboard);

export default router;
