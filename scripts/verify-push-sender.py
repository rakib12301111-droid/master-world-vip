from pathlib import Path
p=Path("supabase/functions/send-push/index.ts").read_text()
assert '"Access-Control-Allow-Origin": "https://rakib12301111-droid.github.io"' in p
assert '"Access-Control-Allow-Origin": "*"' not in p
assert 'req.headers.get("x-push-webhook-secret") !== expectedSecret' in p
assert 'Push sender secrets are not configured' in p
assert '.eq("id", record.id)' in p and '.eq("user_id", record.user_id)' in p
assert 'statusCode === 404 || statusCode === 410' in p
print("PASS — push sender restricted to production app origin")
print("PASS — webhook secret remains mandatory")
print("PASS — notification is verified against user and notification ID")
print("PASS — expired subscriptions are removed")
