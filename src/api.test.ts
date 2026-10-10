import { describe, expect, it } from 'vitest';
import { onRequest } from '../functions/api/[[path]]';

const fakeEnv = { DB: {} as never };
const context = (request: Request, path: string, db: unknown = fakeEnv.DB) => ({ request, env: { DB: db as never }, params: { path }, data: {} });

function emptyDatabase() {
  return { prepare: () => ({ bind() { return this; }, async all() { return { results: [] }; }, async first() { return { total: 0 }; }, async run() { return {}; } }) } as never;
}

describe('admin API access control', () => {
  it('rejects unauthenticated dashboard access', async () => {
    const response = await onRequest(context(new Request('https://example.test/api/admin/dashboard'), 'admin/dashboard'));
    expect(response.status).toBe(401);
    expect(await response.json()).toMatchObject({ ok: false, error: 'Sign in required.' });
  });
  it('rejects unauthenticated moderation changes', async () => {
    const response = await onRequest(context(new Request('https://example.test/api/admin/review/centres/123', { method: 'PATCH' }), 'admin/review/centres/123'));
    expect(response.status).toBe(401);
  });
});

describe('public API responses', () => {
  it('returns a useful health response without exposing bindings', async () => {
    const response = await onRequest(context(new Request('https://example.test/api/health'), 'health'));
    expect(response.status).toBe(200);
    expect(await response.json()).toMatchObject({ ok: true, service: 'exam-centre-help-api' });
  });
  it('returns an empty paginated listing cleanly', async () => {
    const ctx = context(new Request('https://example.test/api/centres?page=999999&limit=500'), 'centres', emptyDatabase());
    const response = await onRequest(ctx);
    expect(response.status).toBe(200);
    expect(await response.json()).toMatchObject({ ok: true, data: [], total: 0, page: 10000, limit: 50 });
  });
  it('rejects incomplete public inquiries with a JSON validation error', async () => {
    const response = await onRequest(context(new Request('https://example.test/api/inquiries', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ name: 'Student', email: 'student@example.in' }) }), 'inquiries'));
    expect(response.status).toBe(400);
    expect(await response.json()).toMatchObject({ ok: false });
  });
  it('returns a safe error when the database fails', async () => {
    const ctx = context(new Request('https://example.test/api/centres'), 'centres', { prepare: () => { throw new Error('private database stack detail'); } });
    const response = await onRequest(ctx);
    expect(response.status).toBe(500);
    expect(await response.text()).not.toContain('private database stack detail');
  });
});
