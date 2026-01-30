//@ This file is part of opal-localstorage.
//@ https://github.com/Pretty-SFOS/opal-localstorage
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ SPDX-FileCopyrightText: 2018-2026 Mirian Margiani
import QtQuick 2.0
import Sailfish.Silica 1.0
import"private"
import"."
Item{id:root
property bool debugMode:false
signal userSignalReceived(var event,var handle,var busy,var data)
property var __events:({})
property var __userEvents:({})
readonly property string _lc:"[Opal.LocalStorage] MessageHandler:"
signal __databaseSignalReceived(var event,var handle,var busy,var data)
function showOverlay(handle,title,description,busy,smallprint){var obj=overlayComponent.createObject(__silica_applicationwindow_instance,{text:title,hintText:description,smallprint:smallprint||"",busy:busy})
if(obj===null){console.error(_lc,"failed to show status overlay!")
}else{obj.show()
}if(__events.hasOwnProperty(handle)){console.warn(_lc,"replacing event with handle",handle)
_hideOverlay(handle)
}__events[handle]=obj
}function hideOverlay(handle){if(__events.hasOwnProperty(handle)){__events[handle].hide(true)
delete __events[handle]
}}function allowDismissOverlay(handle){if(__events.hasOwnProperty(handle)){__events[handle].allowDismiss=true
__events[handle].dismissed.connect(function(){if(__events.hasOwnProperty(handle)){delete __events[handle]
}})
}}function _register(force){if(!force&&!!LocalStorage._DB_STATUS_SIGNAL){console.warn(_lc,"database status signal already set!")
}else{console.log(_lc,"database event handler installed")
LocalStorage._DB_STATUS_SIGNAL=__databaseSignalReceived
}}visible:false
parent:__silica_applicationwindow_instance
on__DatabaseSignalReceived:{function _show(title,hint,smallprint,dismissible){showOverlay(handle,title,hint,busy,smallprint)
if(!!dismissible){allowDismissOverlay(handle)
}}
if(/^user-/ .test(handle)){__userEvents[handle]=1
userSignalReceived(event,handle,busy,data)
if(debugMode){_show(event,"user signal","Event: %1<br><br>Data:<br><pre>%2</pre>".arg(event).arg(JSON.stringify(data,2,2)),true)
}return
}switch(event){case"end":if(!__userEvents.hasOwnProperty(handle)){hideOverlay(handle)
}break
case"init":case"upgrade":break
case"query-failed":if(!!data.notify||debugMode){_show(qsTranslate("Opal.LocalStorage","Database query failed"),qsTranslate("Opal.LocalStorage","An error occurred while accessing "+"the database.")+(!!data.fatal?" "+qsTranslate("Opal.LocalStorage","Try restarting the app.")+" "+qsTranslate("Opal.LocalStorage","Please report this issue if it happens again."):""),"Exception: %1<br><br>Query: <pre>%2</pre><br><br>Values: %3<br>Read-only: %4<br><br>Stack:<br>%5".arg(data.exception).arg(data.query).arg(JSON.stringify(data.values)).arg(!!data.readOnly?"true":"false").arg(data.exception.stack.split("\n").join("<br><br>")),!data.fatal||debugMode)
}break
case"upgrade-failed":_show(qsTranslate("Opal.LocalStorage","Database upgrade failed"),qsTranslate("Opal.LocalStorage","An error occurred while upgrading "+"the database from version %1 to version %2. "+"Please report this issue.").arg(data.from).arg(data.to),"%1<br><br>Stack:<br>%2".arg(data.exception).arg(data.exception.stack.split("\n").join("<br><br>")),false||debugMode)
break
case"invalid-version":_show(qsTranslate("Opal.LocalStorage","Invalid database version"),qsTranslate("Opal.LocalStorage","The app cannot start because "+"the database has version %1 "+"but only version %2 is supported.").arg(data.got).arg(data.expected),"",false||debugMode)
break
case"maintenance":_show(qsTranslate("Opal.LocalStorage","Database Maintenance"),qsTranslate("Opal.LocalStorage","Please be patient and allow up to 30 seconds for this."),"",false||debugMode)
break
default:_show(qsTranslate("Opal.LocalStorage","Database issue"),qsTranslate("Opal.LocalStorage","An unexpected issue occurred in the database. "+"Try restarting the app."),"Event: %1<br><br>Data:<br><pre>%2</pre>".arg(event).arg(JSON.stringify(data,2,2)),false||debugMode)
break
}}Component{id:overlayComponent
BlockingOverlay{}}Component.onCompleted:{_register()
}}