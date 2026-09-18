import urllib.request, zipfile, io, os

u = "https://github.com/thomaslvz/intro-python-student/archive/refs/heads/main.zip"
z = zipfile.ZipFile(io.BytesIO(urllib.request.urlopen(u).read()))
root = z.namelist()[0].split("/")[0]
dest = root[:-5] if root.endswith("-main") else root
os.makedirs(dest, exist_ok=True)
[
    os.makedirs(os.path.dirname(os.path.join(dest, n[len(root) + 1 :])), exist_ok=True)
    or open(os.path.join(dest, n[len(root) + 1 :]), "wb").write(z.read(n))
    for n in z.namelist()
    if n.startswith(root + "/") and not n.endswith("/")
]
