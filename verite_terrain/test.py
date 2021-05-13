import os
#print(os.listdir("./depth_vi"))
for dirname in os.listdir("."):
    if os.path.isdir(dirname):
        for i, filename in enumerate(os.listdir(dirname)):
            os.rename(dirname + "/" + filename, dirname + "/" + filename.split(".")[0] + ".png")
