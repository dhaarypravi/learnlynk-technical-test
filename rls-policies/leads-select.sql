-- SELECT Policy: allow admin, owner, or team members
CREATE POLICY "allow_read_by_owner_or_team_or_admin"
ON leads
FOR SELECT
USING (
  auth.jwt()->>'role' = 'admin'
  OR owner_id = auth.uid()
  OR EXISTS (
    SELECT 1
    FROM user_teams ut
    WHERE ut.user_id = owner_id
      AND ut.team_id IN (
        SELECT team_id
        FROM user_teams
        WHERE user_id = auth.uid()
      )
  )
);
