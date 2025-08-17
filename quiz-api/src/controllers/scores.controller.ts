import { Request, Response, NextFunction } from "express";
import { ScoreBody, PeriodQuery } from "../validators/score.schema";
import { addScore, getTopLeaderboard } from "../services/scores.service";

export const postScore = (req: Request, res: Response, next: NextFunction) => {
  try {
    const body = ScoreBody.parse(req.body);
    addScore(body);
    res.status(201).json({ ok: true });
  } catch (err) {
    next(err);
  }
};

export const getLeaderboard = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { period } = PeriodQuery.parse(req.query);
    const list = getTopLeaderboard(period);
    res.json({ period, top: list });
  } catch (err) {
    next(err);
  }
};
