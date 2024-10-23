import covalent as ct
from covalent_ssh_plugin import SSHExecutor
import subprocess
import numpy as np

sshexec = ct.executor.SSHExecutor(
    username="root",
    hostname="localhost",
    ssh_key_file="/Users/jparker/.ssh/id_rsa",
    ssh_port=2222
)

# Construct manageable tasks out of functions
# by adding the @ct.electron decorator
@ct.electron
def add(x, y):
   return x + y

@ct.electron
def multiply(x, y):
   return x*y

# Note that electrons can be shipped to variety of compute
# backends using executors, for example, "local" computer.
# See below for other common executors.
@ct.electron(executor=sshexec)
def divide(x, y):
   return x/y

@ct.electron
def sumvec(x):
   return np.sum(x)

# Construct the workflow by stitching together
# the electrons defined earlier in a function with
# the @ct.lattice decorator
@ct.lattice
def workflow(x, y):
   r1 = add(x, y)
   r2 = [multiply(r1, z) for z in range(4)]
   r3 = [divide(value, y) for value in r2]
   r4 = sumvec(r3)
   return r4

# Dispatch the workflow
dispatch_id = ct.dispatch(workflow)(1, 2)
result = ct.get_result(dispatch_id, wait=True)
print(result.result)
print(result.status)
