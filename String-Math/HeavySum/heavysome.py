''' sum multiple large integer values together '''
DIFF = ord('0')

def add(a, b):
    la, lb = len(a), len(b)
    
    if la < lb:
        x = b
        b = a
        a = x
        la, lb = len(a), len(b)
        
    carry = 0
    r = list(a)

    for i in range(1, lb + 1):
        d = ord(a[-i]) + ord(b[-i]) + carry - DIFF * 2
        if d >= 10:
            d -= 10
            carry = 1
        else:
            carry = 0
        r[-i] = chr(d + DIFF)
    if carry > 0:
        for i in range(lb + 1, la + 1):
            r[-i] = ord(r[-i]) + carry - DIFF
            if r[-i] >= 10:
                r[-i] -= 10 
                carry = 1
            else:
                carry = 0
            r[-i] = chr(r[-i] + DIFF)
            if not carry:
                break
        if carry > 0:
            r.insert(0, chr(carry + DIFF))
    return ''.join(r)

if __name__ == '__main__':
    print('Pro version written by rust: https://github.com/pya-h/byteculator')
    print('Enter any number of positive inputs to sum, 0 to end input.')
    result = ''
    num = True
    while num and num != '0':
        num = input('')
        result = add(result, num) if result else num
        
    print(result)