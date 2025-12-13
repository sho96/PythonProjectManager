from create_venv import create_venv

# This test uses dry_run to avoid making filesystem changes.
res = create_venv(r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe", "venv_test", dry_run=True)
print("RESULT:", res)
