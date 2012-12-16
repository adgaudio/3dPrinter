"""
This script has a few random functions for working with circles
and calculating measurements for gears.

Specifically, it can be used to estimate the radius of a circle when
you know the distance between two consecutive points on the circle,
and you know that there needs to be an integer (rather than
floating point) number of points.
"""
import numpy as np
from numpy import sin, cos, pi, arange
import pylab


def make_circle(r, npoints=30):
    x = r * cos(arange(0, 2 * pi, pi / float(npoints / 2.)))
    y = r * sin(arange(0, 2 * pi, pi / float(npoints / 2.)))
    return x, y


def euclidean_dist(x, y):
    """Given array of x and y values,
    Find euclidean distance between all successive (x_i,y_i) points
    Basecase: For last point, find distance to first point"""
    rv = np.hypot(np.append(x[:-1] - x[1:], x[-1] - x[0]),
                  np.append(y[:-1] - y[1:], y[-1] - y[0]))
    return rv


def make_teeth(x, y, h):
    """Given all consecutive points, find the midpoint
    h units above the given line segment"""
    #find midpoints
    x_midpoints = (x + np.roll(x, len(x) - 1)) / 2
    y_midpoints = (y + np.roll(y, len(y) - 1)) / 2
    pylab.plot(x_midpoints, y_midpoints, 'y.')
    # find midpoint at tooth height
    degrees = np.arctan2(y_midpoints, x_midpoints)
    x_tooth = cos(degrees) * h + x_midpoints
    y_tooth = sin(degrees) * h + y_midpoints
    return x_tooth, y_tooth
    # TODO: find point at distance past midpoint along ray from origin
    #tooth_vertex = perpendicular_slopes * (x_midpoints + tooth + y_midpoints
    #plt(x, tooth_ver
    #apply some sort of function that defines tooth shape


def side_length(n_teeth, r):
    """Calculate the distance between two points
    assuming that the given num_points are all equidistant on a circle
    r is radius
    """
    raise NotImplementedError("Haven't checked this is correct")
    #return 2. * r * sin(1. / n_teeth)
    return 2. * r * sin(np.pi)


def n_teeth(side_length, r):
    """Calculate the number of teeth in a circle
    assuming that the teeth are separated by side_length.
    side_length is a straight line between two points and not arc length.
    r is radius
    """
    return ((np.pi) / (np.arcsin(side_length / (2. * r))))


def gradient_descent(side_length, r, alpha=1., n_iter=2000):
    """Estimate the radius, r, of a circle if you know the side_length,
    and also know that the number of points (or teeth in a gear) must
    be an integer.

    There's certainly a more direct way of solving this,
    but this func is probably the quickest answer"""
    cost_func = lambda est_n_teeth, target: \
        ((est_n_teeth - target) / float(target)) ** 2

    est_n_teeth = n_teeth(side_length, r)
    target = np.round(est_n_teeth)
    for _ in xrange(n_iter):
        sign = -1. * (est_n_teeth - target) / abs(est_n_teeth - target)
        r = r + r * sign * alpha * cost_func(est_n_teeth, target)
        est_n_teeth = n_teeth(side_length, r)
    return r

if __name__ == '__main__':
    shaft_radius = 5.5
    ball_size = 4.5
    link_length = 1.5
    side = ball_size + link_length
    est_r = 20.
    r = gradient_descent(side, est_r, alpha=10.)
    teeth = n_teeth(side, r)

    print 'side_length:', side
    print '  ball size:', ball_size
    print '  link_length:', link_length
    print 'radius:', r
    print 'shaft radius:', shaft_radius
    print 'teeth:', teeth
    print

    print '---\ntesting the math'
    x, y = make_circle(r, np.round(teeth))
    #pylab.ioff()
    #pylab.plot(x, y, 'ro')
    #pylab.show()
    dists = euclidean_dist(x, y)
    print dists[0], '==?', ball_size + link_length
    assert np.equal.reduce(dists)
    #print 'check passed'
