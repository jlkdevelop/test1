import { neon } from "@neondatabase/serverless";
import type { VercelRequest, VercelResponse } from "@vercel/node";

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  if (req.method === "OPTIONS") { res.status(200).end(); return; }

  const sql = neon(process.env.DATABASE_URL!);

  if (req.method === "GET") {
    const rows = await sql`
      SELECT t.id, t.title, t.status, t.created_at, u.name AS owner
      FROM tasks t JOIN users u ON u.id = t.user_id
      ORDER BY t.created_at DESC`;
    res.status(200).json(rows);
    return;
  }

  if (req.method === "POST") {
    const { title, user_id = 1 } = req.body ?? {};
    if (!title) { res.status(400).json({ error: "title is required" }); return; }
    const [row] = await sql`
      INSERT INTO tasks (user_id, title) VALUES (${user_id}, ${title})
      RETURNING id, title, status, created_at`;
    res.status(201).json(row);
    return;
  }

  res.status(405).json({ error: "Method not allowed" });
}
