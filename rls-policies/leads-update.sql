-- UPDATE Policy: allow admin or owner or counselor
CREATE POLICY "allow_update_by_owner_or_admin_or_counselor"
ON leads
FOR UPDATE
USING (
  auth.jwt()->>'role' = 'admin'
  OR owner_id = auth.uid()
  OR auth.jwt()->>'role' = 'counselor'
)
WITH CHECK (
  auth.jwt()->>'role' = 'admin'
  OR owner_id = auth.uid()
  OR auth.jwt()->>'role' = 'counselor'
);
