 SELECT encode(hmac( 'Hi There', decode('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b', 'hex'), 'md5'), 'hex');
  SELECT encode(hmac( 'Jefe', 'what do ya want for nothing?', 'md5'), 'hex');
  SELECT encode(hmac( decode('dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd', 'hex'), decode('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'hex'), 'md5'), 'hex');
  SELECT encode(hmac( decode('cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd', 'hex'), decode('0102030405060708090a0b0c0d0e0f10111213141516171819', 'hex'), 'md5'), 'hex');
  SELECT encode(hmac( 'Test With Truncation', decode('0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c', 'hex'), 'md5'), 'hex');
  SELECT encode(hmac( 'Test Using Larger Than Block-Size Key - Hash Key First', decode('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'hex'), 'md5'), 'hex');
  SELECT encode(hmac( 'Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data', decode('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'hex'), 'md5'), 'hex');
 