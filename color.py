import cv2
import numpy as np

V = r"" # same like main.py
R = 144 # resolution เเบบ 144x144 360x360 720x720 เเต่เเนะนำน้อยๆ ดีกว่า
F = 30 # fps
C = 30 # จำนวน frames ต่อ chunk 30 น่าจะดีสุดเเละมั้งนะ
O = "out_c.rbxmx"

H = """<roblox version="4">
<Item class="Folder">
<Properties>
<string name="Name">VideoFrames</string>
</Properties>
"""
M = """
<Item class="ModuleScript">
<Properties>
<string name="Name">{n}</string>
<ProtectedString name="Source"><![CDATA[{s}]]></ProtectedString>
</Properties>
</Item>
"""
T = "</Item></roblox>"

def p(a):
    return "return {" + ",".join(f'"{x}"' for x in a) + "}"

c = cv2.VideoCapture(V)
f0 = c.get(cv2.CAP_PROP_FPS)

a = []
b = []
i = 1
fi = 0
fo = 0

while True:
    r, x = c.read()
    if not r:
        break

    t = fi / f0
    w = int(t * F)
    fi += 1
    if w < fo:
        continue
    fo += 1

    x = cv2.resize(x, (R, R), interpolation=cv2.INTER_AREA)
    x = cv2.cvtColor(x, cv2.COLOR_BGR2RGB)

    a.append(x.astype(np.uint8).tobytes().hex())

    if len(a) == C:
        b.append(M.format(n=f"Chunk_{i}", s=p(a)))
        a = []
        i += 1

if a:
    b.append(M.format(n=f"Chunk_{i}", s=p(a)))

c.release()

with open(O, "w", encoding="utf-8") as f:
    f.write(H)
    f.writelines(b)
    f.write(T)

print("FRAMES:", fo)
print("SIZE:", len(open(O, "rb").read()))
