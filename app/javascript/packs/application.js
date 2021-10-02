// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "../stylesheets/application"
import "jquery"
import '@fortawesome/fontawesome-free/js/all';
window.$ = window.jQuery = require('jquery');
import 'src/raty'
import 'src/jquery.jpostal'
require.context("../images", true)
import 'src/scroll'
import 'src/countLength'

Rails.start()
ActiveStorage.start()
