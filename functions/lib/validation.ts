export function clean(value: unknown, max = 200): string {
  return typeof value === 'string' ? value.trim().slice(0, max) : '';
}

export function emailOk(value: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value) && value.length <= 254;
}

export function pageWindow(pageValue: unknown, limitValue: unknown) {
  const page = Math.max(1, Math.min(10_000, Number(pageValue) || 1));
  const limit = Math.max(1, Math.min(50, Number(limitValue) || 12));
  return { page, limit, offset: (page - 1) * limit };
}

export function distanceKm(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const rad = Math.PI / 180;
  const a = Math.sin((lat2-lat1)*rad/2)**2 + Math.cos(lat1*rad)*Math.cos(lat2*rad)*Math.sin((lon2-lon1)*rad/2)**2;
  return Math.round(6371 * 2 * Math.asin(Math.sqrt(a)) * 10) / 10;
}

export function coordinatesOk(lat: unknown, lon: unknown): boolean {
  return typeof lat === 'number' && typeof lon === 'number' && Number.isFinite(lat) && Number.isFinite(lon) && Math.abs(lat) <= 90 && Math.abs(lon) <= 180;
}
