SET bytea_output TO escape;
  SELECT encode(encrypt( decode('80 00 00 00 00 00 00 00', 'hex'), decode('01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01', 'hex'), '3des-ecb/pad:none'), 'hex');
  select encode(    encrypt('', 'foo', '3des'), 'hex');
 select encode(    encrypt('foo', '0123456789', '3des'), 'hex');
 select encode(    encrypt('foo', '0123456789012345678901', '3des'), 'hex');
  select decrypt(encrypt('foo', '0123456', '3des'), '0123456', '3des');
  select encode(encrypt_iv('foo', '0123456', 'abcd', '3des'), 'hex');
 select decrypt_iv(decode('50735067b073bb93', 'hex'), '0123456', 'abcd', '3des');
  select encode(encrypt('Lets try a longer message.', '0123456789012345678901', '3des'), 'hex');
 select decrypt(encrypt('Lets try a longer message.', '0123456789012345678901', '3des'), '0123456789012345678901', '3des');
 