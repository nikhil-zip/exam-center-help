import csv,hashlib,sqlite3
from pathlib import Path
src=Path('data/legacy-centres.csv')
dst=Path('migrations/0002_import_legacy_centres.sql')
q=lambda x: "'"+str(x).replace("'","''")+"'"
with src.open(encoding='utf-8-sig',newline='') as f: rows=list(csv.DictReader(f))
out=['-- Snapshot of the public CSV used by the original centres.html integration.','-- Existing public entries are retained but deliberately marked unverified.']
seen=set()
for row in rows:
 name=row.get('College Name','').strip();city=row.get('City','').strip()
 if not name or not city: continue
 key=(name.casefold(),city.casefold())
 if key in seen: continue
 seen.add(key)
 uid=hashlib.sha1((name+'|'+city).encode('utf-8')).hexdigest()[:32]
 url=row.get('Google Map','').strip();near=row.get('Nearby Place','').strip() or None
 out.append('INSERT OR IGNORE INTO exam_centres(id,name,city,nearby_place,map_url,status,source,verified) VALUES('+','.join([q(uid),q(name),q(city),q(near) if near else 'NULL',q(url) if url else 'NULL',q('approved'),q('legacy_google_sheet'),'0'])+');')
dst.write_text('\n'.join(out)+'\n',encoding='utf-8')
print(f'Imported {len(seen)} records into {dst}')
