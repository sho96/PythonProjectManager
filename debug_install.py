from create_venv import install_packages_in_venv
import json
print('templates:', json.load(open('.pynstal/templates.json')))
ok,out,err = install_packages_in_venv('venv_pt', json.load(open('.pynstal/templates.json'))['templates']['pytorch'], dry_run=True)
print('OK:', ok)
print('OUT:', out)
print('ERR:', err)
