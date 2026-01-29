# This file is part of opal-localstorage.
# https://github.com/Pretty-SFOS/opal-localstorage
# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2025 Mirian Margiani

import sys
import os

# output Python logs to console
sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 1)
sys.stderr = os.fdopen(sys.stderr.fileno(), 'w', 1)
