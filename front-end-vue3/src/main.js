import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { Quasar } from 'quasar'
import quasarLang from 'quasar/lang/zh-CN'
import axios from "axios";

// import './assets/main.css'

// Import icon libraries
import '@quasar/extras/roboto-font/roboto-font.css'
import '@quasar/extras/material-icons/material-icons.css'

// Import Quasar css
import 'quasar/src/css/index.sass'

const app = createApp(App)

// app.config.globalProperties.$h = axios;

app.use(router)
// app.use(Quasar)
// Quasar.lang.set(Quasar.lang.zhCN)
app.use(Quasar, {
    plugins: {}, // import Quasar plugins and add here
    lang: quasarLang,
  })

app.mount('#app')