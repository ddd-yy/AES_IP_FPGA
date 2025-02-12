from Crypto.Cipher import AES

# 定义密钥
key = bytes.fromhex('0123456789ABCDEF0123456789ABCDEF')

# 定义密文
ciphertexts = [
    bytes.fromhex('35A167EF1F2C2DFD79CD08FF0607C91A'),
    bytes.fromhex('6B3054C3CA5C5435C8041E0CC5283001'),
    bytes.fromhex('38BE1CC2E904D1AAB8C5B8770D9BA63F')
]

# 初始化AES加密器
cipher = AES.new(key, AES.MODE_ECB)

# 解密过程
for i, ciphertext in enumerate(ciphertexts):
    # 解密
    decrypted_plaintext = cipher.decrypt(ciphertext)
    
    # 打印结果
    print(f'Ciphertext {i+1}: {ciphertext.hex()}')
    print(f'Decrypted Plaintext {i+1}: {decrypted_plaintext.hex()}')
    print('---')