#!/usr/bin/env python
"""Exports each openscad module/function that has "//make me" defined
"""
import argparse
import atexit
import re
import sys
import subprocess
import shlex
import tempfile


template = u"""
include <{fp}>;
{module}();
"""


def get_modules(fp):
    lines = open(fp, 'r').readlines()
    modules = [re.sub(r'(.*\)|)([A-Za-z0-9_-]+)\(\) *;.*// *make me.*', r'\2', line).strip()
               for line in lines if re.match('.*// *make me.*', line)]
    return modules


def export(fp, ftype, modules, block=True):
    if not modules:
        modules = get_modules(fp)
    cmd = "openscad -o {module}.{ftype} {tfp}"
    ps = {}
    for module in modules:
        _, tfp = tempfile.mkstemp(prefix='openscad_%s_' % module, suffix='.scad')
        atexit.register(lambda tfp: subprocess.Popen('rm %s' % tfp, shell=True), tfp)
        with open(tfp, 'w') as tfd:
            tfd.write(template.format(fp=fp, module=module))
        tcmd = cmd.format(module=module, ftype=ftype, tfp=tfp)
        p = subprocess.Popen(shlex.split(tcmd))
        ps[tcmd] = p
    if block:
        for tcmd, p in ps.items():
            p.wait()
            if not int(p.returncode):
                print 'Failed: %s, %s' % (tcmd, p.returncode)


def arg_parser():
    parser = argparse.ArgumentParser(description='Export openscad modules simply and in parallel')
    parser.add_argument('fp', help="please supply a <file.scad>")
    parser.add_argument('--ftype', default='stl')
    parser.add_argument('--modules', default=[], type=lambda x: x.split(','),
                        help='Comma separated list of modules to export to stl')
    return parser


if __name__ == '__main__':
    ns = arg_parser().parse_args(sys.argv[1:])
    export(**ns.__dict__)
