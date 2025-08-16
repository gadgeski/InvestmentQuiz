import { z } from "zod";

export const QuizQuestion = z
  .object({
    id: z.string().uuid(),
    question: z.string(),
    choices: z.array(z.string()).min(2),
    correctIndex: z.number().int().nonnegative(),
    hint: z.string(),
    explanation: z.string(),
    difficulty: z.enum(["初級", "中級", "上級"]),
  })
  .refine((q) => q.correctIndex < q.choices.length, {
    message: "correctIndex が choices 配列の範囲外です",
  });

export const QuizPayload = z.object({
  version: z.number().int().positive(),
  questions: z.array(QuizQuestion).min(1),
});

export type QuizPayload = z.infer<typeof QuizPayload>;
