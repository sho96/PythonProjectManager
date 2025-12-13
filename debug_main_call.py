from main import cmd_create_from_template
import types

args = types.SimpleNamespace()
args.template = 'pytorch'
args.venv_dir = 'venv_pt'
args.dry_run = True
args.interpreter = None

res = cmd_create_from_template(args)
print('RES:', res)
