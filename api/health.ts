import { neon } from "@neondatabase/serverless";
import type { VercelRequest, VercelResponse } from "@vercel/node";

export default async function handler(_req: VercelRequest, res: VercelResponse) {
  const sql = neon(process.env.DATABASE_URL!);
  const [row] = await sql`SELECT NOW() as now`;
  res.status(200).json({ ok: true, db: "neon/test1", now: row.now });
}
