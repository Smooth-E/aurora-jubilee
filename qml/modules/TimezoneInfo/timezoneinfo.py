# This file is part of harbour-jubilee.
# SPDX-FileCopyrightText: 2026 Smooth-E
# SPDX-License-Identifier: GPL-3.0-or-later

from datetime import datetime
from babel import Locale
from babel.dates import get_timezone, get_timezone_location, get_timezone_name, get_timezone_gmt, format_datetime

def get_timezones(system_locale):
    babel_locale = Locale.parse(system_locale)
    
    timezones = []
    for tzname in babel_locale.time_zones.keys():
        try:
            tz = get_timezone(tzname)
        except LookupError:
            continue
        
        dt = datetime.now(tz)
        
        entry = { }
        entry['name'] = tzname
        
        if get_timezone_gmt(dt, return_z=True) == 'Z':
            utc = format_datetime(dt, "zzz", locale=babel_locale)
            entry['city'] = utc
            entry['area'] = utc
            entry['country'] = utc
        else:
            entry['city'] = get_timezone_location(tz, babel_locale, return_city=True)
            entry['area'] = get_timezone_name(tz, locale=babel_locale, zone_variant='standard', return_zone=True)
        
            country = get_timezone_location(tz, babel_locale)
            country = country[:country.rfind(',')]
            index = country.rfind('(')
            if index != -1:
                country = country[:index]
            country = country.strip()
            
            entry['country'] = country
        
        offset = get_timezone_gmt(dt, locale=babel_locale)
        entry['offset'] = offset
        entry['sectionOffset'] = offset[:-2] + "00"
        
        timezones.append(entry)
    
    return timezones
