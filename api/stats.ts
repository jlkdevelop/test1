import { neon } from "@neondatabase/serverless";
import type { VercelRequest, VercelResponse } from "@vercel/node";

export default async function handler(_req: VercelRequest, res: VercelResponse) {
  const sql = neon(process.env.DATABASE_URL!);
  const [row] = await sql`
    SELECT count(*)::int AS total,
           count(*) FILTER (WHERE status = 'done')::int AS done
    FROM tasks`;
  res.status(200).json(row);
}
