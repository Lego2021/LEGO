SET bytea_output TO escape;
   SELECT encode(encrypt( decode('01 23 45 67 89 AB CD EF', 'hex'), decode('01 23 45 67 12 34 56 78 23 45 67 89 34 56 78 9A', 'hex'), 'cast5-ecb/pad:none'), 'hex');
  SELECT encode(encrypt( decode('01 23 45 67 89 AB CD EF', 'hex'), decode('01 23 45 67 12 34 56 78 23 45', 'hex'), 'cast5-ecb/pad:none'), 'hex');
  SELECT encode(encrypt( decode('01 23 45 67 89 AB CD EF', 'hex'), decode('01 23 45 67 12', 'hex'), 'cast5-ecb/pad:none'), 'hex');
   select encode(    encrypt('', 'foo', 'cast5'), 'hex');
 select encode(    encrypt('foo', '0123456789', 'cast5'), 'hex');
  select decrypt(encrypt('foo', '0123456', 'cast5'), '0123456', 'cast5');
  select encode(encrypt_iv('foo', '0123456', 'abcd', 'cast5'), 'hex');
 select decrypt_iv(decode('384a970695ce016a', 'hex'), '0123456', 'abcd', 'cast5');
  select encode(encrypt('Lets try a longer message.', '0123456789', 'cast5'), 'hex');
 select decrypt(encrypt('Lets try a longer message.', '0123456789', 'cast5'), '0123456789', 'cast5');
 