-- INSERT Policy: allow only admins and counselors
CREATE POLICY "allow_insert_by_admin_or_counselor"
ON leads
FOR INSERT
WITH CHECK (
  auth.jwt()->>'role' = 'admin'
  OR auth.jwt()->>'role' = 'counselor'
);
