import importlib
keygenme = importlib.import_module("keygenme-trial")
keygenme.bUsername_trial
import hashlib
h = hashlib.sha256(keygenme.bUsername_trial).hexdigest()
print("{}{}{}".format(keygenme.key_part_static1_trial, "".join([h[4], h[5], h[3], h[6], h[2], h[7], h[1], h[8]]), keygenme.key_part_static2_trial))

# picoCTF{1n_7h3_|<3y_of_0d208392}