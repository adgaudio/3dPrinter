#!/usr/bin/env python
"""Exports each openscad module/function that has '//make me' defined
"""
import argparse
import atexit
from os.path import abspath
from os import getenv
import re
from subprocess import check_call, Popen
import tempfile


TEMPLATE = u"""
include <{fp}>;
{module}({args});
"""
REGEX = r'( *module *|.*\)|)([A-Za-z0-9_-]+)\((.*?)\) *(\{|;).*// *make me.*'
CMD = "openscad -o {module}.{ftype} {tfp}"


def cleanup(procs, tfp):
    """Remove temp file created on exit"""
    for proc in procs.values():
        proc.wait()
    check_call(['rm',  tfp])


def get_modules(fp):
    """Find all lines that have '// make me' defined and extract
    the module name and, if it is a called module, the parameters given
    """
    lines = open(fp, 'r').readlines()
    matches = [
        re.search(REGEX, line)
        for line in lines if re.match('.*// *make me.*', line)]
    assert matches, (
        "No modules found.  You should specify "
        " '// make me' on a module or when calling one")
    modules = [
        (x.group(2), x.group(3) if 'module' not in x.group(1) else '')
        for x in matches]
    return modules


def main(ns):
    procs = {}
    for module, args in (ns.modules or get_modules(ns.fp)):
        # make temp scad file with relevant contents
        _, tfp = tempfile.mkstemp(
            prefix='openscad_%s_' % module, suffix='.scad')
        with open(tfp, 'w') as tfd:
            tfd.write(TEMPLATE.format(module=module, args=args, fp=ns.fp))

        # run openscad on temp file
        tcmd = CMD.format(module=module, ftype=ns.ftype, tfp=tfp)
        if ns.openscadpath:
            tcmd = "OPENSCADPATH=%s %s" % (ns.openscadpath, tcmd)
        print(tcmd)
        p = Popen(tcmd, shell=True)
        procs[tcmd] = p
        atexit.register(cleanup, procs=procs, tfp=tfp)

    if ns.block:
        for p in procs.values():
            p.wait()
        for tcmd, p in procs.items():
            if p.returncode:
                print('FAILED: %s, %s' % (tcmd, p.returncode))
                print(open(tfp).read())
                print("")

            else:
                print('Finished: %s, %s' % (tcmd, p.returncode))


def arg_parser():
    parser = argparse.ArgumentParser(
        description='Export openscad modules simply and in parallel')
    parser.add_argument(
        'fp', type=abspath, help="please supply a <file.scad>")
    parser.add_argument(
        '--ftype', default='stl',
        help="generate STL or other openscad supported file type")
    parser.add_argument(
        '--modules', default=[], nargs='+', type=lambda x: (x, ''),
        help='Comma separated list of modules to export to stl')
    parser.add_argument(
        '--openscadpath', default=getenv('OPENSCADPATH'),
        help="OPENSCADPATH lets you define where external libraries might be")
    parser.add_argument(
        '--block', action='store_true', help=(
            'Run in serial rather than in parallel.  '
            ' May take forever if you are compiling a lot of openscad modules'))
    return parser


if __name__ == '__main__':
    NS = arg_parser().parse_args()
    main(NS)
