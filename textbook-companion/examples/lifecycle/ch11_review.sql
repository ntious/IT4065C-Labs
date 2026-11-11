-- Listing 11.3: privilege inventory from the system catalog (readable without data access)
SELECT c.relnamespace::regnamespace AS schema, c.relname AS object,
       a.grantee::regrole AS grantee, a.privilege_type
FROM pg_class c, LATERAL aclexplode(c.relacl) a
WHERE c.relnamespace IN ('reporting'::regnamespace, 'raw'::regnamespace)
  AND a.grantee <> c.relowner
ORDER BY 1, 2, 3;
