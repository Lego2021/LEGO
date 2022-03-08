 select pgp_sym_decrypt(dearmor('  ww0ECQMCsci6AdHnELlh0kQB4jFcVwHMJg0Bulop7m3Mi36s15TAhBo0AnzIrRFrdLVCkKohsS6+ DMcmR53SXfLoDJOv/M8uKj3QSq7oWNIp95pxfA== =tbSn '), 'key', 'expect-compress-algo=1');
  select pgp_sym_decrypt( pgp_sym_encrypt('Secret message', 'key', 'compress-algo=0'), 'key', 'expect-compress-algo=0');
  select pgp_sym_decrypt( pgp_sym_encrypt('Secret message', 'key', 'compress-algo=1'), 'key', 'expect-compress-algo=1');
  select pgp_sym_decrypt( pgp_sym_encrypt('Secret message', 'key', 'compress-algo=2'), 'key', 'expect-compress-algo=2');
  select pgp_sym_decrypt( pgp_sym_encrypt('Secret message', 'key', 'compress-algo=2, compress-level=0'), 'key', 'expect-compress-algo=0');
  SELECT setseed(0);
 WITH random_string AS ( SELECT string_agg(decode(lpad(to_hex((random()*256)::int), 2, '0'), 'hex'), '') as bytes FROM generate_series(0, 16365) ) SELECT bytes = pgp_sym_decrypt_bytea( pgp_sym_encrypt_bytea(bytes, 'key', 'compress-algo=1,compress-level=1'), 'key', 'expect-compress-algo=1') AS is_same FROM random_string;
 