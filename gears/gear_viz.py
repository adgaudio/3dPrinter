from numpy import square, sqrt
import mpl_toolkits.mplot3d.axes3d as p3d
import numpy as np
from numpy import arange
import pylab

from gear import *


def make_circle_v2(r=5, step_size=.1, origin=(0, 0)):
    """Make a circle of points with radius.
    Space points by step size
    (x-a)2 + (y-b)2 = r2
    (y-b) = sqrt( r2 - (x-a)2 )
    y = +-sqrt( r2 - (x-a)2 ) + b
    """
    a = origin[0]
    b = origin[1]
    x = arange(-1 * r, r, step_size)
    _y = r * r - square(x - a) + b
    y = sqrt(_y)
    return (np.append(-1 * x, x), np.append(-1 * y, y))


def test_points_on_circle():
    """assert dist between points on circle
    are the same distance from each other"""
    npoints = 20
    distances = euclidean_dist(*make_circle(r=30))
    assert np.equal.reduce(distances)
    assert len(distances) == npoints


def plt3d(x, y, z, _ax=[], **kwargs):
    default_kwargs = dict(linestyle='dot', marker='.')
    default_kwargs.update(kwargs)
    if not _ax:
        _ax.append(pylab.figure())
        _ax.append(p3d.Axes3D(_ax[0]))
    ax = _ax[-1]
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    #ax.plot_wireframe(x, y, z)
    ax.plot(x, y, zs=z, **default_kwargs)


def plt(x, y, *plt_args):
    pylab.plot(x, y, *plt_args)
    #for ax, ax_lim in ((x, pylab.xlim), (y, pylab.ylim)):
        #minn = np.min(ax)
        #maxx = np.max(ax)
        #ax_lim(minn - .1 * (maxx - minn),
               #maxx + .1 * (maxx - minn))


if __name__ == '__main__':

    pylab.close('all')
    x, y = make_circle(r=30, npoints=50)
    x_teeth, y_teeth = make_teeth(x, y, h=3)
    plt(x, y, 'go', x_teeth, y_teeth, 'r.')

    plt3d(x, y, np.ones(len(y)), color='blue')
    plt3d(x_teeth, y_teeth, np.ones(len(y_teeth)), color='green')
    plt3d(x, y, 2 * np.ones(len(y)), color='blue')
    plt3d(x_teeth, y_teeth, 2 * np.ones(len(y_teeth)), color='red')
    pylab.show()

