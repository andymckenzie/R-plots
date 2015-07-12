-- first oxford practical questions 
t = torch.Tensor({{1,2,3},{4,5,6},{7,8,9}})

t:select(2,2)
 2
 5
 8
[torch.DoubleTensor of dimension 3]

 t[{ {}, 2 }]
 2
 5
 8
[torch.DoubleTensor of dimension 3]