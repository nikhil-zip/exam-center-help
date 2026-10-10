import { describe, expect, it } from 'vitest';
import { clean, coordinatesOk, distanceKm, emailOk, pageWindow } from '../functions/lib/validation';

describe('request validation helpers', () => {
  it('trims text and caps its length', () => {
    expect(clean('  Gorakhpur  ')).toBe('Gorakhpur');
    expect(clean('123456', 4)).toBe('1234');
    expect(clean(null)).toBe('');
  });
  it('accepts bounded email values', () => {
    expect(emailOk('student@example.in')).toBe(true);
    expect(emailOk('bad email')).toBe(false);
    expect(emailOk(`${'a'.repeat(250)}@x.in`)).toBe(false);
  });
  it('clamps page window inputs and defaults empty data requests', () => {
    expect(pageWindow('0', '200')).toEqual({ page: 1, limit: 50, offset: 0 });
    expect(pageWindow('3', '12')).toEqual({ page: 3, limit: 12, offset: 24 });
    expect(pageWindow('n/a', null)).toEqual({ page: 1, limit: 12, offset: 0 });
  });
  it('checks coordinate bounds and computes Haversine distance', () => {
    expect(coordinatesOk(91, 0)).toBe(false);
    expect(coordinatesOk(0, 181)).toBe(false);
    expect(coordinatesOk(0, 0)).toBe(true);
    expect(distanceKm(0, 0, 0, 1)).toBeCloseTo(111.2, 1);
  });
});
