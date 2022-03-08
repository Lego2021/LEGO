SET bytea_output TO escape;
  select pgp_pub_decrypt( pgp_pub_encrypt('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=1;
  select pgp_pub_decrypt( pgp_pub_encrypt('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=2;
  select pgp_pub_decrypt( pgp_pub_encrypt('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=3;
  select pgp_pub_decrypt( pgp_pub_encrypt('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=6;
  select pgp_pub_decrypt( pgp_pub_encrypt('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=4;
  select pgp_pub_decrypt( pgp_pub_encrypt('Secret msg', dearmor(seckey)), dearmor(seckey)) from keytbl where keytbl.id=1;
  select pgp_pub_decrypt_bytea( pgp_pub_encrypt('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=1;
  select pgp_pub_decrypt( pgp_pub_encrypt_bytea('Secret msg', dearmor(pubkey)), dearmor(seckey)) from keytbl where keytbl.id=1;
 