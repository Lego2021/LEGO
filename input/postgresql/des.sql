SET bytea_output TO escape;
   SELECT encode(encrypt( decode('0123456789abcdef', 'hex'), decode('fedcba9876543210', 'hex'), 'des-ecb/pad:none'), 'hex');
  select encode(    encrypt('', 'foo', 'des'), 'hex');
 select encode(    encrypt('foo', '01234589', 'des'), 'hex');
  select decrypt(encrypt('foo', '0123456', 'des'), '0123456', 'des');
  select encode(encrypt_iv('foo', '0123456', 'abcd', 'des'), 'hex');
 select decrypt_iv(decode('50735067b073bb93', 'hex'), '0123456', 'abcd', 'des');
  select encode(encrypt('Lets try a longer message.', '01234567', 'des'), 'hex');
 select decrypt(encrypt('Lets try a longer message.', '01234567', 'des'), '01234567', 'des');
 