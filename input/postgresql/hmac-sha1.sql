 SELECT encode(hmac( 'Hi There', decode('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b', 'hex'), 'sha1'), 'hex');
  SELECT encode(hmac( 'Jefe', 'what do ya want for nothing?', 'sha1'), 'hex');
  SELECT encode(hmac( decode('dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd', 'hex'), decode('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'hex'), 'sha1'), 'hex');
  SELECT encode(hmac( decode('cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd', 'hex'), decode('0102030405060708090a0b0c0d0e0f10111213141516171819', 'hex'), 'sha1'), 'hex');
  SELECT encode(hmac( 'Test With Truncation', decode('0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c', 'hex'), 'sha1'), 'hex');
  SELECT encode(hmac( 'Test Using Larger Than Block-Size Key - Hash Key First', decode('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'hex'), 'sha1'), 'hex');
  SELECT encode(hmac( 'Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data', decode('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'hex'), 'sha1'), 'hex');
 