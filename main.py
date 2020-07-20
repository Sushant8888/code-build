import torch
print("its working now")
print("its working now")
print("its working now")
print("its working now")
print("its working now")
print("its working now")


print("hello world ")
print("hello world ")
print("hello world ")


x = torch.rand(2,2)
y = torch.rand(2,2)
print(x)
print(y)
y.add(x)
print("FINAL RESULTS:",y)
print("FINAL RESULTS:",y)
print("FINAL RESULTS:",y)


device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

print(device)
print(device)
print(device)
