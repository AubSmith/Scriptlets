b64string = "Z m x h Z z o g c G l j b 0 N U R n t E M W R f d V 9 r b j B 3 X 3 B w d H N f c l 9 6 M X A 1 f Q"
# Use Translate to delete spaces
echo $b64string | tr -d ' ' | base64 -d

# flag: picoCTF{D1d_u_kn0w_ppts_r_z1p5}base64: invalid input
