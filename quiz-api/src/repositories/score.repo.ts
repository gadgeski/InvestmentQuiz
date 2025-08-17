// とりあえずインメモリ（プロセス再起動で消えます）
// 将来はPrisma + PostgreSQL等に差し替え
type ScoreRow = {
  userId: string;
  score: number; // 0..15
  elapsed?: number; // 経過秒など
  version?: number;
  createdAt: number; // epoch ms
};

const rows: ScoreRow[] = [];

export const storeScore = (row: ScoreRow) => {
  rows.push(row);
};

const periodToSince = (period: "daily" | "weekly" | "all") => {
  const now = Date.now();
  if (period === "daily") return now - 24 * 60 * 60 * 1000;
  if (period === "weekly") return now - 7 * 24 * 60 * 60 * 1000;
  return 0; // all
};

export const getLeaderboardByPeriod = (period: "daily" | "weekly" | "all") => {
  const since = periodToSince(period);
  const recent = rows.filter((r) => r.createdAt >= since);

  // ユーザーごとにベストスコアを採用、同点は早い者勝ち
  const byUser = new Map<
    string,
    { userId: string; bestScore: number; attempts: number; bestAt: number }
  >();

  for (const r of recent) {
    const prev = byUser.get(r.userId);
    if (!prev) {
      byUser.set(r.userId, {
        userId: r.userId,
        bestScore: r.score,
        attempts: 1,
        bestAt: r.createdAt,
      });
    } else {
      const attempts = prev.attempts + 1;
      let bestScore = prev.bestScore;
      let bestAt = prev.bestAt;
      if (
        r.score > prev.bestScore ||
        (r.score === prev.bestScore && r.createdAt < prev.bestAt)
      ) {
        bestScore = r.score;
        bestAt = r.createdAt;
      }
      byUser.set(r.userId, { userId: r.userId, bestScore, attempts, bestAt });
    }
  }

  const list = Array.from(byUser.values())
    .sort((a, b) => b.bestScore - a.bestScore || a.bestAt - b.bestAt)
    .slice(0, 50); // 上位50件

  return list.map(({ userId, bestScore, attempts }) => ({
    userId,
    bestScore,
    attempts,
  }));
};
