
-- torch7 hello world
-- works on my AMI 

x = torch.CharStorage('hello.txt')
a = x:string()
print(a)