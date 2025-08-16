import express from "express";
import cors from "cors";
import { QuizPayload } from "./schema";
import data from "./data/questions.json";

const app = express();

// 必要に応じてCORSを許可（iOSアプリのURLSessionには不要ですが、ブラウザ検証用）
app.use(cors());

// 起動時にデータ検証（不正ならプロセスを落とす）
const payload = QuizPayload.parse(data);

// API: クイズ配信
app.get("/api/quiz/v1/questions", (_req, res) => {
  // キャッシュを抑止したい場合（任意）
  res.setHeader("Cache-Control", "no-store");
  res.json(payload);
});

// ヘルスチェック
app.get("/healthz", (_req, res) => res.json({ ok: true }));

const PORT = Number(process.env.PORT || 3000);
app.listen(PORT, () => {
  console.log(`Quiz API listening on http://127.0.0.1:${PORT}`);
});
