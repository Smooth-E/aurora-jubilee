# coding: utf-8
#
# This file is part of harbour-jubilee.
# SPDX-FileCopyrightText: 2026 Mirian Margiani
# SPDX-License-Identifier: GPL-3.0-or-later
#

import math
from datetime import datetime
from datetime import timedelta
from dateutil.relativedelta import relativedelta
from dateutil import tz
from dateutil import parser


try:
    import pyotherside
    HAVE_SIDE = True
except ImportError:
    HAVE_SIDE = False

    class pyotherside:
        def send(*args, **kwargs):
            print(f"pyotherside.send: {args} {kwargs}")


def log(*args) -> None:
    pyotherside.send('log', ' '.join([str(x) for x in args]))


def calculateAge(start, startTz, till, tillTz):
    log("calculating age:", start, startTz, till, tillTz)
    tzinfos = {"START": tz.gettz(startTz), "TILL": tz.gettz(tillTz)}

    startDt = parser.parse(f"{start} START", tzinfos=tzinfos)
    tillDt = parser.parse(f"{till} TILL", tzinfos=tzinfos)

    wall = relativedelta(tillDt, startDt)
    minutes = int((tillDt - startDt).total_seconds() / 60)

    return {
        "wall": {
            "years": wall.years,
            "months": wall.months,
            "days": wall.days,
            "hours": wall.hours,
            "minutes": wall.minutes
        },
        "minutes": str(minutes),  # expected as string
    }


def projectMinutes(start: str, startTz: str, ageInMinutes: str, tillTz: str):
    log("projecting minutes:", ageInMinutes)
    ageInMinutes = int(ageInMinutes)
    log("- converted:", ageInMinutes)
    tzinfos = {"START": tz.gettz(startTz), "TILL": tz.gettz(tillTz)}

    startDt = parser.parse(f"{start} START", tzinfos=tzinfos)
    tillDt = startDt.astimezone(tz.UTC)

    try:
        tillDt += relativedelta(minutes=+ageInMinutes)
        tillDt = tillDt.astimezone(tzinfos["TILL"])
    except OverflowError:
        tillDt = datetime(9999, 12, 31, 23, 59, tzinfo=tzinfos["TILL"])

    tillDt = tillDt.strftime("%Y-%m-%d %H:%M:%S")
    age = calculateAge(start, startTz, tillDt, tillTz)
    log("- calculated projection:", tillDt, age)

    return {
        "age": age,
        "date": tillDt,
        "tz": tillTz,
    }


def projectWall(start: str, startTz: str, walltime: dict, tillTz: str):
    log("projecting wall time:", walltime)
    tzinfos = {"START": tz.gettz(startTz), "TILL": tz.gettz(tillTz)}

    startDt = parser.parse(f"{start} START", tzinfos=tzinfos)
    tillDt = startDt.astimezone(tz.UTC)

    try:
        tillDt += relativedelta(years=walltime['years'], months=walltime['months'],
                                days=walltime['days'], hours=walltime['hours'], minutes=walltime["minutes"])
        tillDt = tillDt.astimezone(tzinfos["TILL"])
    except (OverflowError, ValueError):
        tillDt = datetime(9999, 12, 31, 23, 59, tzinfo=tzinfos["TILL"])

    tillDt = tillDt.strftime("%Y-%m-%d %H:%M:%S")
    age = calculateAge(start, startTz, tillDt, tillTz)
    log("- calculated projection:", tillDt, age)

    return {
        "age": age,
        "date": tillDt,
        "tz": tillTz,
    }
