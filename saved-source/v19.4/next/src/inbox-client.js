import { apiRequest } from './api-client.js';

export async function getInbox() {
  return apiRequest('/inbox', { method: 'GET' });
}

export async function markInboxMessageRead(messageId) {
  return apiRequest(`/inbox/read/${encodeURIComponent(messageId)}`, { method: 'POST' });
}
