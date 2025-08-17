import { storeScore, getLeaderboardByPeriod } from "../repositories/score.repo";
import type { ScoreBodyType, Period } from "../validators/score.schema";

export const addScore = (body: ScoreBodyType) => {
  storeScore({
    userId: body.userId,
    score: body.score,
    elapsed: body.elapsed,
    version: body.version,
    createdAt: Date.now(),
  });
};

export const getTopLeaderboard = (period: Period) => {
  return getLeaderboardByPeriod(period);
};
