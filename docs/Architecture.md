## Architecture (MVP)

### High-Level
- Frontend: Next.js + TypeScript
- Backend: Supabase (PostgreSQL, Auth, Storage, Edge Functions)
- Visualization: React Flow for mind maps
- AI: QianWen via Supabase Edge Functions

### Data Model (v0)
- `profiles` (1 row per auth user)
- `learning_plans` (belongs to user)
- `learning_nodes` (belongs to plan)
- `plan_shares` (public token for read-only share)
- `badges`, `user_badges` (award on completion)

### Security
- RLS enabled on all tables
- Policies: user can access only own rows; public read via token view for shared plans

### Frontend Pages
- `/login` — auth
- `/dashboard` — list plans
- `/plans/[id]` — mind map editor
- `/p/[token]` — public read-only viewer

### Key Libraries
- `@supabase/supabase-js`
- `react-flow-renderer`
- `zod` for input validation

### Observability
- Console + Supabase logs for MVP
- Add client error boundary + simple toast logger

