import numpy as np
from numpy import sin, cos, pi, arange, arcsin
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
    return 2. * r * sin(1. / n_teeth)


def n_teeth(side_length, r):
    """Calculate the number of teeth in a circle
    assuming that the teeth are separated by side_length.
    side_length is a straight line between two points and not arc length.
    r is radius
    """
    return ((2 * np.pi) / (np.arcsin(side_length / (2. * r))))
    #return 1. / (2. * arcsin(side_length / (2. * r)))


def gradient_descent(side_length, r, alpha=1., n_iter=2000):
    """There's certainly a more direct way of solving this,
    but this func is probably the quickest answer"""
    cost_func = lambda est_n_teeth, target: \
        ((est_n_teeth - target) / float(target)) ** 2

    est_n_teeth = n_teeth(side_length, r)
    target = np.round(est_n_teeth)
    for _ in xrange(n_iter):
        sign = -1. * (est_n_teeth - target) / abs(est_n_teeth - target)
        r = r + r * sign * alpha * cost_func(est_n_teeth, target)
        est_n_teeth = n_teeth(side_length, r)
        #pylab.show()
        #pylab.plot(r, est_n_teeth, 'ro')
    return r

if __name__ == '__main__':

    side = (4.45 + 1.6)
    est_r = 20.
    r = gradient_descent(side, est_r, alpha=10.)
    teeth = n_teeth(side, r)
    tooth_height = 4.45 * .75
    inner_radius = ((6.45 - 1.2) / 2.)
    base = r - inner_radius
    dedendum = (1/2.) * tooth_height
    addendum = (1/2.) * tooth_height
    outer_radius = r - addendum
    print 'side_length:', side
    print 'radius:', r
    print 'teeth:', teeth
    print 'tooth_height:', tooth_height
    print
    print """
    blender settings:
        nteeth: {teeth}
        radius: {outer_radius}
        width: 10
        base: {base}
        dedendum: {dedendum}
        addendum: {addendum}
        """.format(**locals())

    6.05
    19.8176341821
    41.0020173326
    3.3375

    #print '---'
    #x, y = make_circle(r, np.round(teeth))
    ##pylab.ioff()
    ##pylab.plot(x, y, 'ro')
    ##pylab.show()
    #dists =  euclidean_dist(x, y)
    #print dists
    #assert np.equal.reduce(dists)
    #print 'check passed'
