# View registed curves for ECC
certutil.exe –displayEccCurve

# Add new curve
# Certutil —addEccCurve curveName curveParameters [curveOID] [curveType]
Certutil —addEccCurve secp334r1 Secp224r1_Params.cer Secp224r1_OID.cer 21

 # Remove curve
 Certutil.exe –deleteEccCurve curveName