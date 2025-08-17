import { z } from "zod";

export const ScoreBody = z.object({
  userId: z.string().min(1), // 将来はUUIDやAppleのsub等に
  score: z.number().int().min(0).max(15),
  elapsed: z.number().int().positive().optional(), // 秒など
  version: z.number().int().positive().optional(), // 問題データのversion
});

export type ScoreBodyType = z.infer<typeof ScoreBody>;

export const PeriodQuery = z.object({
  period: z.enum(["daily", "weekly", "all"]).default("daily"),
});

export type Period = "daily" | "weekly" | "all";
