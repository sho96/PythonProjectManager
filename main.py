import argparse
import sys
import os

from pythonprojectmanager.main import cli as _package_cli

if __name__ == "__main__":
	raise SystemExit(_package_cli())



def cmd_add_interpreter(args):
	path = args.path
	if interpreters_data.interpreters is None:
		interpreters_data.interpreters = []
	if path in interpreters_data.interpreters:
		print("Interpreter already exists in data.")
		return
	interpreters_data.interpreters.append(path)
	interpreters_data.save()
	print(f"Added interpreter: {path}")


def cmd_list(args):
	print("Interpreters:")
	if interpreters_data.interpreters:
		for p in interpreters_data.interpreters:
			print(f" - {p}")
	else:
		print(" - (none)")
	print("Global interpreter:")
	print(f" - {interpreters_data.global_interpreter}")


def cmd_create(args):
	interpreter = args.interpreter
	venv_dir = args.venv_dir
	dry_run = args.dry_run
	success = create_venv(interpreter, venv_dir, dry_run=dry_run)
	from pythonprojectmanager.main import cli as _package_cli


	if __name__ == "__main__":
	    raise SystemExit(_package_cli())


	template = args.template

	venv_dir = args.venv_dir

	dry_run = args.dry_run

	interpreter = args.interpreter


