// FROM https://github.com/ajaxorg/ace-builds/issues/129#issuecomment-406783352

import 'ace-builds/src-min-noconflict/ace' // Load Ace Editor

// Import initial theme and mode so we don't have to wait for 2 extra HTTP requests
import 'ace-builds/src-min-noconflict/theme-chrome'
import 'ace-builds/src-min-noconflict/mode-javascript'

// cdnjs didn't have a "no-conflict" version, so we'll use jsdelivr
const CDN = 'https://cdn.jsdelivr.net/npm/ace-builds@1.3.3/src-min-noconflict';

// Now we tell ace to use the CDN locations to look for files
ace.config.set('basePath', CDN);
ace.config.set('modePath', CDN);
ace.config.set('themePath', CDN);
ace.config.set('workerPath', CDN);

// // Create Editor
// const editor = ace.edit('editor');

// // Set Editor Theme and Mode
// editor.setTheme('ace/theme/chrome');
// editor.session.setMode('ace/mode/javascript');

/////////////////

import './Ace.scss'
