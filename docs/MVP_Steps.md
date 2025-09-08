## MVP Step-by-Step (Learn-by-Build)

This plan helps you build the MVP incrementally and learn core concepts along the way.

### Phase 0 — Setup & Concepts (You learn: Supabase, schema design)
- Install Node.js (v18+), pnpm or npm
- Create Supabase project (dashboard) and get anon/service keys
- Create local `.env.local` for frontend keys (later)
- Apply database schema (see `supabase/schema.sql`)

### Phase 1 — Data Foundations (You learn: relational modeling, JSONB)
1) Create base tables: `profiles`, `learning_plans`, `learning_nodes`
2) Add JSONB fields for `position`, `resources`, `outputs`
3) Add essential indexes and FKs
4) Enable RLS and add minimal policies

### Phase 2 — Frontend Skeleton (You learn: Next.js, Supabase client)
1) Init Next.js + TypeScript app
2) Integrate Supabase client (auth + database)
3) Build pages: `/login`, `/dashboard`, `/plans/[id]`

### Phase 3 — Auth & Profile (You learn: auth flows, RLS testing)
1) Email/password login (Supabase Auth)
2) Create/read `profiles` row on first login with trigger or client logic
3) Ensure policies allow users to read/write only their own rows

### Phase 4 — Plans CRUD (You learn: CRUD patterns, optimistic UI)
1) Create a plan
2) List plans on dashboard
3) Edit plan title/description/goal
4) Soft delete or archive

### Phase 5 — Mind Map Basics (You learn: React Flow)
1) Render nodes for a plan using React Flow
2) Support add node, select node, edit node title
3) Persist `position` to DB

### Phase 6 — Progress & Outputs (You learn: state + schema evolution)
1) Add `status` per node: `not_started|in_progress|completed`
2) Add required `outputs` per node (JSONB array)
3) Mark node complete only when output submitted (MVP rule)

### Phase 7 — Resources (You learn: rich data via JSONB)
1) Add `resources` array to nodes
2) Validate link format on client
3) Quick-open resources from node panel

### Phase 8 — Sharing (You learn: security & read-only views)
1) Add `plan_shares` table with `public_read_token`
2) Public read-only view for a plan
3) Copy/fork plan into own account

### Phase 9 — Badges (You learn: triggers & computed state)
1) `badges` reference + `user_badges` mapping table
2) Award basic badge when plan completed (DB trigger)

### Phase 10 — AI Roadmap (You learn: edge functions)
1) Create Supabase Edge Function `generate_roadmap`
2) Call OpenAI to propose nodes
3) Insert nodes server-side securely

---

Checklist to keep learning:
- After each phase, write a short test note: what works, what to improve
- Add 2–3 assertions as a QA checklist (happy path + edge case)

