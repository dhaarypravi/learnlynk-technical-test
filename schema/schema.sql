-- LEADS TABLE
CREATE TABLE IF NOT EXISTS leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  owner_id uuid NOT NULL,
  name text,
  stage text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- APPLICATIONS TABLE
CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  lead_id uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  program text,
  status text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- TASKS TABLE
CREATE TABLE IF NOT EXISTS tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  application_id uuid NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  title text,
  type text NOT NULL,
  due_at timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT tasks_due_after_created CHECK (due_at >= created_at),
  CONSTRAINT tasks_valid_type CHECK (type IN ('call', 'email', 'review'))
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_leads_owner ON leads(owner_id);
CREATE INDEX IF NOT EXISTS idx_leads_stage ON leads(stage);
CREATE INDEX IF NOT EXISTS idx_leads_created ON leads(created_at);

CREATE INDEX IF NOT EXISTS idx_applications_lead ON applications(lead_id);

CREATE INDEX IF NOT EXISTS idx_tasks_due_at ON tasks(due_at);
CREATE INDEX IF NOT EXISTS idx_tasks_application ON tasks(application_id);
CREATE INDEX IF NOT EXISTS idx_tasks_tenant_due_at ON tasks(tenant_id, due_at);
