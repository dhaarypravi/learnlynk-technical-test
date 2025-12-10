-- DELETE Policy: allow admin, owner, or counselor
CREATE POLICY "allow_delete_by_owner_or_admin_or_counselor"
ON leads
FOR DELETE
USING (
  auth.jwt()->>'role' = 'admin'
  OR owner_id = auth.uid()
  OR auth.jwt()->>'role' = 'counselor'
);
