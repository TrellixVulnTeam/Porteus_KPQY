/********************************************************************
 KWin - the KDE window manager
 This file is part of the KDE project.

 Copyright (C) 2017 Kai Uwe Broulik <kde@privat.broulik.de>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
/*global effect, effects, animate, animationTime, Effect*/
var frozenAppEffect = {
    inDuration: animationTime(1500),
    outDuration: animationTime(250),
    loadConfig: function () {
        "use strict";
        frozenAppEffect.inDuration = animationTime(1500);
        frozenAppEffect.outDuration = animationTime(250);
    },
    windowAdded: function (window) {
        "use strict";
        if (!window || !window.unresponsive) {
            return;
        }
        frozenAppEffect.windowBecameUnresponsive(window);
    },
    windowBecameUnresponsive: function (window) {
        "use strict";
        if (window.unresponsiveAnimation) {
            return;
        }
        frozenAppEffect.startAnimation(window, frozenAppEffect.inDuration);
    },
    startAnimation: function (window, duration) {
        "use strict";
        if (!window.visible) {
            return;
        }
        window.unresponsiveAnimation = set({
            window: window,
            duration: duration,
            animations: [{
                type: Effect.Saturation,
                to: 0.1
            }, {
                type: Effect.Brightness,
                to: 1.5
            }]
        });
    },
    windowClosed: function (window) {
        "use strict";
        frozenAppEffect.cancelAnimation(window);
        if (!window.unresponsive) {
            return;
        }
        frozenAppEffect.windowBecameResponsive(window);
    },
    windowBecameResponsive: function (window) {
        "use strict";
        if (!window.unresponsiveAnimation) {
            return;
        }
        cancel(window.unresponsiveAnimation);
        window.unresponsiveAnimation = undefined;

        animate({
            window: window,
            duration: frozenAppEffect.outDuration,
            animations: [{
                type: Effect.Saturation,
                from: 0.1,
                to: 1.0
            }, {
                type: Effect.Brightness,
                from: 1.5,
                to: 1.0
            }]
        });
    },
    cancelAnimation: function (window) {
        "use strict";
        if (window.unresponsiveAnimation) {
            print(window);
            cancel(window.unresponsiveAnimation);
            window.unresponsiveAnimation = undefined;
        }
    },
    desktopChanged: function () {
        "use strict";

        var windows = effects.stackingOrder;
        for (var i = 0, length = windows.length; i < length; ++i) {
            print(i);
            var window = windows[i];
            frozenAppEffect.cancelAnimation(window);
            frozenAppEffect.restartAnimation(window);
        }
    },
    unresponsiveChanged: function (window) {
        "use strict";
        if (window.unresponsive) {
            frozenAppEffect.windowBecameUnresponsive(window);
        } else {
            frozenAppEffect.windowBecameResponsive(window);
        }
    },
    restartAnimation: function (window) {
        "use strict";
        if (!window || !window.unresponsive) {
            return;
        }
        frozenAppEffect.startAnimation(window, 1);
    },
    init: function () {
        "use strict";

        effects.windowAdded.connect(frozenAppEffect.windowAdded);
        effects.windowClosed.connect(frozenAppEffect.windowClosed);
        effects.windowMinimized.connect(frozenAppEffect.cancelAnimation);
        effects.windowUnminimized.connect(frozenAppEffect.restartAnimation);
        effects.windowUnresponsiveChanged.connect(frozenAppEffect.unresponsiveChanged);
        effects['desktopChanged(int,int)'].connect(frozenAppEffect.desktopChanged);
        effects.desktopPresenceChanged.connect(frozenAppEffect.cancelAnimation);
        effects.desktopPresenceChanged.connect(frozenAppEffect.restartAnimation);

        var windows = effects.stackingOrder;
        for (var i = 0, length = windows.length; i < length; ++i) {
            frozenAppEffect.restartAnimation(windows[i]);
        }
    }
};
frozenAppEffect.init();
