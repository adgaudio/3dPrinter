#!/usr/bin/env python
"""Exports each openscad module/function that has '//make me' defined
TODO: currently doesn't support args or kwargs when rendering the openscad
module.
"""
import argparse
import atexit
from os.path import abspath
import re
import sys
import subprocess
import shlex
import tempfile


template = u"""
include <{fp}>;
{module}({args});
"""


def get_modules(fp):
    """Find all lines that have '// make me' defined and extract
    the module name and, if it is a called module, the parameters given
    """
    lines = open(fp, 'r').readlines()
    matches = [re.search(r'( *module *|.*\)|)([A-Za-z0-9_-]+)\((.*?)\) *(\{|;).*// *make me.*', line)
               for line in lines if re.match('.*// *make me.*', line)]
    assert matches, ("No modules found.  You should specify "
                     " '// make me' on a module or when calling one")
    modules = [(x.group(2), x.group(3) if 'module' not in x.group(1) else '')
               for x in matches]
    return modules


def export(fp, ftype, modules, block=True):
    if not modules:
        modules = get_modules(fp)
    cmd = "openscad -o {module}.{ftype} {tfp}"
    ps = {}
    for module, args in modules:
        # make temp scad file with relevant contents
        _, tfp = tempfile.mkstemp(prefix='openscad_%s_' % module, suffix='.scad')
        atexit.register(lambda tfp: subprocess.Popen('rm %s' % tfp, shell=True), tfp)
        with open(tfp, 'w') as tfd:
            tfd.write(template.format(fp=abspath(fp), module=module, args=args))
        # run openscad on temp file
        tcmd = cmd.format(module=module, ftype=ftype, tfp=tfp)
        p = subprocess.Popen(shlex.split(tcmd))
        ps[tcmd] = p
    if block:
        for p in ps.values():
            p.wait()
        for tcmd, p in ps.items():
            if p.returncode:
                print 'FAILED: %s, %s' % (tcmd, p.returncode)
                print open(tfp).read()
                print

            else:
                print 'Finished: %s, %s' % (tcmd, p.returncode)


def arg_parser():
    parser = argparse.ArgumentParser(description='Export openscad modules simply and in parallel')
    parser.add_argument('fp', help="please supply a <file.scad>")
    parser.add_argument('--ftype', default='stl')
    parser.add_argument('--modules', default=[], nargs='+', type=lambda x: (x, ''),
                        help='Comma separated list of modules to export to stl')
    return parser


if __name__ == '__main__':
    ns = arg_parser().parse_args(sys.argv[1:])
    export(**ns.__dict__)
