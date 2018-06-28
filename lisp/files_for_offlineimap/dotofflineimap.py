import subprocess

def mailpasswd(account):
    path = "/home/chengzhengqian/.mail-%s-passwd.gpg" % account
    return subprocess.check_output(["gpg2", "--quiet", "--batch", "-d", path]).strip()

