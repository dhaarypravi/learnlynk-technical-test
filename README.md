This repository contains the full implementation of the LearnLynk technical test, including:

✅ Supabase schema

✅ RLS policies for leads

✅ Edge Function (swift-worker)

✅ Next.js dashboard page showing "Tasks Due Today"

✅ Stripe Checkout implementation explanation
```
📂 Project Structure
learnlynk-technical-test/
│
├── schema/
│   └── schema.sql
│
├── rls-policies/
│   ├── leads-select.sql
│   ├── leads-insert.sql
│   ├── leads-update.sql
│   └── leads-delete.sql
│
├── edge-functions/
│   └── swift-worker/
│       └── index.ts
│
└── nextjs-app/
    ├── lib/
    │   └── supabaseClient.js
    └── app/
        ├── QueryProvider.jsx
        └── dashboard/
            └── today/
                └── page.jsx
```
🗄️ ##Section 1 — Supabase Schema

All tables required by the test:

leads

applications

tasks

Includes:

indexes

foreign keys

constraints

task type validation

due date validation

👉 Full file: /schema/schema.sql

🔐## Section 2 — RLS Policies

Policies included:

SELECT policy: admin, owner, or team members

INSERT policy: admin or counselor

UPDATE policy: admin, owner, or counselor

DELETE policy: admin, owner, or counselor

👉 Files in: /rls-policies/

⚡ Section 3 — Supabase Edge Function

Function name: swift-worker

Features:

Validates request body

Accepts application_id, task_type, due_at

Checks task_type must be call/email/review

Ensures due_at is a future date

Inserts into tasks table

Emits realtime event

Returns JSON response

👉 Full implementation: edge-functions/swift-worker/index.ts

💻## Section 4 — Next.js Dashboard Page

Route:

/dashboard/today


Features:

Fetches tasks due today

Displays task table

“Mark Complete” button

Uses React Query for caching

Updates tasks in Supabase

👉 Code: nextjs-app/app/dashboard/today/page.jsx

💳
🚀 How to Run the Project
1. Clone repository
git clone https://github.com/dhaarypravi/learnlynk-technical-test

2. Run Next.js frontend
 ```
cd nextjs-app
npm install
npm run dev
```
4. Configure .env.local

Add:
```
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```
4. Edge Function environment variables

Inside Supabase:
```
PROJECT_URL
SERVICE_ROLE_KEY
```
✨## Submission Complete

This repository includes all components required by the technical test, organized cleanly and ready for review.
