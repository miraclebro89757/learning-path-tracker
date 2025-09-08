## Learning Path Tracker (MVP)

Build a learn-by-doing app to create AI-guided learning roadmaps with an interactive mind map.

### Tech
- Frontend: Next.js + TypeScript
- Backend: Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- Visualization: React Flow

### Getting Started
1) Create a Supabase project in the dashboard
2) Open Supabase SQL editor and run: `supabase/schema.sql`
3) Init frontend (suggested): Next.js App Router + Tailwind

### Commands (suggested)
```bash
# Create Next.js app (App Router, TS)
npm create next-app@latest learning-path-tracker -- --typescript --eslint --tailwind --no-src-dir --app

cd learning-path-tracker
npm install @supabase/supabase-js @xyflow/react zod

# Create .env.local
echo "NEXT_PUBLIC_SUPABASE_URL=..." >> .env.local
echo "NEXT_PUBLIC_SUPABASE_ANON_KEY=..." >> .env.local
```

See `docs/MVP_Steps.md` to proceed phase by phase.

