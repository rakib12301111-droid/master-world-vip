import { Router } from 'express';

const router = Router();

// DEMO ONLY: in-memory notification inbox.
// Not a persistent direct-message/chat backend. Replace with database storage
// and participant-scoped authorization before any production mounting.
const inbox = new Map();

router.get('/', (req, res) => {
  const userId = String(req.user?.id || '');
  if (!userId) return res.status(401).json({ error: 'Authentication required' });
  res.json({ messages: inbox.get(userId) || [] });
});

router.post('/read/:messageId', (req, res) => {
  const userId = String(req.user?.id || '');
  const items = inbox.get(userId) || [];
  const item = items.find((message) => message.id === req.params.messageId);
  if (!item) return res.status(404).json({ error: 'Message not found' });
  item.readAt = new Date().toISOString();
  res.json({ updated: true });
});

export function addInboxMessage(userId, { id, title, body }) {
  const key = String(userId);
  const items = inbox.get(key) || [];
  items.unshift({
    id: String(id),
    title: String(title).slice(0, 100),
    body: String(body).slice(0, 1000),
    createdAt: new Date().toISOString(),
    readAt: null
  });
  inbox.set(key, items.slice(0, 100));
}

export default router;
