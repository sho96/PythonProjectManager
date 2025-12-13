import zipfile
p='dist/pythonprojectmanager-0.1.0-py3-none-any.whl'
try:
    with zipfile.ZipFile(p) as z:
        metas=[n for n in z.namelist() if n.endswith('METADATA')]
        print('METADATA files:', metas)
        if metas:
            print('---METADATA START---')
            print(z.read(metas[0]).decode(errors='replace'))
            print('---METADATA END---')
        else:
            print('No METADATA found')
except Exception as e:
    print('ERROR:', e)
