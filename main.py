import cv2
import numpy as np

V = r"C:\Users\admin\Downloads\awd.mp4" # your video file (.mp4)
S = 720
F = 60  # ปรับตามขนาด resolution ที่ต้องการจาก file เด้อ เเบบ 64 - 256 ก้ 300 ได้ไรงี้
C = 100
O = f"out.rbxmx"

H = """<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
    <Item class="Folder" referent="RBX0">
        <Properties>
            <string name="Name">VideoFrames</string>
        </Properties>
"""
M = """
        <Item class="ModuleScript" referent="RBX_CHUNK_{i}">
            <Properties>
                <string name="Name">{n}</string>
                <ProtectedString name="Source"><![CDATA[{c}]]></ProtectedString>
            </Properties>
        </Item>"""
T = "\n    </Item>\n</roblox>"

def f(d):
    x = '",\n  "'.join(d)
    return f'return {{\n  "{x}"\n}}'

a = cv2.VideoCapture(V)

p = a.get(cv2.CAP_PROP_FPS)
print(f"Original video FPS: {p}")
print(f"Target FPS: {F}")

i = 1
l = []
k = []
q = 0

print("Processing video...")

while True:
    r, e = a.read()
    if not r:
        break

    t = q / p
    z = int(t * F)
    q += 1

    e = cv2.resize(e, (S, S))
    g = cv2.cvtColor(e, cv2.COLOR_BGR2GRAY)
    _, b = cv2.threshold(g, 128, 255, cv2.THRESH_BINARY)

    y = (b > 128).astype(np.uint8)
    h = np.packbits(y)
    k.append(h.tobytes().hex())

    if len(k) == C:
        u = f(k)
        l.append(M.format(i=i, n=f"Chunk_{i}", c=u))
        k = []
        print(f"Finished Chunk {i} (frame {q})")
        i += 1

if k:
    u = f(k)
    l.append(M.format(i=i, n=f"Chunk_{i}", c=u))

with open(O, "w", encoding="utf-8") as w:
    w.write(H)
    w.writelines(l)
    w.write(T)

a.release()
print(f"DONE! Total frames: {q}, File saved as {O}")
