import express from "express";
import cors from "cors";
import { apiRouter } from "./routes";
import { errorHandler } from "./middlewares/errorHandler";

export const createApp = () => {
  const app = express();

  // Middlewares
  app.use(cors()); // iOSからは不要だがブラウザ検証用にON
  app.use(express.json()); // JSONボディを扱う

  // Health check
  app.get("/healthz", (_req, res) => res.json({ ok: true }));

  // API v1
  app.use("/api/quiz/v1", apiRouter);

  // 統一エラーハンドラ（最後）
  app.use(errorHandler);

  return app;
};
