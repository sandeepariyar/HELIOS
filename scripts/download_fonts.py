#!/usr/bin/env python3
"""Fetch SIL Open Font License TTF files directly from Google Fonts (developer machine).

No font binaries are shipped by MCU Asset Forge. If download fails, native QML text uses
installed font fallback. Review upstream OFL license files before redistribution.
"""
import sys
from pathlib import Path
from urllib.request import urlopen,Request
from urllib.parse import quote

FONTS={
  'JetBrainsMono.ttf':'ofl/jetbrainsmono/JetBrainsMono[wght].ttf',
  'SpaceGrotesk.ttf':'ofl/spacegrotesk/SpaceGrotesk[wght].ttf',
}

def download(out:Path):
    out.mkdir(parents=True,exist_ok=True)
    failures=0
    for name,path in FONTS.items():
        dest=out/name
        if dest.exists() and dest.stat().st_size>20000:
            print('Using existing font',name);continue
        url='https://raw.githubusercontent.com/google/fonts/main/'+quote(path,safe='/')
        try:
            req=Request(url,headers={'User-Agent':'MCUAssetForge/0.1'})
            with urlopen(req,timeout=12) as resp:data=resp.read()
            if not (data[:4] in (b'\x00\x01\x00\x00',b'OTTO',b'ttcf')):raise ValueError('Not a TTF/OTF font')
            dest.write_bytes(data)
            print('Downloaded',name, len(data),'bytes')
        except Exception as e:
            print('Warning:',name,'not downloaded:',e)
            failures+=1
    return 0 if failures==0 else 1

if __name__=='__main__':sys.exit(download(Path(sys.argv[1] if len(sys.argv)>1 else 'fonts')))
