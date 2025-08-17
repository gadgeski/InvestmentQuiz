import { NextFunction, Request, Response } from "express";
import { ZodError } from "zod";

export const errorHandler = (
  err: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  if (err instanceof ZodError) {
    return res
      .status(400)
      .json({ error: "validation_error", details: err.flatten() });
  }
  console.error(err);
  res.status(500).json({ error: "internal_error" });
};
