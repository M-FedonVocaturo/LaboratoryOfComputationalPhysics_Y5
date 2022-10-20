def norm(num):
    s=0;
    for i in range(0,len(num)): s+=num[i]**2
    for i in range(0,len(num)): num[i]=num[i]/s**0.5
    return num
