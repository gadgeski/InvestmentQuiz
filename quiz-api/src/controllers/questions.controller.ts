import { Request, Response, NextFunction } from "express";
import { getQuizPayload } from "../services/questions.service";

export const getQuestions = (
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const payload = getQuizPayload();
    res.setHeader("Cache-Control", "no-store");
    res.json(payload);
  } catch (err) {
    next(err);
  }
};
